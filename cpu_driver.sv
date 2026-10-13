//=============================================================================
// cpu_driver.sv
// UVM driver for the CPU. Uses interface tasks to send transactions.
//=============================================================================
class cpu_driver extends uvm_driver #(cpu_transaction);
  `uvm_component_utils(cpu_driver)
  
   uvm_analysis_port #(cpu_transaction) ap;

  virtual prog_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("DRIVER", "Driver object created", UVM_LOW)
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	ap = new("ap", this);
    if (!uvm_config_db#(virtual prog_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("DRIVER", "Could not get vif")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    wait (vif.rst_n == 1'b1);
    `uvm_info("DRIVER", "reset done", UVM_LOW)
    @vif.cb;
    forever begin
      seq_item_port.get_next_item(req);
	  ap.write(req);
      drive_transaction(req);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_transaction(cpu_transaction tr);
    logic [7:0] cmd;
    logic [11:0] res_addr;
	frame_c frame;
    
    `uvm_info("DRIVER", $sformatf("Driving: %s", tr.convert2string()), UVM_LOW)

    // TODO-2: Write operand1 to address tr.address (use vif.send_frame with cmd=8'h02)
	frame.addr = tr.address; frame.opcode = OP_WRITE; frame.data = tr.operand1;
	vif.send_frame(frame);
	//`uvm_info("DRIVER", $sformatf("Driven 1: %s", tr.convert2string()), UVM_LOW)
    // TODO-2: Write operand2 to address tr.address+1
	frame.addr = tr.address+1; frame.opcode = OP_WRITE; frame.data = tr.operand2;
	vif.send_frame(frame);
	//`uvm_info("DRIVER", $sformatf("Driven 2: %s", tr.convert2string()), UVM_LOW)
    // TODO-2: Send the command to tr.address (data=32'h0)
	frame.addr = tr.address; frame.opcode = tr.op; frame.data = 0;
	vif.send_frame(frame);
	//`uvm_info("DRIVER", $sformatf("Driven 3: %s", tr.convert2string()), UVM_LOW)
    // TODO-2: Determine result address (A+2 for most ops, A for OP_INV)
	if(tr.op==OP_INV)
		res_addr = tr.address+1;
	else begin
		res_addr = tr.address+2;
    // TODO-2: Send read command (8'h03) to result address
	frame.addr = res_addr; frame.opcode = OP_READ; frame.data = 0;
	vif.send_frame(frame);
	end
	//`uvm_info("DRIVER", $sformatf("Driven: %s", tr.convert2string()), UVM_LOW)
  endtask

endclass