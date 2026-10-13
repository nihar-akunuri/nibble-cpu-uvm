//=============================================================================
// cpu_agent.sv
// UVM agent containing driver, monitor, and sequencer.
//=============================================================================
class cpu_agent extends uvm_agent;
  `uvm_component_utils(cpu_agent)

  cpu_driver    driver;
  cpu_monitor   monitor;
  uvm_sequencer #(cpu_transaction) sequencer;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("AGENT", "Agent object created", UVM_LOW)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // TODO-3: Create driver, monitor, and sequencer using type_id::create()
	driver = cpu_driver::type_id::create("driver", this);
	monitor = cpu_monitor::type_id::create("monitor", this);
	sequencer = uvm_sequencer #(cpu_transaction)::type_id::create("sequencer", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // TODO-3: Connect driver.seq_item_port to sequencer.seq_item_export
	driver.seq_item_port.connect(sequencer.seq_item_export);
  endfunction

endclass