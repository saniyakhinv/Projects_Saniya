library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity demux4 is 
port( I : in std_logic;
      Y : out std_logic_vector(3 downto 0);
		sel : in std_logic_vector(1 downto 0));
		
end entity;


architecture struct of demux4 is

component demux2 is 
port( I : in std_logic;
      Y : out std_logic_vector(1 downto 0);
		sel : in std_logic);
		
		
end component;

signal s1,s0 : std_logic;

begin
inst1: demux2 port map(I=>I, sel=>sel(1), Y(1)=>s1, Y(0)=>s0);
inst2: demux2 port map(I=>s1, sel=>sel(0), Y(1)=>Y(3), Y(0)=>Y(2));
inst3: demux2 port map(I=>s0, sel=>sel(0), Y(1)=>Y(1), Y(0)=>Y(0));

end architecture;

