library ieee;
use ieee.std_logic_1164.all;

entity Toplevel is
   port(
		clk: in std_logic;
		reset_master: in std_logic;
		reset_lcd: in std_logic;
		miso: in std_logic;
		lcd_rw: out std_logic;
		lcd_en: out std_logic;
		lcd_rs: out std_logic;
		lcd1: out std_logic_vector(7 downto 0);
		detect: out std_logic;
		mosi: out std_logic;
		sclk: out std_logic;
		mosi_dac : out std_logic :='Z';
		cs_dac : out std_logic :='1';
		sclk_dac : out std_logic :='0';
		cs: out std_logic;
		led_out: out std_logic_vector(9 downto 0)
	);
end entity;



architecture struct of Toplevel is 

component part3_master is
     port(clk: in std_logic;
	       reset: in std_logic;
			 miso: in std_logic;
			 mosi: out std_logic:= '1';
			 reg_a: out std_logic_vector(9 downto 0):= (others =>'Z');
			 sclk: out std_logic;
			 mosi_dac : out std_logic;
		    cs_dac : out std_logic;
		    sclk_dac : out std_logic;
			 cs: out std_logic);
end component;

component test is
	port( 
--	clk_slow		: in std_logic;
		  inp 			: in std_logic_vector(9 downto 0);
		  clk			: in  std_logic;
		  rst 			: in  std_logic;
		  lcd_rw 		: out std_logic;                         	--read & write control
     	  lcd_en 		: out std_logic;                         	--enable control
        lcd_rs 		: out std_logic;                         	--data or command control
         lcd1  		: out std_logic_vector(7 downto 0);			--see pin planning in krypton manual 
--		  b11 			: out std_logic;
--		  b12 			: out std_logic;
		  detect 		: out std_logic
		  );
end component;	   


signal clk1,cs_temp : std_logic;
signal temp_reg_a : std_logic_vector(9 downto 0);
begin

inst1: part3_master port map(clk=>clk,reset=>reset_master,miso=>miso,mosi=>mosi,reg_a=>temp_reg_a,sclk=>clk1,mosi_dac=>mosi_dac,sclk_dac=>sclk_dac,cs_dac=>cs_dac,cs=>cs_temp);
inst2: test port map(inp=>temp_reg_a,clk=>clk,rst=>reset_lcd,lcd_rw=>lcd_rw,lcd_en=>lcd_en,lcd_rs=>lcd_rs,lcd1=>lcd1,detect=>detect);

sclk <= clk1;
cs <= cs_temp;
led_out<= temp_reg_a;


end architecture; 