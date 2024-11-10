library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Multiplier is
generic(n:natural:=32;
	swidth:natural:=8;
	cntAd:natural:=4;
	wid:natural:=32);
port(
	clk,rst:in std_logic;
	st: in std_logic;
	input1,input2: in std_logic_vector(n-1 downto 0);
	output: out std_logic_vector(2*n-1 downto 0);
	done: out std_logic;
	busy: out std_logic;
	tb_ad,tb_sh1,tb_sh2,tb_input:out std_logic
);

end entity;


architecture mul of Multiplier is

signal sh1,sh2,ad:std_logic;
signal registarMultiplicand: std_Logic_vector(n-1 downto 0);
signal regMultiplier: std_logic_vector(n-1 downto 0);
signal s1,s2,s3,s4,s5: std_logic;
signal tmpReg1, tmpreg2, tmpReg3: std_logic_vector(n-1 downto 0);
signal wr: std_logic;
begin
controller: entity work.multiplierControl(mc)
	generic map(
		cnt=>n
	)
	port map(
	clk=>clk,
	rst=>rst,
	add=>ad,
	start=>st,
	input=>s1,
	shift1=>sh1,
	shift2=>sh2,
	busy=>busy,
	done=>done,
	w=>wr
	);

registarMultiplicand<=input1;

rgmult: entity work.shiftRegister(shreg2)
			generic map(n=>n)
			port map(
				clk=>clk,
				rst=>rst,
-----------------ISPRAVI OVOOO WE=>ADD-------------------------------------
				we=>wr,
				shift=>sh1,
				input=>input2,
				shiftIn=>s2,
				shiftOut=>s1,
				output=>regMultiplier
			);

reg: entity work.shiftRegister(shreg1)
			generic map(n=>n)
			port map(
				clk=>clk,
				rst=>rst,
				we=>ad,
				shift=>sh2,
				input=>tmpReg1,
				shiftIn=>s3,
				--shiftOut=>s5,
				output=>tmpReg2
			);

adder: entity work.fulladder32b(fa32b)
		generic map(
			swidth=>swidth,
			cntAd=>cntAd,
			wid=>wid
		)
		port map(
			input1=>input1,
			input2=>tmpReg2,
			cin=>'0',
			cout=>s4,
			sum=>tmpReg3
		);

mx: entity work.predictedMultiplexer(predMux)
		generic map(
			wid=>wid
		)
		port map(
			x1=>tmpReg2,
			x2=>tmpReg3,	
			cin1=>'0',
			cin2=>s4,
			predCin=>s1,
			s1=>ad,
			y=>tmpReg1,
			cout=>s3,
			predCout=>s2
		);

output<= tmpReg2 & regMultiplier;
tb_ad<=ad;
tb_sh1<=sh1;
tb_sh2<=wr;
tb_input<=s1;
end architecture;






architecture mantMul of Multiplier is

signal sh1,sh2,ad:std_logic;
signal registarMultiplicand: std_Logic_vector(n-1 downto 0);
signal regMultiplier: std_logic_vector(n-1 downto 0);
signal s1,s2,s3,s4,s5: std_logic;
signal tmpReg1, tmpreg2, tmpReg3: std_logic_vector(n-1 downto 0);
signal wr: std_logic;
begin
controller: entity work.multiplierControl(mc)
	generic map(
		cnt=>n-5
	)
	port map(
	clk=>clk,
	rst=>rst,
	add=>ad,
	start=>st,
	input=>s1,
	shift1=>sh1,
	shift2=>sh2,
	busy=>busy,
	done=>done,
	w=>wr
	);

registarMultiplicand<=input1;

rgmult: entity work.shiftRegister(shreg2)
			generic map(n=>n)
			port map(
				clk=>clk,
				rst=>rst,
				we=>wr,
				shift=>sh1,
				input=>input2,
				shiftIn=>s2,
				shiftOut=>s1,
				output=>regMultiplier
			);

reg: entity work.shiftRegister(shreg1)
			generic map(n=>n)
			port map(
				clk=>clk,
				rst=>rst,
				we=>ad,
				shift=>sh2,
				input=>tmpReg1,
				shiftIn=>s3,
				--shiftOut=>s5,
				output=>tmpReg2
			);


nadder: entity work.serialfulladder
generic map(n=>n)
port map(
	input1=>input1,
	input2=>tmpreg2,
	cin=>'0',
	cout=>s4,
	sum=>tmpreg3
);


--OVAJ ADER JE STVARNO POD KOMENTAROM

--adder: entity work.fulladder32b(fa32b)
--		generic map(
--			swidth=>swidth,
--			cntAd=>cntAd,
--			wid=>wid
--		)
--		port map(
--			input1=>input1,
--			input2=>tmpReg2,
--			cin=>'0',
--			cout=>s4,
--			sum=>tmpReg3
--		);

mx: entity work.predictedMultiplexer(predMux)
		generic map(
			wid=>wid
		)
		port map(
			x1=>tmpReg2,
			x2=>tmpReg3,	
			cin1=>'0',
			cin2=>s4,
			predCin=>s1,
			s1=>ad,
			y=>tmpReg1,
			cout=>s3,
			predCout=>s2
		);

output<= tmpReg2 & regMultiplier;
tb_ad<=ad;
tb_sh1<=sh1;
tb_sh2<=s2;
tb_input<=s1;
end architecture;






























library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mul_tb is
end entity;



architecture m_tb of mul_tb is

signal clk:std_logic:='0';
signal rst,tb_ad,tb_sh1,tb_sh2,tb_input:std_logic;

	signal input1,input2:std_logic_vector(31 downto 0);
	signal output:std_logic_vector(63 downto 0);
	signal done,busy:std_logic;
	signal s: std_logic;

begin

clk<=not clk after 10 ps;

dut: entity work.Multiplier(mul)
		port map(
			clk=>clk,
			rst=>rst,
			st=>s,
			input1=>input1,
			input2=>input2,
			output=>output,
			tb_ad=>tb_ad,
			tb_sh1=>tb_sh1,
			tb_sh2=>tb_sh2,
			tb_input=>tb_input,
			done=>done,
			busy=>busy
		);


process

begin


rst<='1';
s<='0';
--input1<="00000000000000000000000000001011";
--input2<="00000000000000000000000000000011";
input1<="00000000000000001111000000000000";
input2<="00000000000000000000000000000110";
wait for 20 ps;


rst<='0';
wait for 50 ps;

s<='1';
wait for 20 ps;

s<='0';
--wait until busy='1';
wait for 640 ps;


rst<='0';
wait for 200 ps;


rst<='1';
wait for 200 ps;

wait;

end process;
end architecture;
