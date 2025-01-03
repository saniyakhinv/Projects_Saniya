library ieee;
use ieee.std_logic_1164.all;

entity Toplevel is
   port(clk : in std_logic;
       s_clk,cs,miso,mosi : out std_logic;
		 data_out_s,data_out_m: out std_logic_vector(2 downto 0));
end entity;



architecture struct of Toplevel is 

component part1_master is
    port(clk: in std_logic;
		 miso: in std_logic;
		 cs: out std_logic;
		 mosi: out std_logic;
		 data_out: out std_logic_vector(2 downto 0):= (others => 'Z');
		 sclk: out std_logic);
end component;

component part1_slave is
    port (sclk: in std_logic;
		 mosi: in std_logic;
		 cs: in std_logic;
		 data_out: out std_logic_vector(2 downto 0):= (others =>'0');
		 miso: out std_logic);
end component;	   


signal s1,s2,clk1,cs_temp : std_logic;
begin

inst1: part1_master port map(clk => clk, sclk => clk1, cs => cs_temp, miso => s1, mosi => s2, data_out => data_out_m);
inst2:  part1_slave port map(sclk => clk1, cs => cs_temp, mosi => s2, miso => s1, data_out => data_out_s);
s_clk <= clk1;
mosi <= s2;
miso <= s1;
cs <= cs_temp;

end architecture; 