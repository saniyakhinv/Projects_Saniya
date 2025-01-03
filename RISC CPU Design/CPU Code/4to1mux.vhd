library ieee;
use ieee.std_logic_1164.all;
library work;


entity mux4 is
	port ( I4,I3,I2,I1,sel2,sel1 : in std_logic;
	Y : out std_logic);
end entity;

architecture struct of mux4 is
	signal s1,s2 : std_logic;
	component mux2 is
	port ( I1,I0,sel : in std_logic;Y : out std_logic);
   end component;

begin
	inst1 : mux2 port map(I1=>I2,I0=>I1,sel=>sel1,Y=>s1);
	inst2 : mux2 port map(I1=>I4,I0=>I3,sel=>sel1,Y=>s2);
	inst3 : mux2 port map(I1=>s2,I0=>s1,sel=>sel2,Y=>Y);
end architecture;