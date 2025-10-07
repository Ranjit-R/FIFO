# ============================================================
# Makefile for UVM Simulation + Coverage + Waveform
# ============================================================

# Tools
VLOG    = vlog
VSIM    = vsim
VCOVER  = vcover
COPEN   = copen

# File names
TOP     = top
SRCS    = top.sv
SR_LOG  = sr_ff.log
SIM_LOG = simulation.log
COV_DB  = coverage.ucdb
COV_DIR = covReport
WAVE    = waves.wlf

# UVM include path
UVM_HOME = /tools/mentor/questasim_10.6c/questasim/uvm-1.1d
UVM_INC  = +incdir+$(UVM_HOME)/../verilog_src/uvm-1.1d/src

# ============================================================
# Default target: compile, simulate, and generate coverage
# ============================================================
all:
	$(MAKE) comp
	$(MAKE) run
	$(MAKE) cov

# ============================================================
# Compile
# ============================================================
comp:
	$(VLOG) +define+UVM_NO_DPI -sv +acc +cover +fcover \
	-l $(SR_LOG) $(SRCS) "$(UVM_INC)"

# ============================================================
# Simulation (batch mode with coverage and waveform)
# ============================================================
run:
	$(VSIM) -vopt work.$(TOP) -voptargs=+acc=npr -assertdebug \
	-l $(SIM_LOG) -coverage -wlf $(WAVE) -c \
	-do "log -r /*; add wave -r /*; run -all; \
	     coverage save -onexit -assert -directive -cvg -codeAll $(COV_DB); exit"

# ============================================================
# View waveform (after batch run)
# ============================================================
waveview:
	$(VSIM) -view $(WAVE)

# ============================================================
# GUI simulation with live waveform
# ============================================================
wave:
	$(VSIM) -novopt -suppress 12110 $(TOP) \
	-do "log -r /*; add wave -r /*; run -all"

# ============================================================
# Generate HTML Coverage Report
# ============================================================
cov:
	$(VCOVER) report -html $(COV_DB) -htmldir $(COV_DIR) -details

# ============================================================
# Open Coverage Database in QuestaSim Coverage GUI
# ============================================================
copen:
	$(COPEN) $(COV_DB) &

# ============================================================
# Open Coverage HTML Report in Firefox
# ============================================================
report:
	firefox $(COV_DIR)/index.html &

# ============================================================
# Cleanup
# ============================================================
clean:
	rm -f $(SR_LOG) $(SIM_LOG) $(COV_DB) $(WAVE)
	rm -rf work $(COV_DIR)

.PHONY: all comp run cov copen report wave waveview clean

