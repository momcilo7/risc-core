library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity ReservationStation is
    port (
        clk,rst,init: in std_logic;
        dest_tag:in integer range 0 to 31;
	tag1,tag2:in integer range -1 to 31;
        value1,value2: in std_logic_vector(31 downto 0);
        cdb_id: in integer range -1 to 31;
        cdb_result: in std_logic_vector(31 downto 0);
        busy: in std_logic;
        cdb_present: in std_logic;

        cdb_request: out std_logic;
        accessible: out std_logic;
        start: out std_logic;
        operand1,operand2: out std_logic_vector(31 downto 0)
    );
end entity ReservationStation;

architecture resStat of ReservationStation is
    
type states is (available,wait_operands,execute,wait_result,request_cdb);--error
--type states is (available,wait_operands,execute);
signal current_state,next_state: states;
signal val1,val2: integer range -1 to 31;
signal input1,input2: std_logic_vector(31 downto 0);
begin
    

    changeState: process(clk, rst)
    begin
        if rst = '1' then
            current_state<=available;
        elsif falling_edge(clk) then
            current_state<=next_state;
        end if;
    end process ;
    
    stateChange: process(current_state,init,busy,cdb_id,clk,cdb_present)
    begin
        
        switchState: case current_state is
            when available =>

                if init='1' and busy='0' then
                    if tag1/=-1 or tag2/=-1 then
                        val1<=tag1;
                        val2<=tag2;
			input1<=value1;
			input2<=value2;
                        next_state<=wait_operands;
                    else
			input1<=value1;
                        input2<=value2;
                        next_state<=execute;
                    end if;
                else
                    next_state<=available;
                end if;
                
                accessible<='1';
                start<='0';
                cdb_request<='0';
                operand1<= (others => '0');
                operand2<= (others => '0');


            when wait_operands =>
                
                if val1 = cdb_id then
                    val1<=-1;
                    input1<=cdb_result;
                end if;

                if val2 = cdb_id then
                    val2<=-1;
                    input2<=cdb_result;
                end if;

                if val1=-1 and val2=-1 then
                    next_state<=execute;
		        else
			        next_state<=wait_operands;
		        end if;

		
                accessible<='0';
                start<='0';
                cdb_request<='0';
                operand1<= (others => '0');
                operand2<= (others => '0');

            when execute =>

                start<='1';
                accessible<='0';
                next_state<=wait_result;
                operand1<=input1;
                operand2<=input2;
                cdb_request<='0';

            when wait_result=>

                start<='0';
                accessible<='0';
                if busy='0' then
                    next_state<=request_cdb;
                else
                    next_state<=wait_result;
                end if;
                cdb_request<='0';

            when request_cdb=>
                
                if cdb_present='1' then
                    next_state<=available;
                else
                    next_state<=request_cdb;
                end if;

                start<='0';
                accessible<='0';
                cdb_request<='1';
        end case switchState;
    end process stateChange;
end architecture resStat;



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ReservationStation_tb is
end entity ReservationStation_tb;


architecture res_arch of ReservationStation_tb is
    signal clk:  std_logic:='0';
    signal rst:  std_logic;
    signal init:  std_logic;
    signal dest_tag,tag1,tag2: integer range -1 to 31;
    signal value1,value2:  std_logic_vector(31 downto 0);
    signal cdb_id:  integer range -1 to 31;
    signal cdb_result: std_logic_vector(31 downto 0);
    signal busy:  std_logic;
    signal accessible: std_logic;
    signal start: std_logic;
    signal operand1,operand2:std_logic_vector(31 downto 0);
    signal cdb_present,cdb_request: std_logic;
begin
    
    clk<= not clk after 10 ps;


    uut: entity work.ReservationStation(resStat)
                    port map(
                        clk=>clk,rst=>rst,init=>init,
                        dest_tag=>dest_tag,tag1=>tag1,tag2=>tag2,
                        value1=>value1,value2=>value2,
                        cdb_id=>cdb_id,
                        cdb_result=>cdb_result,
                        busy=>busy,
                        accessible=>accessible,
                        start=>start,
			operand1=>operand1,operand2=>operand2,
			cdb_present=>cdb_present,cdb_request=>cdb_request
                    );
    
process
begin
   
    rst<='1';
    busy<='0';
    wait for 30 ps;


    init<='0';
    rst<='0';
    wait for 20 ps;


    init<='1';
    tag1<=-1;
    tag2<=15;
    value1<="01010000010100000101000001010000";
    value2<="11111111111111111111111111111111";
    wait for 20 ps;

    init<='0';
    wait for 80 ps;

    cdb_id<=16;
     busy<='1';
    cdb_result<="11111111000000000000000000000000";
    wait for 140 ps;
    

    cdb_id<=15;
    cdb_result<="11111111000000000000000000001111";
     
    wait for 80 ps;


	busy<='0';
	wait for 40 ps;

	cdb_present<='1';
	wait for 20 ps;

	cdb_present<='0';

    wait;

end process ;


end architecture res_arch;