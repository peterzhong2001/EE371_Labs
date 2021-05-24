transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/clock_generator.v}
vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/audio_codec.v}
vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/audio_and_video_config.v}
vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/Altera_UP_SYNC_FIFO.v}
vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/Altera_UP_Slow_Clock_Generator.v}
vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/Altera_UP_I2C_AV_Auto_Initialize.v}
vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/Altera_UP_I2C.v}
vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/Altera_UP_Clock_Edge.v}
vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/Altera_UP_Audio_Out_Serializer.v}
vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/Altera_UP_Audio_In_Deserializer.v}
vlog -vlog01compat -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/Altera_UP_Audio_Bit_Counter.v}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/noise_gen.sv}
vlog -sv -work work +incdir+D:/UW/ee371labs/lab5 {D:/UW/ee371labs/lab5/DE1_SoC.sv}

