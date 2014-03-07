ECE281_CE3
==========
##Elevator Controller
VHDL code and testbench that simulates an elevator controller which traverses 4 floors
####Moore Machine
Implementaion of elevator controller as a Moore Machine, the output only depends on the state in a Moore Machine.
######Code Design
Began with the given shell, goal was to edit the process that defined the floor state. There was an inefficent piece of code found in the given shell.
```VHDL
clk'event and clk='1'
```
was changed to
```VHDL
RISING_EDGE(CLK)
```

The if statements were then filled in.

```VHDL
				when floor3 =>
					if (up_down='0' and stop='0') then 
						floor_state <= floor2;
					elsif (up_down='1' and stop='0') then 
						floor_state <= floor4;	
					else
						floor_state <= floor3;	
					end if;
				when floor4 =>
					if (up_down='0' and stop='0') then 
						floor_state <= floor3;	
					else 
						floor_state <= floor4;
					end if;
```
Also had to define the output logic, in a Moore Machine, the output logic only depends on the state.
```VHDL
floor <= "0001" when (floor_state = floor1) else
			"0010" when (floor_state = floor2) else
			"0011" when (floor_state = floor3) else
			"0100" when (floor_state = floor4) else
			"0001";
```
#####Testbench
The testbench implemented a for loop to traverse through all 4 levels of the elevator, to change levels up, up_down was kept at 1 and stop was changed with the clock.

```VHDL
for i in 1 to 4 loop
	wait for clk_period*2;				
	assert(floor = floorNum ) report "FAIL! Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
	assert(floor = floorNum-1 ) report "SUCESS! Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
	stop <= '0';
	up_down <= '1';
	wait for clk_period*2;
	stop <= '1';
	floorNum <= floorNum + "0001";
end loop;
```
![alt tag](https://raw.github.com/EricWardner/ECE281_CE3/master/Moore_Capture.PNG)
The testbench results show that the elevator starts at level 1 (0001) and rises a level and waits at that level for 2 clock periods everytime the stop becomes 0. When the elevator reaches level 4 (0100), it descends back to 1. The self-checker explicitly shows the change in levels. 

####Mealy Machine
Implementaion of elevator controller as a Mealy Machine
######Code Design
The only difference in the Mealy Machine is the output logic. To implement this in VHDL some rearranging had to be done.
```VHDL
floor <= "0001" when (floor_state = floor1) else
			"0010" when (floor_state = floor2) else
			"0011" when (floor_state = floor3) else
			"0100" when (floor_state = floor4) else
			"0001";
nextfloor <= 	"0001" when (floor_state = floor1) and (stop = '1') else
					"0010" when (floor_state = floor2) and (stop = '1') else
					"0011" when (floor_state = floor3) and (stop = '1') else
					"0100" when (floor_state = floor4) and (stop = '1') else
					"0010" when (floor_state = floor1) and (up_down = '1') and (stop = '0') else
					"0011" when (floor_state = floor2) and (up_down = '1') and (stop = '0') else
					"0100" when (floor_state = floor3) and (up_down = '1') and (stop = '0') else
					"0100" when (floor_state = floor4) and (up_down = '1') and (stop = '0') else
					"0001" when (floor_state = floor1) and (up_down = '0') and (stop = '0') else
					"0001" when (floor_state = floor2) and (up_down = '0') and (stop = '0') else
					"0010" when (floor_state = floor3) and (up_down = '0') and (stop = '0') else
					"0011" when (floor_state = floor4) and (up_down = '0') else
					"0001";  --phantom state
```
#####Testbench
The testbench for the Mealy machine is the same as the Moore with slightly different self-checker.
```VHDL
for i in 1 to 4 loop
				wait for clk_period*2;				
				assert(floor = floorNum ) report "FAIL! Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
				assert(floor = floorNum-1 ) report "SUCCESS! Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
				stop <= '0';
				up_down <= '1';
				wait for clk_period;
				if (floorNum < "0100") then
				assert(nextfloor = floorNum+1) report "FAIL! Next Floor is"&integer'image(to_integer(unsigned((nextfloor)))) severity note;
				end if;
				assert(nextfloor = floorNum) report "SUCCESS! Next Floor is"&integer'image(to_integer(unsigned((nextfloor)))) severity note;
				wait for clk_period;
				
				stop <= '1';
				floorNum <= floorNum + "0001";
			end loop;			
			
			stop <= '0';
			up_down <= '0';
			wait for clk_period*6;			
			assert(floor = "0000") report "SUCCESS! Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
```
![alt tag](https://raw.github.com/EricWardner/ECE281_CE3/master/Mealy_Capture.PNG)
The testbench results show that the elevator starts at level 1 (0001) and rises a level and waits at that level for 2 clock periods everytime the stop becomes 0. When the elevator reaches level 4 (0100), it descends back to 1. The self-checker explicitly shows the change in levels. The next level is also shown corectly by the self checker.  

###Debugging
I forgot that binary numbers need to have quotes around them to be interpreted properly.
It took a little while to find the right place between clock changes to put my assert statements.
###Questions
**Moore: is reset synchronous or --asynchronous?** <br />
       &nbsp;&nbsp;&nbsp;&nbsp; -synchronus, changes with the clock. <br />
**Mealy: is reset synchronous or --asynchronous?** <br />
       &nbsp;&nbsp;&nbsp;&nbsp; -synchronus, dependent on clock as well. <br />
**What is the clock frequency?**  <br />
        &nbsp;&nbsp;&nbsp;&nbsp;-1/10ns 100MHz, freq = 1/period <br />
**What value would we set to simulate a 50MHz clock?** <br />
       &nbsp;&nbsp;&nbsp;&nbsp;-1/t = 50,000,000, 20ns <br />
**If up_down is set to "go up" and stop is set to "don't stop" which floor do we want to go to?** <br />
       &nbsp;&nbsp;&nbsp;&nbsp;The next floor up, untill the max floor is reached in which case the floor doesn't change. <br />
####Documentation
C3C Tyler Spence helped be realize that a Mealy machine is dependant on both the state and the input.
