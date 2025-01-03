library ieee;
use ieee.std_logic_1164.all;

entity Testbench is
end entity Testbench;

architecture behavioral of Testbench is
	component part3_master is
   port(clk:  in  std_logic;
		  reset: in std_logic;
        miso: in  std_logic;
        cs:   out std_logic;
        mosi: out std_logic:='Z';
		  reg_a: out std_logic_vector(9 downto 0):= (others =>'Z');
        sclk: out std_logic);
end component;


      signal sclk: std_logic;
		signal reset: std_logic:='0';
		signal reg_a : std_logic_vector(9 downto 0);
		signal clk: std_logic := '0';
		signal cs,mosi: std_logic;
		signal miso: std_logic;
		
      constant clock_period : time := 20 ns;
begin
    dut_instance: part3_master port map(clk => clk, sclk => sclk,cs => cs, miso => miso, mosi => mosi,reg_a => reg_a, reset =>reset); 
    clk_process: process
    begin
        clk <= not clk after clock_period / 2;
        wait for clock_period / 2;
    end process clk_process;
	
	 reset_process: process
	 begin
--		reset <= '1' after 600 ns;
--	   wait for 600 ns ; -- Keep the process alive indefinitely
		reset <= '0' after 700 ns;
		wait;
	end process reset_process;
 
end architecture;