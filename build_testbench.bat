@ECHO OFF
cmd /c "update_deps.bat"
cmd /c "iverilog -o alu_tb.out -f deps.f alu_tb.v"
cmd /c "move alu_tb.out Tests/"
