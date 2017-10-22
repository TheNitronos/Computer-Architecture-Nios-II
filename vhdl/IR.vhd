library ieee;
use ieee.std_logic_1164.all;

entity IR is
    port(
        clk    : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic_vector(31 downto 0);
        Q      : out std_logic_vector(31 downto 0)
    );
end IR;

architecture synth of IR is

  signal s_D : std_logic_vector(31 downto 0);

begin

  pro_save : process(D, enable)
  begin

    if (enable = '1') then s_D <= D;
    end if;

  end process;

  pro_write : process(clk)
  begin

    if(rising_edge(clk)) then Q <= s_D;
    end if;

  end process;

end synth;
