
# Tools
VLOG   = vlog
VSIM   = vsim
VCOVER = vcover

# File names
TOP     = top
SRCS    = top.sv
SR_LOG  = sr_ff.log
SIM_LOG = simulation.log
COV_DB  = coverage.ucdb
COV_DIR = covReport

# UVM include path
UVM_HOME = /tools/mentor/questasim_10.6c/questasim/uvm-1.1d
UVM_INC  = +incdir+$(UVM_HOME)/../verilog_src/uvm-1.1d/src

# Default target
all:
	$(MAKE) comp
	$(MAKE) run
	$(MAKE) cov

# Compile step
comp:	
	$(VLOG) +define+UVM_NO_DPI -sv +acc +cover +fcover \
        -l $(SR_LOG) $(SRCS) "$(UVM_INC)"

# Simulation step
run:
	$(VSIM) -vopt work.$(TOP) -voptargs=+acc=npr -assertdebug \
        -l $(SIM_LOG) -coverage -c \
        -do "coverage save -onexit -assert -directive -cvg -codeAll $(COV_DB); run -all; exit"

# Coverage report
cov:
	$(VCOVER) report -html $(COV_DB) -htmldir $(COV_DIR) -details

# Cleanup
clean:
	rm -f $(SR_LOG) $(SIM_LOG) $(COV_DB)
	rm -rf work $(COV_DIR)

.PHONY: all compile simulate coverage clean


