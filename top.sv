module top;
	bit clk;

	initial begin
		forever 
		#1 clk=~clk;
	end

FIFO_if f_if (clk);
FIFO_tb tb (f_if);
FIFO DUT (f_if);
FIFO_monitor monitor (f_if);
endmodule