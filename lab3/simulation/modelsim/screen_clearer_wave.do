onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /screen_clearer_testbench/clk
add wave -noupdate /screen_clearer_testbench/clear
add wave -noupdate /screen_clearer_testbench/listen
add wave -noupdate /screen_clearer_testbench/drawer_reset
add wave -noupdate -radix unsigned /screen_clearer_testbench/x
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31763750 ps} 0}
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
WaveRestoreZoom {30176886 ps} {32801904 ps}
