library ieee;
use ieee.std_logic_1164.all;

entity part1_slave is 
   port(sclk: in std_logic;
		 mosi: in std_logic;
		 cs: in std_logic;
		 data_out: out std_logic_vector(2 downto 0):= (others =>'Z');
		 miso: out std_logic:= 'Z');
end entity;

architecture behavioral of part1_slave is
       signal counter1: integer:=0;
		 signal counter2: integer:=0;
		 signal data_to_send: std_logic_vector(2 downto 0):= "111"; 
	
begin 
		process(sclk)
		begin
		
		if falling_edge(sclk) then   ---write
		miso <= data_to_send(0);
		   if cs = '0' then 
			   counter1<=counter1+1; ----data_out_s should be 011 and data_out_m should be 001
				if counter1=0 then
				miso <= data_to_send(1);
				
				elsif counter1=1 then
				miso <= data_to_send(2);
				
				end if;
		   end if;
			
		elsif rising_edge(sclk) then         ---read
		   if cs = '0' then
			   counter2<=counter2+1;
				if counter2 = 0 then
				data_out(0) <= mosi;
				end if;
				
				if counter2=1 then
				data_out(1) <= mosi;
				
				elsif counter2=2 then
				data_out(2) <= mosi;
				
				end if;
			end if;
		end if;
			
	   end process;

end architecture;		
		

