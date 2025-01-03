library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity shift_one is
	port(
			a: in std_logic_vector(15 downto 0);
			b: out std_logic_vector(15 downto 0)
		);
end entity;

architecture struct of shift_one is
	
begin 
	for_shift: for i in 0 to 14 generate
	b(i+1)<= a(i);
	end generate for_shift;
	b(0)<='0';
		
end architecture;
