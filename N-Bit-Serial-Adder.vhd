library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity serialfulladder is
generic(n:natural:=8);	
port(
	input1:in std_logic_vector(n-1 downto 0);
	input2:in std_logic_vector(n-1 downto 0);
	cin:in std_logic;

	cout: out std_logic;
	sum:out std_logic_vector(n-1 downto 0)
);
end entity;


architecture sfa of serialfulladder is
signal ciner: std_logic_vector(n downto 0);
signal sumer: std_logic_vector(n-1 downto 0);
begin
	
	--ciner <= cin & output;
	ciner(0)<=cin;

	genlop: for i in n-1 downto 0 generate
		begin
			ader: entity work.fulladder(fa)
				port map(
					a=>input1(i),
					b=>input2(i),
					cin=>ciner(i),
					s=>sumer(i),
					cout=>ciner(i+1)
				);
	end generate;
	sum <= sumer;
	cout<= ciner(n);
end architecture; 
