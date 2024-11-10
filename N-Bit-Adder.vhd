library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity nadder is
generic(n:natural:=32);
port(
	input1,input2:in std_logic_vector(n-1 downto 0);
	cin: in std_logic;
	cout: out std_logic;
	sum: out std_logic_vector(n-1 downto 0)
);
end entity;


architecture na of nadder is
signal cins: std_logic_vector(n-1 downto 0);
signal sums: std_logic_vector(n-1 downto 0);
begin
genLab:for i in n-1 downto 0 generate

		genif:if i = 0 generate
			ader: entity work.fulladder(fa)
				port map(
					a=>input1(i),
					b=>input2(i),
					cin=>cin,
					cout=>cins(i),
					s=>sums(i)
				);
		else generate
			ader: entity work.fulladder(fa)
				port map(
					a=>input1(i),
					b=>input2(i),
					cin=>cins(i-1),
					cout=>cins(i),
					s=>sums(i)
				);
		end generate;

	sum<=sums;
	cout<=cins(n-1);

end generate;


end architecture;
