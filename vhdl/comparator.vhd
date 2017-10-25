library ieee;
use ieee.std_logic_1164.all;

entity comparator is
  port(
    a_31    : in  std_logic;
    b_31    : in  std_logic;
    diff_31 : in  std_logic;
    carry   : in  std_logic;
    zero    : in  std_logic;
    op      : in  std_logic_vector(2 downto 0);
    r       : out std_logic
  );
end comparator;

architecture synth of comparator is
begin

  with op select
    r <= ((not a_31 and b_31) or (not diff_31 and (not a_31 xor b_31))) when "001",
    ((a_31 and not b_31) or (diff_31 and (not a_31 xor b_31))) when "010",
    not zero when "011",
    not carry when "110",
    carry when "101",
    zero when others;

end synth;
