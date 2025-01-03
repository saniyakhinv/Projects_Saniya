library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mux8 is
port ( I : in std_logic_vector(7 downto 0);
     sel : in std_logic_vector(2 downto 0);
       Y : out std_logic);
end entity;

architecture struct of mux8 is

component mux4 is
	port ( I4,I3,I2,I1,sel2,sel1 : in std_logic;
	Y : out std_logic);
end component;

component mux2 is
	port ( I1,I0,sel : in std_logic;
	               Y : out std_logic);
   end component;

signal s1,s0 : std_logic;

begin

inst1: mux4 port map(I(7),I(6),I(5),I(4),sel(1),sel(0),s1);
inst2: mux4 port map(I(3),I(2),I(1),I(0),sel(1),sel(0),s0);
inst3: mux2 port map(s1,s0,sel(2),Y);

end architecture;