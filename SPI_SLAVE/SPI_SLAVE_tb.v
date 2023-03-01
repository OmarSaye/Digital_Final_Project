module SPI_SLAVE_tb ();
    reg MOSI_tb, SS_n_tb, clk_tb, rst_n_tb, tx_valid_tb;
    reg [7:0] tx_data_tb;
    wire MISO_tb, rx_valid_tb;
    wire [9:0] rx_data_tb;
    reg [9:0] temp_1, temp_2;
    //will be used as storage of what will be sent to SPI
    reg [7:0] i;
    integer counter;
    
    SPI_SLAVE DUT(.MOSI(MOSI_tb),.SS_n(SS_n_tb), .clk(clk_tb), .rst_n(rst_n_tb), .tx_valid(tx_valid_tb), .tx_data(tx_data_tb), .MISO(MISO_tb), .rx_valid(rx_valid_tb), .rx_data(rx_data_tb));
    
    initial begin
        clk_tb = 0;
        forever begin
            #10 clk_tb = ~clk_tb;
        end
    end
    
    initial begin
        //resetting SPI slave
        rst_n_tb    = 0;
        tx_valid_tb = 0;
        SS_n_tb     = 1;
        #5
        rst_n_tb = 1;
        //NEXT LOOP TRY TO ACT AS SPI MASTER SENDING DATA TO SLAVE
        for (i = 0;i<100 ;i = i+1) begin
            //wrapping the word to send to spi slave {CMD[1],CMD[0],address}
            temp_1 = {1'b0,1'b1,i};
            //sending data to MOSI (SERIAL)
            for (counter = 0; i<10; i = i+1) begin
                @(negedge clk_tb)
                SS_n_tb = 0;
                MOSI_tb = temp_1[9-counter];
            end
            //returning to IDILE state
            @(negedge clk_tb)
            SS_n_tb = 1;
        end
        //NEXT LOOP TRIES TO ACT AS RAM SENDING DATA TO SPI SLAVE
        for (i = 0; i<100; i = i+1) begin
            //wrapping the word to send to spi slave {CMD[1],CMD[0],address}
            temp_1 = {1'b1,1'b0,i};
            @(negedge clk_tb);
            SS_n_tb    = 0;
            tx_data_tb = temp_1;
            //tx_valid signal tell SPI that data is ready to be sent to the master
            tx_valid_tb = 1;
            //NEXT LOOP SENDING RECIEVED DATA FROM RAM TO SPI MASTER
            for (counter = 0; counter<10; counter = counter+1) begin
                @(negedge clk_tb);
                tx_valid_tb       = 0;
                temp_2[9-counter] = MISO_tb;
            end
            @(negedge clk_tb);
            SS_n_tb                 = 1;
            $display("tx_data(MISO) = %b  i = %b\n",temp_2,i);
        end
        
        $stop;
    end
    //  NEXT LOOP WAITS FOR DATA SENT BY SPI MASTER AND DISPLAYS IT
    initial begin
        forever begin
            //waiting for rx_valid to rais (SPI has collected complete byte)
            @(posedge rx_valid_tb);
            $display("rx_data = %b\n",rx_data_tb);
        end
    end
    
endmodule
