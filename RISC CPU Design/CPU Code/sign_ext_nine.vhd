library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity sign_ext_nine is
	port(
			a: in std_logic_vector(8 downto 0);
			b: out std_logic_vector(15 downto 0)
		);
end entity;

architecture struct of sign_ext_nine is
	
begin 
	for_1: for i in 0 to 8 generate
	b(i)<= a(i);
	end generate for_1;
	for_2: for i in 9 to 15 generate
	b(i)<= a(8);
	end generate for_2;		
end architecture;