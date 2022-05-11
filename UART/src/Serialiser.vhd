--Default Library
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--Entity
ENTITY Serialiser IS
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
END ENTITY Serialiser;

--Architecture
ARCHITECTURE rtl OF Serialiser IS
	signal shift_register	:	std_logic_vector(DATA_WIDTH-1 downto 0);
BEGIN
	dout	<=	shift_register(0);
	
	SerialiserProcess: PROCESS(clk, rst)
	BEGIN
		IF(rst = '1')	THEN
			shift_register	<=	(others => DEFAULT_STATE);
		ELSIF(rising_edge(clk))	THEN
			IF(load = '1')	THEN
				shift_register	<=	Din;
			ELSIF(shiftEN = '1')	THEN
				shift_register	<=	DEFAULT_STATE & shift_register(shift_register'left downto 1);
			END IF;
		END IF;
	END PROCESS SerialiserProcess;
	
END ARCHITECTURE rtl;