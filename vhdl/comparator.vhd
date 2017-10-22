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
    r <= ((NOT a_31 AND b_31) OR (NOT diff_31 AND (NOT a_31 XOR b_31))) WHEN "001",
    ((a_31 AND NOT b_31) OR (diff_31 AND (NOT a_31 XOR b_31))) WHEN "010",
    NOT zero WHEN "011",
    NOT carry WHEN "110",
    carry WHEN "101",
    zero WHEN others;

end synth;
