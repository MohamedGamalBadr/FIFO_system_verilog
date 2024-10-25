import shared_pkg::*;
import FIFO_transaction_pkg::*;
module FIFO_tb(FIFO_if.TEST f_if);
logic clk, rst_n;
bit [f_if.FIFO_WIDTH-1:0] data_in;
bit wr_en, rd_en;
logic [f_if.FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

assign f_if.data_in = data_in;
assign clk = f_if.clk;
assign f_if.rst_n = rst_n;
assign f_if.wr_en = wr_en;
assign f_if.rd_en = rd_en;
assign data_out = f_if.data_out;
assign wr_ack = f_if.wr_ack;
assign overflow = f_if.overflow;
assign full = f_if.full;
assign empty = f_if.empty;
assign almostfull = f_if.almostfull;
assign almostempty = f_if.almostempty;
assign underflow = f_if.underflow;


FIFO_transaction obj_transaction = new;

initial begin
	assert_reset;

	repeat(1000) begin
		assert(obj_transaction.randomize());
		rd_en=obj_transaction.rd_en;
		wr_en=obj_transaction.wr_en;
		data_in=obj_transaction.data_in;
		rst_n = obj_transaction.rst_n;
		@(negedge clk) #0 ;

	end
  
   test_finished = 1;
end

task assert_reset;
	rst_n = 0;
    @(negedge clk) #0
	
	rst_n = 1;
endtask : assert_reset
endmodule