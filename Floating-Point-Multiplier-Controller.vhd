library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FPMultiplierControler is 
port(
clk,rst,st:in std_logic;
d: in std_logic;
input: in std_logic_vector(1 downto 0);

evn: in std_logic;
rnd: in std_logic_vector(22 downto 0);

shLeft,shRight: out std_logic;
rounder: out integer range -1 to 1;

busy,done: out std_logic
);
end entity;




architecture fpMc of FPMultiplierControler is

type states is (Start, MulMant,Normalize,Rounding,Finish);
signal current_state, next_state: states;
signal count: natural;

begin

     stateChange: process (rst, clk)
    begin
        if rst = '1' then
            current_state <= Finish;
        elsif falling_edge(clk) then
            current_state <= next_state;
        end if;
    end process;





OutputAndStateCalculation: process (current_state,st,d)
    begin
        case current_state is

	    when Finish =>
		
		if st='1' then
			next_state<=Start;
		else
			next_state<=Finish;
		end if;

		shLeft<='0';
		shRight<='0';
		rounder<=0;	
		busy<='0';
		done<='1';	

            when Start =>

		next_state <= MulMant;
		
		shLeft<='0';
		shRight<='0';
		rounder<=0;
		busy<='1';
		done<='0';

            when MulMant =>
	
		if d = '1' then
			next_state<=Normalize;
		else
			next_state <= MulMant;
		end if;

		shLeft<='0';
		shRight<='0';
		rounder<=0;
		busy<='1';
		done<='0';

	when Normalize =>

		next_state<=Finish;

		if input="11" or input="10" then
				--11
			--shLeft<='Z';
			--shRight<='Z';
			shLeft<='1';
			shRight<='1';
		else
			--00
			shLeft<='Z';
			shRight<='Z';
			--shLeft<='0';
			--shRight<='0';
		end if;
		
		rounder<=0;
		busy<='1';
		done<='0';
		



 	when Rounding =>
	
		next_state<=Finish;
                -- Zaokru?ivanje
            if rnd(22) = '1' then -- Guard bit je 1
                if rnd(21 downto 0) = "0000000000000000000000" then -- Round bit i Sticky bit su 0
                    -- Ako je trenutna vrednost parna, ne menjamo, ina?e pove?avamo
                    if evn = '1' then
			rounder<=1;
                        --rounded_product <= std_logic_vector(unsigned(product(46 downto 24)) + 1);
                    else
			rounder<=0;
                        --rounded_product <= product(46 downto 24);
                    end if;
                else -- Ako Round bit ili Sticky bit nisu 0, zaokru?ujemo na ve?u vrednost
			rounder<=1;                    
			--rounded_product <= std_logic_vector(unsigned(product(46 downto 24)) + 1);
                end if;
            else -- Guard bit je 0, ne menjamo
		rounder<=0;
                --rounded_product <= product(46 downto 24);
            end if;


		shLeft<='0';
		shRight<='0';
		busy<='1';
		done<='0';


        end case;
    end process;

end architecture;






library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_FPMultiplierControler is
end entity;

architecture behavior of tb_FPMultiplierControler is

    -- Signal declarations
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal d : std_logic := '0';
    signal input : std_logic_vector(1 downto 0) := (others => '0');
    signal evn : std_logic := '0';
    signal rnd : std_logic_vector(22 downto 0) := (others => '0');

    signal shLeft : std_logic;
    signal shRight : std_logic;
    signal rounder : integer range -1 to 1;
    signal busy : std_logic;
    signal done : std_logic;
    signal st: std_logic;

    -- Clock generation
    constant clk_period : time := 50 ps;
    
begin

    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.FPMultiplierControler
        port map (
            clk => clk,
            rst => rst,
	    st=>st,
            d => d,
            input => input,
            evn => evn,
            rnd => rnd,
            shLeft => shLeft,
            shRight => shRight,
            rounder => rounder,
            busy => busy,
            done => done
        );

    -- Clock process definitions
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Reset the design
        rst <= '1';
        wait for clk_period;
        rst <= '0';

        -- Apply test vectors
        d <= '1';
        input <= "01";
        evn <= '1';
        rnd <= "00000000000000000000001";
        wait for clk_period*10;

        -- Change inputs
        d <= '0';
        input <= "10";
        evn <= '0';
        rnd <= "00000000000000000000010";
        wait for clk_period * 10;

        -- Add more test cases as needed
        wait;
    end process;

end architecture;



