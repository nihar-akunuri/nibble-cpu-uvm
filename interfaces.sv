`timescale 1ns/1ps
interface prog_if(input logic clk);
 import nibble_cpu_tb_pkg::*;
 logic rst_n;
 logic [3:0] prog_nibble_in, prog_nibble_out;
 logic prog_nibble_in_valid, prog_out_valid, prog_done;
 clocking cb @(posedge clk);
  default input #1ns output #1ns;
  output rst_n, prog_nibble_in, prog_nibble_in_valid;
  input prog_nibble_out, prog_out_valid, prog_done;
 endclocking
 modport DUT(input clk,rst_n,prog_nibble_in,prog_nibble_in_valid,output prog_nibble_out,prog_out_valid,prog_done);
 modport TB(clocking cb);
 task automatic apply_reset(); cb.rst_n<=0; cb.prog_nibble_in<=0; cb.prog_nibble_in_valid<=0; repeat(5) @(cb); cb.rst_n<=1; @(cb); endtask
 task automatic send_nibble(input logic [3:0] nibble); cb.prog_nibble_in<=nibble; cb.prog_nibble_in_valid<=1; @(cb); endtask
endinterface
interface mem_if(input logic clk);
 logic [11:0] mem_addr; logic [31:0] mem_wdata,mem_rdata; logic mem_wen,mem_cen;
 clocking cb @(posedge clk); default input #1ns output #1ns; input mem_addr,mem_wdata,mem_wen,mem_cen,mem_rdata; endclocking
 modport DUT(input mem_rdata,output mem_addr,mem_wdata,mem_wen,mem_cen);
 modport TB(clocking cb);
endinterface
