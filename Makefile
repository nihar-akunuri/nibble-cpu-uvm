TEST = cpu_test
UVM_HOME=$(MGLS_HOME)/verilog_src/uvm-1.2
QUESTA_UVM_HOME=$(MGLS_HOME)/verilog_src/questa_uvm_pkg-1.2
SRC_RTL = \
	cmd_controller.sv \
	cpu_top.sv \
	done_generator.sv \
	memory_model.sv \
	output_serializer.sv \
	serial_interface.sv
VERILOG_FILES = $(SRC_RTL) nibble_cpu_tb_pkg.sv prog_if.sv mem_if.sv cpu_tb_top.sv
UVM_FILES = +incdir+$(UVM_HOME)/src +define+UVM_NO_DEPRECATED +define+QUESTA $(UVM_HOME)/src/uvm.sv
UVM_DEBUG_FILES = +incdir+$(UVM_HOME)/src $(QUESTA_UVM_HOME)/src/questa_uvm_pkg.sv $(UVM_HOME)/src/dpi/uvm_dpi.cc -ccflags "-DQUESTA"
UVM_DEBUG_OPTION = -classdebug -msgmode both -uvmcontrol=all
TOPLEVEL = cpu_tb_top
help:
	@echo "make questa_gui / questa_batch / clean"
questa_gui:
	vlib work
	vmap work work
	vlog -64 +acc $(VERILOG_FILES) $(UVM_FILES) $(UVM_DEBUG_FILES)
	vsim -64 $(UVM_DEBUG_OPTION) -L $(MGLS_HOME)/uvm-1.2 +UVM_TESTNAME=$(TEST) -do run.do $(TOPLEVEL)
questa_batch: $(VERILOG_FILES) clean
	vlib work
	vmap work work
	vlog -64 +acc $(UVM_FILES) $(VERILOG_FILES)
	vsim -64 -c -L $(MGLS_HOME)/uvm-1.2 +UVM_TESTNAME=$(TEST) -do run.do $(TOPLEVEL)
DIR = $(shell basename `pwd`)
tar: clean
	cd ..; \
	tar cvf $(DIR).tar $(DIR)
clean:
	@rm -rf work transcript vsim.wlf
