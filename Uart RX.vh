module uartRX (clk, nrst,rx,data, rcv);
	input clk, nrst,rx;
	output data, rcv;

	wire clk,nrst,rx;
	reg [7:0] data;
	reg [7:0] databuffer;
	reg rcv;

	reg [3:0] ctr = 0;
	reg [1:0] cstate = 0;

	parameter [1:0] idle = 2'b0;
	parameter [1:0] receiving = 2'b01;

	always@(posedge clk) begin
		if (!nrst) cstate <= idle;
		else begin
			case (cstate)
				idle: if (!rx) cstate <= receiving; else cstate <= idle;
				receiving: if (ctr == 4'b1000) cstate <= idle; else cstate <= receiving;
			endcase
		end
	end

	//ctr
	always@(posedge clk) begin
		if (!nrst) ctr <= 0;
		else begin
			case (cstate)
				idle: if (!rx) ctr = 1;
				receiving: if (ctr == 4'b1000) ctr = 0; else  ctr <= ctr + 1;
			endcase
		end
	end

	//databuffer
	always@ (posedge clk) begin
		if(!nrst) databuffer = 0;
		else begin
			case (cstate)
				receiving: if (ctr == 4'b1000) databuffer <= databuffer; else  databuffer <= {databuffer,rx};
				idle: databuffer <= databuffer;
			endcase
		end
	end


	//data
	always@(*) begin
		if (!nrst) data <= 0;
		else if (ctr == 4'b1000) data = databuffer; else data <= 0;
	end
endmodule
