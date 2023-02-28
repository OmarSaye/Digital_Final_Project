module moduleName ();
reg MOSI_tb,SS_n_tb,rst_n_tb,clk_tb;
wire MISO_tb;
integer counter;
initial begin
    clk_tb = 0;
    forever begin
        #15 clk_tb = ~clk_tb;
    end
end

    MEMORY_BLOCK_WRAPPER DUT ( MOSI_tb,MISO_tb,SS_n_tb,clk_tb,rst_n_tb);
initial begin
    rst_n_tb=0;
    MOSI_tb=0;
    SS_n_tb=0;
    
end


endmodule