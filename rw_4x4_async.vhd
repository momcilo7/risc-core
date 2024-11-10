library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rw_4x4_async is
	port (address  : in std_logic_vector(1 downto 0);
		data_in  : in std_logic_vector(3 downto 0);
		WE	   : in std_logic;
		data_out : out std_logic_vector(3 downto 0));
end entity;

architecture rw_4x4_async_arch of rw_4x4_async is	
	type RW_type is array (0 to 3) of std_logic_vector(3 downto 0);
	signal RW : RW_type;
	
begin	
	
	MEMORY : process (address, WE, data_in)
		begin
			if (WE = '1') then
				RW(to_integer(unsigned(address))) <= data_in;
			else
				data_out <= RW(to_integer(unsigned(address)));
			end if;
	end process;

end architecture;

entity rw_4x4_async_TB is 
end entity; 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

architecture rw_4x4_async_TB_arch of rw_4x4_async_TB is 
component rw_4x4_async 
port (address  : in std_logic_vector(1 downto 0);
	data_in  : in std_logic_vector(3 downto 0);
	WE	   : in std_logic;
	data_out : out std_logic_vector(3 downto 0));
end component; 
signal address_TB  : std_logic_vector(1 downto 0);
signal data_in_TB  : std_logic_vector(3 downto 0);
signal WE_TB			 : std_logic;
signal data_out_TB : std_logic_vector(3 downto 0); 
begin 
DUT1: rw_4x4_async port map (address => address_TB,
				     data_in => data_in_TB,

     WE => WE_TB,
     data_out => data_out_TB); 

STIMULUS : process
begin
WE_TB <= '0';
wait for 40 ns;
for i in 0 to 3 loop	
address_TB <= std_logic_vector(to_unsigned(i,2));
	
wait for 40 ns;
end loop;

WE_TB <= '1';
wait for 120 ns;
for i in 0 to 3 loop
address_TB <= std_logic_vector(to_unsigned(i,2));
	data_in_TB <= std_logic_vector(to_unsigned(i,4));	
wait for 120 ns;
end loop;

WE_TB <= '0';
wait for 200 ns;	
for i in 0 to 3 loop
address_TB <= std_logic_vector(to_unsigned(i,2));

wait for 200 ns;	
end loop;
	 
end process;
end architecture; 
