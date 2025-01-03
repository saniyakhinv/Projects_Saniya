library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity demux8bit16 is
port ( I : in std_logic_vector(15 downto 0);
       A,B,C,D,E,F,G,H :out std_logic_vector(15 downto 0);
		  sel : in std_logic_vector(2 downto 0));
end entity;


architecture struct of demux8bit16 is

component demux8 is 
port( I : in std_logic;
      Y : out std_logic_vector(7 downto 0);
		sel : in std_logic_vector(2 downto 0));
		
end component;

begin

inst: for k in 0 to 15 generate
inst1: demux8 port map(Y(7)=>A(k),Y(6)=>B(k),Y(5)=>C(k),Y(4)=>D(k),Y(3)=>E(k),Y(2)=>F(k),Y(1)=>G(k),Y(0)=>H(k),sel=>sel,I=>I(k));
end generate;

end architecture;

		  