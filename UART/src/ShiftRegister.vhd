--Default Libraries
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--Entity
ENTITY ShiftRegister IS
GENERIC
(
	CHAIN_LENGHT		:	integer;
	SHIFT_DIRECTION	:	character	--'L' generates a shift to the left. 'R' generates a shift to the right
);
PORT
(
	clk		: in	std_logic;		
	rst		: in	std_logic;	
	shiftEn	: in	std_logic;	
	din		: in	std_logic;
	dout		: out	std_logic_vector(CHAIN_LENGHT-1 downto 0)	
);
END ENTITY ShiftRegister;

--Architecture
ARCHITECTURE rtl OF ShiftRegister IS
	signal SR	: std_logic_vector(CHAIN_LENGHT-1 downto 0);
BEGIN

	dout <=	SR;
	
	--Shift SR to the right (when the serial data is transmitted LSB first)
	SHIFT_TO_THE_RIGHT: IF(SHIFT_DIRECTION = 'R') 
	GENERATE
	
		ShiftProcess:	PROCESS(clk, rst)
		BEGIN
			IF(rst = '1')	THEN
				SR	<= (OTHERS => '0');
			ELSIF(rising_edge(clk))		THEN
				IF(shiftEn	=	'1')	THEN
					SR	<= din & SR(SR'left downto 1);
				END IF;
			END IF;
		END PROCESS ShiftProcess;	
	
	END GENERATE;
	
	--Shift SR to the right (when the serial data is transmitted MSB first)
	SHIFT_TO_THE_LEFT: IF(SHIFT_DIRECTION = 'L') 
	GENERATE
	
		ShiftProcess:	PROCESS(clk, rst)
		BEGIN
			IF(rst = '1')	THEN
				SR	<= (OTHERS => '0');
			ELSIF(rising_edge(clk))		THEN
				IF(shiftEn	=	'1')	THEN
					SR	<= SR(SR'left-1 downto 0) & din;
				END IF;
			END IF;
		END PROCESS ShiftProcess;	
	
	END GENERATE;
	
END ARCHITECTURE rtl;