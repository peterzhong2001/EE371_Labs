transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab2/task3 {D:/UW/ee371labs/lab2/task3/ram16x8.v}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task3 {D:/UW/ee371labs/lab2/task3/FIFO_Control.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task3 {D:/UW/ee371labs/lab2/task3/hex_driver.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task3 {D:/UW/ee371labs/lab2/task3/D_FF.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task3 {D:/UW/ee371labs/lab2/task3/FIFO.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task3 {D:/UW/ee371labs/lab2/task3/input_processing.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task3 {D:/UW/ee371labs/lab2/task3/DE1_SoC.sv}

