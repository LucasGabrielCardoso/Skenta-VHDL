--Standardy Library
library IEEE;
use IEEE.std_logic_1164.all;

--Entity
Entity KeyLed is
port
(
	key	:	in		std_logic;
	led	:	out	std_logic
);
end Entity KeyLed;

--Architecture
Architecture rtl of KeyLed is

begin
	Process1: process(key)
	begin
		led	<=	key;
	end process;
end architecture rtl;
