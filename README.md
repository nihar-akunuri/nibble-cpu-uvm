# Nibble CPU — SystemVerilog RTL and UVM Testbench

This repository contains the RTL for a nibble-serial programmable CPU and a SystemVerilog UVM testbench.

## Overview

The CPU accepts 4-bit nibbles through a programming interface. The serial interface assembles command frames (address, opcode, data); the controller accesses a memory model and performs arithmetic/logic operations; and an output serializer returns results as nibbles.

The UVM environment includes a sequence item, configuration, sequencer, driver, monitor, agent, environment, scoreboard, functional coverage, and directed, constrained-random, and virtual-sequence tests. Fibonacci and factorial sequences exercise repeated operations.

## Files

- **RTL:** `cmd_controller.sv`, `cpu_top.sv`, `serial_interface.sv`, `output_serializer.sv`, `done_generator.sv`, `memory_model.sv`
- **Interfaces/package:** `prog_if.sv`, `mem_if.sv`, `interfaces.sv`, `nibble_cpu_tb_pkg.sv`
- **UVM environment:** `cpu_config.sv`, `cpu_transaction.sv`, `cpu_sequencer.sv`, `cpu_driver.sv`, `cpu_monitor.sv`, `cpu_agent.sv`, `cpu_env.sv`, `cpu_scoreboard.sv`, `cpu_coverage.sv`
- **Tests/sequences:** `cpu_test.sv`, `cpu_random_test.sv`, `cpu_virtual_test.sv`, `cpu_sequence.sv`, `random_sequence.sv`, `cpu_virtual_sequence.sv`, `cpu_virtual_sequencer.sv`, `fibonacci_sequence.sv`, `factorial_sequence.sv`
- **Simulation setup:** `Makefile`, `run.do`, `cpu_tb_top.sv`

## Run with QuestaSim

The Makefile expects Questa/ModelSim, `MGLS_HOME` set to the relevant installation, and UVM 1.2 sources at the path configured in the Makefile.

```sh
# GUI mode, default test
make questa_gui

# Batch mode
make questa_batch

# Select a test
make questa_batch TEST=cpu_random_test
make questa_batch TEST=cpu_virtual_test

# Clean generated simulator files
make clean
```

Simulation top: `cpu_tb_top`. The `run.do` script runs `run -all`.

## Notes

The project contains lab-oriented source comments and TODO markers. The historical logs included with the original submitted bundle showed 0 UVM errors and 0 UVM fatals in those recorded runs, but those log files are not included here, and no fresh simulation was run while publishing this repository. `interfaces.sv` is an alternate/combined interface source; the Makefile compile list uses `prog_if.sv` and `mem_if.sv`.
