--Default library
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--Entity
ENTITY UART_TX IS
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
END ENTITY UART_TX;

--Architecture

--/==========================================
--/	       COMPONET DECLARATION
--/==========================================
ARCHITECTURE rtl OF UART_TX IS

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

	COMPONENT BaudClkGenerator IS
	generic 
	(
		 NUMBER_OF_CLOCKS    : integer;
		 SYS_CLK_FREQ        : integer;
		 BAUD_RATE           : integer
	);
	port
	(
		 Clk 		: in std_logic; -- 50MHz
		 Rst 		: in std_logic;
						
		 Start   : in std_logic;
		 BaudClk : out std_logic;
		 Ready   : out std_logic
	);
	end COMPONENT BaudClkGenerator;

--/=============================================
--/               SIGNAL DECLARATION
--/=============================================
	signal	BaudClk		: std_logic;
	signal	tx_packet	: std_logic_vector(RS232_DATA_BIT+1 downto 0);
	
BEGIN

	tx_packet	<=	'1' & tx_data & '0';
	
--/===========================================
--/			COMPONENT INSTATIATION
--/===========================================
	UART_Serialiser_Inst: Serialiser
	GENERIC	MAP
	(
		DATA_WIDTH		=>	RS232_DATA_BIT + 2,
		DEFAULT_STATE	=>	'1'	
	)
	PORT	MAP
	(
		clk		=> clk,
		rst		=> rst,
		shiftEN	=> BaudClk,
		load		=> tx_start,
		din		=> tx_packet,
		dout		=> uart_tx_pin
	);

	UART_BIT_Timing_Inst: BaudClkGenerator
	GENERIC MAP
	(
		 NUMBER_OF_CLOCKS    => RS232_DATA_BIT + 2,
		 SYS_CLK_FREQ        => SYS_CLK_FREQ,
		 BAUD_RATE           => BAUD_RATE
	)
	PORT	MAP
	(
		 Clk 		=> Clk,
		 Rst 		=> Rst,
		 Start   => tx_start,
		 BaudClk => BaudClk,
		 Ready   => tx_Ready
	);	
	
	
END ARCHITECTURE rtl;