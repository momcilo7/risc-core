library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer4x1 is
generic(wid:natural:=32);
port(
	x1:in std_logic_vector(wid-1 downto 0);
	x2:in std_logic_vector(wid-1 downto 0);
	x3:in std_logic_vector(wid-1 downto 0);
	x4:in std_logic_vector(wid-1 downto 0);
	s1:in std_logic;
	s2:in std_logic;
	y:out std_logic_vector(wid-1 downto 0)
);
end entity;


architecture mux4x1 of multiplexer4x1 is

begin

	WITH std_logic_vector'(s2,s1) SELECT
 		y <= 	x1 WHEN "00",
 			x2 WHEN "01",
 			x3 WHEN "10",
 			x4 WHEN "11",
			(others => '0') when others;
end architecture;


