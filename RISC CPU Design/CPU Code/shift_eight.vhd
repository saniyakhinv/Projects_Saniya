library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity shift_eight is
	port(
		a: in std_logic_vector(15 downto 0);
		b: out std_logic_vector(15 downto 0)
	);
end entity;

architecture design of shift_eight is
begin
	b(7 downto 0) <= "00000000";
	b(15 downto 8) <= a(7 downto 0);
end architecture;