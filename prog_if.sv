`timescale 1ns/1ps
`include "nibble_cpu_tb_pkg.sv"
interface prog_if(input logic clk);
 import nibble_cpu_tb_pkg::*;
 logic rst_n; logic [3:0] prog_nibble_in,prog_nibble_out; logic prog_nibble_in_valid,prog_out_valid,prog_done;
 initial begin rst_n=1'b1; prog_nibble_in=4'h0; prog_nibble_in_valid=1'b0; end
 clocking cb @(posedge clk); default input #1ns output #1ns; output rst_n,prog_nibble_in,prog_nibble_in_valid; input prog_nibble_out,prog_out_valid,prog_done; endclocking
 modport dut(input rst_n,prog_nibble_in,prog_nibble_in_valid,output prog_nibble_out,prog_out_valid,prog_done);
 task automatic send_nibble(input logic [3:0] nibble); cb.prog_nibble_in<=nibble; @(cb); endtask
 task automatic send_frame(input frame_c framee); logic [51:0] bits; bits={framee.data,framee.opcode,framee.addr}; cb.prog_nibble_in_valid<=1; wait(cb.rst_n==1); for(int i=0;i<13;i++) begin send_nibble(bits[3:0]); bits=bits>>4; end cb.prog_nibble_in_valid<=0; wait(cb.prog_done===1'b1); @(cb); endtask
 task automatic wait_for_output(output logic [31:0] data); data=0; @(posedge cb.prog_out_valid); for(int i=0;i<8;i++) begin data={cb.prog_nibble_out,data[31:4]}; @(cb); end endtask
 task automatic read_data(input logic [11:0] addr,output logic [31:0] data); frame_c f; f.addr=addr; f.opcode=OP_READ; f.data=0; fork send_frame(f); wait_for_output(data); join endtask
endinterface
