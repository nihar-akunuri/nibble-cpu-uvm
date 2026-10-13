//=============================================================================
// cpu_config.sv
// Lab12 Task B – Configuration object.
// Centralises testbench control knobs passed via uvm_config_db.
//=============================================================================
class cpu_config extends uvm_object;
  `uvm_object_utils(cpu_config)

  // TODO-B: Declare three fields with appropriate defaults:
  //   num_transactions (int)  – number of random transactions to generate
  int num_transactions = 1000;
  //   enable_coverage  (bit)  – controls whether the coverage collector is created
  bit enable_coverage = 1;
  //   use_random_test  (bit)  – controls factory instance override in cpu_test
  bit use_random_test = 1;

  function new(string name = "cpu_config");
    super.new(name);
  endfunction

  // TODO-B: Override do_copy to copy all three fields from the rhs object
  function void do_copy(uvm_object rhs);
    cpu_config rhs_;

    if (!$cast(rhs_, rhs)) begin
      `uvm_fatal("DO_COPY", "Cast failed in cpu_config")
    end

    super.do_copy(rhs);

    this.num_transactions = rhs_.num_transactions;
    this.enable_coverage  = rhs_.enable_coverage;
    this.use_random_test  = rhs_.use_random_test;
  endfunction

  // TODO-B: Override do_print to print all three fields using the printer argument
  function void do_print(uvm_printer printer);
    super.do_print(printer);

    printer.print_int("num_transactions", num_transactions, $bits(num_transactions), UVM_DEC);
    printer.print_int("enable_coverage",  enable_coverage,  1, UVM_BIN);
    printer.print_int("use_random_test",  use_random_test,  1, UVM_BIN);
  endfunction

endclass
