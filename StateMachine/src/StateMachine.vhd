--Standardy Library
library IEEE;
use IEEE.std_logic_1164.all;

--Entity
Entity StateMachine is
port
(
	rst	:	in		std_logic;
	sw		:	in		std_logic_vector(3 downto 1);
	led	:	out	std_logic_vector(3 downto 1);
	clk	:	in		std_logic
);
end Entity StateMachine;

--Architecture
Architecture rtl of StateMachine is
	type	DataTypeOfSMState is (STATE1, STATE2, STATE3);
	signal StateVariable	:	DataTypeOfSMState;
	signal clk_25MHz		:	std_logic;
	
	COMPONENT PLL IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0				: OUT STD_LOGIC 
	);
	END COMPONENT PLL;
	
begin

	PLL1: PLL 
	PORT MAP
	(
		areset		=>	not(rst),
		inclk0		=>	clk,
		c0				=>	clk_25MHz
	);

	
	Process1: process(rst, clk_25MHz)
	begin
		if rst = '0' then
			StateVariable	<=	STATE1;
			led				<=	"111";
		elsif(rising_edge(clk_25MHz)) then
			case StateVariable is
			
				when STATE1	=>	
					led	<=	"110";
					if sw(1) = '0' then
						StateVariable	<=	STATE2;
					end if;
					
				when STATE2	=>	
					led	<=	"101";
					if sw(2) = '0' then
						StateVariable	<=	STATE3;
					end if;
				
				when STATE3	=>	
					led	<=	"011";
					if sw(3) = '0' then
						StateVariable	<= STATE1;
					end if;
				
				when OTHERS	=>	
					StateVariable <= STATE1;
			end case;
		end if;
	end process;
end architecture rtl;
