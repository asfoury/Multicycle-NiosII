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
	TYPE stateType IS (FETCH1, FETCH2, DECODE, R_OP, I_OP, STORE, BREAK, LOAD1, LOAD2, BRANCH, CALL, JMP, UI_OP, RI_OP);
	SIGNAL s_cur_state, s_next_state : stateType;
begin
	op_alu <= "100001" WHEN op = "111010" and opx = "001110" else
			  "110011" WHEN op= "111010"  and opx = "011011" else
			  -- I_OP Table 8
			  "000111" WHEN (op = "000100" or op="010111" or op = "010101") else
			  -- I_OP Table 10
			  ("011" & op(5 downto 3)) WHEN ((op(2 downto 0) = "000") and 
			  	(op(5 downto 3)= "001" or 
			  	 op(5 downto 3)= "010" or 
			  	 op(5 downto 3)= "011" or 
			  	 op(5 downto 3)= "100"))else
			  	 
			  -- R_OP Table 12
			  --add/sub
			  "000111" WHEN opx = "110001" and op = "111010" else
			  "001111" WHEN opx = "111001" and op = "111010" else
			  --cmp
			  "011" & opx(5 downto 3) WHEN (opx = "001000" or opx = "010000") and op = "111010" else
			  -- logical
			  "100" & opx(5 downto 3) WHEN (opx(2 downto 0) = "110" and 
			  	  (opx(5 downto 3)= "000" 
			  	or opx(5 downto 3)= "001"
			  	or opx(5 downto 3)= "010"
			  	or opx(5 downto 3)= "011" )) and op = "111010" else
			  
			  -- shift
			  "111" & opx(5 downto 3) WHEN (opx(2 downto 0) = "011") and  
			  	  (opx(5 downto 3)= "010" 
			  	or opx(5 downto 3)= "011"
			  	or opx(5 downto 3)= "111") and op = "111010" else
			  	
			  -- R_OP Table 14
			  -- cmp
			  "011" & opx(5 downto 3) WHEN (opx(2 downto 0) = "000") and
			  	(opx(5 downto 3)= "011" 
			  	or opx(5 downto 3)= "100"
			  	or opx(5 downto 3)= "101" 
			  	or opx(5 downto 3) = "110") and op = "111010" else
			  -- rol/ror
			  "111000" WHEN opx = "000011" and op = "111010" else
			  "111001" WHEN opx = "001011" and op = "111010" else
			  -- UI_OP Table 9 and 11
			  -- Table 9
			  "100" & op(5 downto 3) WHEN op(2 downto 0) = "100" and (op(5 downto 3) = "001" 
			  	or op(5 downto 3) = "010" or op(5 downto 3) = "011") else
			  -- Table 11	
			  "011" & op(5 downto 3) WHEN op(2 downto 0) = "000" and (op(5 downto 3) = "101" or op(5 downto 3) = "110") else
			  
			  -- RI_OP Table 13 and 15
			  -- Table 13
			  "111" & opx(5 downto 3) WHEN op = "111010" and opx(2 downto 0) = "010" and (opx(5 downto 3) = "010" or opx(5 downto 3) =  "011" 
			  	or opx(5 downto 3) =  "111" or opx(5 downto 3) =  "000")else
			  
			  


			  -- theese correspond to branch
			  "011100" WHEN (op = "000110" or op="100110") else
			  "011001" WHEN (op = "001110") else
			  "011010" WHEN (op = "010110")  else
			  "011011" WHEN (op = "011110") else
			  "011101" WHEN (op = "101110") else
			  "011110" WHEN (op = "110110")
			  
		else "100000";
	
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
		
		WHEN DECODE => 
		 if(op= "111010")  and (opx = "011011" or opx = "001110"
		 	or opx = "110001" or opx="111001" or opx = "001000" or opx = "010000"
		 	or opx = "010110" or opx="011110" 
		 	or opx="010011"  or opx = "111011" or opx = "011000" or opx = "100000" 
		 	or opx = "101000" or opx= "110000" or opx="000011" or opx= "001011" or opx = "000110") 
		 	THEN s_next_state <= R_OP; end if;
		 if(op = "000100" or op = "001000" or op = "010000" or op = "011000" or op = "100000") THEN s_next_state <= I_OP; end if;
		 
		 -- UI_OP
		 if (op = "001100" or op="010100" or op = "011100" or op= "101000" or op = "110000") 
		 THEN s_next_state <= UI_OP; end if; 	
		 --RI_OP
		 if(opx = "010010" or opx= "011010" or opx="111010" or opx="000010") and op = "111010" THEN s_next_state <= RI_OP; end if;
		 
		 if(op = "010111") THEN s_next_state <= LOAD1; end if;
		 if(op = "010101") THEN s_next_state <= STORE; end if;
		 -- add new states part 4 of project	
		 -- state Branch added
		 if(op = "000110") or (op = "001110") or (op = "010110") or (op = "011110") or (op = "100110") 
		 or (op = "101110") or (op = "110110") THEN s_next_state <= BRANCH; end if;	
		 -- Call
		 if(op = "000000") THEN s_next_state <= CALL; end if;
		 if(op ="111010" and opx= "011101") THEN s_next_state <= CALL; end if;
		 -- JMP
		 if (op = "111010" and (opx = "001101" or opx = "000101")) or op = "000001" THEN s_next_state <= JMP;end if;
		 -- Nothing after this line has been modified
		 if(op= "111010" and opx ="110100") THEN s_next_state <= BREAK; end if;
		
		WHEN LOAD1 => s_next_state <= LOAD2;
		
		WHEN BREAK => s_next_state <= BREAK;
			
		WHEN OTHERS => s_next_state <= FETCH1;
		
		END CASE;
	
	END PROCESS transition;
	

	-- FETCH2
	ir_en <= '1' WHEN s_cur_state = FETCH2  ELSE '0'; 
	pc_en <= '1' WHEN s_cur_state = FETCH2 or s_cur_state = CALL or s_cur_state = JMP  ELSE '0';
	-- R_OP and I_OP
	imm_signed <= '1' WHEN s_cur_state = I_OP or s_cur_state = STORE or s_cur_state = LOAD1 ELSE '0';
	rf_wren <= '1' WHEN s_cur_state = I_OP or s_cur_state = UI_OP or s_cur_state = R_OP or s_cur_state = RI_OP or s_cur_state = LOAD2 or s_cur_state = CALL ELSE '0';
	-- R_OP and STORE
	sel_b <= '1' WHEN s_cur_state = R_OP or s_cur_state = BRANCH ELSE '0';
	sel_rC <= '1' WHEN s_cur_state = R_OP or s_cur_state = RI_OP ELSE '0';
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
	-- new values that correspond to the call instructions
	sel_pc    <= '1' WHEN s_cur_state = CALL ELSE '0';
	sel_ra   <= '1' WHEN s_cur_state = CALL ELSE '0';
	pc_sel_imm <= '1' WHEN (s_cur_state = CALL and op = "000000") or (s_cur_state = JMP and op = "000001") ELSE '0';
	pc_sel_a  <= '1' WHEN (s_cur_state = CALL and op = "111010" and opx = "011101") or (s_cur_state = JMP and (opx = "001101" or opx = "000101") and op = "111010") ELSE '0';
	
	
    
   	
   
    
	
	
	
  


	
			
			


			
end synth;
