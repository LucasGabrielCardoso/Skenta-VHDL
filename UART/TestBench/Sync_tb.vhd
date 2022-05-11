--Default Library
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--Entity
ENTITY Sync_tb
END ENTITY Sync_tb;

--Architecture
ARCHITECTURE rtl OF Sync_tb IS
--/==================================================
--/					SIGNAL DECLARATION
--/==================================================
	signal	IDLE_STATE 		:	std_logic;
	signal	clk				:	std_logic	:= '0';							
	signal	rst				:	std_logic;														
	signal	async				:	std_logic;														
	signal	synced			:	std_logic;

--/==================================================
--/					COMPONENT DECLARATION
--/==================================================
	COMPONENT Sync IS
	GENERIC
	(
		IDLE_STATE 		:	std_logic
	)
	PORT
	(
		clk				:	in		std_logic;							
		rst				:	in		std_logic;														
		async				:	in		std_logic;														
		synced			:	out	std_logic
	);
	END COMPONENT Sync;

BEGIN
--/==================================================
--/					SIGNAL INSTATIATION
--/==================================================
	clk	<=	not clk after 10ns;
	
--/==================================================
--/					COMPONENT INSTATIATION
--/==================================================
	UUT: Sync 
	GENERIC
	(
		IDLE_STATE 		=>	IDLE_STATE
	)
	PORT
	(
		clk				=>	clk,							
		rst				=>	rst,														
		async				=>	async,														
		synced			=>	synced
	);
	END COMPONENT Sync;

--/==================================================
--/							PROCESS
--/==================================================	

	
END ARCHITECTURE rtl;