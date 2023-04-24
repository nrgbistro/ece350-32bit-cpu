## set debug_rtd_standalone true, to enable debugging
##   of this rtd, in standalone mode ... 
###################################################
set debug_rtd_standalone false


if { $debug_rtd_standalone } {
  set rt::partid xc7a100tcsg324-1
  if { ! [info exists ::env(RT_TMP)] } {
    set ::env(RT_TMP) [pwd]
  } 
  source $::env(SYNTH_COMMON)/task_worker.tcl
} 
set genomeRtd $env(RT_TMP)/22917E203D0.rtd
set parallel_map_command "rt::do_techmap_steps"
set rt::parallelMoreOptions "set rt::bannerSuppress true"
puts "this genome's name is [subst -nocommands -novariables {RAM__GB7}]"
puts "this genome's rtd file is $genomeRtd"
source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
source $::env(RT_TMP)/parameters.tcl
rt::set_parameter parallelChildUpdateCell true; rt::set_parameter parallelTimingMode true; rt::set_parameter parallelTimingModeRound 1; set rt::SDCFileList C:/Users/nolan/Duke/ece350/ece350-32bit-cpu/vivado/vivado.runs/synth_1/.Xil/Vivado-8456-NRG-Laptop/realtime/Wrapper_synth.xdc; 
set genomeName [subst -nocommands -novariables {RAM__GB7}]
source $::env(SYNTH_COMMON)/synthesizeAGenome.tcl 
set rt::parallelMoreOptions "set rt::bannerSuppress false"
