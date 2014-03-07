--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:19:47 03/07/2014
-- Design Name:   
-- Module Name:   C:/Users/C16Eric.Wardner/Documents/School/2014/ECE 281/Designs/CE3_Wardner/Moore_testbench_Wardner.vhd
-- Project Name:  CE3_Wardner
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MooreElevatorController_Shell
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;
  USE ieee.std_logic_unsigned.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Moore_testbench_Wardner IS
END Moore_testbench_Wardner;
 
ARCHITECTURE behavior OF Moore_testbench_Wardner IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MooreElevatorController_Shell
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         stop : IN  std_logic;
         up_down : IN  std_logic;
         floor : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal stop : std_logic := '0';
   signal up_down : std_logic := '0';
	
	SIGNAL floorNum : std_logic_vector(3 downto 0) := "0000";

 	--Outputs
   signal floor : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MooreElevatorController_Shell PORT MAP (
          clk => clk,
          reset => reset,
          stop => stop,
          up_down => up_down,
          floor => floor
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period;
		clk <= '1';
		wait for clk_period;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here
--			floorNum <= "0000";
			
			reset<='1';
			wait for clk_period*2;
			reset<='0';
			
			for i in 1 to 4 loop
				wait for clk_period*2;				
				assert(floor = floorNum ) report "Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
				stop <= '0';
				up_down <= '1';
				wait for clk_period*2;
				stop <= '1';
				floorNum <= floorNum + "0001";
			end loop;			
			
			stop <= '0';
			up_down <= '0';
			wait for clk_period*6;			
			assert(floor = "0000") report "Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
			

			
			
			
--			reset<='0';
--			assert(floor = "0000") report "Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
--			stop <= '0';
--			up_down <= '1';			
--			wait for clk_period*2;
--			stop <= '1';
--			wait for clk_period*2;
--			
--			assert(floor = "0001") report "Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
--			stop <= '0';			
--			wait for clk_period*2;
--			stop <= '1';
--			wait for clk_period*2;
--			
--			assert(floor = "0010") report "Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
--			stop <= '0';			
--			wait for clk_period*2;
--			stop <= '1';
--			wait for clk_period*2;
--			
--			assert(floor = "0011") report "Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
--			stop <= '0';
--			up_down <= '0';
--			wait for clk_period*6;
--			
--			assert(floor = "0000") report "Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
--			

      wait;
   end process;

END;
