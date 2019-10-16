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
begin
	
	imm32 <= ("1111111111111111"&imm16)  WHEN signed = '1' and imm16(15) = '1' ELSE  ("0000000000000000"&imm16);
	
end synth;
