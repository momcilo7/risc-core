library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FloatingPointMultiplier is
generic(polar: std_logic_vector(7 downto 0));
port(

	clk,rst: in std_logic;
	start: in std_logic;
	sign1,sign2: in std_logic;
	exponent1,exponent2: in std_logic_vector(7 downto 0);
	mantiss1,mantiss2: in std_logic_vector(22 downto 0);

	sign: out std_logic;
	exponent: out std_logic_vector(7 downto 0);
	mantiss: out std_logic_vector(22 downto 0);
	
	busy,done: out std_logic
);
end entity;



architecture fpmull of FloatingPointMultiplier is

signal exp,expo,leftShiftOutput: std_logic_vector(7 downto 0);
signal mant: std_logic_vector(47 downto 0);
signal d: std_logic;
signal rightShiftOutput: std_logic_vector(22 downto 0);

signal mnt1,mnt2: std_logic_vector(23 downto 0);

signal shiftLeft,shiftRight: std_logic;
signal rnder: integer range -1 to 1;



begin

adder: entity work.nadder(na)
		generic map(n=>8)
		port map(
			input1=>exponent1,
			input2=>exponent2,
			cin=>'0',
			sum=>exp
		);

sub: entity work.nadder(na)
		generic map(n=>8)
		port map(
			input1=>exp,
			input2=>polar,
			cin=>'0',
			sum=>expo
		);

mnt1<='1' & mantiss1;
mnt2<='1' & mantiss2;

mul: entity work.Multiplier(mantmul)
		generic map(
			n=>24,
			swidth=>8,
			cntAd=>3,
			wid=>24
		)
		port map(
			clk=>clk,
			rst=>rst,
			st=>start,
			input1=>mnt1,
			input2=>mnt2,
			output=>mant,
			done=>d
			--busy=>
		);



controller: entity work.FPMultiplierControler(fpMc)
		port map(
			clk=>clk,rst=>rst,
			st=>start,
			d=>d,
			input=>mant(47 downto 46),
			
			evn=>mant(23),
			rnd=>mant(22 downto 0),
			
			shLeft=>shiftLeft,
			shRight=>shiftRight,
----za sad nije iskorisceno
			rounder=>rnder,
			
			busy=>busy,done=>done
		);


shifterLeft: entity work.shifter(sh)
		generic map(n=>8)
		port map(
			clk=>clk,rst=>rst,
	
			input=>expo,
			output=>leftShiftOutput,
			we=>shiftLeft,
			shiftLeft=>shiftLeft,
			shiftRight=>shiftRight,
			count=>1
		);

shifterRight: entity work.shifter(sh)
		generic map(n=>23)
		port map(
			clk=>clk,rst=>rst,
			input=>mant(45 downto 23),
			output=>rightShiftOutput,
			we=>shiftRight,
			shiftLeft=>shiftLeft,
			shiftRight=>shiftRight,
			count=>1
		);



sign<= sign1 xor sign2;
----nije normalizovano
exponent<=expo;
mantiss<=mant(45 downto 23);

----sad jeste----
--exponent<=leftShiftOutput;
--mantiss<=rightShiftOutput;


end architecture;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_FloatingPointMultiplier is
end entity;

architecture behavior of tb_FloatingPointMultiplier is

    -- Declaring signals for UUT connections
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal start       : std_logic := '0';
    signal sign1       : std_logic := '0';
    signal sign2       : std_logic := '0';
    signal exponent1   : std_logic_vector(7 downto 0) := (others => '0');
    signal exponent2   : std_logic_vector(7 downto 0) := (others => '0');
    signal mantiss1    : std_logic_vector(22 downto 0) := (others => '0');
    signal mantiss2    : std_logic_vector(22 downto 0) := (others => '0');

    signal sign        : std_logic;
    signal exponent    : std_logic_vector(7 downto 0);
    signal mantiss     : std_logic_vector(22 downto 0);
    
    signal busy        : std_logic;
    signal done        : std_logic;

    -- Clock period definition
    constant clk_period : time := 50 ps;

begin

    -- Clock generation process
    clk_process : process
    begin
        clk <= '0';
        wait for 50 ps;
        clk <= '1';
        wait for 50 ps;
    end process;

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.FloatingPointMultiplier
        generic map(
            polar => "00000000"
        )
        port map(
            clk => clk,
            rst => rst,
            start => start,
            sign1 => sign1,
            sign2 => sign2,
            exponent1 => exponent1,
            exponent2 => exponent2,
            mantiss1 => mantiss1,
            mantiss2 => mantiss2,
            sign => sign,
            exponent => exponent,
            mantiss => mantiss,
            busy => busy,
            done => done
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset
        rst <= '1';
	start<='0';
        wait for 150 ps;
        rst <= '0';

        -- Test case 1: Simple multiplication
        start <= '1';
        sign1 <= '0';
        sign2 <= '0';
        exponent1 <= "00011001"; -- Example exponent
        exponent2 <= "00000101"; -- Example exponent
        mantiss1 <= "00000000000000000100000"; -- Example mantissa
        mantiss2 <= "00000000000001000000000"; -- Example mantissa
        
        wait for 100 ps;
        start <= '0';

        -- Wait for operation to complete
        wait until done = '1';

        -- Add more test cases as needed

        -- Finish simulation
        wait;
    end process;

end architecture;




