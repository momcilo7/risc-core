library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity DividerControler is 
port(
clk,rst:in std_logic;
start: in std_logic;
shift,minus,wr,wr1,q:out std_logic;
input: in std_logic;
busy,done: out std_logic;
rst1: out std_logic
);
end entity;




architecture dc of DividerControler is

type states is (Shifter,Minuser, ALess,AAbove,Finish);--sStart
signal current_state, next_state: states;
signal count: natural;

begin

     stateChange: process (rst, clk)
    begin
        if rst = '1' then
            current_state <= Finish;
	    count<=32;
        elsif falling_edge(clk) then
            current_state <= next_state;
	    if(current_state = Finish) then
		count<=32;
            elsif ((current_state = ALess or current_state = AAbove)  and count > 0 ) then
                count <= count - 1;
            end if;
        end if;
    end process;





OutputAndStateCalculation: process (current_state, input,start)
    begin
        case current_state is

--	    when Finish =>
--		
--		if start='1' then
--			next_state<= sStart;
--			--count<=32;
--		else
--			next_state<=Finish;
--		end if;
--		shift <= '0';
--                minus <= '0';
--                wr <= '0';
--		wr1 <= '0';	
--		q <= '0';
--		busy<='0';
--		done<='1';	
		
            when Finish =>

		if start='1' then
			next_state <= Shifter;
			busy<='1';
			rst1<='0';
		else 	
			next_state <= Finish;
			busy<='0';
			rst1<='1';
		end if;
		
		shift <= '0';
                minus <= '0';
                wr <= '0';
		wr1 <= '0';	
		q <= '0';
		done<='0';

            when Shifter =>
	
		if count = 0 then
	             	next_state <= Finish;
				shift <= '0';
				busy<='0';
				done<='1';
                else
			next_state <= Minuser;
				shift <= '1';
				busy<='1';
				done<='0';
		end if;
		
		minus <= '0';
	        wr <= '0';
		wr1 <= '0';	
		q <= '0';
		rst1<='0';

	when Minuser =>
		if count = 0 then
                    next_state <= Finish;
                elsif input = '1' then
                    next_state <= ALess;
                elsif input = '0' then
                    next_state <= AAbove;
                end if;

		shift <= '0';
                minus <= '1';
                wr <= '1';
		wr1 <= '0';	
		q <= '0';
		busy<='1';
		done<='0';
			rst1<='0';

            when ALess =>
                if count = 0 then
                    next_state <= Finish;
                else 
		    next_state <= Shifter;
		end if;

                shift <= '0';
                minus <= '0';
                wr <= '1';
		wr1 <= '1';	
		q <= '0';
		busy<='1';
		done<='0';
			rst1<='0';

	    when AAbove =>
                if count = 0 then
                    next_state <= Finish;
                else 
		    next_state <= Shifter;
		end if;

                shift <= '0';
                minus <= '0';
                wr <= '0';
		wr1 <= '1';	
		q <= '1';
		busy<='1';
		done<='0';
			rst1<='0';

        end case;
    end process;




end architecture;
