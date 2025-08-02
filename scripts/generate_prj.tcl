# This is a basic example, it may need to be adapted for your specific project
# Assumes the project is already open in ISE's internal Tcl shell

# Get a list of all Verilog and VHDL source files in the project
set verilog_files [xilinx::project::get_files -filter {file_type=="Verilog" || file_type=="Verilog Behavioral Simulation"}]
set vhdl_files [xilinx::project::get_files -filter {file_type=="VHDL" || file_type=="VHDL Behavioral Simulation"}]

# Open the .prj file for writing
set prj_file [open "project.prj" w]

# Write Verilog files to the .prj file
foreach file $verilog_files {
    puts $prj_file "verilog work \"[xilinx::project::get_property -name "file_name" -file $file]\""
}

# Write VHDL files to the .prj file
foreach file $vhdl_files {
    puts $prj_file "vhdl work \"[xilinx::project::get_property -name "file_name" -file $file]\""
}

# Close the .prj file
close $prj_file