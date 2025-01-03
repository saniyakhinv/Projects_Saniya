library ieee;
use ieee.std_logic_1164.all;

entity part2_master is
   port(clk:  in  std_logic;
		  reset: in std_logic;
        miso: in  std_logic;
        cs:   out std_logic;
        mosi: out std_logic:='1';
		  reg_a: out std_logic_vector(9 downto 0):= (others =>'Z');
        sclk: out std_logic);   
end entity;

architecture behavioral of part2_master is
    signal counter1: integer:= 0;
    signal counter2: integer:= 0;
    signal data_to_send:  std_logic_vector(17 downto 0):= "100101101100000011";
    signal cs1: std_logic:= '1'; 
	 signal cntr_div : INTEGER := 0;
    signal temp_sclk : STD_LOGIC := '0';
    constant divider_value : INTEGER := 25; 
begin 
	 clk_divider: process(clk,reset)
    begin
        if reset = '1' then
            cntr_div <= 0;
            temp_sclk <= '0';
				
        elsif rising_edge(clk) then
            if cntr_div = divider_value - 1 then
                cntr_div <= 0;
                temp_sclk <= NOT temp_sclk; -- Toggle the output clock
            else
                cntr_div <= cntr_div + 1;
            end if;
        end if;
    end process;
	 
    clk_process: process(temp_sclk)
    begin
		  if reset = '1' then
		  cs1<='1';
		  mosi <= 'Z';
		  counter1<=0;
		  counter2<=0;
		  reg_a(0)<='Z';
		  reg_a(1)<='Z';
		  reg_a(2)<='Z';
		  reg_a(3)<='Z';
		  reg_a(4)<='Z';
		  reg_a(5)<='Z';
		  reg_a(6)<='Z';
		  reg_a(7)<='Z';
		  reg_a(8)<='Z';
		  reg_a(9)<='Z';
		  else
			if rising_edge(temp_sclk) then
            if cs1 = '0' then 
                counter1 <= counter1 + 1;
                case counter1 is
							when 7 =>
								reg_a(9) <= miso;
							when 8 =>
								 reg_a(8) <= miso;
							when 9 =>
								 reg_a(7) <= miso;
							when 10 =>
								 reg_a(6) <= miso;
							when 11 =>
								 reg_a(5) <= miso;
							when 12 =>
								 reg_a(4) <= miso;
							when 13 =>
								 reg_a(3) <= miso;
							when 14 =>
								 reg_a(2) <= miso;
							when 15 =>
								 reg_a(1) <= miso;
							when 16 =>
								 reg_a(0) <= miso;	 
                          
                    when others =>
                        null;
                end case;
            end if;

        elsif falling_edge(temp_sclk) then					
               counter2 <= counter2 + 1;
					if counter1 = 17 then
						cs1 <= '1';
					end if;
					if counter1 = 0 then
						cs1 <= '0';
					end if;
                case counter2 is
                    when 0 =>
                        mosi <= data_to_send(0);  
                    when 1 =>
                        mosi <= data_to_send(1);  
						  when 2 =>
								mosi <= data_to_send(2);
						  when 3 =>
                        mosi <= data_to_send(3);  
                    when 4 =>
                        mosi <= data_to_send(4);  
						  when 5 =>
								mosi <= data_to_send(5);
						  when 6 =>
                        mosi <= data_to_send(6);  
                    when 7 =>
                        mosi <= data_to_send(7);  
						  when 8 =>
								mosi <= data_to_send(8);
						  when 9 =>
                        mosi <= data_to_send(9);  
                    when 10 =>
                        mosi <= data_to_send(10);  
						  when 11 =>
								mosi <= data_to_send(11);
						  when 12 =>
                        mosi <= data_to_send(12);  
                    when 13 =>
                        mosi <= data_to_send(13);  
						  when 14 =>
								mosi <= data_to_send(14);
						  when 15 =>
                        mosi <= data_to_send(15);  
                    when 16 =>
                        mosi <= data_to_send(16);  
						  when 17 =>
								mosi <= data_to_send(17);
                    when others =>
                        null;
                end case;
        end if;
		 end if;
		
		
        
    end process;
    cs <= cs1;
    sclk <= temp_sclk;  

end architecture;



