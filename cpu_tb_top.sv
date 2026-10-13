`timescale 1ns/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"
import nibble_cpu_tb_pkg::*;

module cpu_tb_top;

  logic clk;

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Reset generation (using pif.apply_reset() as in solution)
  initial begin
   vif.apply_reset();
  end

  // Instantiate interfaces
  prog_if vif (clk);
  mem_if  mif (clk);

  // Instantiate DUT
  cpu_top dut(clk,vif.rst_n,
                vif.prog_nibble_in,vif.prog_nibble_in_valid,vif.prog_nibble_out,
                vif.prog_out_valid,vif.prog_done,
                mif.mem_addr,mif.mem_wdata,mif.mem_rdata,mif.mem_wen,mif.mem_cen);
     
  memory_model duut(clk,mif.mem_addr,mif.mem_wdata,mif.mem_wen,mif.mem_cen,mif.mem_rdata);

  // UVM test start
  initial begin
	cpu_config cfg;
  
	cfg = cpu_config::type_id::create("cfg");
	cfg.num_transactions = 50;
    cfg.enable_coverage  = 1;
    cfg.use_random_test  = 1;
	uvm_config_db#(cpu_config)::set(null, "*", "cpu_config", cfg);
    // TODO-6: Set the virtual interface in the UVM configuration database
	uvm_config_db#(virtual prog_if)::set(null, "*", "vif", vif);
    // TODO-6: Call run_test("cpu_test");
	run_test();
  end

 

endmodule