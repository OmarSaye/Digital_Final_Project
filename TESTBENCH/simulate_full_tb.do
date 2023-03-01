vlog -work work {E:/youssef/engineering/courses/kareem wassem digital electronics diploma/final_project/Digital_Final_Project-main/Digital_Final_Project/TESTBENCH/testbench.v}
vlog -work work {E:/youssef/engineering/courses/kareem wassem digital electronics diploma/final_project/Digital_Final_Project-main/Digital_Final_Project/TESTBENCH/wrapper.v}
vlog -work work {E:/youssef/engineering/courses/kareem wassem digital electronics diploma/final_project/Digital_Final_Project-main/Digital_Final_Project/RAM/RAM.v}
vlog -work work {E:/youssef/engineering/courses/kareem wassem digital electronics diploma/final_project/Digital_Final_Project-main/Digital_Final_Project/SPI_SLAVE/SPI slave.v}
vsim -gui work.full_testbench
add wave -unsigned * 
run -all 