library IEEE;
use IEEE.std_logic_1164.all;

entity andgate is
port(
	input1:in std_logic;
	input2:in std_logic;
	output:out std_logic
);
end entity;



architecture andg of andgate is

begin

output<= input1 and input2;
end architecture;
