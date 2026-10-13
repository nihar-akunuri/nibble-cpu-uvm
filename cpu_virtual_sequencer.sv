//=============================================================================
// cpu_virtual_sequencer.sv
// Lab12 Task E – Virtual sequencer.
// Holds handles to real sequencers; has no driver of its own.
//=============================================================================
class cpu_virtual_sequencer extends uvm_sequencer;
  `uvm_component_utils(cpu_virtual_sequencer)

  // TODO-E: Declare a handle to the cpu_agent's real sequencer
  uvm_sequencer #(cpu_transaction) cpu_seqr;
  //   (it will be assigned in cpu_env::connect_phase, not created here)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

endclass
