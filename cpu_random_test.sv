//=============================================================================
// cpu_random_test.sv
// Lab12 Task K – Demonstrates UVM factory type override.
// Run with: +UVM_TESTNAME=cpu_random_test
//=============================================================================
class cpu_random_test extends cpu_test;
  `uvm_component_utils(cpu_random_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    // TODO-K: Register a global type override so every cpu_sequence becomes
    //   a random_sequence – do this before calling super.build_phase
	 uvm_factory::get().set_type_override_by_type(
      cpu_sequence::get_type(),
      random_sequence::get_type()
    );

    super.build_phase(phase);
  endfunction

endclass
