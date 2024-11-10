library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux8x1_32b is
    Port (
        input0 : in std_logic_vector(31 downto 0);
        input1 : in std_logic_vector(31 downto 0);
        input2 : in std_logic_vector(31 downto 0);
        input3 : in std_logic_vector(31 downto 0);
        input4 : in std_logic_vector(31 downto 0);
        input5 : in std_logic_vector(31 downto 0);
        input6 : in std_logic_vector(31 downto 0);
        input7 : in std_logic_vector(31 downto 0);
        sel : in std_logic_vector(2 downto 0);
        output : out std_logic_vector(31 downto 0)
    );
end Mux8x1_32b;

architecture mx8x1_32b of Mux8x1_32b is
begin
    process(sel, input0, input1, input2, input3, input4, input5, input6, input7)
    begin
        case sel is
            when "000" => output <= input0;
            when "001" => output <= input1;
            when "010" => output <= input2;
            when "011" => output <= input3;
            when "100" => output <= input4;
            when "101" => output <= input5;
            when "110" => output <= input6;
            when "111" => output <= input7;
            when others => output <= (others => '0'); -- Default case, just in case
        end case;
    end process;
end;