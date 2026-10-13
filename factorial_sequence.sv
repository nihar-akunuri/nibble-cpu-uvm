//=============================================================================
// factorial_sequence.sv
// Lab12 Task G – Factorial sequence using OP_MUL.
// Computes n! iteratively: product = 1*2*3*...*n
//=============================================================================
class factorial_sequence extends uvm_sequence #(cpu_transaction);
  `uvm_object_utils(factorial_sequence)

  int n = 7;   // keep small to avoid 32-bit overflow

  function new(string name = "factorial_sequence");
    super.new(name);
  endfunction

  virtual task body();
    cpu_transaction tr;

    // TODO-G: Declare a running product variable, initialised to 1
	bit [31:0] product = 1;
    int base_addr = 32'h100;

    // TODO-G: Loop from i=2 to n; each iteration drives an OP_MUL transaction
    //   with operand1 = running product so far and operand2 = i
	for (int i = 2; i <= n; i++) begin

      tr = cpu_transaction::type_id::create("tr");

      start_item(tr);

      tr.op        = OP_MUL;
      tr.operand1  = product;
      tr.operand2  = i;
      tr.address      = base_addr + i; // unique address per iteration

      finish_item(tr);

      // TODO-G: Update the running product after each finish_item
    //   Use an address base that does not overlap with fibonacci_sequence
      product = product * i;

    end
    

  endtask
endclass
