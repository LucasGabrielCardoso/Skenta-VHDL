--Default Libraries
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--Entity
ENTITY UART_TX_tb IS
GENERIC
(	
	RS232_DATA_BIT	: integer := 8;
	SYS_CLK_FREQ	: integer := 50000000;
	BAUD_RATE		: integer := 115200	--Bit period = 8.7us
);
END ENTITY UART_TX_tb;

--Architecture
ARCHITECTURE rtl OF UART_TX_tb IS
--/=========================================
--/			COMPONENTS DECLARATION
--/=========================================
	COMPONENT UART_TX IS
	GENERIC
	(
		RS232_DATA_BIT		: integer;
		SYS_CLK_FREQ		: integer;
		BAUD_RATE			: integer := 115200
	);
	PORT
	(
		clk				: in		std_logic;
		rst				: in		std_logic;
		tx_start			: in		std_logic;
		tx_data			: in		std_logic_vector(RS232_DATA_BIT-1 downto 0);
		tx_Ready			: out		std_logic;
		uart_tx_pin		: out 	std_logic
	);
END COMPONENT UART_TX;

--//=============================================
--//				SIGNAL DECLARATION
--//=============================================
signal	clk				: std_logic	:=	'0';
signal	rst				: std_logic;
signal	tx_start			: std_logic;
signal	tx_data			: std_logic_vector(RS232_DATA_BIT-1 downto 0);
signal	tx_Ready			: std_logic;
signal	uart_tx_pin		: std_logic;

BEGIN
--//=============================================
--//				SIGNAL INSTATIATION
--//=============================================
	clk	<=	not clk after 10ns;	--Simulate the 50 MHz clock input

--//=============================================
--//		COMPOENTS INSTATIATION
--//=============================================
	UART_TX_inst: UART_TX
	GENERIC MAP
	(
		RS232_DATA_BIT		=>	RS232_DATA_BIT,
		SYS_CLK_FREQ		=>	SYS_CLK_FREQ,
		BAUD_RATE			=>	BAUD_RATE
	)
	PORT MAP
	(
		clk			=> clk,
		rst			=> rst,
		tx_start		=> tx_start,
		tx_data		=> tx_data,
		tx_Ready		=> tx_Ready,
		uart_tx_pin	=> uart_tx_pin
	);

--//=============================================
--//						PROCESSES
--//=============================================
	TestProcess: PROCESS
	BEGIN
		rst			<=	'1';
		tx_start		<=	'0';
		tx_data		<=	(OTHERS => '0');
		WAIT FOR 100ns;
		rst	<= '0';
		WAIT FOR 100ns;
		
		WAIT UNTIL rising_edge(clk);
		tx_data	<=	x"AA";
		tx_start	<=	'1';
		WAIT UNTIL rising_edge(clk);
		tx_start		<=	'0';
		tx_data		<=	(OTHERS => '0');		
		
		WAIT;
		END PROCESS TestProcess;
END ARCHITECTURE rtl;