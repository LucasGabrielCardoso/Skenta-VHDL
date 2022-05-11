--Default Library
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--Entity
ENTITY Serialiser_tb IS
GENERIC
(
	DATA_WIDTH		: integer 			:=	 8;
	DEFAULT_STATE	: std_logic 		:=	'1'
);
END ENTITY Serialiser_tb;

--Architecture
ARCHITECTURE rtl OF Serialiser_tb IS
	
	signal clk		: std_logic	:= '0';
	signal rst		: std_logic;
	signal shiftEN	: std_logic;
	signal load		: std_logic;
	signal din		: std_logic_vector(DATA_WIDTH-1 downto 0);
	signal dout		: std_logic;
	
	COMPONENT Serialiser IS
	GENERIC
	(
		DATA_WIDTH		:	integer;
		DEFAULT_STATE	:	std_logic	
	);
	PORT
	(
		clk		: in 	std_logic;
		rst		: in 	std_logic;
		
		shiftEN	: in 	std_logic;	
		load		: in 	std_logic;
		din		: in 	std_logic_vector(DATA_WIDTH-1 downto 0);
		dout		: out std_logic
	);
	END COMPONENT Serialiser;

BEGIN
	
	clk	<= not clk after 10ns;
	
	UUT: Serialiser 
	GENERIC MAP
	(
		DATA_WIDTH		=>	DATA_WIDTH,
		DEFAULT_STATE	=>	DEFAULT_STATE
	)
	PORT MAP
	(
		clk		=>	clk,
		rst		=>	rst,
		
		shiftEN	=>	shiftEN,
		load		=>	load,
		din		=>	din,
		dout		=>	dout
	);
	
	TestProcess: PROCESS
	BEGIN
		rst			<= '1';
		shiftEN		<=	'0';
		load			<=	'0';
		din			<=	(others=>'0');
		wait for 100ns;
		rst			<=	'0';
		wait for 100ns;
		
		wait until rising_edge(clk);
		load			<= '1';
		din			<= x"AA";
		wait until rising_edge(clk);
		load			<= '0';
		din			<= (others=>'0');
		
		for i in 0 to 7 loop
			wait for 8.7us;
			wait until rising_edge(clk);
			shiftEN	<=	'1';
			wait until rising_edge(clk);
			shiftEN	<=	'0';
		end loop;
		
		wait;
	END PROCESS TestProcess;
	
END ARCHITECTURE rtl;