library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0); -- inst(5 downto 0)
        opx        : in  std_logic_vector(5 downto 0); -- inst(16 downto 11)
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is
	TYPE stateType IS (FETCH1, FETCH2, DECODE, R_OP, I_OP, STORE, BREAK, LOAD1, LOAD2, BRANCH);
	SIGNAL s_cur_state, s_next_state : stateType;
begin
	op_alu <= "100001" WHEN op = "111010" and opx = "001110" else
			  "110011" WHEN op= "111010"  and opx = "011011" else
			  "000111" WHEN (op = "000100" or op="010111" or op = "010101") else
			  -- corresponds to branch uncond instruction want to do the comp A==B so op_alu gets the compare op
			  "011100" WHEN (op = "000110" or op="100110") else
			  "011001" WHEN (op = "001110") else
			  "011010" WHEN (op = "010110")  else
			  "011011" WHEN (op = "011110") else
			  "011101" WHEN (op = "101110") else
			  "011110" WHEN (op = "110110")
			  
		else "000000";
	
	dff : process(clk, reset_n) IS
	BEGIN
		if(reset_n = '0') THEN
			s_cur_state <= FETCH1;
		else if(rising_edge(clk)) THEN
			s_cur_state <= s_next_state;
		END if;
	END if;
	end process dff;

	transition : process(s_cur_state, op, opx,s_next_state) IS
	BEGIN 
		CASE (s_cur_state) IS
		WHEN FETCH1 => s_next_state <= FETCH2;
		
		WHEN FETCH2 => s_next_state <= DECODE;
		
		WHEN DECODE => if(op = "111010" and opx = "001110") THEN s_next_state <= R_OP; end if;
		 if(op= "111010"  and opx = "011011") THEN s_next_state <= R_OP; end if;
		 if(op = "000100") THEN s_next_state <= I_OP; end if;
		 if(op = "010111") THEN s_next_state <= LOAD1; end if;
		 if(op = "010101") THEN s_next_state <= STORE; end if;
		 -- add new states part 4 of project	
		 if(op = "000110") or (op = "001110") or (op = "010110") or (op = "011110") or (op = "100110") 
		 or (op = "101110") or (op = "110110") THEN s_next_state <= BRANCH; end if;	
		 --	
		 if(op= "111010" and opx ="110100") THEN s_next_state <= BREAK; end if;
		
		WHEN LOAD1 => s_next_state <= LOAD2;
		
		WHEN BREAK => s_next_state <= BREAK;
			
		WHEN OTHERS => s_next_state <= FETCH1;
		
		END CASE;
	
	END PROCESS transition;
	

	-- FETCH2
	ir_en <= '1' WHEN s_cur_state = FETCH2  ELSE '0'; 
	pc_en <= '1' WHEN s_cur_state = FETCH2  ELSE '0';
	-- R_OP and I_OP
	imm_signed <= '1' WHEN s_cur_state = I_OP or s_cur_state = STORE or s_cur_state = LOAD1 ELSE '0';
	rf_wren <= '1' WHEN s_cur_state = I_OP or s_cur_state = R_OP or s_cur_state = LOAD2 ELSE '0';
	-- R_OP and STORE
	sel_b <= '1' WHEN s_cur_state = R_OP or s_cur_state = BRANCH ELSE '0';
	sel_rC <= '1' WHEN s_cur_state = R_OP ELSE '0';
	--LOAD1
	sel_addr <= '1' WHEN s_cur_state = LOAD1 or s_cur_state = STORE ELSE '0';
	read <= '1' WHEN s_cur_state = LOAD1 or s_cur_state = FETCH1 ELSE '0';
	--LOAD2
	sel_mem <= '1' WHEN s_cur_state = LOAD2 ELSE '0';
	--STORE
	write <= '1' WHEN s_cur_state = STORE  ELSE '0';
	
	-- new values that correspond to the branch instructions
	branch_op <= '1' WHEN s_cur_state = BRANCH ELSE '0';
	pc_add_imm <= '1' WHEN s_cur_state = BRANCH ELSE '0';
	
	-- all outputs that are not used will be given 0
	
    pc_sel_a  <= '0';
   	pc_sel_imm <= '0';
   	sel_pc    <= '0';
    sel_ra   <= '0';
	
	
	
  


	
			
			


			
end synth;
