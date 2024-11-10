library IEEE;
use IEEE.std_logic_1164.all;
use work.array_pkg.all;

entity decoder5x32 is
	port(
		input:in std_logic_vector(4 downto 0);
		--output:out array8(3 downto 0)
		output:out std_logic_vector(31 downto 0)
	);
end entity;


architecture dec5x32 of decoder5x32 is

signal temp:std_logic_vector(3 downto 0);

begin

	dec2: entity work.decoder2x4(dec2x4)
		port map(
		input=>input(4 downto 3),
		y4=>temp(3),
		y3=>temp(2),
		y2=>temp(1),
		y1=>temp(0)
		);


	labGen: for i in 3 downto 0 generate
		begin
			dec8: entity work.decoder3x8
				port map(
					en=>temp(i),
					input=>input(2 downto 0),
					y1=>output(i*8+0),
					y2=>output(i*8+1),
					y3=>output(i*8+2),
					y4=>output(i*8+3),
					y5=>output(i*8+4),
					y6=>output(i*8+5),
					y7=>output(i*8+6),
					y8=>output(i*8+7)
				);
		end generate;


end architecture;








library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_decoder5x32 is
end tb_decoder5x32;

architecture behavior of tb_decoder5x32 is

  -- Komponente za testiranje
  component decoder5x32
    Port (
      input : in std_logic_vector(4 downto 0);
      output : out std_logic_vector(31 downto 0)
    );
  end component;

  -- Signali za povezivanje sa DUT
  signal input : std_logic_vector(4 downto 0);
  signal output : std_logic_vector(31 downto 0);

begin

  -- Instanciranje DUT
  uut: decoder5x32
    Port map (
      input => input,
      output => output
    );

  -- Stimuli?ite proces za generisanje test vektora
  stimulus: process
  begin
    -- Inicijalne vrednosti
    input <= "00000";
    wait for 100 ps;
    
    -- Test vektor 1
    input <= "00001";
    wait for 100 ps;
    
    -- Test vektor 2
    input <= "00010";
    wait for 100 ps;
    
    -- Test vektor 3
    input <= "00011";
    wait for 100 ps;

    -- Test vektor 4
    input <= "00100";
    wait for 100 ps;

    -- Test vektor 5
    input <= "00101";
    wait for 100 ps;

    -- Dodajte vi?e test vektora prema potrebi
    input <= "11111";
    wait for 100 ps;

    -- Zavr?etak simulacije
    wait;
  end process stimulus;

end behavior;

