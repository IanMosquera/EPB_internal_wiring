`timescale 1ns/10ps

module tb_uartTx();

reg [7:0]data_in = 0;
reg clk;
reg nrst, start;

wire tx,ready;

reg rx;
wire [7:0] accuData;
wire rcv;

uartTX utx(data_in,clk,nrst, start, tx,ready);
uartRX urx(clk, nrst, rx, accuData, rcv);

always begin
rx = tx;
#2 clk = ~ clk;
end 

initial begin
	rx = tx;
	clk <= 0;
	nrst <=0;

	#10
	start <= 0;
	nrst <=1;
	data_in <= 8'b01001011;


	#10
	start <= 1;

	#40
	start <= 0;

	#10
	data_in <= 8'b01001000;
	start <= 1;

	#40
	start <= 0;

	#40
	$finish;
end

endmodule
