# Toolchains
VERILATOR := verilator

# Verilator common arguments
VL_COMMON_ARGS := 

# Verilator lint arguments
VL_LINT_COMMON_ARGS := $(VL_COMMON_ARGS) -Wall
VL_RTL_LINT_ARGS := $(VL_LINT_COMMON_ARGS) --no-timing
VL_TB_LINT_ARGS := $(VL_LINT_COMMON_ARGS) --timing

# Verilator simulation arguments
VL_SIM_COMMON_ARGS := $(VL_COMMON_ARGS) -Wno-fatal
ifeq ($(WAVE), vcd)
VL_SIM_COMMON_ARGS += --trace --trace-structs
else ifeq ($(WAVE), fst)
VL_SIM_COMMON_ARGS += --trace-fst --trace-structs
endif
ifeq ($(ASSERT), 1)
VL_SIM_COMMON_ARGS += --assert
endif
ifeq ($(COVERAGE), 1)
VL_SIM_COMMON_ARGS += --coverage
endif

VL_TB_SIM_ARGS := $(VL_SIM_COMMON_ARGS) --timing --stats

# RTL file list
RTL_FLIST_IP_ARG := $(foreach ip, $(RTL_IP_DEP), $(addprefix -F ip/, $(addsuffix /rtl/source.f, $(ip))))
RTL_FLIST_REPO_ARG := $(foreach ip, $(RTL_REPO_DEP), $(addprefix -F ../, $(addsuffix /rtl/source.f, $(ip))))

RTL_FLIST_ARG := $(RTL_FLIST_IP_ARG) $(RTL_FLIST_REPO_ARG) -F rtl/source.f

# Verification file list
VERIF_FLIST_IP_ARG := $(foreach ip, $(VERIF_IP_DEP), $(addprefix -F ip/, $(addsuffix /verif/source.f, $(ip))))
VERIF_FLIST_REPO_ARG := $(foreach ip, $(VERIF_REPO_DEP), $(addprefix -F ../, $(addsuffix /verif/source.f, $(ip))))

VERIF_FLIST_ARG := $(VERIF_FLIST_IP_ARG) $(VERIF_FLIST_REPO_ARG) -F verif/source.f

# Testbench file
TB_FILE := tb/$(TB_NAME).sv

# Lint with Verilator
.PHONY: lint-rtl
lint-rtl:
	$(VERILATOR) --lint-only $(VL_RTL_LINT_ARGS) $(RTL_FLIST_ARG) --top $(RTL_TOP_NAME)

.PHONY: lint-tb
lint-tb:
	$(VERILATOR) --lint-only $(VL_TB_LINT_ARGS) $(RTL_FLIST_ARG) $(TB_FILE) --top $(TB_NAME)

# Simple SystemVerilog Testbench Simulation
# Build simulation executable
sim/$(TB_NAME)_obj_dir/V$(TB_NAME):
	mkdir -p sim
	$(VERILATOR) --cc --exe --main $(VL_TB_SIM_ARGS) --top $(TB_NAME) $(RTL_FLIST_ARG) $(TB_FILE) -Mdir sim/$(TB_NAME)_obj_dir
	$(MAKE) -C sim/$(TB_NAME)_obj_dir -f V$(TB_NAME).mk

.PHONY: build-tb-sim
build-tb-sim: sim/$(TB_NAME)_obj_dir/V$(TB_NAME)

.PHONY: run-tb-sim
run-tb-sim: sim/$(TB_NAME)_obj_dir/V$(TB_NAME)
	cd sim ; ./$(TB_NAME)_obj_dir/V$(TB_NAME) $(SIM_ARGS)

# Generate CSR block RTL
.PHONY: csr
csr:
	peakrdl regblock $(RDL_SRC) -o rtl/ --cpuif apb4-flat

# Clean
.PHONY: clean
clean:
	rm -rf sim/* *.vcd *.fst
