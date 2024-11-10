library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity IncrementDecrement is
generic(n:natural:=32);
port(
	input:in std_logic_vector(n-1 downto 0);
	output:out std_logic_vector(n-1 downto 0);
	increment,decrement: in std_logic;
	count: in integer
);
end entity;


architecture id of IncrementDecrement is

begin

	   output <= 	std_logic_vector(to_unsigned(to_integer(unsigned(input)) + count, input'length)) when increment = '1' else
          		std_logic_vector(to_unsigned(to_integer(unsigned(input)) - count, input'length)) when decrement = '1' else
          		input;



end architecture;
