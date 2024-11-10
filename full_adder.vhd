-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
--USE IEEE.std_logic_arith.ALL;

entity full_adder is
port(a,b,c_in:in bit;
	s,c_out:out bit);
end entity;

architecture truth_table of full_adder is
begin
with bit_vector'(a,b,c_in) select
(c_out,s)<= bit_vector'("00")when("000"),
			bit_vector'("01")when("001"),
            bit_vector'("01")when("010"),
            bit_vector'("10")when("011"),
            bit_vector'("01")when("100"),
            bit_vector'("10")when("101"),
            bit_vector'("10")when("110"),
            bit_vector'("11")when("111"),
            bit_vector'("00")when others;
end architecture;




entity adder3b is
port(	a1,b1:in bit_vector(2 downto 0);
	cin:in bit;
	sum:out bit_vector(2 downto 0);
	cout:out bit
);
end entity;


architecture struct of adder3b is
signal c0,c12:bit;
begin

bit0:entity work.full_adder(truth_table)
port map(a1(0),b1(0),cin,sum(0),c0);

bit1:entity work.full_adder(truth_table)
port map(a=>a1(1),b=>b1(1),c_in=>c0,s=>sum(1),c_out=>c12);

bit2:entity work.full_adder(truth_table)
port map(a=>a1(2),b=>b1(2),c_in=>c12,s=>sum(2),c_out=>cout);

end architecture;







entity adder_3b_tb is
end entity;



architecture adder_3b_tb_arch of adder_3b_tb is
signal a_tb,b_tb,s:bit_vector(2 downto 0);
signal cout_tb,cin_tb:bit;
begin
uut: entity work.adder3b(struct)
port map(a1=>a_tb,b1=>b_tb,sum=>s,cin=>cin_tb,cout=>cout_tb);


stimulus: process
begin
a_tb<="010";
b_tb<="111";
cin_tb<='0';
wait for 100ps;
end process;
end architecture;