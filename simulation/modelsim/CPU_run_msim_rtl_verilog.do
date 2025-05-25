transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/CPU/CYHCPU {D:/CPU/CYHCPU/CPU.v}
vlog -vlog01compat -work work +incdir+D:/CPU/CYHCPU {D:/CPU/CYHCPU/proc.v}
vlog -vlog01compat -work work +incdir+D:/CPU/CYHCPU {D:/CPU/CYHCPU/hex7_seg.v}
vlog -vlog01compat -work work +incdir+D:/CPU/CYHCPU {D:/CPU/CYHCPU/key_anti_shake.v}
vlog -vlog01compat -work work +incdir+D:/CPU/CYHCPU {D:/CPU/CYHCPU/int_memten.v}
vlog -vlog01compat -work work +incdir+D:/CPU/CYHCPU {D:/CPU/CYHCPU/count5.v}
vlog -vlog01compat -work work +incdir+D:/CPU/CYHCPU {D:/CPU/CYHCPU/hex7seg.v}

