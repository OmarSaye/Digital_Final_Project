//
module project_SPI_slave #(parameter IDLE = 3'b000,
                           CHK_CMD = 3'b001,
                           READ_ADD = 3'b010,         //master sending an addr to read from RAM
                           READ_DATA = 3'b011,        //RAM sending the data in the sent address from READ_ADD
                           WRITE = 3'b100)
                          (input wire clk,
                           rst_n,
                           MOSI,
                           SS_n,
                           tx_valid,
                           input wire [7:0] tx_data,
                           output reg MISO,
                           rx_valid,
                           output reg [9:0] rx_data);
reg [2:0] cs,ns;

                       //serial to parallel and vice versa
reg [3:0] MOSI_count;  //to count received bits from master ..10 bits
reg MOSI_done;
reg [7:0] MISO_temp;  //to save parallel data recieved from RAM and send it serially to MISO
reg [2:0] MISO_count; //to count received bits from RAM ..8 bits
reg MISO_done;

//ADDRESS or DATA
reg addr_or_data;
//if 1: address..if 0: data, deafult (1..because address is sent first) with each reset , then it's inverted with each READ_ADD/DATA states
always @(rst_n or cs) begin
    if (!rst_n)begin
        addr_or_data = 1; //default
        MISO_done    = 1;
    end
    
    if (cs == READ_ADD || cs == READ_DATA)
        addr_or_data = ~addr_or_data;
        end
    
    
    //memory state logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cs <= IDLE;
        else
            cs <= ns;
    end
    
    
    //next state logic
    always @(cs,SS_n,MOSI,addr_or_data)
        case (cs)
            IDLE:
            if (!SS_n)
                ns = CHK_CMD;
            else
                ns = IDLE;
            
            CHK_CMD:
            if (SS_n)
                ns = IDLE;
            else begin
                if (!MOSI)
                    ns = WRITE;
                else begin
                    if (addr_or_data)
                        ns = READ_ADD;
                    else
                        ns = READ_DATA;
                end
            end
            
            READ_ADD:
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_ADD;
            
            WRITE:
            if (SS_n)
                ns = IDLE;
            else
                ns = WRITE;
            
            READ_DATA:
            if (SS_n)
                ns = IDLE;
            else
                ns = READ_DATA;
            
            default: ns = IDLE;
        endcase
    
    //OUTPUT LOGIC
    always @(posedge clk) begin
        //serial input from master via MOSI to parallel ouput to RAM via rx_data through a temp reg
        //no communication
        if (SS_n) begin
            MOSI_count <= 0;
            MOSI_done  <= 0;
           

        end
        //communication
        else begin
                                        //MOSI_count starts with 0 and is supposed to stop at 9
        rx_data[10-MOSI_count] <= MOSI; //MSB is recived 1st
        MOSI_count             <= MOSI_count+1;
        if (MOSI_count == 10) begin
            MOSI_done <= 1;
        end
        end
        //RAM sent read data
        if (tx_valid) begin
            MISO_temp <= tx_data;
            MISO_done <= 0;
            
            
        end
        
        //master done sending addr(read or write) OR data(write)
        if (MOSI_done) begin
            rx_valid <= 1;
        end
        else begin
            rx_valid <= 0;
        end
        //tx_data recieved from RAM at output "MISO" serially
        if (!MISO_done && MISO_count<8 && cs == READ_DATA && (MOSI_count>= 10||MOSI_done)) begin
            MISO       <= MISO_temp[7-MISO_count]; //output LSB 1st
            MISO_count <= MISO_count+1;
        end else if(SS_n) begin
            MISO_count <=0;
             MISO_done  <= 1;
        end
    
end
endmodule
