-- Default Library 
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--Entity
ENTITY HeaterMachine IS
PORT
(
	clk				:	in		std_logic;
	rst_n				:	in		std_logic;
	sw					:	in		std_logic;
	thermostate		:	in		std_logic;
	waterLevel		:	in		std_logic;
	ledReady			:	out	std_logic;
	ledError			:	out	std_logic;
	heater			:	out	std_logic
);
END ENTITY HeaterMachine;

--Architecture
ARCHITECTURE rtl OF HeaterMachine IS
type FSMStateType is (IDLE, ERROR, HEATING, READY);
signal State	:	FSMStateType;
BEGIN
	FSMProcess: PROCESS(clk, rst_n)
	BEGIN
		IF(rst_n = '0')	THEN
			State			<=	IDLE;
			ledReady		<=	'0';
			ledError		<=	'0';
			heater		<=	'0';
		ELSIF(rising_edge(clk))	THEN
			CASE State IS
				WHEN IDLE 	=>	ledReady <= '0';
									ledError	<=	'0';
									heater	<=	'0';
									IF((sw = '1') and (waterLevel = '1'))	THEN
										State	<=	ERROR;
									ELSIF(sw = '1')	THEN
										State	<= HEATING;
									END IF;
									
				WHEN ERROR 	=>	ledReady	<=	'0';
									ledError	<=	'1';
									heater	<=	'0';
									IF(sw	=	'0')	THEN
										State <= IDLE;
									END IF;
									
				WHEN HEATING=>	ledReady	<= '0';
									ledError	<= '0';
									heater	<=	'1';
									IF(sw	=	'0')	THEN
										State	<=	IDLE;
									ELSIF(thermostate = '1')	THEN
										State	<=	READY;
									END IF;
									
				WHEN READY	=>	ledReady	<=	'1';
									ledError	<=	'0';
									heater	<=	'0';
									IF(sw = '0')	THEN
										State <=	IDLE;
									ELSIF(thermostate = '0')	THEN
										State	<=	HEATING;
									END IF;
			END CASE;
		END IF;
	END PROCESS FSMProcess;
END ARCHITECTURE rtl;