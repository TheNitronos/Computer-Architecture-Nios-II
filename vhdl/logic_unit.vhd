library ieee;
use ieee.std_logic_1164.all;

entity logic_unit is
  port(
    a  : in  std_logic_vector(31 downto 0);
    b  : in  std_logic_vector(31 downto 0);
    op : in  std_logic_vector(1 downto 0);
    r  : out std_logic_vector(31 downto 0)
  );
end logic_unit;

architecture synth of logic_unit is
begin

  with op select r <= A nor B when "00",
                      A and B when "01",
                      A or B when "10",
                      A xor B when others;

end synth;
