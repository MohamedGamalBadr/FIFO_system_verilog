vlib work
vlog *v +define+SIM +cover 
vsim -voptargs=+acc top -cover
add wave /top/DUT/*
coverage save top.ucdb -onexit 
run -all