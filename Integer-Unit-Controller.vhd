library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IntegerController is
    port (
        clk,rst: in std_logic;
        code: in std_logic_vector(2 downto 0);
        tip: in std_Logic;
        bs:in std_logic;
        special: in std_logic;
	start: in std_logic;
        start1,start2: out std_logic;
        left1,right1: out std_logic;
        mx: out std_logic_vector(2 downto 0)
    );
end entity IntegerController;



architecture intController of IntegerController is
    type states is (Done, MInst, OneClkInstruction); 
    signal current_state, next_state: states;


begin

    stateChange: process (rst, clk)
    begin
        if rst = '1' then
            current_state <= Done;
        elsif falling_edge(clk) then
            current_state <= next_state;
        end if;
    end process;    
    


    OutputAndStateCalculation: process (current_state, code)
    begin
        case current_state is

	    when Done =>
            if start='1' then
                --Logika za promenu stanja
                if(tip='0') then
                    next_state <= OneClkInstruction;
                else   
                    next_state <= MInst;
                end if;
            else
                next_state <= Done;
            end if;
		
        when OneClkInstruction =>
            next_state<=Done;

        when MInst =>
                if(bs='1') then
                    next_state <= MInst;
                elsif (start='1') then
                    
                    if(tip='0') then
                        next_state<=OneClkInstruction;
                    elsif (tip='1') then
                        next_state<=MInst;
                    else
                        next_state<=Done;
                    end if;
                else
                    next_state<=Done;
                end if;


        end case;
    end process;



    output_logic: process(current_state)
    begin
        
        if start='1' then


            if current_state = MInst and bs='1' then
                start1<='0';
                start2<='0';
                left1<='0';
                right1<='0';
		mx<=mx;

            else 
                if(tip='0') then
                    start1<='0';
                    start2<='0';
                    	case code is
                        --sabiranje/oduzimanje
                        when "000" =>
                            left1<='0';
                            right1<='0';
                            mx<="000";
                        --compare signed
                        when "010" =>
                            left1<='0';
                            right1<='0';
                            mx<="001";
                        --compare unsigned
                        when "011" =>
                            left1<='0';
                            right1<='0';
                            mx<="010";
                        --logical operation
                        when "100" =>
                            left1<='0';
                            right1<='0';
                            mx<="011";
                        when "110" =>
                            left1<='0';
                            right1<='0';
                            mx<="011";
                        when "111" =>
                            left1<='0';
                            right1<='0';
                            mx<="011";
        
                        --logicalShift left  
                        when "001" =>
                            left1<='1';
                            right1<='0';
                            mx<="100";
                        --logical Shift right
                        when "101" =>
                            if (special='1') then
                                left1<='0';
                                right1<='0';
                                mx<="101";
                            else
                                left1<='0';
                                right1<='1';
                                mx<="100";
			    end if;
			when others=>
				left1<='0';
				right1<='0';
				start1<='0';
				start2<='0';
				mx<="000";			
                    end case; 
        
                else   
                    if(code="000") then
                        start1<='1';
                        start2<='0';
                        mx<="110";
                    elsif(code="100") then
                        start1<='0';
                        start2<='1';
                        mx<="111";
                    else
                        start1<='0';
                        start2<='0';
                        mx<="000";
                    end if;
                    left1<='0';
                    right1<='0';
                end if;
            end if;
        end if;
    end process;

end architecture intController;




library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity int_cnt_tb is
end entity;


architecture int_c_tb of int_cnt_tb is
signal clk:  std_logic:='0';
	signal rst:  std_logic;
        signal code:  std_logic_vector(2 downto 0);
        signal tip:  std_Logic;
        signal bs: std_logic;
        signal special:  std_logic;
	signal start:  std_logic;
        signal start1,start2:  std_logic;
        signal left1,right1:  std_logic;
        signal mx: std_logic_vector(2 downto 0);
begin
	clk<= not clk after 50 ps;



	uut: entity work.IntegerController(intController)
			port map(
				clk=>clk,
			        rst =>rst,
			        code=>code ,
			        tip=>tip ,
			        bs=>bs,
			        special=>special ,
				start=>start,
			        start1=>start1,start2=>start2 ,
			        left1=>left1,right1=>right1,
			        mx=>mx
			);

process

begin

start<='0';
rst<='1';
wait for 150 ps;

start<='1';
rst<='0';
code<="100";
tip<='0';
bs<='0';
special<='0';
wait for 100 ps;

start<='1';
rst<='0';
code<="001";
tip<='0';
bs<='0';
special<='0';
wait for 100 ps;



start<='1';
rst<='0';
code<="101";
tip<='0';
bs<='0';
special<='0';
wait for 100 ps;


start<='1';
rst<='0';
code<="000";
tip<='1';
bs<='0';
special<='0';
wait for 500 ps;


wait;

end process;


end architecture;
