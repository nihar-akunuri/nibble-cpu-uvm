//=============================================================================
// cpu_virtual_sequence.sv
// Lab12 Task I – Virtual sequence.
// Coordinates sub-sequences on the real sequencer via the virtual sequencer.
//=============================================================================
class cpu_virtual_sequence extends uvm_sequence;
  `uvm_object_utils(cpu_virtual_sequence)

  fibonacci_sequence fib_seq;
  factorial_sequence fact_seq;

  function new(string name = "cpu_virtual_sequence");
    super.new(name);
  endfunction

  virtual task body();
    cpu_virtual_sequencer vseqr;

    // TODO-I: Cast m_sequencer to cpu_virtual_sequencer; issue an error and return on failure
	if (!$cast(vseqr, m_sequencer)) begin
      `uvm_error("VSEQ", "Failed to cast m_sequencer to cpu_virtual_sequencer")
      return;
    end

    // TODO-I: Create fib_seq and fact_seq using type_id::create
	fib_seq  = fibonacci_sequence::type_id::create("fib_seq");
    fact_seq = factorial_sequence::type_id::create("fact_seq");

    // TODO-I: Start fib_seq on the real sequencer (obtained from the virtual sequencer handle)
	fib_seq.start(vseqr.cpu_seqr);	
    // TODO-I: Then start fact_seq on the same real sequencer
	fact_seq.start(vseqr.cpu_seqr);

  endtask
endclass
