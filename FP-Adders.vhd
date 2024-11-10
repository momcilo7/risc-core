library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;




entity FloatingPointAdder is
port(
	clk,rst: in std_logic;
	start: in std_logic;
	sign1,sign2: in std_logic;
	exponent1,exponent2: in std_logic_vector(7 downto 0);
	mantiss1,mantiss2: in std_logic_vector(22 downto 0);


------ TB

signal di: out natural;
signal si: out std_logic;
------

	sign: out std_logic;
	exponent: out std_logic_vector(7 downto 0);
	mantiss: out std_logic_vector(22 downto 0);

	busy,done: out std_logic
);
	constant expwid:natural :=8;
	constant mantwid:natural:=23;

end entity;





architecture fpadder of FloatingPointAdder is

signal mx1output,smallAluOutput,mx4output: std_logic_vector(expwid-1 downto 0);
signal mx2output,mx3output,shifterOutput,mx5output,bigAluOutput: std_logic_vector(mantwid-1 downto 0);

signal mx1,mx2,mx3,mx4,mx5: std_logic;


signal selector: std_logic;
signal diff,difference: natural;
signal bigAluCout:  std_logic;


signal exp: std_logic_vector(expwid-1 downto 0);
signal mant:std_logic_vector(mantwid downto 0);


signal shr1,shr2,shl2,w1,w2: std_logic;
signal count,shiftCount:  natural;
signal increment,decrement:  std_logic;
--signal bs,dn:  std_logic;

signal inpt2: std_logic_vector(7 downto 0);

begin

--busy<=busy;
--done<=done;


m1: entity work.multiplexer2x1(mux2x1)
		generic map(wid=>expwid)
		port map(
			x1=>exponent1,
			x2=>exponent2,
			s1=>mx1,
			y=>mx1output
		);




m2: entity work.multiplexer2x1(mux2x1)
		generic map(wid=>mantwid)
		port map(
			x1=>mantiss1,
			x2=>mantiss2,
			s1=>mx2,
			y=>mx2output
		);



m3: entity work.multiplexer2x1(mux2x1)
		generic map(wid=>mantwid)
		port map(
			x1=>mantiss1,
			x2=>mantiss2,
			s1=>mx3,
			y=>mx3output
		);


--inpt1<="000000000000000000000000"&exponent1;
inpt2<=std_logic_vector(unsigned (not (exponent2)) + 1);

smallAlu: entity work.nadder(na)
		generic map(
			n=>expwid
		)
		port map(
			input1=>exponent1,
			input2=>inpt2,
			cin=>'0',
			sum=>smallAluOutput
		);


expDif: entity work.exponentDifference(ed)
		port map(
			input=>smallAluOutput,
			difference=>diff,
			selector=>selector
		);
sign<=selector;

shifter: entity work.Shifter(sh)
		generic map(
			n=>mantwid
		)
		port map(
			clk=>clk,
			rst=>rst,
			input=>mx2output,
			output=>shifterOutput,
			we=>w1,	
			shiftLeft=>'0',
			shiftRight=>shr1,
			count=>difference
		);

controller: entity work.floatingPointAdderController(fpaController)
		port map(
			clk=>clk, rst=>rst,
			st=>start,
			sign1=>sign1,sign2=>sign2,
			selector=>selector, 
			diff=>diff,
			difference=>difference,
		
		
			exp=>exp,
			cin=>bigAluCout,
			mant=>mant,
		
		  	mx1=>mx1,mx2=>mx2,mx3=>mx3,mx4=>mx4,mx5=>mx5,

			shr1=>shr1,shr2=>shr2,shl2=>shl2,
			count=>count,shiftCount=>shiftCount,
			increment=>increment,decrement=>decrement,
			busy=>busy,done=>done,w1=>w1,w2=>w2
		);



bigAlu: entity work.nadder(na)
		generic map(n=>mantwid)
		port map(
			input1=>shifterOutput,
			input2=>mx3output,
			cin=>'0',
			sum=>bigAluOutput,
			cout=>bigAluCout
		);




m4: entity work.multiplexer2x1(mux2x1)
		generic map(wid=>expwid)
		port map(
			x1=>mx1output,
			x2=>exp,
			s1=>mx4,
			y=>mx4output
		);



m5: entity work.multiplexer2x1(mux2x1)
		generic map(wid=>mantwid)
		port map(
			x1=>bigAluOutput,
			x2=>mant(22 downto 0),
			s1=>mx5,
			y=>mx5output
		);



incdec: entity work.IncrementDecrement(id)
		generic map(
			n=>expwid
		)
		port map(
			input=>mx4output,
			output=>exp,
			increment=>increment,
			decrement=>decrement,
			count=>count
		);


shifter2: entity work.Shifter(sh)
		generic map(
			n=>mantwid
		)
		port map(
			clk=>clk,
			rst=>rst,
			input=>mx5output,
			output=>mant(22 downto 0),
			we=>w2,	
			shiftLeft=>shl2,
			shiftRight=>shr2,
			count=>shiftCount
		);

exponent<=exp;
mantiss<=mant(22 downto 0);
--mantiss<=shifterOutput;


----tb
si<=shr1;
di<=shiftCount;

---
end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;





entity fp_tb is
end entity;


architecture fp_arch_tb of fp_tb is	
	signal clk: std_logic:='0'; signal rst: std_logic;

	signal sign1,sign2: std_logic;
	signal exponent1,exponent2: std_logic_vector(7 downto 0);
	signal mantiss1,mantiss2: std_logic_vector(22 downto 0);

-----
signal di: natural;
signal si: std_logic;
---
	signal sign: std_logic;
	signal exponent: std_logic_vector(7 downto 0);
	signal mantiss: std_logic_vector(22 downto 0);

	signal busy,done,start: std_Logic;

begin


clk<= not clk after 50 ps;

dut: entity work.FloatingPointAdder(fpadder)
		port map(
		    clk => clk,
		    rst => rst,
		    start=>start,
		    sign1 => sign1,
		    sign2 => sign2,
		    exponent1 => exponent1,
		    exponent2 => exponent2,
		    mantiss1 => mantiss1,
		    mantiss2 => mantiss2,
		    sign => sign,
		    exponent => exponent,
-----
		di=>di,
		si=>si,
	
---
		    busy=>busy,done=>done,
		    mantiss => mantiss
		);


process 
begin


rst<='1';
sign1<='0';
sign2<='0';
start<='0';
mantiss1<="00000000000000000000000";
mantiss2<="00000000000000000000000";
exponent1<="00000000";
exponent2<="00000000";
wait for 150 ps;

rst<='0';
start<='1';
sign1<='0';
sign2<='0';
mantiss1<="00000001101111100110011";
mantiss2<="00101011001101010101010";
exponent1<="11000101";
exponent2<="11000100";
--
wait for 500 ps;


end process;



end architecture;




