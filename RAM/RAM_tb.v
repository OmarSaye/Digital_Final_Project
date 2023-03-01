module project_RAM_tb();
    //signal declaration
    reg [9:0] din_tb;
    reg clk,rstn_tb,rx_valid_tb;
    wire [7:0] dout_dut;
    wire tx_valid_dut;
    reg [7:0] x,y; //x: random address, y: random data .. line 60
                   //instantiation
    RAM dut(din_tb,clk,rstn_tb,rx_valid_tb,dout_dut,tx_valid_dut);
    //clk generation
    initial begin
        clk = 0;
        forever
            #1 clk = ~clk;
    end
    //stimulus generation
    integer i;
    initial begin
        //reseting
        rstn_tb = 0;
        #10
        rstn_tb = 1;
        #20;
        //fill RAM with data = address
        @(negedge clk)
        rx_valid_tb = 1;
        for (i = 0; i<256; i = i+1) begin
            dut.MEM[i] = i;
            @(negedge clk);
            end	//for loop
            
            //read data check
            rx_valid_tb = 0;
            for (i = 0; i<512; i = i+1) begin
                if (i%2) begin //i odd.. read data
                    din_tb[9:8] = 2'b01;
                    din_tb[7:0] = $random; //it's dummy data
                end
                else begin//i even..read address
                    din_tb[9:8] = 2'b00;
                    din_tb[7:0] = i/2; //so that we go through adresses one by one
                end
                @(negedge clk);
                end	//for loop
                    //expected: dout_dut = 0, tx_valid_dut = 0 ; because rx_valid = 0
                
                rx_valid_tb = 1;
                for (i = 0; i<512; i = i+1) begin
                    if (i%2) begin //i odd.. read data
                        din_tb[9:8] = 2'b00;
                        din_tb[7:0] = $random; //it's dummy data
                    end
                    else begin //i even..read address
                        din_tb[9:8] = 2'b01;
                        din_tb[7:0] = i/2; //so that we go through adresses one by one
                    end
                    @(negedge clk);
                    end	//for loop
                        //expected: dout_dut = 0 to 255, tx_valid_dut = alternating between 0(addr) and 1(data) ; because rx_valid = 1
                    
                    //write data check
                    //generating a random addr to write random data in, then reading from the same addr each time
                    rx_valid_tb = 0;
                    for(i = 1; i<100; i = i+1) begin
                        if (i%4 == 1) begin   //1st.. random write addr
                            din_tb[9:8] = 2'b10;
                            x           = $random;
                            din_tb[7:0] = x; //random addr
                        end
                        else if (i%4 == 2) begin     //2nd..random data to write
                            din_tb[9:8] = 2'b11;
                            y           = $random;
                            din_tb[7:0] = y; //random data
                        end
                            else if (i%4 == 3) begin //3rd..read from the random addr generated..x
                            din_tb[9:8] = 2'b00;
                            din_tb[7:0] = x;
                            end
                        else begin //read the random data
                            din_tb[9:8] = 2'b01;
                            din_tb[7:0] = $random; //dummy data
                        end
                        @(negedge clk);
                    end //for loop
                        //expected: dout_dut = 0, tx_valid_dut = 0 ; because rx_valid = 0
                    rx_valid_tb = 1;
                    for(i = 1; i<100; i = i+1) begin
                        if (i%4 == 1) begin   //1st.. random write addr
                            din_tb[9:8] = 2'b10;
                            x           = $random;
                            din_tb[7:0] = x; //random addr
                        end
                        else if (i%4 == 2) begin     //2nd..random data to write
                            din_tb[9:8] = 2'b11;
                            y           = $random;
                            din_tb[7:0] = y; //random data
                        end
                            else if (i%4 == 3) begin //3rd..read from the random addr generated..x
                            din_tb[9:8] = 2'b00;
                            din_tb[7:0] = x;
                            end
                        else begin //read the random data
                            din_tb[9:8] = 2'b01;
                            din_tb[7:0] = $random; //dummy data
                                                   //expected: dout_dut = y , tx_valid = 1
                        end
                        @(negedge clk);
                    end //for loop
                    
                    @(negedge clk);
                    $stop;
                end //initial block
                
                endmodule
