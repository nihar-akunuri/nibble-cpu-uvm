`uvm_analysis_imp_decl(_stim)
`uvm_analysis_imp_decl(_resp)

class cpu_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(cpu_scoreboard)
  uvm_analysis_imp_stim #(cpu_transaction, cpu_scoreboard) stim_imp;
  uvm_analysis_imp_resp #(cpu_transaction, cpu_scoreboard) resp_imp;
  cpu_transaction exp_q[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    stim_imp = new("stim_imp", this);
    resp_imp = new("resp_imp", this);
  endfunction

  function void write_stim(cpu_transaction tr);
    cpu_transaction exp_tr;
    exp_tr = cpu_transaction::type_id::create("exp_tr");
    exp_tr.copy(tr);
    exp_tr.result = compute_expected(tr);
    exp_q.push_back(exp_tr);
  endfunction

  function void write_resp(cpu_transaction tr);
    cpu_transaction exp_tr;
    if (exp_q.size() == 0) begin
      `uvm_error("SCOREBOARD", "No expected transaction in queue!")
      return;
    end
    exp_tr = exp_q.pop_front();
    if (tr.result !== exp_tr.result) begin
      `uvm_error("SCOREBOARD", $sformatf("Mismatch! Expected=%0d, Got=%0d", exp_tr.result, tr.result))
    end else begin
      `uvm_info("SCOREBOARD", $sformatf("Match OK: %0d", tr.result), UVM_LOW)
    end
  endfunction

  function int compute_expected(cpu_transaction tr);
    int result;
    case (tr.op)
      OP_ADD: result = tr.operand1 + tr.operand2;
      OP_SUB: result = tr.operand1 - tr.operand2;
      OP_MUL: result = tr.operand1 * tr.operand2;
      OP_DIV: result = tr.operand1 / tr.operand2;
      OP_INV: result = ~tr.operand1;
      OP_AND: result = tr.operand1 & tr.operand2;
      OP_OR : result = tr.operand1 | tr.operand2;
      OP_XOR: result = tr.operand1 ^ tr.operand2;
      default: begin
        `uvm_warning("SCOREBOARD", "Unknown operation")
        result = 0;
      end
    endcase
    return result;
  endfunction
endclass
