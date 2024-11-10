library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;


entity comparator is
generic(n:natural:=32);	
port(
	input1,input2:in std_logic_vector(n-1 downto 0);
	less,equal,above: out std_logic
);
end entity;

architecture comp of comparator is

begin

less<= '1' when to_integer(signed(input1)) < to_integer(signed(input2)) else 
	'0';

equal<= '1' when to_integer(signed(input1)) = to_integer(signed(input2)) else 
	'0';

above<= '1' when to_integer(signed(input1)) > to_integer(signed(input2)) else '0' ;

end architecture;


architecture compu of comparator is

begin

less<= '1' when to_integer(unsigned(input1)) < to_integer(unsigned(input2)) else 
	'0';

equal<= '1' when to_integer(unsigned(input1)) = to_integer(unsigned(input2)) else 
	'0';

above<= '1' when to_integer(unsigned(input1)) > to_integer(unsigned(input2)) else '0' ;

end architecture;
