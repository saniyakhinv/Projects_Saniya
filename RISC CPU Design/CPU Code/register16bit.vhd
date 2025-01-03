library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.Gates.all;

entity register16bit is
 port(Clk, Reset, En : in std_logic;
 data_in: in std_logic_vector(15 downto 0);
 data_out: out std_logic_vector(15 downto 0));
 end entity;
 
 architecture struct of register16bit is
 
 component dff_reset is port(D,clock,reset:in std_logic:='0'; Q:out std_logic:='0');
end component dff_reset;

component mux2bit16 is
port ( Y   : out std_logic_vector(15 downto 0);
       A,B : in std_logic_vector(15 downto 0);
		  sel : in std_logic);
end component;

signal clock : std_logic := '1';
signal data_in_ff,data_out_ff: std_logic_vector(15 downto 0):="0000000000000000";
--signal revised_enable: std_logic := '1';

begin

--mux_inst: entity work.mux2 port map (Clk, '1', En, clock);
mux: 	mux2bit16 port map(Y=>data_in_ff, B=>data_out_ff,A=>data_in,sel=>En);

--inst: AND_2 port map(a=>Clk,b=> revised_enable,Y=>clock);
reg_b : for i in 0 to 15 generate
reg_dff : dff_reset port map(D=>data_in_ff(i), clock=>Clk, reset=>Reset, Q=>data_out_ff(i)); -- at falling edge of clock
end generate;
data_out <= data_out_ff;
--data_in_tb <= data_in_ff;
end architecture; 