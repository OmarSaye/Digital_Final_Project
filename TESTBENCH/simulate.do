vlib work
vlog *.v
vsim -gui work.full_testbench
add wave -unsigned *
add wave -position insertpoint  -unsigned\
sim:/full_testbench/DUT/ram_instance/MEM
add wave -position insertpoint  \
sim:/full_testbench/DUT/spi_slave_instance/addr_or_data
add wave -position insertpoint  -unsigned\
sim:/full_testbench/DUT/ram_instance/dout \
sim:/full_testbench/DUT/ram_instance/tx_valid
add wave -position insertpoint  \
sim:/full_testbench/DUT/spi_slave_instance/MISO_count \
sim:/full_testbench/DUT/spi_slave_instance/MISO_done \
sim:/full_testbench/DUT/spi_slave_instance/MISO_temp \
sim:/full_testbench/DUT/spi_slave_instance/rx_data \
sim:/full_testbench/DUT/spi_slave_instance/tx_data

run -all