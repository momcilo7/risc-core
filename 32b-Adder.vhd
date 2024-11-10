library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fulladder32b is
generic( swidth:natural:=8;
	cntAd:natural:=4;
	wid:natural:=32
);
port(
	input1:in std_logic_vector(wid-1 downto 0);
	input2:in std_logic_vector(wid-1 downto 0 );
	cin: in std_logic;

	cout:out std_logic;
	sum:out std_logic_vector(wid-1 downto 0)
);
end entity;


architecture fa32b of fulladder32b is 
signal ciner:std_logic_vector(cntAd-1 downto 0);
signal sumer:std_logic_vector(wid-1 downto 0);
begin


	s0: entity work.serialfulladder(sfa)
		port map(
			input1=>input1(7 downto 0),
			input2=>input2(7 downto 0),
			cin=>cin,
			cout=>ciner(0),
			sum=>sumer(7 downto 0)
			
		);

	
	genLab: for i in cntAd downto 2 generate
		signal in1:std_logic_vector(7 downto 0);
		signal in2:std_logic_vector(7 downto 0);

		signal c1:std_logic;
		signal c2:std_logic;
	
		begin

			s1: entity work.serialfulladder(sfa)
			port map(
				input1=>input1(i*8-1 downto 8*(i-1)),
				input2=>input2(i*8-1 downto 8*(i-1)),
				cin=>'0',
				cout=>c1,
				sum=>in1
			
				);

			s2: entity work.serialfulladder(sfa)
			port map(
				input1=>input1(i*8-1 downto 8*(i-1)),
				input2=>input2(i*8-1 downto 8*(i-1)),
				cin=>'1',
				cout=>c2,
				sum=>in2
			
				);


			mux: entity work.fulladdermultiplexer2x1(famux2x1)
				generic map(
					wid=>swidth
				)
				port map(
					x1=>in1,
					x2=>in2,
					cin1=>c1,
					cin2=>c2,
					s1=>ciner(i-2),
					cout=>ciner(i-1),
					y=>sumer(i*8-1 downto 8*(i-1))
				);

		end generate;
		
	cout<= ciner(cntAd-1);
	sum<= sumer;
end architecture;