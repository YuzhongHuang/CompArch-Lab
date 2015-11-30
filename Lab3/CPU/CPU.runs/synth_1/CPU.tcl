# 
# Synthesis run script generated by Vivado
# 

debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7z010clg400-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.cache/wt [current_project]
set_property parent.project_path C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
read_verilog -library xil_defaultlib {
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/verilog/fsm/fsmCommand.v
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/verilog/signextend/se.v
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/verilog/IR/IR.v
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/verilog/fsm/fsm.v
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/verilog/dff/dff.v
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/verilog/datamemory/datamemory.v
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/verilog/concat/concat.v
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/verilog/alu/alu.v
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/regfile/regfile.v
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/muxes/muxes.v
  C:/CompArchFA15/LAB/CompArch-Lab/Lab3/CPU/CPU.srcs/sources_1/imports/verilog/cpu.v
}
synth_design -top CPU -part xc7z010clg400-1
write_checkpoint -noxdef CPU.dcp
catch { report_utilization -file CPU_utilization_synth.rpt -pb CPU_utilization_synth.pb }
