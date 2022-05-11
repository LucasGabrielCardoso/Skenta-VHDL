-- Default Library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Entity
entity RAM is
generic
(
	Dwidth		:	integer	:= 5;
	Awidth		:	integer	:= 5
);
port
(
	Clock			:	in		std_logic;
	WriteData	:	in		std_logic_vector(Dwidth-1 downto 0);
	ReadData		:	out	std_logic_vector(Dwidth-1 downto 0);
	Address		:	in		std_logic_vector(Awidth-1 downto 0);
	WriteEnable	:	in		std_logic
);
end entity RAM;

-- Architecture
architecture rtl of RAM is
	type memory_t	is	array(0 to 2**Awidth-1)	of std_logic_vector((Dwidth-1) downto 0);
	signal MyRam	:	memory_t;
begin
	RAMProcess:	process(Clock)
	begin
		if(rising_edge(Clock))	then
			if(WriteEnable = '1')	then
				MyRAM(to_integer(unsigned(Address)))<=WriteData;
			end if;
			ReadData	<=	MyRAM(to_integer(unsigned(Address)));
		end if;
	end process RAMProcess;
end architecture rtl;