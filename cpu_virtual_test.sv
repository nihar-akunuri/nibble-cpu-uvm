//=============================================================================
// cpu_virtual_test.sv
// Lab12 Task L – Demonstrates the virtual sequence pattern.
// Run with: +UVM_TESTNAME=cpu_virtual_test
//=============================================================================
class cpu_virtual_test extends cpu_test;
  `uvm_component_utils(cpu_virtual_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    cpu_virtual_sequence vseq;

    phase.raise_objection(this);

    // TODO-L: Create the virtual sequence using type_id::create
	vseq = cpu_virtual_sequence::type_id::create("vseq");
    // TODO-L: Start it on the virtual sequencer (env.vseqr), not the agent sequencer
	vseq.start(env.vseqr);

    #1000;
    phase.drop_objection(this);
  endtask

endclass
