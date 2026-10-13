interface mem_if(input logic clk);
 logic [11:0] mem_addr;
 logic [31:0] mem_wdata, mem_rdata;
 logic mem_wen, mem_cen;
 modport cpu_side(output mem_addr,mem_wdata,mem_wen,mem_cen,input mem_rdata);
 modport mem_side(input mem_addr,mem_wdata,mem_wen,mem_cen,output mem_rdata);
endinterface
