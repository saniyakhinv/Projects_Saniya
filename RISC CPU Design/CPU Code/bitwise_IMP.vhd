library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity bitwise_IMP is
	port(
			a,b: in std_logic_vector(15 downto 0);
			c: out std_logic_vector(15 downto 0));
end entity;

architecture struct of bitwise_IMP is
signal s: std_logic_vector(15 downto 0);
begin 
	for_and: for  i in 0 to 15 generate
	inst1: INVERTER port map(a=>a(i), y=>s(i));
	inst2: OR_2 port map(a=>s(i),b=>b(i),y=>c(i));
	end generate;
	
end architecture;
