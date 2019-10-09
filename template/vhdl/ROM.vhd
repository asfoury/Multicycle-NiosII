library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is
	
	signal s_read_and_cs : std_logic;
	signal s_address_cur : std_logic_vector(9 downto 0);
	signal s_read_and_cs_cur : std_logic;
	signal s_number : std_logic_vector(31 downto 0);
	
	COMPONENT ROM_Block is
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
	END Component;
begin
	
	rom_block_0 : ROM_Block
	Port map(
		address => s_address_cur,
		clock => clk,
		q => s_number
	);
	
	
	s_read_and_cs <= read and cs;
	dff1:process(clk,s_read_and_cs_cur,s_read_and_cs,s_address_cur,address) IS
		BEGIN
		IF(rising_edge(clk)) THEN
			s_read_and_cs_cur <= s_read_and_cs;
			s_address_cur <= address;
		END IF;
	END process dff1;	
	
	rddata <= s_number WHEN s_read_and_cs_cur = '1' ELSE (OTHERS => 'Z');	
	
	
	
	
	
	
	
end synth;
