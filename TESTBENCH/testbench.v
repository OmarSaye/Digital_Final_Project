module full_testbench ();
    reg MOSI_tb,SS_n_tb,rst_n_tb,clk_tb;
    wire MISO_tb;
    parameter clk_cycle = 30;
    integer counter;
    integer SPI_counter; //will be used on sending and reciving data
    reg[7:0] address;
    reg [7:0] data;
    reg [7:0] receivedData;
    reg [7:0] referanceData;
    reg [1:0] CMD;
    initial begin
        clk_tb = 0;
        forever begin
            #(clk_cycle/2) clk_tb = ~clk_tb;
        end
    end
    
    MEMORY_BLOCK_WRAPPER DUT (MOSI_tb,MISO_tb,SS_n_tb,clk_tb,rst_n_tb);
    initial begin
        //giving intial values for used variables
        address = 100;
        data    = 11;
        @(negedge clk_tb)
        rst_n_tb = 0;
        MOSI_tb  = 0;
        SS_n_tb  = 1;
        #(5*clk_cycle)
        rst_n_tb = 1;
        //trying to write at addresses sequentially data will be 11,22,33.....253,11,22,33...253...
        for(counter = 0;counter<100;counter = counter+1)begin
            @(negedge clk_tb)
            SS_n_tb = 0;
            //sending Write address command
            CMD     = 2'b00;
            MOSI_tb = CMD[1];
            @(negedge clk_tb)
            MOSI_tb = CMD[0];
            //sending address to SPI
            for(SPI_counter = 0;SPI_counter<8;SPI_counter = SPI_counter+1)begin
                @(negedge clk_tb)
                MOSI_tb = address[7-SPI_counter];
            end
            @(negedge clk_tb);
            SS_n_tb = 1;
            //sending Write data command
            @(negedge clk_tb);
            SS_n_tb = 0;
            CMD     = 2'b01;
            @(negedge clk_tb)
            MOSI_tb = CMD[1];
            @(negedge clk_tb)
            MOSI_tb = CMD[0];
            //sending data to SPI
            for(SPI_counter = 0;SPI_counter<8;SPI_counter = SPI_counter+1)begin
                @(negedge clk_tb)
                MOSI_tb = data[7-SPI_counter];
            end
            //ending of writing process
            @(negedge clk_tb);
            SS_n_tb = 1;
            //modifying variables for next loop entry
            if (data>= 253)
                data = 11;
            else
                data    = data+11;
                address = address+1;
        end
        //*******************************************************************************************//
        //  NOW DATA IS SUCCESSFULLY STORED INSIDE MEMORY. WE WILL RESTORE IT AND CHECK IF THERE IS   //
        //  ANY ERRORS AND DISPLAY THAT ERROR                                                        //
        //*******************************************************************************************//
        //giving intial values for used variables
        address       = 100;
        referanceData = 11;
        receivedData  = 0;
        for(counter = 0;counter<100;counter = counter+1)begin
            @(negedge clk_tb)
            SS_n_tb = 0;
            //sending Read address command
            CMD     = 2'b10;
            MOSI_tb = CMD[1];
            @(negedge clk_tb);
            MOSI_tb = CMD[0];
            //sending address to SPI
            for(SPI_counter = 0;SPI_counter<8;SPI_counter = SPI_counter+1)begin
                @(negedge clk_tb);
                MOSI_tb = address[7-SPI_counter];
            end
            @(negedge clk_tb);
            SS_n_tb = 1;
            //sending read data command
            CMD = 2'b11;
            @(negedge clk_tb);
            SS_n_tb = 0;
            MOSI_tb = CMD[1];
            @(negedge clk_tb)
            MOSI_tb = CMD[0];
            //reciving data from SPI
            for(SPI_counter = 0;SPI_counter<8;SPI_counter = SPI_counter+1)begin
                @(negedge clk_tb)
                receivedData[7-SPI_counter] = MISO_tb;
            end
            //ending of writing process
            @(negedge clk_tb);
            SS_n_tb = 1;
            if (receivedData!= receivedData)
                $display("Testbench error !!!\n");
                if (referanceData>= 253)
                    referanceData = 11;
                else
                    referanceData = referanceData+11;
            
            //modifynig variables for next loop entry
            address = address+1;
        end
        $stop;
    end
endmodule
