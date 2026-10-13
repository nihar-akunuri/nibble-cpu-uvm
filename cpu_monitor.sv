//=============================================================================
// cpu_monitor.sv
// UVM monitor for the CPU. Observes output nibbles and reconstructs result.
//=============================================================================
class cpu_monitor extends uvm_monitor;
  `uvm_component_utils(cpu_monitor)

  virtual prog_if vif;
  uvm_analysis_port #(cpu_transaction) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("MONITOR", "Monitor object created", UVM_LOW)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual prog_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MONITOR", "Could not get vif")
    end
    ap = new("ap", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    logic [31:0] result;
    int nibble_count;
    cpu_transaction obs;
    forever begin
      // TODO-1: Detect prog_out_valid
	  @(posedge vif.prog_out_valid);
      // TODO-1: Initialize result and nibble_count.
	  result = 0;
	  nibble_count = 0;
      // TODO-1: Collect 8 nibbles (use @vif.cb to sync with clock).
      //         Reconstruct result (LSB first).
	  while(nibble_count<8) begin
		@(vif.cb);
		result = {vif.prog_nibble_out, result [31:4]};
		nibble_count++;
	  end
      // TODO-1: Create a transaction, set its operand1 to result
	  obs = new();
	  obs.result = result;

      // For simplicity, we just print; in later labs we'll have a scoreboard.
      `uvm_info("MONITOR", $sformatf("Captured result: 0x%h", result), UVM_LOW)
	  ap.write(obs);
    end
  endtask

endclass