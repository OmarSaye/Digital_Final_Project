module project_SPI_slave 
#(parameter
	IDLE=     3'b000,
	CHK_CMD=  3'b001,
	READ_ADD= 3'b010, //master sending an addr to read from RAM 
	READ_DATA=3'b011, //RAM sending the data in the sent address from READ_ADD
	WRITE=    3'b100 ) //master sending addr/data to write in RAM
(input wire clk,rst_n,MOSI,SS_n,tx_valid,
	input [7:0] tx_data,
	output reg MISO, rx_valid,
	output reg [9:0] rx_data );
reg [2:0] cs,ns;
reg add_or_data=1; //starts with 1 because address is sent first, if 1: address, if 0: data
integer i;
//memory state logic 
always @(posedge clk or negedge rst_n) 
if (!rst_n)
cs<= IDLE;
else 
cs<=ns;
//next state logic 
always @(cs,SS_n,MOSI,add_or_data) 
case (cs)
IDLE: 
if (!SS_n) 
ns<=CHK_CMD;

CHK_CMD: 
if (SS_n)
ns<=IDLE;
else begin
	if (!MOSI)
	ns<=WRITE;
	else begin
		if(add_or_data) 
			ns<=READ_ADD;	
		else 
		ns<=READ_DATA;
	end
end

READ_ADD:
if (SS_n) 
ns<=IDLE;
WRITE:
if (SS_n) 
ns<=IDLE;
READ_DATA:
if (SS_n) 
ns<=IDLE;
default: ns<=IDLE;
endcase

/* //next state logic another version
always @(cs,SS_n,MOSI,add_or_data)
case (cs)
IDLE: 
if (!SS_n) 
ns<=CHK_CMD;

CHK_CMD: 

if(!SS_n) 
	if (!MOSI)
	ns<=WRITE;
	else begin
		if(add_or_data) 
		ns<=READ_ADD;
		else 
		ns<=READ_DATA;
	end
else 
ns<=IDLE;


default:
if (SS_n) 
 ns<=IDLE;
 endcase
*/

//output logic
always @(SS_n or tx_valid) begin
rx_valid=0;
if(cs==WRITE || cs==READ_ADD || cs==READ_DATA) begin//either way(write or read), MISO bits are sent through rx_data 
   for (i=0; i<10; i=i+1) begin 
	@(posedge clk);
	rx_data[i]= MOSI;
   end	// for loop
   rx_valid=1;

   if (cs!= WRITE) begin 
   	add_or_data=~add_or_data; //you either recive an address or data alternatively
    if (cs== READ_DATA && tx_valid)  
    	for (i=0; i<8; i=i+1) begin 
	      @(posedge clk);
	      MISO=tx_data[i];
        end	//for loop
   end //internal if
   end//outer if
   end//always block 
     
endmodule


