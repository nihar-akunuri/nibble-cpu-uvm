//=============================================================================
// cpu_coverage.sv
// Lab12 Task D – Functional coverage model.
// Samples a covergroup on every transaction observed by the monitor.
//=============================================================================
class cpu_coverage extends uvm_subscriber #(cpu_transaction);
  `uvm_component_utils(cpu_coverage)


  // TODO-D: Declare class variables to hold the current sample values
  //   (opcode enum, operand1, operand2, result)
  opcode_t opcode;
  int operand1;
  int operand2;
  int result;

  // TODO-D: Declare a covergroup with:
  //   - a coverpoint for the opcode
  covergroup cg_ops;
		option.per_instance = 1;
		coverpoint opcode {
			bins add_bin = {OP_ADD};
			bins sub_bin = {OP_SUB};
			bins mul_bin = {OP_MUL};
			bins div_bin = {OP_DIV};
			bins inv_bin = {OP_INV};
			bins and_bin = {OP_AND};
			bins or_bin = {OP_OR};
			bins xor_bin = {OP_XOR};	
			}
	endgroup
  //   - a coverpoint for operand1 with four named bins (zero, small, medium, large)
  covergroup cg_operand1;
  option.per_instance = 1;
    coverpoint operand1 {
      bins zero   = {32'd0};
      bins small_bin  = {[32'd1 : 32'd10]};
      bins medium_bin = {[32'd11 : 32'd1000]};
      bins large_bin  = {[32'd1001 : 32'hFFFF_FFFF]};
    }
  endgroup
  //   - a coverpoint for operand2 with the same four bins
  covergroup cg_operand2;
  option.per_instance = 1;
    coverpoint operand2 {
      bins zero   = {32'd0};
      bins small_bin  = {[32'd1 : 32'd10]};
      bins medium_bin = {[32'd11 : 32'd1000]};
      bins large_bin  = {[32'd1001 : 32'hFFFF_FFFF]};
    }
  endgroup

  //   - a cross of opcode, operand1, and operand2 coverpoints
  covergroup cg_cross_ops_operands;
  option.per_instance = 1;

  coverpoint opcode {
    bins add_bin = {OP_ADD};
    bins sub_bin = {OP_SUB};
    bins mul_bin = {OP_MUL};
    bins div_bin = {OP_DIV};
    bins inv_bin = {OP_INV};
    bins and_bin = {OP_AND};
    bins or_bin  = {OP_OR};
    bins xor_bin = {OP_XOR};
  }

  coverpoint operand1 {
    bins zero   = {32'd0};
    bins small_bin  = {[32'd1 : 32'd10]};
    bins medium_bin = {[32'd11 : 32'd1000]};
    bins large_bin  = {[32'd1001 : 32'hFFFF_FFFF]};
  }

  coverpoint operand2 {
    bins zero   = {32'd0};
    bins small_bin  = {[32'd1 : 32'd10]};
    bins medium_bin = {[32'd11 : 32'd1000]};
    bins large_bin  = {[32'd1001 : 32'hFFFF_FFFF]};
  }

  
  cross opcode, operand1, operand2 {

    ignore_bins inv_invalid =
      binsof(opcode) intersect {OP_INV} &&
      binsof(operand2) intersect {[32'd1:32'hFFFF_FFFF]};

    ignore_bins div_invalid =
      binsof(opcode) intersect {OP_DIV} &&
      binsof(operand2) intersect {32'd0};
  }

	endgroup


  function new(string name, uvm_component parent);
    super.new(name, parent);
    //analysis_imp = new("analysis_imp", this);
    // TODO-D: Construct the covergroup instance
	cg_ops                   = new();
  cg_operand1              = new();
  cg_operand2              = new();

  cg_cross_ops_operands    = new();
  endfunction

  // TODO-D: Implement write – copy transaction fields into the sample variables, then call sample()
  virtual function void write(cpu_transaction t);

  // Assign sampled values
  opcode        = t.op;
  operand1  = t.operand1;
  operand2  = t.operand2;
  result    = t.result;

  // Sample all covergroups
  cg_ops.sample();
  cg_operand1.sample();
  cg_operand2.sample();

  cg_cross_ops_operands.sample();

	endfunction

endclass
