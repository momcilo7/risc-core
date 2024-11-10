library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity floatingPointAdderController is
    port(
        clk, rst,st: in std_logic;

	sign1,sign2: in std_logic;
	selector: in std_logic; 
	diff: in natural;
	difference: out natural;


	exp: in std_logic_vector(7 downto 0);
	cin: in std_logic;
	mant:in std_logic_vector(23 downto 0);

  	mx1,mx2,mx3,mx4,mx5: out std_logic;
	shr1,shr2,shl2,w1,w2: out std_logic;
	count,shiftCount: out natural;
	increment,decrement: out std_logic;
	busy,done,error: out std_logic
    );
end entity;

architecture fpaController of floatingPointAdderController is
    type states is (Start, Exponent, Normalizing,Finish); 
    signal current_state, next_state: states;
begin

    stateChange: process (rst, clk)
    begin
        if rst = '1' then
            current_state <= Finish;
        elsif falling_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    OutputAndStateCalculation: process (current_state,cin,st,selector)
	variable point: std_logic_vector(1 downto 0);
	variable position : integer;
        variable i : integer;
	variable tip: std_logic;
    begin
        case current_state is

	    when Finish =>
		
		if st='1' then
			next_state<=Start;
		else
			next_state<=Finish;
		end if;

		mx1<='0';
		mx2<='0';
		mx3<='0';
		mx4<='0';
		mx5<='0';
		shr1<='0';	
		shr2<='0';
		shl2<='0';
		difference<=0;
		count<=0;
		shiftCount<=0;
		increment<='0';
		decrement<='0';
		busy<='0';
		done<='1';
		tip:='0';
		w1<='0';
		w2<='0';
		error<='0';

            when Start =>

		next_state<=Exponent;

                mx1<='0';
		mx2<='0';
		mx3<='0';
		mx4<='0';
		mx5<='0';
		shr1<='0';	
		shr2<='0';
		shl2<='0';
		difference<=0;
		count<=0;
		shiftCount<=0;
		increment<='0';
		decrement<='0';
		busy<='1';
		done<='0';
		tip:='0';
		w1<='0';
		w2<='0';
		error<='0';

            when Exponent =>

                if selector = '1' then
                    	mx1<='1';
		    	mx2<='0';
		    	mx3<='1';
			if ((sign1 xor sign2) = '1') then
				tip:=sign2;
			else 
				tip:= sign1;
			end if;
                elsif selector = '0' then
                    	mx1<='0';
		    	mx2<='1';
		    	mx3<='0';
			tip:=sign1;
                end if;

			mx4<='0';
			mx5<='0';
			shr1<='1';	
			shr2<='0';
			shl2<='0';
			busy<='1';
			done<='0';
			difference<=diff;
			count<=0;
			shiftCount<=0;
			increment<='0';
			decrement<='0';
			error<='0';
			w1<='1';
			w2<='0';

		next_state<= Normalizing;
		
            when Normalizing =>
                w1<='0';
		w2<='1';
		point:= cin & mant(23);

		case point is

			when "10" =>
				-----Mantisa u desno, exp u levo
				if exp /= "11111110" then
					shr2<='1';
					shl2<='0';
					count<= natural(to_integer(unsigned(exp)));
					increment<='1';
					decrement<='0';
					error<='0';
					--------Pazi na Zaokruzivanje
					shiftCount<=1;
				else 
					-----Prekoracenje
					error<='1';

					shr2<='0';
					shl2<='0';
					count<= 0;
					increment<='0';
					decrement<='0';
					error<='0';
					shiftCount<=0;
				end if;

			when "11" =>
				-----Mantisa desno, exp u levo
				if exp /= "11111110" then
					shr2<='1';
					shl2<='0';
					count<=natural(to_integer(unsigned(exp)));
					increment<='1';
					decrement<='0';
					error<='0';
					--------Pazi na Zaokruzivanje
					shiftCount<=1;
					
				else 
					-----Prekoracenje
					error<='1';
					shr2<='0';
					shl2<='0';
					count<= 0;
					increment<='0';
					decrement<='0';
					error<='0';
					shiftCount<=0;
				end if;


			when "00" =>
				-----Mantisa levo, exp u desno

				------Trazenje prve jedinice
			        
			        position := -1;
			        for i in 22 downto 0 loop
			            if mant(i) = '1' then
			                position := i;
			                exit;
			            end if;
			        end loop;
			        
			        if position /= -1 then
				    position := 23 - position;
			            --shift_count <= position;

					--Provera da li exp moze da se shiftuje u desno
					if to_integer(shift_right(unsigned(exp),position)) > 0 then
						shr2<='0';
						shl2<='1';
						count<=2 ** position;
						shiftCount<=position;
						increment<='0';
						decrement<='1';
						error<='0';
					else
						----Potkoracenje
						error<='1';
						shr2<='0';
						shl2<='0';
						count<= 0;
						increment<='0';
						decrement<='0';
						shiftCount<=0;
					end if;
					
				else
					count<= 19;
					error<='1';
	
			        end if;




--------------------WHEN 01
			when others =>

				mx1<='0';
				mx2<='0';
				mx3<='0';
				mx4<='0';
				mx5<='0';
				shr1<='0';	
				shr2<='0';
				shl2<='0';
				difference<=0;
				count<=0;
				shiftCount<=0;
				increment<='0';
				decrement<='0';
				busy<='0';
				done<='0';
				tip:='0';
				-----Nista se ne dira
		end case;
---Potencijalni problem kasnije
		 		mx1<= '0';
				mx2<= '0';
				mx3<= '0';

				mx4<='0';
				mx5<='0';
				shr1<='0';	
				difference<=0;
				busy<='1';
				done<='0';
				tip:=tip;
				next_state<= Finish;
        end case;
    end process;
end architecture;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.math_real.all;


entity fpadc_tb is
end entity;


architecture fpad_tb of fpadc_tb is
	signal clk: std_logic:='0';
	signal rst: std_logic;

	signal sign1,sign2: std_logic;
	signal selector: std_logic; 
	signal diff:  natural;
	signal difference:  natural;


	signal exp:  std_logic_vector(7 downto 0);
	signal cin:  std_logic;
	signal mant: std_logic_vector(23 downto 0);

  	signal mx1,mx2,mx3,mx4,mx5:  std_logic;
	signal shr1,shr2,shl2:  std_logic;
	signal count,shiftCount:  natural;
	signal increment,decrement:  std_logic;
	signal busy,done,error:  std_logic;
	signal st: std_logic;
begin


clk<= not clk after 50 ps;


dut: entity work.floatingPointAdderController(fpaController)
			port map (
			    clk => clk,
			    rst => rst,
			    st=>st,
			    sign1 => sign1,
			    sign2 => sign2,
			    selector => selector,
			    diff => diff,
			    difference => difference,
			    exp => exp,
			    cin => cin,
			    mant => mant,
			    mx1 => mx1,
			    mx2 => mx2,
			    mx3 => mx3,
			    mx4 => mx4,
			    mx5 => mx5,
			    shr1 => shr1,
			    shr2 => shr2,
			    shl2 => shl2,
			    count => count,
			    shiftCount => shiftCount,
			    increment => increment,
			    decrement => decrement,
			    busy => busy,
			    done => done,
			    error => error
			);


process 

begin

rst<='1';
wait for 100 ps;


rst<='0';
sign1<='0';
sign2<='0';
selector<='0'; 
diff<= 0;
exp<="00000000";
cin<='0';
mant<="000000000000000000000000";
st<='1';
wait for 100 ps;


st<='0';
wait for 600 ps;




rst<='0';
sign1<='0';
sign2<='0';
selector<='0'; 
diff<= 0;
exp<="00001100";
cin<='0';
mant<="000000001111000010100111";
st<='1';
wait for 400 ps;

st<='0';
exp<="11111100";
cin<='0';
mant<="000000000111000010100111";
wait for 300 ps;


wait;

end process;



end architecture;






