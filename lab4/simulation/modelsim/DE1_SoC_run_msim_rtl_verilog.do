transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/UW/ee371labs/lab4 {D:/UW/ee371labs/lab4/binary_search.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab4 {D:/UW/ee371labs/lab4/ram32x8.sv}

