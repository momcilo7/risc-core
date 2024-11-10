library IEEE;
use IEEE.std_logic_1164.all;

entity decoder3x8 is
	port(
		y1:out std_logic;
		y2:out std_logic;
		y3:out std_logic;
		y4:out std_logic;
		y5:out std_logic;
		y6:out std_logic;
		y7:out std_logic;
		y8:out std_logic;
		
		input:in std_logic_vector(2 downto 0);
		en:in std_logic
	);
end entity;


architecture dec3x8 of decoder3x8 is

begin
	WITH std_logic_vector'(en & input) SELECT
 		(y8,y7,y6,y5,y4,y3,y2,y1) <= 	
			std_logic_vector'("00000001") WHEN "1000",
 			std_logic_vector'("00000010") WHEN "1001",
 			std_logic_vector'("00000100") WHEN "1010",
 			std_logic_vector'("00001000") WHEN "1011",
			std_logic_vector'("00010000") WHEN "1100",
 			std_logic_vector'("00100000") WHEN "1101",
 			std_logic_vector'("01000000") WHEN "1110",
 			std_logic_vector'("10000000") WHEN "1111",
			(others => '0') when others;


end architecture;
