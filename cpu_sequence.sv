//=============================================================================
// cpu_sequence.sv
// Sequence that generates a few hardcoded CPU operations.
//=============================================================================
class cpu_sequence extends uvm_sequence #(cpu_transaction);
  `uvm_object_utils(cpu_sequence)

  function new(string name = "cpu_sequence");
    super.new(name);
  endfunction

  virtual task body();
    cpu_transaction tr;

    // TODO-4: Create and send transactions
    // Use start_item(tr), randomize or set fields, then finish_item(tr)
    // Example for ADD:
    tr = cpu_transaction::type_id::create("tr");
    start_item(tr);
    tr.address = 12'h100;
    tr.op = OP_ADD;
    tr.operand1 = 10;
    tr.operand2 = 5;
    finish_item(tr);
	
	start_item(tr);
    tr.address = 12'h200;
    tr.op = OP_MUL;
    tr.operand1 = 10;
    tr.operand2 = 5;
    finish_item(tr);
	
	start_item(tr);
    tr.address = 12'h300;
    tr.op = OP_AND;
    tr.operand1 = 10;
    tr.operand2 = 5;
    finish_item(tr);

  endtask
endclass