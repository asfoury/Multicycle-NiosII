library ieee;
use ieee.std_logic_1164.all;

entity multiplexer is
    port(
        i0  : in  std_logic_vector(31 downto 0);
        i1  : in  std_logic_vector(31 downto 0);
        i2  : in  std_logic_vector(31 downto 0);
        i3  : in  std_logic_vector(31 downto 0);
        sel : in  std_logic_vector(1 downto 0);
        o   : out std_logic_vector(31 downto 0)
    );
end multiplexer;

architecture synth of multiplexer is
begin
	o<= i0 WHEN (sel = "00") else
		i1 WHEN (sel = "01") else
		i2 WHEN (sel = "10") else
		i3 WHEN (sel = "11") else (OTHERS => '1');
end synth;
