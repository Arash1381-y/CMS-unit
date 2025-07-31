# --- Test Selection ---
# The user can override this from the command line.
MODULE ?= test_cms

# --- Default Configuration (Top-Level Integration Test) ---
TOPLEVEL := ComplexMeanSquare
VERILOG_SOURCES := $(shell realpath ../rtl/ComplexMeanSquare.v) \
                   $(shell realpath ../rtl/ComplexMultiplier.v) \
                   $(shell realpath ../rtl/ComplexAdderSubtractor.v)

# Configuration for the ComplexMultiplier unit test
ifeq ($(MODULE), test_multiplier)
    TOPLEVEL := ComplexMultiplier
    VERILOG_SOURCES := $(shell realpath ../rtl/ComplexMultiplier.v)
endif

# Configuration for the ComplexAdderSubtractor unit test
ifeq ($(MODULE), test_adder_subtractor)
    TOPLEVEL := ComplexAdderSubtractor
    VERILOG_SOURCES := $(shell realpath ../rtl/ComplexAdderSubtractor.v)
endif


# Add the test directory to the Python search path
export PYTHONPATH := test:$(PYTHONPATH)

SIM = verilator

EXTRA_ARGS = --Wno-fatal

ifeq ($(WAVE),1)
	EXTRA_ARGS += --trace --trace-fst --trace-structs
endif

include $(shell cocotb-config --makefiles)/Makefile.sim
