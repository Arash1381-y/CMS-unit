# Tcl script to create the ISE project
# This script should be run from the root of the repository

# 1. Define Project Name and Output Directory
set proj_name "complex_mean_square"
set proj_dir "build"

# 2. Create a new project file
project new ${proj_dir}/${proj_name}.xise

# 3. Set project properties (adjust for your specific device)
project set "Family" "Artix7"
project set "Device" "xc7a100t"
project set "Package" "csg324"
project set "Speed" "-3"
project set "Top-Level Source Type" "HDL"
project set "Synthesis Tool" "XST (VHDL/Verilog)"
project set "Simulator" "ISim (VHDL/Verilog)"
project set "Preferred Language" "Verilog"

# 4. Add all Verilog source files from the rtl directory
# The paths are relative to the location of the .xise file
foreach file [glob -nocomplain ../rtl/*.v] {
    xfile add $file
}

# 5. Add all Verilog testbench files from the tb directory
foreach file [glob -nocomplain ../sim/rtl/*.v] {
    xfile add $file
}

# # 6. Add the constraints file
# xfile add ../src/constraints/design.ucf

# 7. (Optional) Add IP cores
xfile add ../ip/complex_multiplier_ip/complex_multiplier_ip.xco


project close