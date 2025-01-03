library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb is
end tb;

architecture behavior of tb is
    -- Signal Declarations
    signal clk : std_logic := '0';
	 signal rst : std_logic;
    signal inp : std_logic_vector(9 downto 0);
    signal lcd_rw, lcd_en, lcd_rs, detect : std_logic;
    signal lcd1 : std_logic_vector(7 downto 0);

    -- Component Declaration for the Unit Under Test (UUT)
    component test
        port(
            inp: in std_logic_vector(9 downto 0);
            clk: in std_logic;
            rst: in std_logic;
            lcd_rw: out std_logic;
            lcd_en: out std_logic;
            lcd_rs: out std_logic;
            lcd1: out std_logic_vector(7 downto 0);
--            b11: out std_logic;
--            b12: out std_logic;
            detect: out std_logic
        );
    end component;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: test
        port map (
            inp => inp,
            clk => clk,
            rst => rst,
            lcd_rw => lcd_rw,
            lcd_en => lcd_en,
            lcd_rs => lcd_rs,
            lcd1 => lcd1,
--            b11 => b11,
--            b12 => b12,
            detect => detect
        );

    -- Clock process definitions
    clk_process: process
    begin
        while True loop
		  wait for 10 ns;  -- Toggle clock every 10ns
            clk <= not clk;
            
        end loop;
    end process clk_process;


    -- Stimulus process
    stim_proc: process
    begin
        inp <= "0010110011";  -- Input pattern (10-bit binary)
        rst <= '0';
        wait for 5 ns;
        rst <= '1';  -- Apply reset
        wait for 10 ns;
        rst <= '0';  -- Deassert reset
        -- Continue simulation as needed
        wait;
    end process stim_proc;

end behavior;