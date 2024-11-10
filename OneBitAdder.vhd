library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY fulladder IS
 	PORT (a, b, cin: IN std_logic; s, cout: OUT std_logic);
END ENTITY fulladder;
 --- 
ARCHITECTURE fa OF fulladder IS
BEGIN
 	WITH std_logic_vector'(a, b, cin) SELECT
 		(cout, s) <= 	std_logic_vector'("00") WHEN "000",
 				std_logic_vector'("01") WHEN "001",
 				std_logic_vector'("01") WHEN "010",
 				std_logic_vector'("10") WHEN "011",
 				std_logic_vector'("01") WHEN "100",
 				std_logic_vector'("10") WHEN "101",
 				std_logic_vector'("10") WHEN "110",
 				std_logic_vector'("11") WHEN "111",
				(others => 'Z') when others; 
END ARCHITECTURE fa;

