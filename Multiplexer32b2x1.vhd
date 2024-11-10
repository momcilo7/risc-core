library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fulladdermultiplexer2x1 is
generic(wid:natural:=32);
port(
	x1:in std_logic_vector(wid-1 downto 0);
	x2:in std_logic_vector(wid-1 downto 0);
	
	cin1:in std_logic;
	cin2:in std_logic;

	s1:in std_logic;

	y:out std_logic_vector(wid-1 downto 0);
	cout: out std_logic	
);
end entity;



architecture famux of fulladdermultiplexer2x1 is

begin

	WITH s1 SELECT
 		y <= 	x1 WHEN '0',
 			x2 WHEN '1',
			(others => '0') when others;
end architecture;



--architecture famux2x1 of fulladdermultiplexer2x1 is
--
--begin
--
--	WITH s1 SELECT
-- 		y <= 	x1 WHEN '0',
-- 			x2 WHEN '1',
--			(others => '0') when others;
--
--	with s1 select
--		cout<= cin1 when '0',
--			cin2 when '1',
--			'0' when others;
--
--end architecture;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity predictedMultiplexer is
generic(wid:natural:=32);
port(
	x1:in std_logic_vector(wid-1 downto 0);
	x2:in std_logic_vector(wid-1 downto 0);
	
	cin1:in std_logic;
	cin2:in std_logic;

	s1:in std_logic;

	y:out std_logic_vector(wid-1 downto 0);
	cout: out std_logic;
	
	predCin:in std_logic;
	predCout: out std_logic
);
end entity;


architecture predMux of predictedMultiplexer is

begin

	WITH s1 SELECT
 		y <= 	x1 WHEN '0',
 			x2 WHEN '1',
			(others => '0') when others;

	with s1 select
		cout<= cin1 when '0',
			cin2 when '1',
			'0' when others;

	with predCin select 
		predCout<= x1(0) when '0',
			 x2(0) when '1',
			'0' when others;

end architecture;



