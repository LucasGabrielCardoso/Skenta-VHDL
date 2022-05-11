--Defaut Libraries
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--Entity
ENTITY ShiftRegister_tb IS
END ENTITY ShiftRegister_tb;

--Architecture
ARCHITECTURE rtl OF ShiftRegister_tb IS

--//==================================================
--//                  SIGNAL DECLARATION
--//==================================================
	SIGNAL clk					: std_logic	:= '0';		
	SIGNAL rst					: std_logic;	
	SIGNAL shiftEn				: std_logic;	
	SIGNAL din					: std_logic;
	SIGNAL dout					: std_logic_vector(7 downto 0);	
	
--//==================================================
--//                  COMPONENT DECLARATION
--//==================================================
	COMPONENT ShiftRegister IS
	GENERIC
	(
		CHAIN_LENGHT		:	integer;
		SHIFT_DIRECTION	:	character
	);
	PORT
	(
		clk					: in	std_logic;		
		rst					: in	std_logic;	
		shiftEn				: in	std_logic;	
		din					: in	std_logic;
		dout					: out	std_logic_vector(CHAIN_LENGHT-1 downto 0)	
	);
	END COMPONENT ShiftRegister;

BEGIN

--//==================================================
--//                  SIGNAL INSTATIATION
--//==================================================	
	clk <= not clk after 10ns;
	
--//==================================================
--//                  COMPONENT INSTATIATION
--//==================================================	
	UUT: ShiftRegister
	GENERIC MAP
	(
		CHAIN_LENGHT		=>	8,
		SHIFT_DIRECTION	=>	'R'
	)
	PORT MAP
	(
		clk		=> clk,		
		rst		=> rst,	
		shiftEn	=> shiftEn,
		din		=> din,
		dout		=> dout
	);
	
--//==================================================
--//                  TEST PROCESS
--//==================================================	

	TestProcess: PROCESS
	BEGIN
		rst				<=	'1';
		shiftEn			<=	'0';
		din				<=	'0';
		WAIT FOR 100ns;
		rst				<=	'0';
		WAIT FOR 100ns;
		
		--RS232 transmitted here is 0x51	-> 0b0101 0001
		din				<=	'1';
		WAIT FOR 4.3us;
		WAIT UNTIL	rising_edge(clk);
		shiftEn			<=	'1';
		WAIT UNTIL	rising_edge(clk);
		shiftEn			<=	'0';
		WAIT FOR 4.3us;
			
		FOR i IN 0 TO 2 LOOP
			din				<=	'0';
			WAIT FOR 4.3us;
			WAIT UNTIL	rising_edge(clk);
			shiftEn			<=	'1';
			WAIT UNTIL	rising_edge(clk);
			shiftEn			<=	'0';
			WAIT FOR 4.3us;
		END LOOP;
		
		FOR i IN 0 TO 1 LOOP
			din				<=	'1';
			WAIT FOR 4.3us;
			WAIT UNTIL	rising_edge(clk);
			shiftEn			<=	'1';
			WAIT UNTIL	rising_edge(clk);
			shiftEn			<=	'0';
			WAIT FOR 4.3us;
			
			din				<=	'0';
			WAIT FOR 4.3us;
			WAIT UNTIL	rising_edge(clk);
			shiftEn			<=	'1';
			WAIT UNTIL	rising_edge(clk);
			shiftEn			<=	'0';
			WAIT FOR 4.3us;
		END LOOP;

		WAIT;
	END PROCESS TestProcess;

END ARCHITECTURE rtl;