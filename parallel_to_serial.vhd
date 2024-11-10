-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
--use ieee.std_logic_unsigned.all; 

entity parallel_to_serial is
GENERIC (n:integer:=8);
port(
		wr,clk:in std_logic;
		d_in: in std_logic_vector(n-1 downto 0);
        	d_out: out std_logic
);
end entity parallel_to_serial;


architecture struct of parallel_to_serial is
begin

	process is
    	variable tmp : std_logic_vector(n-1 downto 0);
    	begin
        	wait until wr='1';
            tmp:= d_in;
            for i in n-1 downto 0 loop
            	wait until clk'event and clk='1';
                d_out<=tmp(i);
           	end loop;
            
            wait until clk'event and clk='1';
            d_out<='Z';
	end process;
end architecture;            
        	



-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity parralel_to_serial_tb is
GENERIC(n_tb:integer:=4);
end entity;



architecture struct_tb of parralel_to_serial_tb is 
signal wr_tb,d_out_tb:std_logic;
signal clk_tb:std_logic:='0';
signal d_in_tb: std_logic_vector(n_tb-1 downto 0);
begin

	--clk_tb<= not clk_tb after 50 ns;

	--clk:='0';
    
	DUT: entity work.parallel_to_serial(struct)
    generic map(n=>n_tb)
	port map(
    	wr=>wr_tb,
        clk=>clk_tb,
        d_in=>d_in_tb,
        d_out=>d_out_tb
    );
    
    clk_tb<=not clk_tb after 50ns;
    
    
    process is
    begin
    
    d_in_tb<="1001";
    clk_tb<='1';
    wait for 50 ns;
    
    clk_tb<='0';
    wait for 600 ns;
    
    
    d_in_tb <= "1101"; 

  	wr_tb<='1'; 

  	WAIT FOR 100 ns; 

	d_in_tb<="0000";  

   	WAIT FOR 500 ns; 

 	END PROCESS;
end architecture;
