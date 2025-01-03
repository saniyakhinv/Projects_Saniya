library ieee;
library work;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
	port(
		clock: in std_logic;
		test_reg_h_out : out std_logic_vector(15 downto 0);
		test_alu_c : out std_logic_vector(15 downto 0);
		test_pc_di : out std_logic_vector(15 downto 0);
		test_pc_do : out std_logic_vector(15 downto 0);
		test_ir_di : out std_logic_vector(15 downto 0);
		test_ir_do : out std_logic_vector(15 downto 0);
		test_t1_di : out std_logic_vector(15 downto 0);
		test_t1_do : out std_logic_vector(15 downto 0);
		test_t2_di : out std_logic_vector(15 downto 0);
		test_t2_do : out std_logic_vector(15 downto 0);
		test_rf_a1: out std_logic_vector(2 downto 0);
		test_rf_a2: out std_logic_vector(2 downto 0);
		test_rf_a3: out std_logic_vector(2 downto 0);
		test_rf_d1 : out std_logic_vector(15 downto 0);
		test_rf_d2 : out std_logic_vector(15 downto 0);
		test_rf_d3 : out std_logic_vector(15 downto 0);
		test_alu_a, test_alu_b: out std_logic_vector(15 downto 0);
		test_alu_zf: out std_logic;
		test_counter,test_state_num: out integer;
		test_rf_enables: out std_logic_vector(7 downto 0);
		test_enable: out std_logic_vector(4 downto 0)
	);
end entity;

architecture design of fsm is

	type state is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, err);
	signal present_state, next_state: state := s0;
	
	signal rf_en, ir_en, t1_en, t1_rst, t2_rst, t2_en, alu_cf, alu_zf, rf_rst, ir_rst, pc_en, pc_rst, fsm_rst, mem_write: std_logic := '0';
	
	signal main_clk : std_logic := '1';
	signal alu_a, alu_b, alu_c, rf_d1, rf_d2, rf_d3, ir_di, ir_do, se16_6_b, se16_9_b, shift1a, shift1b, shift8a, shift8b, t1_di, t1_do, t2_di, t2_do, mem_add, mem_in, mem_out: std_logic_vector(15 downto 0);
	signal pc_do: std_logic_vector(15 downto 0) := (others =>'0');
	signal pc_di: std_logic_vector(15 downto 0) := (others =>'0');
	signal alu_sel: std_logic_vector(2 downto 0);
	
	signal rf_a1, rf_a2, rf_a3: std_logic_vector(2 downto 0);
	
	signal se16_6_a: std_logic_vector(5 downto 0);
	signal se16_9_a: std_logic_vector(8 downto 0);
	
	-- memory
	signal rf_d3_1 : std_logic_vector(15 downto 0) := "0000000000011111";
	signal rf_d3_2 : std_logic_vector(15 downto 0) := "0000000001101010";
	
	signal counter: integer := -2;
	signal state_num: integer :=0;
--	signal counter_rise: inmte
	signal enable: std_logic_vector(4 downto 0) := "00000";
	signal rf_enables: std_logic_vector(7 downto 0);
	--	rf_en 4
	--	ir_en 3
	--	t1_en 2
	--	t2_en 1
	--	pc_en 0
	
	
		
begin
   test_pc_di<=pc_di;
	test_pc_do<=pc_do;
	test_ir_di<=ir_di;
	test_ir_do<=ir_do;
	test_t1_di <= t1_di;
	test_t1_do <= t1_do;
	test_t2_di <= t2_di;
	test_t2_do <= t2_do;
	test_rf_a1 <= rf_a1;
	test_rf_a2 <= rf_a2;
	test_rf_a3 <= rf_a3;
	test_rf_d1 <= rf_d1;
	test_rf_d2 <= rf_d2;
	test_rf_d3 <= rf_d3;
	test_enable <= enable;
	test_rf_enables <= rf_enables;
	test_counter <= counter;
	test_state_num <= state_num;
	test_alu_a <= alu_a;
	test_alu_b <= alu_b;
	main_clk <= clock;
	test_alu_c <= alu_c;
	test_alu_zf <= alu_zf;
	alu_inst: entity work.alu port map(alu_a, alu_b, alu_c, alu_sel, alu_zf, alu_cf);
	rf_inst: entity work.register_file port map (rf_a1, rf_a2, rf_a3, main_clk, enable(4), rf_rst, test_reg_h_out, rf_d1, rf_d2, rf_d3, rf_enables);
	ir_inst: entity work.register16bit port map (main_clk, ir_rst, enable(3), ir_di, ir_do);
	pc_inst: entity work.register16bit port map (main_clk, pc_rst, enable(0), pc_di, pc_do);
	se16_6_inst: entity work.sign_ext_six port map (se16_6_a, se16_6_b);
	se16_9_inst: entity work.sign_ext_nine port map (se16_9_a, se16_9_b);
	shift_one_inst: entity work.shift_one port map (shift1a, shift1b);
	shift_eight_inst: entity work.shift_eight port map(shift8a, shift8b);
	t1_inst: entity work.register16bit port map (main_clk, t1_rst, enable(2), t1_di, t1_do);
	t2_inst: entity work.register16bit port map (main_clk, t2_rst, enable(1), t2_di, t2_do);
	
	memory_inst: entity work.memory port map(mem_add, mem_in, mem_out, mem_write);
	
--	clock_transition_proc: process(main_clk)
--		begin
--			if falling_edge(main_clk) then -- state transition on falling edge
--				if (fsm_rst = '1') then
--					present_state <= s0;
--					counter <= 1; -- *
--				else
--					present_state <= next_state;
--					counter <= counter + 1; -- counter update on falling edge
--				end if;
--			end if;
--		end process;
		
	state_transition_proc: process(main_clk, counter)
		begin
		if falling_edge(main_clk) then -- state transition on falling edge
			if (fsm_rst = '1') then
				present_state <= s0;
--				counter <= 0; -- *
			else
				present_state <= next_state;
--				counter <= counter + 1; -- counter update on falling edge
			end if;
		elsif rising_edge(main_clk) then
			
			
			case present_state is
			   	when s0 =>
		         		state_num<=0;
					case counter is
						when -2 =>
							rf_a3 <= "000";
							enable <= "10001";
							rf_d3 <= rf_d3_1;
							counter <= counter + 1;
						when -1 =>
							rf_a3 <= "001";
							enable <= "10000";
							rf_d3 <= rf_d3_2;
							counter <= counter + 1;
						when 1 =>
							enable <= "00000";
							mem_add <= pc_do;
							report "PC_DO: " & integer'image(to_integer(unsigned(PC_do)));
							counter <= counter + 1;
						when 2 =>
							enable <= "01000";
							alu_sel <= "000";
							ir_di <= mem_out;
							alu_a <= pc_do;
							alu_b <= "0000000000000010";
							counter <= counter + 1;
						when 3 =>
							enable <= "00001"; 
							pc_di <= alu_c;
							counter <= counter + 1;
						when 4 =>
							enable <= "00000";
							counter <= 1;
							case ir_do(15 downto 12) is
								when "0000" | "0010" | "0011" | "0100" | "0101" | "0110" | "1100" | "1010" | "1011" =>
									next_state <= s1;
								when "0001" =>
									next_state <= s2;
								when "1001" =>
									next_state <= s3;
								when "1000" =>
									next_state <= s4;
								when "1101" | "1110" | "1111" => 
									next_state <= s5;
								when others =>
									next_state <= err;
							end case;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
						
--					pc_en <= '1';
--					ir_en <= '1';
--					alu_sel <= "000";
--					mem_add <= pc_do;
--					ir_di <= mem_out;
--					alu_a <= pc_do;
--					alu_b <= "0000000000000010";
--					pc_di <= alu_c;
					

					
				
				when s1 =>
		         		state_num<=1;
					case counter is
						when 1 =>
							enable <= "00000";
							rf_a1 <= ir_do(11 downto 9);
							rf_a2 <= ir_do(8 downto 6);
							counter <= counter + 1;
						when 2 =>
							enable <= "00110";
							t1_di <= rf_d1;
							t2_di <= rf_d2;
							counter <= counter + 1;
--						when 3 =>
--							enable <= "00000";
--							counter <= counter + 1;
						when 3 =>
							enable <= "00000";
							counter <= 1;
							case ir_do(15 downto 12) is
								when "1100" =>
									next_state <= s7;
								when "0000" | "0010" | "0011" | "0100" | "0101" | "0110" =>
									next_state <= s8;
									alu_sel <= ir_do(14 downto 12);
								when "0001" =>
									next_state <= s8;
									alu_sel <= "000";							
								when "1010" | "1011" =>
									next_state <= s6;
								when others =>
									next_state <= err;
							end case;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;	

					
				when s2 =>
				   state_num<=2;
--					t1_en <= '1';
--					t2_en <= '1';
--					rf_a1 <= ir_do(11 downto 9);
--					t1_di <= rf_d1;
--					
--					t2_di <= se16_6_b; -- big doubt
--					next_state <= s8; 
					case counter is
						when 1 =>
							enable <= "00000";
							rf_a1 <= ir_do(11 downto 9);
							counter <= counter + 1;
						when 2 =>
							enable <= "00100";
							t1_di <= rf_d1;
							se16_6_a <= ir_do(5 downto 0);
							counter <= counter + 1;
						when 3 =>
							enable <= "00010";
							t2_di <= se16_6_b;
							counter <= counter + 1;
						when 4 =>
							enable <= "00000";
							counter <= 1;
							next_state <= s8;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
					
				when s3 => 
				   state_num<=3;
--					rf_en <= '1';
--					rf_a3 <= ir_do(11 downto 9);
--					rf_d3 <= ir_do(8 downto 6);
--					next_state <= s0;
					
					case counter is
						when 1 =>
							enable <= "00000";
							se16_9_a <= ir_do(8 downto 0);
							counter <= counter + 1;
						when 2 =>
							enable <= "10000";
							rf_a3 <= ir_do(11 downto 9);
							rf_d3 <= se16_9_b;
							counter <= counter + 1;
--						when 3 =>
--							enable <= "00000";
--	                  counter <= counter + 1;						
						when 3 =>
							enable <= "00000";
							counter <= 1;
							next_state <= s0;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
					
				when s4 => 
				   state_num<=4;
--					rf_en <= '1';
--					rf_a3 <= ir_do(11 downto 9);
--					se16_9_a <= ir_do(8 downto 0);
--					shift1a <= se16_9_b;
--					shift1a <= shift1b;
--					shift1a <= shift1b;
--					shift1a <= shift1b;
--					shift1a <= shift1b;
--					shift1a <= shift1b;
--					shift1a <= shift1b;
--					shift1a <= shift1b;
--					rf_d3 <= shift1b;
--					next_state <= s0;

					case counter is
						when 1 =>
							enable <= "00000";
							se16_9_a <= ir_do(8 downto 0);
							counter <= counter + 1;
						when 2 =>
							enable <= "00000";	
							shift8a <= se16_9_b;
						   counter <= counter + 1;	
						when 3 =>
							enable <= "10000";	
							rf_d3 <= shift8b;
							rf_a3 <= ir_do(11 downto 9);
							counter <= counter + 1;
						when 4 =>
							enable <= "00000";
							counter <= 1;
							next_state <= s0;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
					
					
					
				when s5 => 
				   state_num<=5;
--					alu_sel <= "010";
--					t2_en <= '1';
--					alu_a <= pc_do;
--					alu_b <= "0000000000000010";
--					t2_di <= alu_c;
					case counter is
						when 1 =>
							alu_sel <= "010";
							enable <= "00000";
							alu_a <= pc_do;
							alu_b <= "0000000000000010";
                     counter <= counter + 1;							
--						when 2 =>
--							enable <= "00000";
--					      counter <= counter + 1;		
						when 2 =>
							enable <= "00010";
							t2_di <= alu_c;
							counter <= counter + 1;
						when 3 =>
							enable <= "00000";
							counter <= 1;
							case ir_do(15 downto 12) is
								when "1100" =>
									next_state <= s13;
								when "1101" | "1111" =>
									next_state <= s14;
								when "1110" =>
									next_state <= s16;
								when others =>
									next_state <= err;						
							end case;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
			
					
				when s6 =>
		      	state_num<=1;	
--					t2_en <= '1';
--					alu_sel <= "000";
--					alu_a <= t2_do;
--					se16_6_a <= ir_do(5 downto 0);
--					shift1a <= se16_6_b;
--					alu_b <= shift1b;
--					t2_di <= alu_c;

					case counter is
						when 1 =>
							se16_6_a <= ir_do(5 downto 0);
							enable <= "00000";
							counter <= counter + 1;
						when 2 =>
							enable <= "00000";
							shift1a <= se16_6_b;
							counter <= counter + 1;
							
						when 3 =>
							alu_a <= t2_do;
							alu_b <= shift1b;
							alu_sel <= "000";
							enable <= "00000";
							counter <= counter + 1;
						
						when 4 =>
							t2_di <= alu_c;
							enable <= "00010";
				   		counter <= counter + 1;	
							
						when 5 =>
							enable <= "00000";
							counter <= 1;
							case ir_do(15 downto 12) is
								when "1011" =>
									next_state <= s9;
								when "1010" =>
									next_state <= s10;
								when others =>
									next_state <= err;
							end case;
							
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
					
					
				when s7 =>
					state_num<=7;
--					alu_sel <= "010";
--					alu_a <= t1_do;
--					alu_b <= t2_do;
--					if (alu_zf = '1') then
--						next_state <= s5;
--					else
--						next_state <= s0;
--					end if;

				case counter is
						when 1 =>
							enable <= "00000";
							alu_sel <= "010";
							alu_a <= t1_do;
							alu_b <= t2_do;
							counter <= counter + 1;
--						when 2 =>
--							enable <= "00000";
--                     counter <= counter + 1;							
						when 2 =>
							enable <= "00000";	
							counter <= 1;
							if (alu_zf = '1') then
								next_state <= s5;
							else
								next_state <= s0;
							end if;
							
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
					
				when s8 =>
					state_num<=8;
--					alu_sel <= "000";
--					t1_en <= '1';
--					alu_a <= t1_do;
--					alu_b <= t2_do;
--					t1_di <= alu_c;

					case counter is
						when 1 =>
							enable <= "00000";
							alu_a <= t1_do;
							alu_b <= t2_do;	
	                  counter <= counter + 1;						
--						when 2 =>
--							enable <= "00000";	
--                     counter <= counter + 1;							
						when 2 =>
							t1_di <= alu_c;
							enable <= "00100";	
							counter <= 1;
							case ir_do(15 downto 12) is
								when "0000" | "0010" | "0011" | "0100" | "0101" | "0110" =>
									next_state <= s11;
								when "0001" =>
									next_state <= s12;
								when others =>
									next_state <= err;
							end case;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
					
					
				when s9 =>
					state_num<=9;
--					mem_write <= '1';
--					mem_add <= t2_do;
--					mem_in <= t1_do;
--					next_state <= s0;



					case counter is
						when 1 =>
							enable <= "00000";
							mem_write <= '1';	
							mem_add <= t2_do;
							mem_in <= t1_do;
							counter <= counter + 1;
						when 2 =>
							enable <= "00000";	
							counter <= 1;
							mem_write <= '0';
							next_state <= s0;	
	                  						
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
				
				when s10 =>
					state_num<=10;
--					t2_en <= '1';
--					mem_add <= t2_do;
--					t2_di <= mem_out;
--					next_state <= s14;
					
					case counter is
						when 1 =>
							enable <= "00000";
							mem_add <= t2_do;
							counter <= counter + 1;
						when 2 =>
							enable <= "00010";
							t2_di <= mem_out;
							counter <= counter + 1;
						when 3 =>
							counter <= 1;
							enable <= "00000";
							next_state <= s14;
							
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
					
				when s11 =>
					state_num<=11;
--					rf_en <= '1';
--					rf_d3 <= t1_do;
--					rf_a3 <= ir_do(5 downto 3);
--					next_state <= s0;
					case counter is
						when 1 =>
							enable <= "10000";
							rf_d3 <= t1_do;
							rf_a3 <= ir_do(5 downto 3);
							counter <= counter + 1;
--						when 2 =>
--							enable <= "00000";
--							counter <= counter + 1;
						when 2 =>
							counter <= 1;
							enable <= "00000";
							next_state <= s0;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
					
					
				when s12 =>
					state_num<=12;
--					rf_en <= '1';
--					rf_d3 <= t1_do;
--					rf_a3 <= ir_do(8 downto 6);
--					next_state <= s0;
					case counter is
						when 1 =>
							enable <= "10000";
							rf_d3 <= t1_do;
							rf_a3 <= ir_do(8 downto 6);
							counter <= counter + 1;
--						when 2 =>
--							enable <= "00000";							
--							counter <= counter + 1;
						when 2 =>
							counter <= 1;
							enable <= "00000";
							next_state <= s0;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
							
				when s13 =>
					state_num<=13;
--					alu_sel <= "000";
--					pc_en <= '1';
--					alu_a <= t2_do;
--					se16_6_a <= ir_do(5 downto 0);
--					shift1a <= se16_6_b;
--					alu_b <= shift1b;
--					pc_di <= alu_c;
--					next_state <= s0;
					case counter is
						when 1 =>
							se16_6_a <= ir_do(5 downto 0);
							enable <= "00000";
							counter <= counter + 1;
						when 2 =>
							enable <= "00000";
							shift1a <= se16_6_b;
							counter <= counter + 1;
						when 3 =>
							enable <= "00000";
							alu_sel <= "000";
							alu_b <= shift1b;
							alu_a <= t2_do;
							counter <= counter + 1;
--						when 4 =>
--							enable <= "00000";
--							counter <= counter + 1;
						when 4 =>
							enable <= "00001";
							pc_di <= alu_c;
							counter <= counter + 1;
						when 5 =>
							enable <= "00000";
							counter <= 1;
							next_state <= s0;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
					
				when s14 =>
				state_num<=14;
--					rf_en <= '1';
--					rf_d3 <= t2_do;
--					rf_a3 <= ir_do(11 downto 9);
--					
--					case ir_do(15 downto 12) is
--						when "1101" =>
--							next_state <= s16;
--						when "1111" =>
--							next_state <= s15;
--						when others =>
--							next_state <= err;
--							
--					end case;
					case counter is
						when 1 =>
							enable <= "10000";
							rf_a3 <= ir_do(11 downto 9);
							rf_d3 <= t2_do;
							counter <= counter + 1;
--						when 2 =>
--							enable <= "00000";
--							counter <= counter + 1;
						when 2 =>
							counter <= 1;
							enable <= "00000";
							case ir_do(15 downto 12) is
								when "1101" =>
									next_state <= s16;
								when "1111" =>
									next_state <= s15;
								when "1010" =>
									next_state <= s0;
								when others =>
									next_state <= err;
							end case;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
					
				when s15 =>
					state_num<=15;
--					pc_en <= '1';
--					rf_a1 <= ir_do(8 downto 6);
--					pc_di <= rf_d1;
--					next_state <= s0;
					case counter is
						when 1 =>
							enable <= "00000";
							rf_a1 <= ir_do(8 downto 6);
							counter <= counter + 1;
						when 2 =>
							enable <= "00001";
							pc_di <= rf_d1;
							counter <= counter + 1;
						when 3 =>
							counter <= 1;
							enable <= "00000";
							next_state <= s0;
							
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
				
				when s16 =>
					state_num<=16;
--					alu_sel <= "000";
--					pc_en <= '1';
--					alu_a <= t2_do;
--					se16_9_a <= ir_do(8 downto 0);
--					shift1a <= se16_9_b;
--					alu_b <= shift1b;
--					pc_di <= alu_c;
--					next_state <= s0;
					case counter is
						when 1 =>
							se16_9_a <= ir_do(8 downto 0);
							enable <= "00000";
							counter <= counter + 1;
						when 2 =>
							enable <= "00000";
							shift1a <= se16_9_b;
							counter <= counter + 1;
						when 3 =>
							enable <= "00000";
							alu_sel <= "000";
							alu_b <= shift1b;
							alu_a <= t2_do;
							counter <= counter + 1;
--						when 4 =>
--							enable <= "00000";
--							counter <= counter + 1;
						when 4 =>
							enable <= "00001";
							pc_di <= alu_c;
							counter <= counter + 1;
						when 5 =>
							enable <= "00000";
							counter <= 1;
							next_state <= s0;
						when others =>
							enable <= "00000";
							counter <= 1;
						end case;
				when err=>
				    next_state <= s0;
			end case;
		end if;
		end process;
				
end architecture;