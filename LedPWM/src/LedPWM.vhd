--Default Librarys
library IEEE;
use IEEE.std_logic_1164.all;

--Entity
Entity LedPWM is
Port
(
	clk		:	in		std_logic;
	pwm_out	:	out	std_logic
);
End Entity LedPWM;

--Architecture
Architecture rtl of LedPWM is
	signal counter : integer range 0 to 50000000;
begin
	PWM_Process: process(clk)
	begin
		if(rising_edge(clk)) then
			if counter > 49999999 then
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
		end if;
		
		if counter > 25000000 then
			pwm_out	<= '1';
		else
			pwm_out 	<= '0';
		end if;
	end process PWM_Process;
	
	
end Architecture rtl;
