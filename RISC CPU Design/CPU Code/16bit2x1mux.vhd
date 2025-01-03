library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity mux2bit16 is
port ( Y   : out std_logic_vector(15 downto 0);
       A,B : in std_logic_vector(15 downto 0);
		  sel : in std_logic);
end entity;


architecture struct of mux2bit16 is

	component mux2 is
	port ( I1,I0,sel : in std_logic;
	               Y : out std_logic);
   end component;

begin

inst: for k in 0 to 15 generate
inst1: mux2 port map(I1=>A(k),I0=>B(k), sel=>sel,Y=>Y(k));
end generate;

end architecture;