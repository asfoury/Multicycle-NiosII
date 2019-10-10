library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        write   : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        wrdata  : in  std_logic_vector(31 downto 0);
        rddata  : out std_logic_vector(31 downto 0));
end RAM;

architecture synth of RAM is
type memory_block is array(0 to 1023) of std_logic_vector(31 downto 0);
	signal s_memory_block : memory_block;
	
	
	signal s_read_and_cs : std_logic;
	signal s_address_cur : std_logic_vector(9 downto 0);
	signal s_read_and_cs_cur : std_logic;
begin
	
	
	s_read_and_cs <= read and cs;
	dffs:process(clk,s_read_and_cs_cur,s_read_and_cs,s_address_cur,address) IS
	BEGIN
		
		IF(rising_edge(clk)) THEN
			s_read_and_cs_cur <= s_read_and_cs;
			s_address_cur <= address;
		END IF;
	END process dffs;
	
	-- read process
	
	
	rddata <= s_memory_block(to_integer(unsigned(s_address_cur))) WHEN s_read_and_cs_cur = '1' ELSE (OTHERS => 'Z');	
	
	-- write process
	dff:process(clk,s_memory_block,s_address_cur,wrdata,write,cs) IS
	BEGIN
		IF(rising_edge(clk)) THEN
			IF(write = '1' and cs = '1') THEN
			s_memory_block(to_integer(unsigned(address))) <= wrdata;
			END IF;
		END IF;
	END process dff;
	
	
	
	
	
end synth;
