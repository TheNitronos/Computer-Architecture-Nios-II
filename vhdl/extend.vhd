library ieee;
use ieee.std_logic_1164.all;

entity extend is
    port(
        imm16  : in  std_logic_vector(15 downto 0);
        signed : in  std_logic;
        imm32  : out std_logic_vector(31 downto 0)
    );
end extend;

architecture synth of extend is

  signal s_extended_inm : std_logic_vector(31 downto 0);

begin

  pro_ext : process(inm16, signed)
  begin
    if (signed = '1') then
      inm32 <= "1000" & X"000" & inm16;
    else
      inm32 <= X"0000" & inm16;
    end if;
  end process;

end synth;
