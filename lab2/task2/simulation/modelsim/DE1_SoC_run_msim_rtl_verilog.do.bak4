transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab2/task2 {D:/UW/ee371labs/lab2/task2/ram32x4.v}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task2 {D:/UW/ee371labs/lab2/task2/hex_driver.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task2 {D:/UW/ee371labs/lab2/task2/counter.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task2 {D:/UW/ee371labs/lab2/task2/DE1_SoC.sv}

