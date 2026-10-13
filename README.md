# Nibble CPU — UVM Verification Environment

A SystemVerilog/UVM verification environment for a Nibble CPU design. The project includes CPU RTL, a reusable UVM agent and environment, directed and constrained-random sequences, virtual-sequence examples, a scoreboard, functional coverage, and saved QuestaSim logs.

## Project contents

### RTL and interfaces

- `cpu_top.sv` — CPU top-level RTL.
- `cmd_controller.sv` — command/control logic.
- `serial_interface.sv`, `output_serializer.sv`, `done_generator.sv` — serial/output and completion logic.
- `memory_model.sv` — memory model.
- `prog_if.sv`, `mem_if.sv`, `interfaces.sv` — programming, memory, and related interfaces.
- `cpu_tb_top.sv` — simulation top-level.

### UVM testbench

- `nibble_cpu_tb_pkg.sv` — package that imports UVM and includes project components.
- `cpu_transaction.sv` — transaction item and associated data definitions.
- `cpu_driver.sv`, `cpu_monitor.sv`, `cpu_sequencer.sv` — core agent components.
- `cpu_agent.sv`, `cpu_config.sv`, `cpu_env.sv` — agent configuration and environment.
- `cpu_scoreboard.sv` — response checking against expected results.
- `cpu_coverage.sv` — functional coverage.
- `cpu_test.sv` — base test.
- `cpu_random_test.sv`, `random_sequence.sv` — factory override and constrained-random test flow.
- `cpu_virtual_test.sv`, `cpu_virtual_sequence.sv`, `cpu_virtual_sequencer.sv` — virtual-sequence test flow.
- `fibonacci_sequence.sv`, `factorial_sequence.sv` — example directed sequences.

## UVM test scenarios

The Makefile selects the test with the `TEST` variable. The provided tests are:

| Test | Purpose |
|---|---|
| `cpu_test` | Runs the base CPU sequence. |
| `cpu_random_test` | Uses a UVM factory type override to substitute `random_sequence` for `cpu_sequence`. |
| `cpu_virtual_test` | Runs a virtual sequence through the virtual sequencer; includes Fibonacci and factorial sequence examples. |

## Prerequisites

- Siemens QuestaSim with SystemVerilog and UVM 1.2 support.
- `make`.
- `MGLS_HOME` set to the Mentor/Questa installation root expected by the provided Makefile. The Makefile references UVM sources under `$(MGLS_HOME)/verilog_src/uvm-1.2` and `$(MGLS_HOME)/verilog_src/questa_uvm_pkg-1.2`.

Paths and UVM installation layout can vary by QuestaSim version and local setup; adjust the Makefile only if required for your environment.

## Running the simulation

From the project root, select a test and run the corresponding target:

```sh
# Base directed test
make questa_batch TEST=cpu_test

# Constrained-random test
make questa_batch TEST=cpu_random_test

# Virtual-sequence test
make questa_batch TEST=cpu_virtual_test
```

For a GUI run, use `questa_gui` instead of `questa_batch`:

```sh
make questa_gui TEST=cpu_test
```

The Makefile's `questa_batch` target compiles the UVM sources and project RTL/testbench, then starts `vsim` with `+UVM_TESTNAME=$(TEST)`. The `run.do` script enables recursive signal logging and runs the simulation to completion. See `make help` for the targets declared in the Makefile.

To remove generated QuestaSim work files:

```sh
make clean
```

## Existing simulation logs

The repository includes these logs from prior QuestaSim runs:

- `logfile_cpu_test.txt`
- `logfile_cpu_random_test.txt`
- `logfile_cpu_virtual_test.txt`

The saved logs report `UVM_ERROR : 0` and `UVM_FATAL : 0` for the recorded runs. These files are historical run outputs; they do not imply that the simulation has been rerun on the current machine or tool version.

## Notes

- This repository preserves the supplied RTL, testbench, Makefile, run script, and log files.
- The simulation has not been freshly executed as part of this repository upload. Use the commands above to validate it in your own QuestaSim/UVM environment.
