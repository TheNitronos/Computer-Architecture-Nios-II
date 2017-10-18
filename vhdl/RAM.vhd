library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
  port(
    clk     : in  std_logic;
    cs      : in  std_logic;
    read    : in  std_logic;
    write   : in  std_logic;
    address : in  std_logic_vector(9 downto 0);
    wrdata  : in  std_logic_vector(31 downto 0);
    rddata  : out std_logic_vector(31 downto 0)
  );
end RAM;

architecture synth of RAM is

	type words_type is array(0 to 1023) of std_logic_vector(31 downto 0);

	signal words: words_type := (others => (others => 'Z'));
	signal s_cs_and_read: std_logic;
  signal s_addr : std_logic_vector(9 downto 0);

begin

  pro_read_en : process(clk) is
  begin
    if(rising_edge(clk)) then
      s_cs_and_read <= cs and read;
      s_addr <= address;
    end if;
  end process;

  pro_read: process (s_cs_and_read, s_addr, words) is
  begin
  	rddata <= (others => 'Z');

    if(s_cs_and_read = '1') then
      rddata <= words(to_integer(unsigned(s_addr)));
    end if;
  end process;

  pro_write: process (clk) is
  begin
    if (rising_edge(clk)) then
      if(cs = '1' and write = '1') then
      		words(to_integer(unsigned(address))) <= wrdata;
      end if;
    end if;
  end process;
end synth;
