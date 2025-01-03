library ieee;
use ieee.std_logic_1164.all;

entity part1_master is
   port(clk:  in  std_logic;
        miso: in  std_logic;
        cs:   out std_logic;
        mosi: out std_logic:='Z';
		  data_out: out std_logic_vector(2 downto 0):= (others =>'Z');
        sclk: out std_logic);   
end entity;

architecture behavioral of part1_master is
    signal counter1: integer:= 0;
    signal counter2: integer:= 0;
    signal data_to_send:  std_logic_vector(2 downto 0):= "101";
    signal cs1: std_logic:= '1';  
    signal mosi_reg: std_logic:= 'Z';  

begin
    process(clk)
    begin
        if rising_edge(clk) then
            if cs1 = '0' then 
                counter1 <= counter1 + 1;
                case counter1 is
                    when 0 =>
                        data_out(0) <= miso;
                    when 1 =>
                        data_out(1) <= miso;
                    when 2 =>
                        data_out(2) <= miso;
                          
                    when others =>
                        null;
                end case;
            end if;

        elsif falling_edge(clk) then
					
                counter2 <= counter2 + 1;
					 if counter1 = 3 then
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
                    when others =>
                        null;
                end case;
        end if;
    end process;
    cs <= cs1;
    sclk <= clk;  

end architecture;



