//=============================================================================
// fibonacci_sequence.sv
// Lab12 Task G – Fibonacci sequence using OP_ADD.
// Computes the first n_terms Fibonacci numbers: 0, 1, 1, 2, 3, 5, 8, ...
//=============================================================================
class fibonacci_sequence extends uvm_sequence #(cpu_transaction);
  `uvm_object_utils(fibonacci_sequence)

  int n_terms = 10;

  function new(string name = "fibonacci_sequence");
    super.new(name);
  endfunction

  virtual task body();
    cpu_transaction tr;

    // TODO-G: Declare variables for the previous value, current value, and a temporary
	bit [31:0] prev = 0;
    bit [31:0] curr = 1;
    bit [31:0] next;
	int base_addr = 32'h000;

    // TODO-G: Loop n_terms times; each iteration drives an OP_ADD transaction
    //   with operand1 = previous Fibonacci value and operand2 = current value
	for (int i = 0; i < n_terms; i++) begin

  tr = cpu_transaction::type_id::create("tr");

  start_item(tr);

  tr.op        = OP_ADD;
  tr.operand1  = prev;
  tr.operand2  = curr;
  tr.address      = base_addr + i;

  finish_item(tr);

     // TODO-G: Advance the series each iteration using a temporary variable
    //   to avoid overwriting values before they are used
      next = prev + curr;
      prev = curr;
      curr = next;

    end


  endtask
endclass
