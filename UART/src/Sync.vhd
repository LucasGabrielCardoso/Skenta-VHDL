--Default libraries
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--Entity
ENTITY Sync IS
GENERIC
(
	IDLE_STATE 		:	std_logic
);
PORT
(
	clk		:	in		std_logic;							
	rst		:	in		std_logic;														
	async		:	in		std_logic;														
	synced	:	out	std_logic
);
END ENTITY Sync;

--Architecture
ARCHITECTURE rtl OF Sync IS
	signal SR	:	std_logic_vector(1 downto 0);
BEGIN
	synced <=	SR(1);
	
	SynchronisationProcess:	PROCESS(clk, rst)
	BEGIN
		IF(rst = '1')	THEN
			SR	<=	(OTHERS => IDLE_STATE);
		ELSIF(rising_edge(clk))	THEN
			SR(0)	<=	async;
			SR(1)	<=	SR(0);
		END IF;
	END PROCESS SynchronisationProcess;
	
END ARCHITECTURE rtl;