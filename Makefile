# Output directory for all generated files
BUILD_DIR = build

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
	@echo "open $(BUILD_DIR)/complex_mean_square.xise in ISE"

# Target to clean all generated files
clean:
	@echo "cleanup ISE project..."
	@rm -rf $(BUILD_DIR) isim* fuse* *.log *.wdb webtalk* _xmsgs*
	@echo "clean complete"

.PHONY: all setup clean