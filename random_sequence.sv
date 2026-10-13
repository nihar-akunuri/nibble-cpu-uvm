class random_sequence extends cpu_sequence;
 `uvm_object_utils(random_sequence)
 function new(string name="random_sequence"); super.new(name); endfunction
 virtual task body();
  cpu_transaction tr; int num_trans=100; cpu_config cfg;
  if (uvm_config_db#(cpu_config)::get(m_sequencer,"","cpu_config",cfg)) num_trans=cfg.num_transactions;
  else `uvm_warning("SEQ","cpu_config not found, using default num_trans=20")
  repeat(num_trans) begin tr=cpu_transaction::type_id::create("tr"); start_item(tr); if (!tr.randomize()) `uvm_error("SEQ","Randomization failed") finish_item(tr); end
 endtask
endclass
