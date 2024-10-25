import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
import shared_pkg::*;

module FIFO_monitor(FIFO_if.MONITOR f_if);

logic [f_if.FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [f_if.FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

assign data_in=f_if.data_in;
assign clk = f_if.clk;
assign rst_n=f_if.rst_n;
assign wr_en = f_if.wr_en;
assign rd_en = f_if.rd_en;
assign data_out = f_if.data_out;
assign wr_ack = f_if.wr_ack;
assign overflow = f_if.overflow;
assign full = f_if.full;
assign empty = f_if.empty;
assign almostfull = f_if.almostfull;
assign almostempty = f_if.almostempty;
assign underflow = f_if.underflow;

FIFO_transaction obj_transaction = new();
FIFO_coverage obj_coverage = new;
FIFO_scoreboard obj_scoreboard = new;

initial begin
	    
	forever begin
		@(negedge clk);
		obj_transaction.wr_en = wr_en;
		obj_transaction.rd_en = rd_en;
		obj_transaction.rst_n = rst_n;
		obj_transaction.data_in = data_in;
		obj_transaction.data_out = data_out;
		obj_transaction.wr_ack = wr_ack;
		obj_transaction.overflow = overflow;
		obj_transaction.full = full;
		obj_transaction.empty = empty;
		obj_transaction.almostfull = almostfull;
		obj_transaction.almostempty = almostempty;
		obj_transaction.underflow = underflow;
		
		fork
		    //process one
		    begin
		    	if (rst_n == 1)
			    obj_coverage.sample_data(obj_transaction);
		    end
		    //process two
		    begin
		     	obj_scoreboard.check_data(obj_transaction);
		    end
     	join
        
        if(test_finished) begin
        	$display("The number of correct counts %0d and the number of the error counts %0d", correct_count, error_count);
        	$stop;
        end
	end
end
endmodule