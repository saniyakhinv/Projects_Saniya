library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity register_file is
port ( A1,A2,A3 : in std_logic_vector(2 downto 0);
    Clk,En,Reset: in std_logic;
	     test_out: out std_logic_vector(15 downto 0);
		    D1,D2 : out std_logic_vector(15 downto 0);
			    D3 : in std_logic_vector(15 downto 0);
				 reg_enables: out std_logic_vector(7 downto 0);
				 reg_inp0, reg_inp1, reg_outp1: out std_logic_vector(15 downto 0));
end entity;

architecture struct of register_file is

component demux8bit16 is
port ( I : in std_logic_vector(15 downto 0);
       A,B,C,D,E,F,G,H :out std_logic_vector(15 downto 0);
		  sel : in std_logic_vector(2 downto 0));
end component;

component demux8 is 
port( I : in std_logic;
      Y : out std_logic_vector(7 downto 0);
		sel : in std_logic_vector(2 downto 0));
end component;

component mux8bit16 is
port( A,B,C,D,E,F,G,H : in std_logic_vector(15 downto 0);
                  sel : in std_logic_vector(2 downto 0);
						  Y : out std_logic_vector(15 downto 0));
end component;


component register16bit is
 port(Clk, Reset, En : in std_logic;
 data_in: in std_logic_vector(15 downto 0);
 data_out: out std_logic_vector(15 downto 0));
end component;

signal En1 : std_logic_vector(7 downto 0) := "00000000";

--signal clock_0, clock_1: std_logic := '1';

type arr is array (0 to 7) of std_logic_vector(15 downto 0);
signal inp : arr;
signal outp : arr;

begin
reg_enables <= En1;
reg_inp0 <= inp(0);
reg_inp1 <= inp(1);
reg_outp1 <= outp(1);
--reg_0_clock <= clock_0;
--reg_1_clock <= clock_1;

--mux_inst0: entity work.mux2 port map (Clk, '1', En1(0), clock_0);
--mux_inst1: entity work.mux2 port map (Clk, '1', En1(1), clock_1);

registers: for k in 0 to 7 generate
reg:  register16bit port map(Clk=>Clk, En=>En1(k), data_in=>inp(k), data_out=>outp(k), Reset=>Reset); 
end generate;

en_demux    : demux8      port map(I=>En, sel=>A3, Y=>En1); -- only turn on enable of the one to write in 
write_demux : demux8bit16 port map(I=>D3, sel=>A3, A=>inp(7), B=>inp(6), C=>inp(5), D=>inp(4), E=>inp(3), F=>inp(2), G=>inp(1), H=>inp(0));
read_mux1   : mux8bit16   port map(Y=>D1, sel=>A1, A=>outp(7), B=>outp(6), C=>outp(5), D=>outp(4), E=>outp(3), F=>outp(2), G=>outp(1), H=>outp(0));
read_mux2   : mux8bit16   port map(Y=>D2, sel=>A2, A=>outp(7), B=>outp(6), C=>outp(5), D=>outp(4), E=>outp(3), F=>outp(2), G=>outp(1), H=>outp(0));
test_out<=outp(2);
--data_in_tb_out <= data_in_tb(0); 
end architecture;