library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Divider is
port(
	clk,rst: in std_logic;
	start:in std_logic;
	input1,input2: in std_logic_vector(31 downto 0);
	output1,output2: out std_logic_vector(31 downto 0);
	busy, done: out std_logic;


	------tb output
	sh,mn,w1,w,qq:out std_logic
);
end entity;



architecture div of Divider is

signal dividend, complementDividend,M: std_logic_vector(31 downto 0);

signal Abefore,Aafter,prevA: std_logic_vector(31 downto 0);

signal shift,minus,wr,wr1,q,bs,dn : std_logic;

signal Qreg: std_logic_vector(31 downto 0);
signal Qout: std_logic;

signal less: std_logic;		
signal r1: std_logic;

begin


dividend<= input2;
--complementDivisor<= std_logic_vector(to_signed(-to_integer(signed(input1)),32));
--complementDivisor<="11111111111111111111111111110110";
complementDividend<= std_logic_vector(unsigned (not input2) + 1);



process(clk)
begin
	if falling_edge(clk) then
		prevA<=Aafter;
	end if;
end process;


controller: entity work.DividerControler(dc)
		port map(
			clk=>clk,
			rst=>rst,
			start=>start,
			input=>less,
			shift=>shift,
			minus=>minus,
			wr=>wr,
			wr1=>wr1,
			q=>q,
			rst1=>r1,
--------------------------------------------------
			busy=>bs,
			done=>dn
		);
busy<=bs;
done<=dn;


mux: entity work.fulladdermultiplexer2x1(famux)
		port map(
			x1=>dividend,
			x2=>complementDividend,
			cin1=>'0',
			cin2=>'0',
			s1=>minus,
			y=>M
		);

adder: entity work.fulladder32b(fa32b)
		port map(
		input1=>prevA,
		input2=>M,
		cin=>'0',
		sum=>Abefore
		);


regA: entity work.shiftRegister(slreg1)
		port map(
		clk=>clk,
		rst=>r1,
		shift=>shift,
		we=>wr,
		shiftIn=>Qout,
		input=>Abefore,
		output=>Aafter
		);


regQ: entity work.shiftRegister(slreg2)
		port map(
		clk=>clk,
		rst=>r1,
		shift=>shift,
		we=>wr1,
		shiftIn=>q,
		input=>input1,
		output=>Qreg,
		shiftOut=>Qout		
		);


comp: entity work.comparator(comp)
		port map(
			input1=>Aafter,
			input2=>(others => '0'),
			less=>less
		);

output1<=Aafter;
output2<=Qreg;
--output2<=Abefore;


-------tbbb

sh <= shift;
mn<=minus;
w1<=wr1;
w<=wr;
qq<=r1;


end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_tb is
end entity;


architecture divv_tb of div_tb is
	signal clk:std_logic:='0';
	signal rst:  std_logic;
	signal input1,input2:  std_logic_vector(31 downto 0);
	signal output1,output2:  std_logic_vector(31 downto 0);
	signal busy, done:  std_logic;


	signal sh,mn,w1,w,qq:std_logic;
	signal st,r1: std_logic;
begin


clk<= not clk after 10 ps;


dut: entity work.Divider(div)
	port map(
		clk=>clk,
		rst=>rst,
		start=>st,
		input1=>input1,
		input2=>input2,
		output1=>output1,
		output2=>output2,
		busy=>busy,
		done=>done,


		sh=>sh,
		mn=>mn,
		w1=>w1,
		w=>w,
		qq=>qq
	);



process
begin

rst<='1';
st<='0';
input1<="00000000000000000000000000001010";
input2<="00000000000000000000000000000110";
wait for 20 ps;


rst<='0';
wait for 160 ps; 


st<='1';
wait for 20 ps;

st<='0';
wait for 2500 ps;

st<='1';
wait for 20 ps;

st<='0';
wait;

end process;

end architecture;



