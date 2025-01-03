library ieee;
use ieee.std_logic_1164.all;

entity Testbench is
end entity Testbench;

architecture behavioral of Testbench is
	component Toplevel is
   port(clk : in std_logic;
       s_clk,cs,miso,mosi : out std_logic;
		 data_out_m,data_out_s: out std_logic_vector(2 downto 0):= (others =>'Z'));
end component;


      signal sclk: std_logic;
		signal clk: std_logic := '0';
		signal cs,miso,mosi: std_logic;
		signal data_out_m,data_out_s: std_logic_vector(2 downto 0);
		
      constant clock_period : time := 100 ns;
begin
    dut_instance: Toplevel port map(clk => clk, s_clk => sclk,cs => cs, miso => miso, mosi => mosi, data_out_m => data_out_m, data_out_s => data_out_s); 
    clk_process: process
    begin
        clk <= not clk after clock_period / 2;
        wait for clock_period / 2;
    end process clk_process;
 
end architecture;