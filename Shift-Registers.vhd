library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity shiftRegister is
generic (n:natural:=32);
port(
	clk,rst,we,shift:in std_logic;
	shiftIn:in std_logic;
	shiftOut:out std_logic;
	input: in std_logic_vector(n-1 downto 0);
	output: out std_logic_vector(n-1 downto 0)
);

end entity;


architecture shreg1 of shiftRegister is

begin

	process(clk,rst)
		variable reg: std_logic_vector(n-1 downto 0);
		variable shOt:std_logic;
		begin
			if rst='1' then
				reg := (others=>'0');
				shOt:='0';
			elsif rising_edge(clk) then

				if we = '1' then
					reg:= input;
					shOt:=reg(0);
				end if;
					if shift='1' then
					shOt:=reg(0);
					reg:= shiftIn & reg(n-1 downto 1);
				end if;
				output<=reg;
				shiftOut<=shOt;
			end if;
			
	end process;


end architecture;


architecture shreg2 of shiftRegister is

begin

	process(clk)
		variable reg: std_logic_vector(n-1 downto 0);
		variable shOt:std_logic;
		begin

			if rising_edge(clk) then


				if rst='1' then
					reg := (others=>'0');
					shOt:='0';
				else

					if we = '1' then
						reg:= input;
						shOt:=reg(0);
					end if;
					if shift='1' then
						reg:= shiftIn & reg(n-1 downto 1);
						shOt:=reg(0);
					end if;
				
				end if;
			output<=reg;
			shiftOut<=shOt;
			end if;
		
	end process;

end architecture;








architecture slreg1 of shiftRegister is
begin
	process(clk)
		variable reg: std_logic_vector(31 downto 0);
		variable shOt:std_logic;
		begin
			if rst='1' then
				reg := (others=>'0');
				shOt:='0';
			elsif rising_edge(clk) then

				if shift='1' then
					shOt:=reg(31);
					reg:= reg(30 downto 0) & shiftIn;
				end if;


				if we = '1' then
					reg := input;
					shOt:= input(31);
				end if;
			output<=reg;
			shiftOut<=shOt;
			end if;
			
	end process;
end architecture;






architecture slreg2 of shiftRegister is
begin
	process(clk)
		variable reg: std_logic_vector(31 downto 0);
		variable shOt:std_logic;
		begin

			if rst='1' then
				reg := input;
				shOt:=reg(31);
			elsif rising_edge(clk) then
				if we = '1' then
					reg(0):= shiftIn;
					shOt:=reg(31);
				end if;

				if shift='1' then
					shOt:=reg(0);
					reg:= reg(30 downto 0) & '0';
				end if;
				output<=reg;
				shiftOut<=shOt;
			end if;
	end process;
end architecture;
