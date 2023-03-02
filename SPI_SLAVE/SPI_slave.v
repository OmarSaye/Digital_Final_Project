module project_SPI_slave 
#(parameter
	IDLE=     3'b000,
	CHK_CMD=  3'b001,
	READ_ADD= 3'b010, //master sending an addr to read from RAM 
	READ_DATA=3'b011, //RAM sending the data in the sent address from READ_ADD
	WRITE=    3'b100  //master sending addr/data to write in RAM
) 
(
	input wire clk,rst_n,MOSI,SS_n,tx_valid,
	input wire [7:0] tx_data,
	output reg MISO, rx_valid,
	output reg [9:0] rx_data 
);
reg [2:0] cs,ns;

//serial to parallel and vice versa
reg [9:0] rx_temp;  //to save serial data recieved from MOSI and send it to RAM in parallel 
reg [3:0] rx_count; //to count received bits from master ..10 bits
reg rx_done;
reg [7:0] tx_temp;  //to save parallel data recieved from RAM and send it serially to MISO
reg [2:0] tx_count; //to count received bits from RAM ..8 bits
reg tx_done;

//ADDRESS or DATA 
reg addr_or_data; 
//starts with 1 at each reset because address is sent first, if 1: address, if 0: data
always @(negedge rst_n)
add_or_data=1;

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
ns=CHK_CMD;

CHK_CMD: 
if (SS_n)
ns=IDLE;
else begin
	if (!MOSI)
	ns=WRITE;
	else begin
		if(add_or_data) 
			ns=READ_ADD;	
		else 
		ns=READ_DATA;
	end
end

READ_ADD:
if (SS_n) 
ns=IDLE;
WRITE:
if (SS_n) 
ns=IDLE;
READ_DATA:
if (SS_n) 
ns=IDLE;
default: ns=IDLE;
endcase

//no "for" loop as this always block isnt combinational, instead, counters will be used.
always @(posedge clk or negedge SS_n) begin
 //serial input from master via MOSI to parallel ouput to RAM via rx_data through a temp reg
 if (cs==WRITE || cs==READ_ADD || cs==READ_DATA) begin
 	//no communication
 	if (SS_n) begin
 		rx_count<=0;
 		//rx_valid<=0;
 		rx_done<=0;	
 	end 
 	//SS_n=0..communication
 	else begin
 		//rx_count starts with 0 and is supposed to stop at 9
 		if (rx_count==10) begin
 			//rx_data<=rx_temp; 
		    //rx_valid<=1;
		    rx_done<=1;
		    if (cs!= WRITE) begin
		    	addr_or_data=~addr_or_data;
		    	//parallel data from RAM saved in a temp. reg 
		    	if(cs==READ_DATA && tx_valid) begin
		    		tx_temp<=tx_data;
		    		tx_count<=0;
		    		tx_done<=1;
		    	end
		    end
		      
 		end //"count==10" if
 		else begin
 			//why not just use rx_data
 			//rx_temp<={MOSI,rx_temp[7:1]};
 		    rx_temp[9-rx_count]<=MOSI; //MSB is recived 1st
 		    rx_count<=rx_count+1; 
 		end
 		
 	end //communication else
 end //cs if 	
end //always

//output logic 
always @ (posedge clk) begin
    //master done sending addr(read or write) OR data(write)
	if (rx_done) begin
		rx_data<=rx_temp;
		rx_valid<=1;
	end
	//RAM sent data(read)
	//not finished yet
	else if (tx_done) begin
		MISO<=tx_temp[tx_count]; //output LSB 1st
		tx_count<=tx_count+1;
	end
end