transcript on
if ![file isdirectory DE1_SoC_iputf_libs] {
	file mkdir DE1_SoC_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog "D:/UW/ee371labs/EE.CSE371/CLOCK25_PLL_sim/CLOCK25_PLL.vo"

vlog -sv -work work +incdir+D:/UW/ee371labs/EE.CSE371 {D:/UW/ee371labs/EE.CSE371/audio_averaging_shift.sv}

