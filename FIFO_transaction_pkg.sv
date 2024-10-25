package FIFO_transaction_pkg;
class FIFO_transaction;
parameter FIFO_WIDTH = 16;
rand logic rst_n;
rand bit [FIFO_WIDTH-1:0] data_in;
rand bit wr_en, rd_en;
 logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
 logic full, empty, almostfull, almostempty, underflow;

integer RD_EN_ON_DIST, WR_EN_ON_DIST;

function new(integer RD_EN_ON_DIST = 30 , integer WR_EN_ON_DIST = 70);
	this.RD_EN_ON_DIST = RD_EN_ON_DIST;
	this.WR_EN_ON_DIST = WR_EN_ON_DIST;
endfunction 

constraint assert_reset {
	rst_n dist {0:=5, 1:=95};
}

constraint write_enable {
	wr_en dist {1:=this.WR_EN_ON_DIST, 0:=100 - this.WR_EN_ON_DIST};
}

constraint read_enable {
	rd_en dist {1:=this.RD_EN_ON_DIST, 0:= 100 - this.RD_EN_ON_DIST};
}
endclass
endpackage