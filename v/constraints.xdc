##based on basys-3-master file from lab 1 -test this on tuesday


## Clock signal
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk] #Should handle time constraint

set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports adj_level] 

set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports sel_level]

#connected to segDisplay module
set_property -dict { PACKAGE_PIN W7    IOSTANDARD LVCMOS33 } [get_ports CA]
set_property -dict { PACKAGE_PIN W6    IOSTANDARD LVCMOS33 } [get_ports CB]
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS33 } [get_ports CC]
set_property -dict { PACKAGE_PIN V8    IOSTANDARD LVCMOS33 } [get_ports CD]
set_property -dict { PACKAGE_PIN U5    IOSTANDARD LVCMOS33 } [get_ports CE]
set_property -dict { PACKAGE_PIN V5    IOSTANDARD LVCMOS33 } [get_ports CF]
set_property -dict { PACKAGE_PIN U7    IOSTANDARD LVCMOS33 } [get_ports CG]

#digits
set_property -dict { PACKAGE_PIN W4    IOSTANDARD LVCMOS33 } [get_ports AN3]
set_property -dict { PACKAGE_PIN V4    IOSTANDARD LVCMOS33 } [get_ports AN2]
set_property -dict { PACKAGE_PIN U4    IOSTANDARD LVCMOS33 } [get_ports AN1]
set_property -dict { PACKAGE_PIN U2    IOSTANDARD LVCMOS33 } [get_ports AN0]

#buttons
#reset button
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports reset_pulse]
# Pause button
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports pause_pulse]
