--Default Library
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY ShiftRegister IS
PORT
(
	rst_n			:	in		std_logic;
	clk			:	in		std_logic;
	
	sw1			:	in		std_logic;
	led			:	out	std_logic_vector(1 to 4)
);
END ENTITY ShiftRegister;

--Architecture
ARCHITECTURE rtl OF ShiftRegister IS
	constant DebouncedPeriod:	integer:=2500000;
	
	signal ButtonPressed		:	std_logic;
	signal ShiftReg			:	std_logic_vector(1 to 4);
	signal sync					:	std_logic_vector(1 downto 0);
	signal delay_switch		:	std_logic;
	signal counter				:	integer;
	signal debouncedSW1		:	std_logic;
BEGIN
	
	led <= ShiftReg;
	
	SyncProcess: PROCESS(clk, rst_n)
	BEGIN
		IF(rst_n = '0')	THEN
			sync	<=	"11";
		ELSIF(rising_edge(clk))	THEN
			sync(0)	<= sw1;
			sync(1)	<= sync(0);
		END IF;
	END PROCESS SyncProcess;
	
	DebounceProcess:	PROCESS(clk, rst_n)
	BEGIN
		IF(rst_n = '0')	THEN
			counter			<=	0;
			debouncedSW1	<=	'1';
		ELSIF(rising_edge(clk))	THEN
			IF(sync(1) = '0')	THEN
				IF(counter < DebouncedPeriod)	THEN
					counter	<= counter + 1;
				END IF;
			ELSE
				IF(counter > 0)	THEN
					counter <= counter - 1;
				END IF;
			END IF;
			
			IF(counter = DebouncedPeriod)	THEN
				debouncedSW1	<= 	'0';
			ELSIF(counter = 0)	THEN
				debouncedSW1	<=		'1';
			END IF;
		END IF;
	END PROCESS DebounceProcess;
	
	ButtonPressDetect: PROCESS(rst_n, clk)
	BEGIN
		IF(rst_n='0')	THEN
			delay_switch	<=	'1';
			ButtonPressed	<=	'0';
		ELSIF(rising_edge(clk))	THEN
			delay_switch	<= debouncedSW1;
			IF((debouncedSW1='0') and (delay_switch='1'))	THEN
				ButtonPressed	<= '1';
			ELSE
				ButtonPressed	<=	'0';
			END IF;
		END IF;
	END PROCESS ButtonPressDetect;
	
	ShiftProcess: PROCESS(rst_n, clk)
	BEGIN
		IF(rst_n = '0')	THEN
			ShiftReg	<=	"0111";
		ELSIF(rising_edge(clk))	THEN
			IF(ButtonPressed = '1')	THEN
				ShiftReg	<=	ShiftReg(4)&ShiftReg(1 to 3);
			END IF;
		END IF;
	END PROCESS ShiftProcess;
	
END ARCHITECTURE rtl;