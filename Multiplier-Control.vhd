library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplierControl is
    generic(cnt:integer);
    port(
        clk, rst: in std_logic;
	start: in std_logic;
        input: in std_logic;
        shift1, shift2: out std_logic;
        add: out std_logic;
	busy,done: out std_logic;
	w:out std_logic;
	broj: out natural
    );
end entity;

architecture mc of multiplierControl is
    type states is (sStart, Shift, AddShift,Finish); 
    signal current_state, next_state: states;
    signal count: natural;
begin

stateChange: process (rst, clk)
    begin
        if rst = '1' then
            current_state <= Finish;
            count <= 0;
        elsif falling_edge(clk) then
            current_state <= next_state;
	     if(current_state = sStart) then
		count<=cnt;
	     elsif count=1 then
		current_state<=Finish;
             elsif ((current_state /= Finish and current_state /= sStart) and count > 0) then
                count <= count - 1;
            end if;
        end if;
    end process;





    OutputAndStateCalculation: process (start,current_state, input)
	variable c:natural;
    begin
        case current_state is


	    when Finish =>
		if start='1' then
			next_state <= sStart;
		else
			next_state <= Finish;
		end if;
		shift1 <= '0';
                shift2 <= '0';
                add <= '0';
		busy <= '0';	
		done <= '1';	
		w<='0';
		
            when sStart =>
		
                if input = '1' then
                    next_state <= AddShift;
			busy <= '1';	
			done <= '0';
                elsif input = '0' then
                    next_state <= Shift;
			busy <= '1';	
			done <= '0';
		end if;


                shift1 <= '0';
                shift2 <= '0';
                add <= '0';
		w<='1';


            when Shift =>

		if input = '1' then
                    next_state <= AddShift;
                elsif input = '0' then
                    next_state <= Shift;
                end if;
                
                shift1 <= '1';
                shift2 <= '1';
                add <= '0';
		busy <= '1';	
		done <= '0';
		w<='0';

            when AddShift =>

		if input = '1' then
                    next_state <= AddShift;
                elsif input = '0' then
                    next_state <= Shift;
                end if;

                shift1 <= '1';
                shift2 <= '1';
                add <= '1';
		busy <= '1';	
		done <= '0';
		w<='0';

            when others =>
                next_state <= Finish;
                shift1 <= '0';
                shift2 <= '0';
                add <= '0';
		busy <= '0';	
		done <= '1';
		w<='0';
        end case;
    end process;
broj<=count;
end architecture;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity mc_tb is
end entity;


architecture mcc_tb of mc_tb is
	signal clk:std_logic:='0';
	signal rst:std_logic;
	signal input: std_logic;
	signal shift1,shift2: std_logic;
	signal add,st: std_logic;
	signal b: std_logic;
	signal broj: natural;
begin 

clk<=not clk after 10 ps;


dut: entity work.multiplierControl(mc)
	generic map(
		cnt=>32
)
	port map(
	clk=>clk,
	rst=>rst,
	start=>'1',
	input=>input,
	shift1=>shift1,shift2=>shift2,
	add=>add,
	busy=>b,
	broj=>broj
);


process

begin

rst<='1';
st<='0';
wait for 30 ps;

rst<='0';
input<='0';
wait for 20 ps;


st<='1';
input<='0';
wait for 20 ps;

st<='0';
input<='1';
wait for 20 ps;

input<='0';
wait for 20 ps;

input<='1';
wait for 20 ps;


input<='0';
wait for 20 ps;


input<='1';
wait for 20 ps;



input<='1';
wait for 20 ps;

input<='0';
wait for 20 ps;


wait for 700 ps;

input<='1';
wait for 100 ps;

end process;
end architecture;



