set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 100.000 -name sys_clk_pin -waveform {0.000 50.000} [get_ports clk]

set_property PACKAGE_PIN D19 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

set_property PACKAGE_PIN M20 [get_ports {sw[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]

set_property PACKAGE_PIN M19 [get_ports {sw[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]

set_property PACKAGE_PIN M14 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

set_property PACKAGE_PIN N16 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN P14 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN R14 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_false_path -from [get_ports rst]
set_false_path -from [get_ports {sw[*]}]
set_input_delay  -clock sys_clk_pin 2.0 [get_ports rst]
set_output_delay -clock sys_clk_pin 2.0 [get_ports {led[*]}]

set_multicycle_path -setup 2 -from [get_cells -hierarchical -filter {NAME =~ *RF*}]
set_multicycle_path -hold  1 -from [get_cells -hierarchical -filter {NAME =~ *RF*}]
set_multicycle_path -setup 2 -from [get_cells -hierarchical -filter {NAME =~ *ALU*}]
set_multicycle_path -hold  1 -from [get_cells -hierarchical -filter {NAME =~ *ALU*}]
set_multicycle_path -setup 2 -from [get_cells -hierarchical -filter {NAME =~ *CU*}]
set_multicycle_path -hold  1 -from [get_cells -hierarchical -filter {NAME =~ *CU*}]
set_multicycle_path -setup 2 -from [get_cells -hierarchical -filter {NAME =~ *IMEM*}]
set_multicycle_path -hold  1 -from [get_cells -hierarchical -filter {NAME =~ *IMEM*}]
set_multicycle_path -setup 2 -from [get_cells -hierarchical -filter {NAME =~ *DMEM*}]
set_multicycle_path -hold  1 -from [get_cells -hierarchical -filter {NAME =~ *DMEM*}]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]