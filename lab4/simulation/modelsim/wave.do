onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /binary_search_testbench/clk
add wave -noupdate /binary_search_testbench/reset
add wave -noupdate /binary_search_testbench/s
add wave -noupdate -radix unsigned /binary_search_testbench/A_in
add wave -noupdate /binary_search_testbench/f
add wave -noupdate /binary_search_testbench/n_f
add wave -noupdate -radix unsigned /binary_search_testbench/addr
add wave -noupdate -radix unsigned /binary_search_testbench/dut/left
add wave -noupdate -radix unsigned /binary_search_testbench/dut/right
add wave -noupdate -radix unsigned /binary_search_testbench/dut/size
add wave -noupdate -radix unsigned /binary_search_testbench/dut/q
add wave -noupdate -radix unsigned /binary_search_testbench/dut/A
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3815 ps} 0}
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
WaveRestoreZoom {0 ps} {18743 ps}
