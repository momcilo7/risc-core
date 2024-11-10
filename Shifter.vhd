library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Shifter is
generic(n:natural:=32);
port(

	clk,rst: in std_logic;
	input: in std_logic_vector(n-1 downto 0);
	output: out std_logic_vector(n-1 downto 0);
	we,shiftLeft,shiftRight: in std_logic;
	count: in natural
);
end entity;

architecture sh of shifter is
begin

	process(clk)
	variable temp: std_logic_vector(n-1 downto 0);
	begin

		if rst='1' then
			output<=(others => '0');
		elsif rising_edge(clk) then

			if we='1' then
				temp:= input;
			end if;

			if shiftLeft = '1' and shiftRight = '1' then
				temp := temp;	
			elsif shiftLeft = '1' then
				temp:= std_logic_vector(unsigned(temp) sll count);
			elsif shiftRight = '1' then
				temp:= std_logic_vector(unsigned(temp) srl count);
			end if;

			output<= temp;
		end if;

	end process;

end architecture;



architecture shA of shifter is
begin

	process(clk)
	variable temp: std_logic_vector(n-1 downto 0);
	begin

		if rst='1' then
			output<=(others => '0');
		elsif rising_edge(clk) then

			if we='1' then
				temp:= input;
			end if;

			if shiftLeft = '1' and shiftRight = '1' then
				temp := temp;	
			elsif shiftLeft = '1' then
				temp:= std_logic_vector(signed(temp) sll count);
			elsif shiftRight = '1' then
				temp:= std_logic_vector(signed(temp) srl count);
			end if;

			output<= temp;
		end if;

	end process;

end architecture;
