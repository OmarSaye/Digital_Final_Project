module RAM (din,
            clk,
            rst_n,
            rx_valid,
            dout,
            tx_valid);
    input [9:0] din;
    output reg [7:0] dout;
    input clk,rst_n,rx_valid;
    output reg tx_valid;
    parameter MEM_DEPTH     = 256;
    parameter ADDR_SIZE     = 8;
    parameter READ_ADDRESS  = 2'b00 ;
    parameter READ_DATA     = 2'b01;
    parameter WRITE_ADDRESS = 2'b10;
    parameter WRITE_DATA    = 2'b11;
    
    reg [7:0] MEM [MEM_DEPTH-1:0];
    
    wire [1:0] R_W;
    assign R_W = din[9:8];
    reg [7:0] currentAddress;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dout     <= 0;
            tx_valid <= 0;
        end
        else begin
            case (R_W)
                READ_ADDRESS:begin
                    if (rx_valid) begin
                        currentAddress <= din[7:0];
                    end
                end
                WRITE_ADDRESS:begin
                    if (rx_valid) begin
                        currentAddress <= din[7:0];
                    end
                    tx_valid <= 0;
                end
                WRITE_DATA:begin
                    if (rx_valid) begin
                        MEM[currentAddress] <= din[7:0];
                    end
                    tx_valid = 0;
                end
                READ_DATA:begin
                    dout     <= MEM[currentAddress];
                    tx_valid <= 1;
                end
                default:
            endcase
        end
    end
    
    
endmodule
