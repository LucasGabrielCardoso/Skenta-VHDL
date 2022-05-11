--Default Library
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--Entity
ENTITY SevenSegmentsDisplay IS
PORT
(
	clk		:	in		std_logic;
	rst_n		:	in		std_logic;
	sw1		:	in		std_logic;
	K			:	out	std_logic_vector(6 downto 0);
	DP			:	out	std_logic;
	A			:	out	std_logic_vector(3 downto 0)
);
END ENTITY SevenSegmentsDisplay;

--Architecture
ARCHITECTURE rtl OF SevenSegmentsDisplay IS

type	StateMachineType	is	(DRIVE_0, DRIVE_1, DRIVE_2, DRIVE_3);

constant debouncePeriod		:	integer := 2500000;

signal debounceCounter		:	integer;
signal sync						:	std_logic_vector(1 downto 0);
signal sw1Sync					:	std_logic;
signal sw1Debounced			:	std_logic;
signal K_Inter					:	std_logic_vector(6 downto 0);
signal SMState					:	StateMachineType;
signal sw1DebouncedDelay	:	std_logic;
signal fallingEdge			:	std_logic;
signal digit0					:	integer;
signal digit1					:	integer;
signal digit2					:	integer;
signal digit3					:	integer;
signal counterPeriode		:	integer;
signal NumberToDisplay		:	integer;
--signal K_Inter				:	std_logic_vector(6 downto 0);

BEGIN
	
	Dp			<=	'1';
	K			<=	not(K_Inter);
	sw1Sync	<=	sync(1);
	
	SyncroniseSW1Process: PROCESS(clk, rst_n)
	BEGIN
		IF(rst_n = '0')	THEN
			sync					<=	"11";
		ELSIF(rising_edge(clk))	THEN
			sync(0)	<=	sw1;
			sync(1)	<=	sync(0);
		END IF;
	END PROCESS SyncroniseSW1Process;
	
	DebounceProcess: PROCESS(clk, rst_n)
	BEGIN
		IF(rst_n	=	'0')	THEN
			debounceCounter	<=	0;
			sw1Debounced		<=	'1';
		ELSIF(rising_edge(clk))	THEN
			IF(sw1Sync = '0')	THEN
				IF(debounceCounter < debouncePeriod)	THEN
					debounceCounter <=	debounceCounter + 1;
				END IF;
			ELSE
				IF(debounceCounter  > 0)	THEN
					debounceCounter	<=	debounceCounter - 1;
				END IF;
			END IF;
			
			IF(debounceCounter = debouncePeriod)	THEN
				sw1Debounced	<=	'0';
			ELSIF(debounceCounter = 0)	THEN
				sw1Debounced	<=	'1';
			END IF;
		END IF;
	END PROCESS DebounceProcess;
	
	DetectButtonFallingEdgeProcess: PROCESS(clk, rst_n)
	BEGIN
		IF(rst_n = '0')	THEN
			sw1DebouncedDelay	<=	'1';
			fallingEdge			<=	'0';
		ELSIF(rising_edge(clk))	THEN
			sw1DebouncedDelay	<=	sw1Debounced;
			IF((sw1Debounced = '0') and (sw1DebouncedDelay = '1'))	THEN
				fallingEdge	<=	'1';
			ELSE
				fallingEdge	<=	'0';
			END IF;
		END IF;
	END PROCESS DetectButtonFallingEdgeProcess;
	
	CounterButtonProcess: PROCESS(clk, rst_n)
	BEGIN
		IF(rst_n = '0')	THEN
			digit0	<=	0;
			digit1	<=	0;
			digit2	<=	0;
			digit3	<=	0;
		ELSIF(rising_edge(clk))	THEN
			IF(fallingEdge = '1')	THEN
				IF(digit0 < 9)	THEN
					digit0	<= digit0 + 1;
				ELSE
					digit0	<=	0;
					IF(digit1 < 9)	THEN
						digit1	<=	digit1 + 1;
					ELSE
						digit1	<=	0;
						IF(digit2 < 9)	THEN
							digit2	<= digit2 + 1;
						ELSE
							digit2	<= 0;
							IF(digit3 < 9)	THEN
								digit3	<=	digit3 + 1;
							ELSE
								digit3	<=	0;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;
	END PROCESS CounterButtonProcess;
	
	DecoderProcess: PROCESS(clk, rst_n)
	BEGIN
		IF(rst_n = '0')	THEN
			K_Inter	<=	"0000000";
		ELSIF(rising_edge(clk))	THEN
			CASE NumberToDisplay	IS
				WHEN 0 		=> K_Inter <= "0111111";
				WHEN 1 		=> K_Inter <= "0000110";
				WHEN 2 		=> K_Inter <= "1011011";
				WHEN 3 		=> K_Inter <= "1001111";
				WHEN 4 		=> K_Inter <= "1100110";
				WHEN 5 		=> K_Inter <= "1101101";
				WHEN 6 		=> K_Inter <= "1111101";
				WHEN 7 		=> K_Inter <= "0000111";
				WHEN 8 		=> K_Inter <= "1111111";
				WHEN 9 		=> K_Inter <= "1100111";
				WHEN OTHERS	=> K_Inter <= "0000000";
			END CASE;
		END IF;
	END PROCESS DecoderProcess;
	
	StateMachineProcess: PROCESS(clk, rst_n)
	BEGIN
		IF(rst_n = '0')	THEN
			SMState	<=	DRIVE_0;
			A			<=	"1111";
		ELSIF(rising_edge(clk))	THEN
			CASE SMState IS
				WHEN DRIVE_0 	=> NumberToDisplay	<=	digit0;
										A						<=	"1110";
										counterPeriode		<=	counterPeriode + 1;
										IF(counterPeriode = 50000)	THEN
											SMState			<= DRIVE_1;
											counterPeriode	<=	0;
										END IF;
										
				WHEN DRIVE_1 	=> NumberToDisplay	<= digit1;
										A						<=	"1101";
										counterPeriode		<=	counterPeriode + 1;
										IF(counterPeriode = 50000)	THEN
											SMState			<=	DRIVE_2;
											counterPeriode	<=	0;
										END IF;
										
				WHEN DRIVE_2 	=> NumberToDisplay	<=	digit2;
										A						<=	"1011";
										counterPeriode		<=	counterPeriode + 1;
										IF(counterPeriode = 50000)	THEN
											SMState			<=	DRIVE_3;
											counterPeriode	<=	0;
										END IF;
										
				WHEN DRIVE_3	=> NumberToDisplay	<= digit3;
										A						<=	"0111";
										counterPeriode		<=	counterPeriode + 1;
										IF(counterPeriode = 50000)	THEN
											SMState			<=	DRIVE_0;
											counterPeriode	<=	0;
										END IF;
										
				WHEN OTHERS		=> SMState	<= DRIVE_0;
										
			END CASE;
		END IF;
	END PROCESS StateMachineProcess;

END ARCHITECTURE rtl;