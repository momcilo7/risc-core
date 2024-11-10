library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity cdb is
    port (
        clk,rst: in std_logic;
        dest_id: in integer range 0 to 31;
        cdb_request: in std_logic_vector(7 downto 0);
        rs_input: in std_logic_vector(31 downto 0);
        
        mx: out std_logic_vector(2 downto 0);
        cdb_present: out std_logic_vector(7 downto 0);
        cdb_data_out: out std_logic_vector(31 downto 0);
        cdb_rob_id: out integer range -1 to 31
    );
end entity cdb;



architecture cdb_arch of cdb is
    type state is (wait_request,output_data);
    signal current_state,next_state: state;

begin
    
    changeState: process(clk, rst)
    begin
        if rst = '1' then
            current_state<=wait_request;
        elsif rising_edge(clk) then
            current_state<=next_state;
        end if;
    end process changeState;


    modelState: process(current_state,cdb_request)
    variable foundIndex:integer;
    begin
        
         case current_state is
            when wait_request =>


		next_state<=output_data;
                mx<= (others => '0');
                cdb_present<= (others => '0');
                cdb_data_out<= (others => '0');
                cdb_rob_id<= -1;
                
        
            when output_data =>

		foundIndex := -1;
for i in 0 to cdb_request'length-1 loop
    if cdb_request(i) = '1' then
        -- A?uriraj cdb_present tako da samo pozicija i bude 1
        cdb_present <= (cdb_present'left downto i+1 => '0') & '1' & (i-1 downto cdb_present'right => '0');
        
        -- Postavi odgovaraju?e izlazne vrednosti
        mx <= std_logic_vector(to_unsigned(i, 3));
        cdb_rob_id <= dest_id;
        cdb_data_out <= rs_input;

        exit;  -- Prekini petlju nakon ?to se prona?e prvi setovani bit
    end if;
end loop;
		if foundIndex/=-1 then
			mx <= std_logic_vector(to_unsigned(foundIndex, 3));
		end if;

--                if to_integer(unsigned(cdb_request)) /= 0 then
--                    next_state<=output_data;
--                else
--                    next_state<=wait_request;
--                end if;
		--next_state<=wait_request;

        end case;    

    end process modelState;

end architecture cdb_arch;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cdb_tb is
end entity cdb_tb;

architecture testbench of cdb_tb is
    signal clk            : std_logic := '0';
    signal rst            : std_logic := '1';
    signal dest_id        : integer range 0 to 31 := 0;
    signal cdb_request     : std_logic_vector(7 downto 0) := (others => '0');
    signal rs_input       : std_logic_vector(31 downto 0) := (others => '0');
    
    signal mx             : std_logic_vector(2 downto 0);
    signal cdb_present    : std_logic_vector(7 downto 0);
    signal cdb_data_out   : std_logic_vector(31 downto 0);
    signal cdb_rob_id     : integer range -1 to 31;


begin
    -- Clock process
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 10 ps;
            clk <= '1';
            wait for 10 ps;
        end loop;
    end process;

    -- Instantiate the CDB entity
    uut: entity work.cdb
        port map (
            clk => clk,
            rst => rst,
            dest_id => dest_id,
            cdb_request => cdb_request,
            rs_input => rs_input,
            mx => mx,
            cdb_present => cdb_present,
            cdb_data_out => cdb_data_out,
            cdb_rob_id => cdb_rob_id
        );

    -- Stimulus process
    stimulus: process
    begin
        -- Reset the system
        rst <= '1';
        wait for 20 ps;  -- Hold reset for 2 clock cycles
        rst <= '0';

        -- Test case 1: Sending CDB request
        dest_id <= 5;
        cdb_request <= "00010000";  -- Request for the first CDB
        rs_input <= "00000000000011000000000000000000";  -- Example input
        wait for 20 ps;

        -- Test case 2: Change dest_id and cdb_request
        dest_id <= 10;
        cdb_request <= "00000010";  -- Request for the second CDB
        rs_input <= "00000000000000000000000000000010";  -- Another example input
        wait for 20 ps;

        -- Test case 3: Check CDB outputs
        dest_id <= 15;
        cdb_request <= "00000011";  -- Request for the third CDB
        rs_input <= "00000000000000000000000000000011";  -- Another example input
        wait for 20 ps;

        -- Finish the simulation
        wait;
    end process;

end architecture testbench;

















