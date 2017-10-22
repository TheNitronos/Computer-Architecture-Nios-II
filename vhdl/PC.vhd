library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is

  signal s_addr : std_logic_vector(15 downto 0);

begin

  addr <= "0000000000000000" & (s_addr and ("1111111111111100"));

  pro_save : process(clk, reset_n)
  begin

    if (reset_n = '1') then
      s_addr <= "0000000000000000";
    else
      if (rising_edge(clk) and en = '1') then
        if (add_imm = '1') then s_addr <= std_logic_vector(unsigned(s_addr) + unsigned(imm));
        elsif (sel_imm = '1') then s_addr <= std_logic_vector(unsigned(s_addr) + shift_left(unsigned(imm), 2));
        elsif (sel_a = '1') then s_addr <= a;
        else s_addr <= std_logic_vector(unsigned(s_addr) + 4);
        end if;
      end if;
    end if;
    
  end process;

end synth;
