library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IntegerUnit is
    port (
        input1,input2:in std_logic_vector(31 downto 0);
        output1,output2:out std_logic_vector(31 downto 0);
        busy: out std_logic;
        clk,rst: in std_logic;
        start: in std_logic;
        code: in std_logic_vector(2 downto 0);
        tip,special: in std_logic
        --bonus: in std_logic;
    );
end entity IntegerUnit;

architecture intUnit of IntegerUnit is
    signal vector1,vector2: std_logic_vector(31 downto 0);
    signal bs: std_logic;

    signal ot1,ot2,ot3,ot4,ot5,ot6: std_logic_vector(31 downto 0);
    signal oot: std_logic_vector(63 downto 0);

    signal bs1,bs2: std_logic;
    signal l,e,a,l1,e1,a1: std_logic;

    signal cnt: natural;
    --signal code: std_logic_vector(2 downto 0);
    --signal tip: std_logic;
    signal st1,st2: std_logic;
    signal lft,rght: std_logic;
    signal mx: std_logic_vector(2 downto 0);

    signal uCmpOutput,cmpOutput: std_logic_vector(31 downto 0);

    signal IntegerUnitOutput: std_logic_vector(31 downto 0);
begin


    busy<= bs1 or bs2;
    --Paznja za input
    process(clk)
    begin
        if bs1='0' and bs2='0' then
            vector1<= input1;
            vector2<= input2;
        else
            vector1<=vector1;
            vector2<=vector2;
        end if;
    end process;

    cnt<=to_integer(unsigned(vector2(4 downto 0)));

    adder: entity work.fulladder32b(fa32b)
                port map(
                    input1=>vector1,
                    input2=>vector2,
                    cin=>'0',
                    sum=>ot1
                );

    multiplier: entity work.Multiplier(mul)
                    port map(
                        clk=>clk,
                        rst=>rst,
                        input1=>vector1,
                        input2=>vector2,
                        output=>oot,
                        st=>st1,
                        busy=>bs1
                    );
    

	

    divider: entity work.Divider(div)
                    port map(
                        clk=>clk,
                        rst=>rst,
                        input1=>vector1,
                        input2=>vector2,
                        output1=>ot2,
                        output2=>ot3,
	                start=>st2,
                        busy=>bs2 
                    );

    unsignedComparator: entity work.comparator(comp)
                        port map(
                            input1=>vector1,
                            input2=>vector2,
	                        less=>l,equal=>e,above=>a
                        );

                        -----Pazi na output zbog gore
    signedComparator: entity work.comparator(comp)
                        port map(
                            input1=>vector1,
                            input2=>vector2,
	                        less=>l1,equal=>e1,above=>a1
                        );

    logicalOperator: entity work.logicalOperator(logOp)
                            port map(
                                input1=>vector1,
                                input2=>vector2,
                                output=>ot4,
                                code=>code(1 downto 0)      
                            );
                        
    logicalShift: entity work.shifter(sh)
                                port map(
                                    clk=>clk,rst=>rst,
                                    input=>vector1,
                                    output=>ot5,
                                    we=>'1',
                                    shiftLeft=>lft,
                                    shiftRight=>rght,
                                    count=>cnt
                                );

    arithmeticalShift: entity work.shifter(shA)
                                port map(
                                    clk=>clk,rst=>rst,
                                    input=>vector1,
                                    output=>ot6,
                                    we=>'1',
                                    shiftLeft=>'0',
                                    shiftRight=>'1',
                                    count=>cnt
                                );

    controller: entity work.IntegerController(intController)
                            port map(
                                clk=>clk,rst=>rst,
                                code=>code,
                                tip=>tip,
				special=>special,
                                bs=>bs,
                                start1=>st1,start2=>st2,
                                left1=>lft,right1=>rght,
                                mx=>mx,
				start=>start
                            );

    mmx: entity work.Mux8x1_32b(mx8x1_32b)
                        port map(
                            input0=>ot1,
                            input1=>cmpOutput,
                            input2=>uCmpOutput,
                            input3=>ot4,
                            input4=>ot5,
                            input5=>ot6,
                            input6=>oot(31 downto 0),
                            input7=>ot2,
                            sel =>mx,
                            output =>IntegerUnitOutput
                        );
    output1<=IntegerUnitOutput;
    --output2<=oot(31 downto 0);
end architecture intUnit;



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity int_tb is
end entity;





architecture iii of int_tb is

	signal input1,input2: std_logic_vector(31 downto 0);
        signal output1,output2: std_logic_vector(31 downto 0);
        signal busy:  std_logic;
        signal clk:  std_logic:='0'; signal rst: std_logic;
        signal start:  std_logic;
        signal code:  std_logic_vector(2 downto 0);
        signal tip,special: std_logic;

begin


clk<= not clk after 50 ps;


uut: entity work.IntegerUnit
    port map (
        input1=>input1,input2=>input2,
        output1=>output1,output2=>output2,
        busy=>busy,
        clk=>clk,rst=>rst,
        start=>start,
        code=>code,
        tip=>tip,special=>special
        --bonus: in std_logic;
    );


process


begin


	rst<='1';
	start<='0';
	wait for 150 ps;

	rst<='0';
	start<='1';
	code<="000";
	tip<='0';
	special<='0';
	input1<="00000000000000000000000000000001";
	input2<="00000000000000000000000000000001";
	wait for 100 ps;

	
	code<="110";
	tip<='0';
	special<='0';
	input1<="00000000000000000000000000001111";
	input2<="11110000000000000000000000000000";
	wait for 100 ps;


	code<="101";
	tip<='0';
	special<='0';
	input1<="00000000000000001111000000000000";
	input2<="00000000000000000000000000000110";
	wait for 100 ps;

	code<="000";
	tip<='1';
	special<='0';
	input1<="00000000000000001111000000000000";
	input2<="00000000000000000000000000000110";
	wait for 10000 ps;


end process;


end architecture;
