//=============================================================================
// cpu_test.sv
// UVM test that runs a sequence on the CPU.
//=============================================================================
class cpu_test extends uvm_test;
  `uvm_component_utils(cpu_test)

  cpu_env env;
  cpu_config cfg;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	
	if (!uvm_config_db#(cpu_config)::get(this, "", "cpu_config", cfg)) begin
      `uvm_info("TEST", "cpu_config not found, creating default", UVM_LOW)
      cfg = cpu_config::type_id::create("cfg");
    end
	
    env = cpu_env::type_id::create("env", this);
	
	uvm_config_db#(cpu_config)::set(this, "env", "cpu_config", cfg);
		
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    cpu_sequence seq;

    // TODO-5: Raise objection
	phase.raise_objection(this);
    // TODO-5: Create sequence and start it on env.agent.sequencer
	seq = cpu_sequence::type_id::create("seq");
	seq.start(env.agent.sequencer);
    // TODO-5: Wait a few cycles (#100) then drop objection
	#1000; phase.drop_objection(this);
  endtask

endclass