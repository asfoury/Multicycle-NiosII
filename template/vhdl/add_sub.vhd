library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is
	SIGNAL s_sub : std_logic_vector(31 downto 0);
	SIGNAL s_addResultUns : unsigned(32 downto 0);
	
	SIGNAL s_a_32Vec : std_logic_vector (31 downto 0);
	SIGNAL s_b_32Vec : std_logic_vector (31 downto 0);
	
	SIGNAL s_a_33Uns : unsigned (32 downto 0);
	SIGNAL s_b_33Uns : unsigned(32 downto 0); 
	
	SIGNAL s_addResultVec : std_logic_vector(32 downto 0);
	SIGNAL s_carryIn : unsigned(32 downto 0);
	SIGNAL s_b :std_logic_vector(31 downto 0);
begin
	s_sub <= (OTHERS => '1') WHEN sub_mode = '1' ELSE (OTHERS => '0');
	s_b <= b xor s_sub;
	
	s_a_32Vec <= a;
	s_a_33Uns <= unsigned('0'&s_a_32Vec);
	
	s_b_32Vec <= s_b;
	s_b_33Uns <= unsigned('0'&s_b_32Vec );
	
	
	
	s_carryIn <= to_unsigned(1,33) WHEN sub_mode ='1'  ELSE to_unsigned(0,33); 
	
	s_addResultUns <= s_a_33Uns + s_b_33Uns + s_carryIn;
	zero <= '1' WHEN (s_addResultUns(31 downto 0) = to_unsigned(0,32)) ELSE '0';
	s_addResultVec <= std_logic_vector(s_addResultUns);
	carry <= s_addResultVec(32);
	r <= s_addResultVec(31 downto 0); 
	
	
end synth;
