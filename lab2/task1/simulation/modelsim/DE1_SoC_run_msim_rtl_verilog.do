transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task1 {D:/UW/ee371labs/lab2/task1/RAM.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task1 {D:/UW/ee371labs/lab2/task1/hex_driver.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab2/task1 {D:/UW/ee371labs/lab2/task1/DE1_SoC.sv}

