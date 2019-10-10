library ieee;
use ieee.std_logic_1164.all;

entity IR is
    port(
        clk    : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic_vector(31 downto 0);
        Q      : out std_logic_vector(31 downto 0)
    );
end IR;

architecture synth of IR is
begin
	
	dff:process(clk) IS
	BEGIN
		IF(rising_edge(clk)) THEN
			IF(enable = '1') THEN
			Q <= D;
			END IF;
		END IF;
	END process dff;
end synth;
