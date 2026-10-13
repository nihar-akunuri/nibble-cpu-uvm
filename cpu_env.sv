//=============================================================================
// cpu_env.sv
// UVM environment containing the agent.
//=============================================================================
class cpu_env extends uvm_env;
  `uvm_component_utils(cpu_env)
  
  cpu_scoreboard         sb;
  cpu_coverage           cov;
  cpu_virtual_sequencer  vseqr;
  cpu_config             cfg;

  cpu_agent agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("ENV", "Environment object created", UVM_LOW)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	if (!uvm_config_db#(cpu_config)::get(this, "", "cpu_config", cfg)) begin
      `uvm_fatal("ENV", "cpu_config not found in config_db")
    end
    // TODO-7: Create the agent using create_method
	agent  = cpu_agent::type_id::create("agent", this);
	
	sb    = cpu_scoreboard::type_id::create("sb", this);
    vseqr = cpu_virtual_sequencer::type_id::create("vseqr", this);
	
	if (cfg.enable_coverage) begin
      cov = cpu_coverage::type_id::create("cov", this);
    end
  endfunction

	function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Driver → Scoreboard (stimulus path)
    agent.driver.ap.connect(sb.stim_imp);

    // Monitor → Scoreboard (response path)
    agent.monitor.ap.connect(sb.resp_imp);

    // Monitor → Coverage (if enabled)
    if (cfg.enable_coverage) begin
      agent.driver.ap.connect(cov.analysis_export);
    end

    // Assign real sequencer to virtual sequencer
    vseqr.cpu_seqr = agent.sequencer;

  endfunction

endclass