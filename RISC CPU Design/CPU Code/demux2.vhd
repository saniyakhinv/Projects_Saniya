library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.Gates.all;

entity demux2 is 
port( I : in std_logic;
      Y : out std_logic_vector(1 downto 0);
		sel : in std_logic);
		
		
end entity;


architecture struct of demux2 is
signal sel_bar: std_logic;
begin
inst1: INVERTER port map(a=>sel,y=>sel_bar);
inst3: AND_2 port map(a=>I, b=>sel, Y=>Y(1));
inst4: AND_2 port map(a=>I, b=>sel_bar, Y=>Y(0));

end architecture;
