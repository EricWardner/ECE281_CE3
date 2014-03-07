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
