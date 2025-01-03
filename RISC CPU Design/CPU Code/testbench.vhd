library ieee;
library work;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end entity;

architecture design of testbench is
    signal input_clock: std_logic := '0';
--    signal output_signal: std_logic_vector(15 downto 0) := (others => '0');
	 signal fsm_alu_a, fsm_alu_b, fsm_alu_c, fsm_reg_h_out, fsm_pc_di, fsm_pc_do, fsm_ir_di, fsm_ir_do, fsm_t1_di, fsm_t1_do, fsm_t2_di, fsm_t2_do, fsm_rf_d1, fsm_rf_d2, fsm_rf_d3 : std_logic_vector(15 downto 0);
	 signal fsm_rf_a1, fsm_rf_a2, fsm_rf_a3: std_logic_vector(2 downto 0);
	 signal fsm_rf_enables: std_logic_vector(7 downto 0);
	 signal fsm_alu_zf: std_logic;
	 signal fsm_enable: std_logic_vector(4 downto 0);
	 signal fsm_counter,fsm_state_num: integer;
	 
begin
    fsm_test: entity work.fsm port map(
	 	input_clock,
		fsm_reg_h_out,
		fsm_alu_c,
		fsm_pc_di,
		fsm_pc_do,
		fsm_ir_di,
		fsm_ir_do,
		fsm_t1_di,
		fsm_t1_do,
		fsm_t2_di,
		fsm_t2_do,
		fsm_rf_a1,
		fsm_rf_a2,
		fsm_rf_a3,
		fsm_rf_d1,
		fsm_rf_d2,
		fsm_rf_d3,
		fsm_alu_a, 
		fsm_alu_b,
		fsm_alu_zf,
		fsm_counter,
		fsm_state_num,
		fsm_rf_enables,
		fsm_enable
	);
    
    clock_100Hz_process: process
        begin
            input_clock <= not input_clock;
            wait for 5ms;
        end process;



end architecture;