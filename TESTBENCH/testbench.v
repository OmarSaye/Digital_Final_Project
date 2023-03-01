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
        $display("          ****RESET DONE**** \n \n \n");
        $display("STARTING LOOP1 ... \n loop one will write 11,22,33....253,11,22,33...253...  in addresses 100,101,102...199 respectively \n \n");
        //trying to write at addresses sequentially data will be 11,22,33.....253,11,22,33...253...
        for(counter = 0;counter<100;counter = counter+1)begin
            $dispaly("_________________________________________");
            $display("\n itteration number %d \n",counter);
            @(negedge clk_tb)
            SS_n_tb = 0;
            //sending Write address command
            CMD     = 2'b00;
            $dispaly("MOSI CMD = %b     enter write address cmd\n",CMD);
            MOSI_tb = CMD[1];
            @(negedge clk_tb)
            MOSI_tb = CMD[0];
            //sending address to SPI
            $display("Address TO MOSI= %d   |   %b \n",address,address);
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
            $dispaly("MOSI CMD = %b     write data cmd\n",CMD);
            MOSI_tb = CMD[1];
            @(negedge clk_tb)
            MOSI_tb = CMD[0];
            //sending data to SPI
            $display("Data TO MOSI= %d   |   %b \n",data,data);
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
        display("           ***END OF LOOP1*** \n \n \n ");
        //*******************************************************************************************//
        //  NOW DATA IS SUCCESSFULLY STORED INSIDE MEMORY. WE WILL RESTORE IT AND CHECK IF THERE IS   //
        //  ANY ERRORS AND DISPLAY THAT ERROR                                                        //
        //*******************************************************************************************//
        //giving intial values for used variables
        address       = 100;
        referanceData = 11;
        receivedData  = 0;
        $display("STARTING LOOP2 ... \n this loop will try to read from memory at addresses 100,101,102...199 ,\ncompare collected data from memory with refrance data and catch mismatches\n \n");
        for(counter = 0;counter<100;counter = counter+1)begin
            $dispaly("_________________________________________");
            $display("\n itteration number %d \n",counter);
            @(negedge clk_tb)
            SS_n_tb = 0;
            //sending Read address command
            CMD     = 2'b10;
            $dispaly("MOSI CMD = %b     enter read address cmd\n",CMD);
            MOSI_tb = CMD[1];
            @(negedge clk_tb);
            MOSI_tb = CMD[0];
            //sending address to SPI
            $display("Address TO MOSI= %d   |   %b \n",address,address);
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
            $display("collected data from memory= %d    |   %b       VS     referance data = %d  |   %b\n",receivedData,receivedData,referanceData,referanceData);
            //ending of reading process
            @(negedge clk_tb);
            SS_n_tb = 1;
            if (receivedData!= receivedData)
                $display("^^^^^^^^^^^^^^^^^^^^^^^^^^^^!!CATCHEDMISS MATCH!!^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n");
                if (referanceData>= 253)
                    referanceData = 11;
                else
                    referanceData = referanceData+11;
            
            //modifynig variables for next loop entry
            address = address+1;
        end
        dispaly("__________________________________\n__________________________________\n                          STOP\n")
        $stop;
    end
endmodule
