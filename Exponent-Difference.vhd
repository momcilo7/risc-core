library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ExponentDifference is
port(
	input: in std_logic_vector(7 downto 0);
	
	difference: out natural;
	selector: out std_logic
);
end entity;


architecture ed of exponentDifference is

begin

selector <= '1' when to_integer(signed(input)) < 0 else
		'0';

difference <= to_integer(signed(input)) when to_integer(signed(input)) >= 0 else
		- to_integer(signed(input));

end architecture;



