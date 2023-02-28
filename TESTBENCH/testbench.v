module moduleName ();
reg MOSI_tb,SS_n_tb,rst_n_tb,clk_tb;
wire MISO_tb;
integer counter;
initial begin
    clk = 0;
    forever begin
        #T/2 clk = ~clk;
    end
end

    MEMORY_BLOCK_WRAPPER DUT ( MOSI_tb,MISO_tb,SS_n_tb,clk_tb,rst_n_tb);
endmodule