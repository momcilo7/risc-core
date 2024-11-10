library IEEE;
use IEEE.std_logic_1164.all;

entity logicalOperator is
    port (
        input1,input2 : in std_logic_vector(31 downto 0);
        output: out std_logic_vector(31 downto 0);
        code: in std_logic_vector(1 downto 0)
    );
end entity logicalOperator;


architecture logOp of logicalOperator is
begin

process (input1, input2, code)
begin
    case code is
        when "00" =>
            output <= input1 xor input2; 
        when "10" =>
            output <= input1 or input2;
        when "11" =>
            output <= input1 and input2;
        when others =>
            output <= input1;
    end case;
end process;

end architecture logOp;
