transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/UW/ee371labs/lab3 {D:/UW/ee371labs/lab3/line_drawer.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab3 {D:/UW/ee371labs/lab3/VGA_framebuffer.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab3 {D:/UW/ee371labs/lab3/screen_clearer.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab3 {D:/UW/ee371labs/lab3/input_processing.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab3 {D:/UW/ee371labs/lab3/DE1_SoC_2.sv}

