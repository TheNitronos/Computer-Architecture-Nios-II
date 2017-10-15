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

  signal s_extended_imm : std_logic_vector(31 downto 0);
  signal s_imm16 : std_logic_vector(15 downto 0);

begin

  s_imm16 <= imm16;

  pro_ext : process(s_imm16, signed)
  begin
    if (signed = '1' and s_imm16(0) = '1') then
      imm32 <= X"1111" & s_imm16;
    else
      imm32 <= X"0000" & s_imm16;
    end if;
  end process;

end synth;
