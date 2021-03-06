   module dmem_ext #(parameter SIZE = 1024, ADDR_WIDTH = 10, COL_WIDTH = 8, NB_COL	= 4) (
      input   clk, valid_st, spec_ld,
      input   [NB_COL-1:0]	        we,            // for enabling individual column accessible (for writes)
      input   [ADDR_WIDTH-1:0]	    addr,      
      input   [NB_COL*COL_WIDTH-1:0]  din,
      output  [NB_COL*COL_WIDTH-1:0]  dout
   );
      
      //reg [NB_COL*COL_WIDTH-1:0] outputreg;   
      reg	[NB_COL*COL_WIDTH-1:0] RAM [SIZE-1:0];
      

      assign dout = spec_ld ? RAM[addr] : 'x;
      // TODO : yosys logic equivalence check - with the other module

      generate
            genvar i;
            for (i = 0; i < NB_COL; i = i+1) begin
               always @(posedge clk) begin
                  //if (spec_ld) begin
                  //   outputreg[(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= RAM[addr][(i+1)*COL_WIDTH-1:i*COL_WIDTH];
                  //end 
                  //else 
                  if (valid_st && we[i]) begin
                     RAM[addr][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= din[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
                  end
               end
            end
      endgenerate        
   endmodule
