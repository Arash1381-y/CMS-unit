# Tcl script to run the ISE simulation
# This script assumes the project has already been created.

# 1. Define Project Name and Directory
set proj_name "complex_mean_square"
set proj_dir "build"

# 2. Open the project
project open "${proj_dir}/${proj_name}.xise"

# 3. Set the top-level testbench for simulation
xfile set "Top-Level Module Name" "complex_mean_square_wip_tb"

# 4. Run the behavioral simulation process
# This command will launch ISim and run the simulation.
process run "Simulate Behavioral Model"

run 1000ns

# 5. Close the project
project close