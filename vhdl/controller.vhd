library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is

  TYPE StateType IS (FETCH1, FETCH2, DECODE, R_OP, STORE, BREAK, LOAD1, LOAD2, I_OP);
  SIGNAl s_cur_state : StateType;

begin

  pro_op : process(op, opx) is
  begin
    if(op = X"3A") then op_alu <= opx;
    elsif op = X"17" then op_alu <= "000000";
    elsif op = X"15" then op_alu <= "000000";
    else op_alu <= op;
    end if;
  end process pro_op;

  pro_fsm : process(clk) is
  begin
    if (reset_n = '0')
      then s_cur_state <= FETCH1;
    end if;

    if (rising_edge(clk)) then
      CASE (s_cur_state) IS
        WHEN FETCH1 => ir_en <= '0';
                        pc_add_imm <= '0';
                        pc_en <= '0';
                        pc_sel_a <= '0';
                        pc_sel_imm <= '0';
                        rf_wren <= '0';
                        sel_addr <= '0';
                        sel_b <= '0';
                        sel_mem <= '0';
                        sel_pc <= '0';
                        sel_ra <= '0';
                        sel_rC <= '0';
                        write <= '0';
                        read <= '1';
                        s_cur_state <= FETCH2;
        WHEN FETCH2 => ir_en <= '1';
                       pc_en <= '1';
                       s_cur_state <= DECODE;
        WHEN DECODE => if (op = "111010" and opx = "110100") then s_cur_state <= BREAK;
                         elsif (op = "111010") then s_cur_state <= R_OP;
                         elsif (op = "010001") then s_cur_state <= LOAD1;
                         elsif (op = "001111") then s_cur_state <= STORE;
                         else s_cur_state <= I_OP;
                       end if;
        WHEN I_OP => rf_wren <= '1';
                     if (op = "011001" or op = "011010") then imm_signed <= '1';
                     else imm_signed <= '0';
                     end if;
                     s_cur_state <= FETCH1;
        WHEN R_OP => rf_wren <= '1';
                     sel_b <= '1';
                     sel_rC <= '1';
                     s_cur_state <= FETCH1;
        WHEN LOAD1 => sel_addr <= '1';
                    sel_b <= '0';
                    read <= '1';
                    imm_signed <= '1';
                    s_cur_state <= LOAD2;
        WHEN LOAD2 => rf_wren <= '1';
                     sel_mem <= '1';
                     sel_rC <= '0';
                     s_cur_state <= FETCH1;
        WHEN STORE => sel_addr <= '1';
                    sel_b <= '0';
                    write <= '1';
                    imm_signed <= '1';
                    s_cur_state <= FETCH1;
        WHEN BREAK => s_cur_state <= BREAK;
      end CASE;
    end if;
  end process;

end synth;
