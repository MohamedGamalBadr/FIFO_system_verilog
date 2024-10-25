package FIFO_scoreboard_pkg;
import FIFO_transaction_pkg::*;
import shared_pkg::*;
	class FIFO_scoreboard;
		parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8 ;

         logic [FIFO_WIDTH-1:0] data_out_ref;
         logic full_ref, almostfull_ref;
         logic empty_ref, almostempty_ref;
         logic wr_ack_ref, overflow_ref, underflow_ref;

        localparam max_fifo_addr = $clog2(FIFO_DEPTH);

         logic [max_fifo_addr:0] count;
         logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;

         logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

        function void check_data (FIFO_transaction F_tran);
           
        	reference_model(F_tran);
            //Check for data out
             if($realtime()>0) begin
            if(data_out_ref !== F_tran.data_out) begin
                $display("%t: Error: Expected data_out is %0d but data_out is %0d",$time, data_out_ref, F_tran.data_out);
                error_count = error_count + 1;
            end
            else 
                correct_count = correct_count + 1;

            //check for full
              if(full_ref !== F_tran.full ) begin
                $display("%t: Error: Expected full is %0d and actual full is %0d",$time, full_ref, F_tran.full);
                error_count = error_count + 1;
            end
            else 
                correct_count = correct_count + 1;

             //check for almostfull
            if(almostfull_ref !== F_tran.almostfull) begin
                $display("%t: Error: Expected almostfull is %0d and actual almostfull is %0d",$time, almostfull_ref, F_tran.almostfull);
                error_count = error_count + 1;
            end
            else 
                correct_count = correct_count + 1;

             //check for empty
             if(empty_ref !== F_tran.empty ) begin
                $display("%t: Error: Expected empty is %0d and actual empty is %0d",$time, empty_ref, F_tran.empty);
                error_count = error_count + 1;
            end
            else 
                correct_count = correct_count + 1;

             //check for almostempty
              if( almostempty_ref !== F_tran.almostempty ) begin
                $display("%t: Error: Expected almostempty is %0d and actual almostempty is %0d",$time, almostempty_ref, F_tran.almostempty);
                error_count = error_count + 1;
            end
            else 
                correct_count = correct_count + 1;

             //check for overflow
             if(overflow_ref !== F_tran.overflow ) begin
                $display("%t: Error: Expected overflow is %0d and actual overflow is %0d",$time,overflow_ref, F_tran.overflow);
                error_count = error_count + 1;
            end
            else 
                correct_count = correct_count + 1;

              //check for underflow
              if(underflow_ref !== F_tran.underflow ) begin
                $display("%t: Error: Expected underflow is %0d and actual underflow is %0d",$time, underflow_ref, F_tran.underflow);
                error_count = error_count + 1;
            end
            else 
                correct_count = correct_count + 1;

             //check for wr_ack
              if(wr_ack_ref !== F_tran.wr_ack) begin
                $display("%t: Error: Expected wr_ack is %0d and actual wr_ack is %0d",$time, wr_ack_ref, F_tran.wr_ack);
                error_count = error_count + 1;
            end
            else 
                correct_count = correct_count + 1;

            end
        endfunction

        function void reference_model(FIFO_transaction F_tran_check);
           if(~F_tran_check.rst_n) begin
              count = 0;
              wr_ptr = 0;
              rd_ptr = 0;
              count = 0;
              wr_ack_ref = 0;
              overflow_ref = 0; 
               underflow_ref =0;
          end
            else begin
                 if (F_tran_check.wr_en && count < FIFO_DEPTH) begin
                    mem[wr_ptr] = F_tran_check.data_in;
                    wr_ptr = wr_ptr + 1; 
                     wr_ack_ref = 1;
                 end
                else 
                    wr_ack_ref = 0;  
                

                if (F_tran_check.rd_en && count != 0) begin
                    data_out_ref = mem[rd_ptr];
                    rd_ptr = rd_ptr + 1;
                end

                if  ( (({F_tran_check.wr_en, F_tran_check.rd_en} == 2'b10) && !full_ref) || ( ({F_tran_check.wr_en, F_tran_check.rd_en} == 2'b11) && empty_ref) )  
                       count = count + 1;
               else if ( (({F_tran_check.wr_en, F_tran_check.rd_en} == 2'b01) && !empty_ref) || ( ({F_tran_check.wr_en, F_tran_check.rd_en} == 2'b11) && full_ref) )
                       count = count - 1;
            
               if (full_ref && F_tran_check.wr_en )
                     overflow_ref = 1;
               else
                    overflow_ref = 0;

                if (empty_ref && F_tran_check.rd_en)
                    underflow_ref =1;
               else 
                    underflow_ref =0;
             end

           full_ref = (count == FIFO_DEPTH)? 1 : 0;
           empty_ref = (count == 0)? 1 : 0;
           almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0; 
           almostempty_ref = (count == 1)? 1 : 0;
        endfunction
	endclass
endpackage