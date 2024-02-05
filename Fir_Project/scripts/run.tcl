cd ..
set root_dir [pwd]
cd scripts
set resultDir ../project

file mkdir $resultDir

create_project project $resultDir -part xc7z010clg400-1
set_property board_part digilentinc.com:zybo-z7-10:part0:1.0 [current_project]


# Ukljucivanje svih izvornih i simulacionih fajlova u projekat

add_files -norecurse ../dut/top.vhd
add_files -norecurse ../dut/redundancy.vhd
add_files -norecurse ../dut/comparator.vhd
add_files -norecurse ../dut/switch_logic.vhd
add_files -norecurse ../dut/variable_io_package.vhd
add_files -norecurse ../dut/voter.vhd
#add_files -norecurse ../dut/fir_param.vhd
add_files -norecurse ../dut/mac.vhd
add_files -norecurse ../dut/txt_util.vhd
add_files -norecurse ../dut/util_pkg.vhd

update_compile_order -fileset sources_1

# Ukljucivanje constraint fajlova
add_files -fileset constrs_1 -norecurse ../constraint/constraint.xdc
update_compile_order -fileset sources_1

set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse ../verif/top_tb.vhd
add_files -fileset sim_1 -norecurse ../verif/tb.vhd
add_files -fileset sim_1 -norecurse ../verif/voter_tb.vhd
add_files -fileset sim_1 -norecurse ../verif/comparator_tb.vhd
add_files -fileset sim_1 -norecurse ../verif/switch_logic_tb.vhd

set_property top top_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]


update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
