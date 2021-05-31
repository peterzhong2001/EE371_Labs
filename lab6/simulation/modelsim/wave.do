onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /audio_averaging_shift_testbench/clk
add wave -noupdate /audio_averaging_shift_testbench/rst
add wave -noupdate -radix unsigned /audio_averaging_shift_testbench/rR
add wave -noupdate -radix unsigned /audio_averaging_shift_testbench/rL
add wave -noupdate -radix unsigned /audio_averaging_shift_testbench/dut/curr_avg
add wave -noupdate /audio_averaging_shift_testbench/dut/update_avg
add wave -noupdate /audio_averaging_shift_testbench/dut/shift_enable
add wave -noupdate -childformat {{{/audio_averaging_shift_testbench/amps[0]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[1]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[2]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[3]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[4]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[5]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[6]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[7]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[8]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[9]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[10]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[11]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[12]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[13]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[14]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[15]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[16]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[17]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[18]} -radix unsigned} {{/audio_averaging_shift_testbench/amps[19]} -radix unsigned}} -expand -subitemconfig {{/audio_averaging_shift_testbench/amps[0]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[1]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[2]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[3]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[4]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[5]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[6]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[7]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[8]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[9]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[10]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[11]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[12]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[13]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[14]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[15]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[16]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[17]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[18]} {-height 15 -radix unsigned} {/audio_averaging_shift_testbench/amps[19]} {-height 15 -radix unsigned}} /audio_averaging_shift_testbench/amps
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {950 ps} 0}
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
WaveRestoreZoom {0 ps} {4253 ps}
