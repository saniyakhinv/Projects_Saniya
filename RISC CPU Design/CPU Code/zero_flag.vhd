library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity zero_flag is
	port(
			a: in std_logic_vector(15 downto 0);
			z: out std_logic);
end entity;

architecture struct of zero_flag is
	signal c: std_logic_vector(13 downto 0);
	signal z_bar: std_logic;
begin 	
	inst1: OR_2 port map(a=>a(0),b=>a(1),y=>c(0));
	inst2: OR_2 port map(a=>c(0),b=>a(2),y=>c(1));
	inst3: OR_2 port map(a=>c(1),b=>a(3),y=>c(2));
	inst4: OR_2 port map(a=>c(2),b=>a(4),y=>c(3));
	inst5: OR_2 port map(a=>c(3),b=>a(5),y=>c(4));
	inst6: OR_2 port map(a=>c(4),b=>a(6),y=>c(5));
	inst7: OR_2 port map(a=>c(5),b=>a(7),y=>c(6));
	inst8: OR_2 port map(a=>c(6),b=>a(8),y=>c(7));
	inst9: OR_2 port map(a=>c(7),b=>a(9),y=>c(8));
	inst10: OR_2 port map(a=>c(8),b=>a(10),y=>c(9));
	inst11: OR_2 port map(a=>c(9),b=>a(11),y=>c(10));
	inst12: OR_2 port map(a=>c(10),b=>a(12),y=>c(11));
	inst13: OR_2 port map(a=>c(11),b=>a(13),y=>c(12));
	inst14: OR_2 port map(a=>c(12),b=>a(14),y=>c(13));
	inst15: OR_2 port map(a=>c(13),b=>a(15),y=>z_bar);
	z <= not Z_bar;
	
end architecture;
