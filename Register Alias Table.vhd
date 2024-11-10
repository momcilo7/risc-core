library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAT is
    port(
        clk    : in std_logic;
	rst: in std_logic;
        we     : in std_logic;
        fp     : in std_logic;
        --red    : in natural range 0 to 31;
	indexWrite: in std_logic_vector(4 downto 0);
	indexRead: in std_logic_vector(4 downto 0);
        din    : in integer range -1 to 31;
        dout   : out integer range -1 to 31
    );
end entity RAT;

architecture Behavioral of RAT is
    -- Definisanje dve kolone od 32 reda, svaka kolona sadr?i integer vrednosti
    type rat_array is array (0 to 31) of integer range -1 to 31;
    signal col0, col1 : rat_array;-- := (others => -1); -- Inicijalizacija na -1

begin
    process(clk)
    begin
	
	if rst='1' then
		for i in 0 to 31 loop
			col0(i)<=-1;
			col1(i)<=-1;
		end loop;

        elsif falling_edge(clk) then
            if we = '1' then
                if fp = '0' then
                    col0(to_integer(unsigned(indexWrite))) <= din; -- Upis u prvu kolonu
                else
                    col1(to_integer(unsigned(indexWrite))) <= din; -- Upis u drugu kolonu
                end if;
            end if;
        end if;
    end process;

    -- ?itanje vrednosti
    process(fp, indexRead)
    begin
        if fp = '0' then
            dout <= col0(to_integer(unsigned(indexRead))); -- ?itanje iz prve kolone
        else
            dout <= col1(to_integer(unsigned(indexRead))); -- ?itanje iz druge kolone
        end if;
    end process;

end architecture Behavioral;

