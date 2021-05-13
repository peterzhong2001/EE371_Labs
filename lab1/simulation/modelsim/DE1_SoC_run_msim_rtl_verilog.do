transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/UW/ee371labs/lab1 {D:/UW/ee371labs/lab1/sensors.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab1 {D:/UW/ee371labs/lab1/counter.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab1 {D:/UW/ee371labs/lab1/hex_driver.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab1 {D:/UW/ee371labs/lab1/DE1_SoC.sv}

