# Output directory for all generated files
BUILD_DIR = build
PRJ_NAME  = complex_mean_square.xise

# Tcl script for project creation
TCL_SCRIPT = scripts/create_ise_project.tcl

# Default target
all: setup

# Target to create the ISE project
setup:
	@echo "setup ISE project..."
	@mkdir -p $(BUILD_DIR)
	@xtclsh $(TCL_SCRIPT)
	@echo "project created in $(BUILD_DIR)/"
	@echo "open $(BUILD_DIR)/$(PRJ_NAME) in ISE"


simulate: ${BUILD_DIR}/${PRJ_NAME}
	@fuse -intstyle ise -incremental -lib unisims_ver -lib unimacro_ver -lib xilinxcorelib_ver -lib secureip      -o sim.exe -prj sim/rtl/complex_mean_square_wip_tb_beh.prj work.complex_mean_square_wip_tb work.glbl
	@./sim.exe
	@rm -rf sim.exe



# Target to clean all generated files
clean:
	@echo "cleanup ISE project..."
	@rm -rf $(BUILD_DIR) isim* fuse* *.log *.wdb webtalk* _xmsgs*
	@echo "clean complete"

.PHONY: all setup clean