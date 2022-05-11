--Default Library
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

LIBRARY STD;
USE STD.textio.ALL;

--Entity
ENTITY TestBunch IS
END ENTITY TestBunch;

--Architecture
ARCHITECTURE rtl OF TestBunch IS
	constant C	:	string	:= "This is a String";
	signal	X	:	std_logic_vector(3 downto 0)	:= "1010";
	signal	Y	:	integer :=	100;
BEGIN
	FileWriteProcess:	PROCESS
--		file 		Outputfile	:	text;
--		variable	lineBuffer	:	line;
	BEGIN
--		file_open(Outputfile, "Outputfile.txt", write_mode);
		
--		write(lineBuffer, string'("Signal X is: "));
--		write(lineBuffer, X);
--		writeline(Outputfile, lineBuffer);
--		
--		write(lineBuffer, string'("Signal Y is: "));
--		write(lineBuffer, Y);
--		writeline(Outputfile, lineBuffer);
--		
--		write(lineBuffer, string'("Signal C is: "));
--		write(lineBuffer, C);
--		writeline(Outputfile, lineBuffer);
--		
--		file_close(Outputfile);
		WAIT;
	END PROCESS FileWriteProcess;
END ARCHITECTURE rtl;