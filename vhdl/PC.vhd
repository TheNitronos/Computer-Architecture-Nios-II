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

  addr <= X"0000" & (s_addr and (X"FFF"&"1100"));

  pro_save : process(clk, reset_n, en)
  begin

    if (reset_n = '0') then s_addr <= X"0000";

    elsif (en = '1') then
      if (rising_edge(clk)) then

        if (add_imm = '1') then s_addr <= std_logic_vector(unsigned(s_addr) + unsigned(imm));
        elsif (sel_imm = '1') then s_addr <= std_logic_vector(shift_left(unsigned(imm), 2));
        elsif (sel_a = '1') then s_addr <= a;
        else s_addr <= std_logic_vector(unsigned(s_addr) + 4);
        end if;

      end if;
    end if;

  end process;

end synth;
