library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mux8bit16 is
port( A,B,C,D,E,F,G,H : in std_logic_vector(15 downto 0);
                  sel : in std_logic_vector(2 downto 0);
						  Y : out std_logic_vector(15 downto 0));
end entity;

architecture struct of mux8bit16 is

component mux8 is
port ( I : in std_logic_vector(7 downto 0);
     sel : in std_logic_vector(2 downto 0);
       Y : out std_logic);
end component;

begin

inst: for k in 0 to 15 generate
inst1: mux8 port map(I(7)=>A(k),I(6)=>B(k),I(5)=>C(k),I(4)=>D(k),I(3)=>E(k),I(2)=>F(k),I(1)=>G(k),I(0)=>H(k),sel=>sel,Y=>Y(k));
end generate;

end architecture;
