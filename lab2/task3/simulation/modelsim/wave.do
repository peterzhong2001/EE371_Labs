onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /FIFO_testbench/clk
add wave -noupdate /FIFO_testbench/reset
add wave -noupdate /FIFO_testbench/full
add wave -noupdate /FIFO_testbench/empty
add wave -noupdate /FIFO_testbench/read
add wave -noupdate /FIFO_testbench/write
add wave -noupdate /FIFO_testbench/inputBus
add wave -noupdate /FIFO_testbench/outputBus
add wave -noupdate /FIFO_testbench/dut/FC/f
add wave -noupdate /FIFO_testbench/dut/FC/n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2111 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {6458 ps}
