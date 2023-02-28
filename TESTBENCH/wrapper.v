module MEMORY_BLOCK_WRAPPER (
    MOSI,MISO,SS_n,clk,rst_n
);
input MOSI,SS_n,clk,rst_n;
output MISO;
wire clk,rst_n,rx_valid,tx_valid;
wire [9:0] din;
wire [7:0] dout;
RAM ram_instance (din,clk,rst_n,rx_valid,dout,tx_valid);
SPI_SLAVE spi_slave_instance (.MOSI(MOSI),.MISO(MISO),.SS_n(SS_n),.clk(clk),.rst_n(rst_n),.rx_valid(rx_valid),.rx_data(din),.tx_valid(tx_valid),.tx_data(dout));

    
endmodule