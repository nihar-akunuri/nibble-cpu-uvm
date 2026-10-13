//=============================================================================
// cpu_transaction.sv
// UVM sequence item representing a CPU operation.
//=============================================================================
class cpu_transaction extends uvm_sequence_item;
  `uvm_object_utils(cpu_transaction)

  rand logic [11:0] address;
  rand opcode_t     op;
  rand logic [31:0] operand1;
  rand logic [31:0] operand2;
  
  logic [31:0] result;

  // Constraints (same as in original transactor)
  constraint valid_address {
    address inside {[0:4090]};
  }
  constraint div_nonzero {
    if (op == OP_DIV) operand2 != 0;
  }
  constraint inv_operand2 {
    if (op == OP_INV) operand2 == 0;
  }
  constraint operand_range {
    operand1 inside {[0:32'hFFFFFFFF]};
    operand2 inside {[0:32'hFFFFFFFF]};
  }
  constraint op_weight {
    op dist {
      OP_ADD := 2, OP_SUB := 2,
      OP_MUL := 2, OP_DIV := 2,
      OP_AND := 2, OP_OR  := 2,
      OP_XOR := 2, OP_INV := 2
    };
  }
  constraint operand_weight {

  operand1 dist {
    32'd0                    :/ 2, 
    [32'd1:32'd10]           :/ 5,  
    [32'd11:32'd1000]        :/ 5,  
    [32'd1001:32'hFFFF_FFFF] :/ 2   
  };

  operand2 dist {
    32'd0                    :/ 2,
    [32'd1:32'd10]           :/ 5,
    [32'd11:32'd1000]        :/ 5,
    [32'd1001:32'hFFFF_FFFF] :/ 2
  };

}

  function new(string name = "cpu_transaction");
    super.new(name);
  endfunction

  // Utility function to display
  virtual function string convert2string();
    return $sformatf("op=%s addr=0x%h op1=0x%h op2=0x%h", op.name(), address, operand1, operand2);
  endfunction

endclass