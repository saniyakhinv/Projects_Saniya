library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity mux2 is
	port ( I1,I0,sel : in std_logic;
	Y : out std_logic);
end entity;

architecture struct of mux2 is
	signal sel_bar,s1,s2 : std_logic;
begin
	inst1 : INVERTER port map(a=>sel,y=>sel_bar);
	inst2 : AND_2 port map(a=>I0,b=>sel_bar,y=>s1);
	inst3 : AND_2 port map(a=>I1,b=>sel,y=>s2);
	inst4 : OR_2 port map(a=>s1,b=>s2,y=>Y);
end architecture;