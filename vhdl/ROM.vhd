library ieee;
use ieee.std_logic_1164.all;

entity ROM is
  port(
    clk     : in  std_logic;
    cs      : in  std_logic;
    read    : in  std_logic;
    address : in  std_logic_vector(9 downto 0);
    rddata  : out std_logic_vector(31 downto 0)
  );
end ROM;

architecture synth of ROM is

	signal s_q : std_logic_vector(31 downto 0);

begin
  ROM_Block: entity work.ROM_Block port map(
    address => address,
    clock => clk,
    q => s_q
  );

  pro_tristate: process (clk) is
  begin


    if(rising_edge(clk) and (cs and read) = '1') then
      rddata <= s_q;
    end if;

    if (rising_edge(clk)) then
      if ((cs and read) = '1') then rddata <= s_q;
      else rddata <= (others => 'Z');
      end if;
    end if;
  end process pro_tristate;
end synth;
