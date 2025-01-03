library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.Gates.all;

entity alu is
	port( A,B : in std_logic_vector(15 downto 0);
			  C : out std_logic_vector(15 downto 0);
			sel : in std_logic_vector(2 downto 0);
		 zf,cf : out std_logic);
end entity;

architecture struct of alu is
 
--add 000 001
--sub 010 111
--or  101
--and 100 
--imp 110 
--mul 011

component sixteen_bit_full_adder is
	port(
			m: in std_logic;
			a,b: in std_logic_vector(15 downto 0);
			cout: out std_logic;
			s: out std_logic_vector(15 downto 0));
end component;

component multiplier is
	port(
			a,b: in std_logic_vector(15 downto 0);
			c: out std_logic_vector(15 downto 0));
end component;

component bitwise_OR is
	port(
			a,b: in std_logic_vector(15 downto 0);
			c: out std_logic_vector(15 downto 0));
end component;

component bitwise_AND is
	port(
			a,b: in std_logic_vector(15 downto 0);
			c: out std_logic_vector(15 downto 0));
end component;

component bitwise_IMP is
	port(
			a,b: in std_logic_vector(15 downto 0);
			c: out std_logic_vector(15 downto 0));
end component;

component mux8bit16 is
port( A,B,C,D,E,F,G,H : in std_logic_vector(15 downto 0);
                  sel : in std_logic_vector(2 downto 0);
						  Y : out std_logic_vector(15 downto 0));
end component;

component zero_flag is
	port(
			a: in std_logic_vector(15 downto 0);
			z: out std_logic);
end component;
signal Y,y1,y2,y3,y4,y0 : std_logic_vector(15 downto 0);
signal c1,cout,sel0_bar,sel2_bar : std_logic;

begin
adder:   sixteen_bit_full_adder port map(a=>A,b=>B,cout=>cout,s=>y0,m=>sel(1)); --y0
log_or:  bitwise_OR  port map(a=>A,b=>B,c=>y1);                                 --y1
log_and: bitwise_AND port map(a=>A,b=>B,c=>y2);                                 --y2
log_imp: bitwise_IMP port map(a=>A,b=>B,c=>y3);                                 --y3
mul:     multiplier  port map(a=>A,b=>B,c=>y4);                                 --y4
mux:     mux8bit16   port map(sel=>sel, A=>y0, B=>y3, C=>y1, D=>y2, E=>y4, F=>y0, G=>y0, H=>y0, Y=>Y);
zflag:   zero_flag   port map(a=>Y,z=>zf);
inst1:   INVERTER    port map(a=>sel(0),y=>sel0_bar);
inst2:   INVERTER    port map(a=>sel(2),y=>sel2_bar);
cf1:      And_2       port map(a=>cout,b=>sel2_bar,y=>c1);
cf2:      And_2       port map(a=>c1,b=>sel0_bar,y=>cf);
C<=Y;
end architecture;