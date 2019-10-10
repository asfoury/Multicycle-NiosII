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
	TYPE stateType IS (FETCH1, FETCH2, DECODE, R_OP, I_OP, STORE, BREAK, LOAD1, LOAD2);
	SIGNAL s_cur_state, s_next_state : stateType;
begin
	op_alu <= "100001" WHEN op = X"3A" and opx = X"0E" else
			  "110011" WHEN op= X"3A"  and opx = X"1B" else
			  "000000" WHEN (op = X"04" or op=X"17" or op = X"15")
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

	transition : process(s_cur_state, op, opx) IS
	BEGIN 
		CASE (s_cur_state) IS
		WHEN FETCH1 => s_next_state <= FETCH2;
		
		WHEN FETCH2 => s_next_state <= DECODE;
		
		WHEN DECODE => 
		if(op = X"3A" and opx = X"0E") THEN s_next_state <= R_OP; 
		else if(op= X"3A"  and opx = X"1B") THEN s_next_state <= R_OP;
		else if(op = X"04") THEN s_next_state <= I_OP;
		else if(op = X"17") THEN s_next_state <= LOAD1;
		else if(op = X"15") THEN s_next_state <= STORE;
		else if(op= X"3A" and opx =X"34") THEN s_next_state <= BREAK;
		end if;
		end if; end if; end if; end if; end if;
		
		WHEN LOAD1 => s_next_state <= LOAD2;
		
		WHEN BREAK => s_next_state <= BREAK;
			
		WHEN OTHERS => s_next_state <= FETCH1;
		
		END CASE;
	
	END PROCESS transition;

	
			
			


			
end synth;
