library IEEE;
use IEEE.std_logic_1164.all;

entity decoder2x4 is
	port(
		y1:out std_logic;
		y2:out std_logic;
		y3:out std_logic;
		y4:out std_logic;
		
		input:in std_logic_vector(1 downto 0)
	);
end entity;


architecture dec2x4 of decoder2x4 is

begin

	WITH input SELECT
 		(y4,y3,y2,y1) <= 	
			std_logic_vector'("0001") WHEN "00",
 			std_logic_vector'("0010") WHEN "01",
 			std_logic_vector'("0100") WHEN "10",
 			std_logic_vector'("1000") WHEN "11",
			(others => '0') when others;


end architecture;

