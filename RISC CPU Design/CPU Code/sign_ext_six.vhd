library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity sign_ext_six is
	port(
			a: in std_logic_vector(5 downto 0);
			b: out std_logic_vector(15 downto 0)
		);
end entity;

architecture struct of sign_ext_six is
	
begin 
	for_1: for i in 0 to 5 generate
	b(i)<= a(i);
	end generate for_1;
	for_2: for i in 6 to 15 generate
	b(i)<= a(5);
	end generate for_2;		
end architecture;