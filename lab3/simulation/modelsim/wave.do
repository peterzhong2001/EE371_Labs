onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /DE1_SoC_2_testbench/dut/CLOCK_50
add wave -noupdate /DE1_SoC_2_testbench/dut/clear
add wave -noupdate /DE1_SoC_2_testbench/dut/running
add wave -noupdate /DE1_SoC_2_testbench/dut/x0_bus
add wave -noupdate /DE1_SoC_2_testbench/dut/y0_bus
add wave -noupdate /DE1_SoC_2_testbench/dut/x1_bus
add wave -noupdate /DE1_SoC_2_testbench/dut/y1_bus
add wave -noupdate /DE1_SoC_2_testbench/dut/listen
add wave -noupdate /DE1_SoC_2_testbench/dut/x_clear
add wave -noupdate /DE1_SoC_2_testbench/dut/count
add wave -noupdate /DE1_SoC_2_testbench/dut/clearer/clk
add wave -noupdate /DE1_SoC_2_testbench/dut/clearer/x
add wave -noupdate /DE1_SoC_2_testbench/dut/clearer/listen
add wave -noupdate /DE1_SoC_2_testbench/dut/clearer/enable
add wave -noupdate /DE1_SoC_2_testbench/dut/clearer/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 81
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {42524948 ps}
