library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.array_pkg.all;

entity multiplexer32x1 is
generic(wid:natural:=32);
  port (
    	input : in array32(31 downto 0);
	s1:in std_logic;
	s2:in std_logic;
	s3:in std_logic;
	s4:in std_logic;
	s5:in std_logic;
    	output:out std_logic_vector(31 downto 0)
  );
end multiplexer32x1;


architecture mux32x1 of multiplexer32x1 is

signal o: array32(3 downto 0);
signal sel1: std_logic_vector(2 downto 0);
signal sel2: std_logic_vector(1 downto 0);
begin

sel1<= s3 & s2 & s1;

	genLab:for i in 3 downto 0 generate
		begin
		mux8: entity work.Mux8x1_32b(mux8x1_32b)
			generic map(wid=>wid)
			port map(
				input0=> input(i*8+0),
				input1=> input(i*8+1),
				input2=> input(i*8+2),
				input3=> input(i*8+3),
				input4=> input(i*8+4),
				input5=> input(i*8+5),
				input6=> input(i*8+6),
				input7=> input(i*8+7),
				sel=> sel1,
				output=>o(i)
			);
	end generate;

	
	mux4: entity work.multiplexer4x1(mux4x1)
		generic map(wid=>wid)
		port map(
			x4=>o(3),
			x3=>o(2),
			x2=>o(1),
			x1=>o(0),
			s2=>s5,
			s1=>s4,
			y=>output
			);

end architecture;


