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

  TYPE StateType IS (FETCH1, FETCH2, DECODE, R_OP, STORE, BREAK, LOAD1, LOAD2, I_OP, BRANCH, CALL, JMP, U_I_OP, SHIFT);
  SIGNAl s_cur_state, s_next_state: StateType;

begin

  pro_op : process(op, opx) is
  begin
    if op = "111010" then if opx = "001110" then op_alu <= "100001";
                            elsif opx = "011011" then op_alu <= "110011";
                            elsif opx = "110001" then op_alu <= "000000";
                            elsif opx = "111001" then op_alu <= "001000";
                            elsif opx = "001000" then op_alu <= "011001";
                            elsif opx = "010000" then op_alu <= "011010";
                            elsif opx = "000110" then op_alu <= "100000";
                            elsif opx = "001110" then op_alu <= "100001";
                            elsif opx = "010110" then op_alu <= "100010";
                            elsif opx = "011110" then op_alu <= "100011";
                            elsif opx = "010011" then op_alu <= "110010";
                            elsif opx = "011011" then op_alu <= "110011";
                            elsif opx = "111011" then op_alu <= "110111";
                            elsif opx = "010010" then op_alu <= "110010";
                            elsif opx = "011010" then op_alu <= "110011";
                            elsif opx = "111010" then op_alu <= "110111";
                            end if;
                            
    elsif op = "010111" then op_alu <= "000000";
    elsif op = "010101" then op_alu <= "000000";
    elsif op = "001110" then op_alu <= "011001";
    elsif op = "010110" then op_alu <= "011010";
    elsif op = "011110" then op_alu <= "011011";
    elsif op = "100110" then op_alu <= "011100";
    elsif op = "101110" then op_alu <= "011101";
    elsif op = "110110" then op_alu <= "011110";
    elsif op = "000100" then op_alu <= "000000";
    elsif op = "001100" then op_alu <= "100001";
    elsif op = "010100" then op_alu <= "100010";
    elsif op = "011100" then op_alu <= "100011";
    elsif op = "000110" then op_alu <= "011100";
    else op_alu <= op;
    end if;
  end process pro_op;

  pro_fsm : process(clk) is
  begin
    if(rising_edge(clk)) then
        if (reset_n = '0') then s_cur_state <= FETCH1;
        else s_cur_state <= s_next_state;
        end if;
    end if;
  end process;

  pro_state : process(s_cur_state) is
  begin
    CASE (s_cur_state) IS
        WHEN FETCH1 => rf_wren <= '0';
                        read <= '0';
                        write <= '0';
                        pc_en <= '0';
                        ir_en <= '0';
                        branch_op <= '0';
                        imm_signed <= '0';
                        pc_add_imm <= '0';
                        pc_sel_a <= '0';
                        pc_sel_imm <= '0';
                        sel_addr <= '0';
                        sel_pc <= '0';
                        sel_ra <= '0';
                        sel_rC <= '0';
                        sel_b <= '0';
                        sel_mem <= '0';
                        write <= '0';
                        read <= '1';
                        s_next_state <= FETCH2;
        WHEN FETCH2 => read <= '0';
                        ir_en <= '1';
                       pc_en <= '1';
                       s_next_state <= DECODE;
        WHEN DECODE => ir_en <= '0';
                        pc_en <= '0';
                        if (op = "111010" and opx = "110100") then s_next_state <= BREAK;
                        elsif(op = "111010" and opx = "001101") then s_next_state <= JMP;
                        elsif(op = "111010" and opx = "000101") then s_next_state <= JMP;
                        elsif(op = "111010" and opx = "010010") then s_next_state <= SHIFT;
                        elsif(op = "111010" and opx = "011010") then s_next_state <= SHIFT;
                        elsif(op = "111010" and opx = "111010") then s_next_state <= SHIFT; 
                         elsif (op = "111010") then s_next_state <= R_OP;
                         elsif (op = "010111") then s_next_state <= LOAD1;
                         elsif (op = "010101") then s_next_state <= STORE;
                         elsif (op = "000110" or op = "001110" or op = "010110" or op = "011110" or op = "100110" or op = "101110" or op = "110110") then s_next_state <= BRANCH;
                         elsif (op = "000000") then s_next_state <= CALL;
                         elsif (op = "001100" or op = "010100" or op = "011100") then s_next_state <= U_I_OP;
                         else s_next_state <= I_OP;
                       end if;
        WHEN I_OP => rf_wren <= '1';
                     imm_signed <= '1';
                     s_next_state <= FETCH1;
        WHEN U_I_OP => rf_wren <= '1';
                     imm_signed <= '0';
                     s_next_state <= FETCH1;
        WHEN R_OP => rf_wren <= '1';
                     sel_b <= '1';
                     sel_rC <= '1';
                     s_next_state <= FETCH1;
        WHEN SHIFT => rf_wren <= '1';
                     sel_b <= '0';
                     sel_rC <= '1';
                     s_next_state <= FETCH1;
        WHEN LOAD1 => sel_addr <= '1';
                    sel_b <= '0';
                    read <= '1';
                    imm_signed <= '1';
                    s_next_state <= LOAD2;
        WHEN LOAD2 => sel_addr <= '0';
                        read <= '0';
                        imm_signed <= '0';
                        rf_wren <= '1';
                     sel_mem <= '1';
                     sel_rC <= '0';
                     s_next_state <= FETCH1;
        WHEN STORE => sel_addr <= '1';
                    sel_b <= '0';
                    write <= '1';
                    imm_signed <= '1';
                    s_next_state <= FETCH1;
        WHEN BREAK => s_next_state <= BREAK;
        WHEN BRANCH => sel_b <= '1';
                        pc_add_imm <= '1';
                        branch_op <= '1';
                        s_next_state <= FETCH1;
        WHEN CALL => sel_ra <= '1';
                    rf_wren <= '1';
                    sel_mem <= '0';
                    pc_en <= '1';
                    pc_sel_imm <= '1';
                    sel_pc <= '1';
                    sel_rC <= '0';
                    s_next_state <= FETCH1;
        WHEN JMP => pc_sel_a <= '1';
                    pc_en <= '1';
                    s_next_state <= FETCH1;
      end CASE;
    end process;
end synth;
