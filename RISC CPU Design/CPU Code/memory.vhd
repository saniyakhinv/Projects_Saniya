library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use ieee.numeric_std.all;

entity memory is 
port ( Mem_Add,Mem_In: in std_logic_vector(15 downto 0);
              Mem_Out: out std_logic_vector(15 downto 0);
		      Mem_Write: in std_logic);
end entity;

architecture behav of memory is

type arr is array (0 to 255) of std_logic_vector(7 downto 0); --255=2^8-1
signal reg : arr := (0=>"10000100",1 =>"01001100", 2 => "10100100", 3 => "01001100",others=>"00000000");
shared variable add_int : INTEGER := 0;

begin

proc: process(Mem_Add,Mem_Write)
 begin
	 add_int:=to_integer(unsigned(Mem_Add));
	 Mem_Out(15 downto 8)<=reg(add_int);
	 Mem_Out(7 downto 0)<=reg(add_int + 1);
	 if (Mem_Write)='1' then
	    reg(add_int)<=Mem_In(15 downto 8);
		 reg(add_int + 1)<=Mem_In(7 downto 0);
	 end if;
 end process;

end architecture;

