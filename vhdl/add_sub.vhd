library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
  port(
    a        : in  std_logic_vector(31 downto 0);
    b        : in  std_logic_vector(31 downto 0);
    sub_mode : in  std_logic;
    carry    : out std_logic;
    zero     : out std_logic;
    r        : out std_logic_vector(31 downto 0)
  );
end add_sub;

architecture synth of add_sub is

	signal s_unsigned_adder : std_logic_vector(32 downto 0);
	signal s_sub : std_logic_vector(31 downto 0);
	signal s_cin : signed(32 downto 0);

begin

	s_sub <= (others => sub_mode);
	s_cin <= to_signed(1, 33) when sub_mode = '1' else to_signed(0, 33);
	s_unsigned_adder <= std_logic_vector(signed('0' & a) + signed('0' & (s_sub XOR b)) + s_cin);
	carry <= s_unsigned_adder(32);
	r <= s_unsigned_adder(31 downto 0);
	zero <= '1' when s_unsigned_adder(31 downto 0) = X"00000000" else '0';

end synth;
