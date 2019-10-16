library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic; -- clock
        reset_n : in  std_logic; -- reset is active low and async
        en      : in  std_logic; -- when enable is active address gets incremented by 4
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is
	SIGNAL s_16_bit_register_cur : std_logic_vector(15 downto 0);
	SIGNAL s_16_bit_register_next : std_logic_vector(15 downto 0);
	
begin
	dff:process(clk,reset_n) IS
	BEGIN
		IF (reset_n = '0') THEN
			s_16_bit_register_cur <= (OTHERS => '0');
		ELSE IF(rising_edge(clk)) THEN
			IF(en = '1') THEN
				s_16_bit_register_cur <= s_16_bit_register_next;
			
			END IF;
		END IF;
	END IF;
END process dff;

	s_16_bit_register_next <= std_logic_vector(unsigned(s_16_bit_register_cur) + 4);
	addr <= "0000000000000000"&s_16_bit_register_cur;
	
	
	
end synth;
