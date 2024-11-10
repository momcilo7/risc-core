library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer2x1 is
generic(wid:natural:=32);
port(
	x1:in std_logic_vector(wid-1 downto 0);
	x2:in std_logic_vector(wid-1 downto 0);
	
	s1:in std_logic;

	y:out std_logic_vector(wid-1 downto 0)
);
end entity;



architecture mux2x1 of multiplexer2x1 is

begin

	WITH s1 SELECT
 		y <= 	x1 WHEN '0',
 			x2 WHEN '1',
			(others => '0') when others;
end architecture;

