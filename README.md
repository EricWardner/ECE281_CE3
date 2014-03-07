ECE281_CE3
==========
##Elevator Controller
VHDL code and testbench that simulates an elevator controller which traverses 4 floors
####Moore Machine
Implementaion of elevator controller as a Moore Machine
######Code Design
Began with the given shell, goal was to edit the process that defined the floor state.

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
#####Testbench
The testbench implemented a for loop to traverse through all 4 levels of the elevator, to change levels up, up_down was kept at 1 and stop was changed with the clock.

```VHDL
for i in 1 to 4 loop
	wait for clk_period*2;				
	assert(floor = floorNum ) report "Current Floor is"&integer'image(to_integer(unsigned((floor)))) severity note;
	stop <= '0';
	up_down <= '1';
	wait for clk_period*2;
	stop <= '1';
	floorNum <= floorNum + "0001";
end loop;
```
