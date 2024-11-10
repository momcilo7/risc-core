library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rob_buffer is
    port (
        clk            : in std_logic;
        rst            : in std_logic;

        func_id        : in integer range -1 to 7;
        register_id    : in std_logic_vector(5 downto 0);
        result         : in std_logic_vector(31 downto 0);
        
        cdb_data_out: in std_logic_vector(31 downto 0);
        cdb_rob_id    : in integer range -1 to 31;

        --empty_pointer  : out integer range 0 to 31; -- pointer to the empty location
        --commit_pointer : out integer range 0 to 31; -- pointer to the commit location
        rob_data       : out std_logic_vector(31 downto 0); -- output for data from ROB
--TB

	commit_tb,empty_tb   : out integer range -1 to 31
    );
end entity rob_buffer;

architecture behavioral of rob_buffer is
    type rob_entry is record
        func_id     : integer range -1 to 7;
        register_id : std_logic_vector(5 downto 0);
        result      : std_logic_vector(31 downto 0);
        finish      : std_logic;
        commit      : std_logic;
    end record;

    type rob_array is array (0 to 31) of rob_entry;
    signal rob : rob_array;
    

begin
    process(clk, rst,cdb_rob_id)
	variable empty_ptr : integer range 0 to 31;
    	variable commit_ptr : integer range 0 to 31;
    begin
        if rst = '1' then
            -- Reset all entries in the ROB
            for i in 0 to 31 loop
                rob(i).func_id <= -1;
                rob(i).register_id <= (others => '0');
                rob(i).result <= (others => '0');
                rob(i).finish <='1'; -- Mark all entries as free
                rob(i).commit <= '1';
            end loop;
            empty_ptr := 0;
            commit_ptr := 0;

            --elsif rising_edge(clk) then
        else  
            -- Store a new entry if the finish bit is '1'
            if  rob(empty_ptr).commit = '1' and rising_edge(clk) and func_id /= -1 then
                rob(empty_ptr).func_id <= func_id;
                rob(empty_ptr).register_id <= register_id;
                rob(empty_ptr).result <= (others=>'0');
                rob(empty_ptr).finish <= '0'; -- Mark as busy
                rob(empty_ptr).commit<='0';
		empty_ptr := (empty_ptr + 1) mod 32;
                 -- Move to next empty location
            end if;

            -- Store a finish value
            if cdb_rob_id /= -1  then
                for i in 0 to 31 loop
                    --mozda treba za ne daj Boze => rob(cdb_rob_id).finish = '0'
                    if rob(i).func_id = cdb_rob_id then
                        rob(i).finish <= '1';
                        rob(i).result <= cdb_data_out;
                        exit;
                    end if;
                end loop;
            end if;

            -- Commit the function if the pointer indicates a valid function
            if  rob(commit_ptr).finish='1' and  rob(commit_ptr).commit = '0' and rising_edge(clk)then

                --==================================== FALI STVARNO KOMITOVANJE U REGISTARSKI FAJL==================================
                rob(commit_ptr).commit <= '1'; -- Mark as finished
                rob_data <= rob(commit_ptr).result;
                commit_ptr := (commit_ptr + 1) mod 32; -- Move to the next commit location
            end if;


        end if;
	commit_tb<=commit_ptr;
	empty_tb<=empty_ptr;
    end process;

     -- Output the result of the committed function

end architecture behavioral;




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rob_buffer is
end entity tb_rob_buffer;

architecture sim of tb_rob_buffer is
    
    -- Testbench signals
    signal clk           : std_logic := '0';
    signal rst           : std_logic := '0';
    signal func_id       : integer range -1 to 7;
    signal register_id   : std_logic_vector(5 downto 0);
    signal result        : std_logic_vector(31 downto 0);
    
    signal cdb_data_out  : std_logic_vector(31 downto 0);
    signal cdb_rob_id    : integer range -1 to 31;
    
    signal rob_data      : std_logic_vector(31 downto 0);
	signal commit_tb,empty_tb   : integer range -1 to 31;
begin

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ps;
            clk <= '1';
            wait for 10 ps;
        end loop;
    end process clk_process;


uut : entity work.rob_buffer
    port map (
        clk           => clk,
        rst           => rst,
        func_id       => func_id,
        register_id   => register_id,
        result        => result,
        cdb_data_out  => cdb_data_out,
        cdb_rob_id    => cdb_rob_id,
        rob_data      => rob_data,
	commit_tb=>commit_tb,
	empty_tb=>empty_tb
    );



    -- Stimulus process
    stimulus : process
    begin

	rst <= '1';  -- Activate reset
	cdb_rob_id<=-1;
        wait for 20 ps;
        rst <= '0';  -- Deactivate reset
        -- Initial values
        wait for 40 ps;
        
        -- Write some values into the buffer
        func_id <= 7;
        register_id <= "000101";
	wait for 20 ps;

	func_id <= 2;
        register_id <= "100101";
	wait for 20 ps;

	func_id <= 1;
        register_id <= "001001";
	wait for 20 ps;

	func_id <= 6;
        register_id <= "100001";
	wait for 20 ps;

	func_id <= 4;
        register_id <= "011100";
	cdb_data_out<= x"5555AAAA";
	cdb_rob_id<= 1;
	wait for 20 ps;


	func_id <= -1;
	cdb_data_out<= x"49842345";
	cdb_rob_id<= 2;
	wait for 20 ps;


	cdb_data_out<= x"32451312";
	cdb_rob_id<= 4;
	wait for 20 ps;

	cdb_data_out<= x"11110020";
	cdb_rob_id<= 6;
	wait for 20 ps;

	cdb_data_out<= x"87234497";
	cdb_rob_id<= 7;
	wait for 20 ps;
        -- Finish simulation
        wait;
    end process stimulus;

end architecture sim;





