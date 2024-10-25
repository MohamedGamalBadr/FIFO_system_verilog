package FIFO_coverage_pkg;
	import FIFO_transaction_pkg::*;
	class FIFO_coverage;
        FIFO_transaction F_cvg_txn = new();
        
        covergroup cross_coverage;

          wr_en_cvr: coverpoint F_cvg_txn.wr_en;
          rd_en_cvr: coverpoint F_cvg_txn.rd_en;
          full_cvr: coverpoint F_cvg_txn.full;
          overflow_cvr: coverpoint F_cvg_txn.overflow;
          underflow_cvr: coverpoint F_cvg_txn.underflow;
          wr_ack_cvr: coverpoint F_cvg_txn.wr_ack;
          empty_cvr: coverpoint F_cvg_txn.empty;

        	cross_WR_RD_full: cross F_cvg_txn.wr_en, rd_en_cvr, full_cvr{
               //It is impossibl to have rd_en high and full flag high at the same time
               illegal_bins rd_en_and_full_high =  binsof(rd_en_cvr) intersect {1} && binsof(full_cvr) intersect {1};
          }
        	cross_WR_RD_almost_full: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.almostfull;
        	cross_WR_RD_empty: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.empty;
        	cross_WR_RD_almost_empty: cross F_cvg_txn.wr_en, F_cvg_txn.rd_en, F_cvg_txn.almostempty;
        	cross_WR_RD_overflow: cross wr_en_cvr, F_cvg_txn.rd_en, overflow_cvr{
              //It is impossibl to have wr_en low and overflow flag high at the same time
              illegal_bins wr_en_low_overflow_high =  binsof(wr_en_cvr) intersect {0} && binsof(overflow_cvr) intersect {1};
          }
        	cross_WR_RD_underflow: cross F_cvg_txn.wr_en, rd_en_cvr, underflow_cvr{
              //It is impossibl to have rd_en low and underflow flag high at the same time
              illegal_bins rd_en_low_underflow_high =  binsof(rd_en_cvr) intersect {0} && binsof(underflow_cvr) intersect {1};
          }
        	cross_WR_RD_wr_ack: cross wr_en_cvr, F_cvg_txn.rd_en, wr_ack_cvr {
              //It is impossibl to have wr_en low and wr_ack flag high at the same time
              illegal_bins wr_en_low_wr_ack_high =  binsof(wr_en_cvr) intersect {0} && binsof(wr_ack_cvr) intersect {1};
          }
        endgroup
        
        function new;
        	cross_coverage = new ();
        endfunction
        
        function void sample_data(FIFO_transaction F_txn);
        	F_cvg_txn = F_txn;
             cross_coverage.sample();
        endfunction
	endclass
endpackage