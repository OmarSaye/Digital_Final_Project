vlog -work work {E:/youssef/engineering/courses/kareem wassem digital electronics diploma/final_project/Digital_Final_Project-main/Digital_Final_Project/RAM/RAM.v}
vlog -work work {E:/youssef/engineering/courses/kareem wassem digital electronics diploma/final_project/Digital_Final_Project-main/Digital_Final_Project/RAM/RAM_tb.v}
vsim -gui work.project_RAM_tb
add wave -unsigned * 
run -all 