RTL_PATH = ../../rtl

# --- Default Configuration (Top-Level Integration Test) ---
MODULE ?= test_cms
TOPLEVEL := complex_mean_square
VERILOG_SOURCES := $(shell realpath ${RTL_PATH}/complex_mean_square.v) \
                   $(shell realpath ${RTL_PATH}/complex_adder_subtractor.v) \
                   $(shell realpath ${RTL_PATH}/complex_multiplier.v)
# ----------------------------------------------------------

# Configuration for the ComplexMultiplier unit test
ifeq ($(MODULE), test_multiplier)
    TOPLEVEL := complex_multiplier
    VERILOG_SOURCES := $(shell realpath ${RTL_PATH}/complex_multiplier.v)
endif

# Configuration for the ComplexAdderSubtractor unit test
ifeq ($(MODULE), test_adder_subtractor)
    TOPLEVEL := complex_adder_subtractor
    VERILOG_SOURCES := $(shell realpath ${RTL_PATH}/complex_adder_subtractor.v)
endif


SIM = verilator

EXTRA_ARGS = --Wno-fatal

ifeq ($(WAVE),1)
	EXTRA_ARGS += --trace --trace-fst --trace-structs
endif

include $(shell cocotb-config --makefiles)/Makefile.sim
