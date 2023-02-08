@ECHO OFF
cmd /c "update_deps.bat"
cmd /c "iverilog -o regfile_tb.out -f deps.f regfile_tb.v"
cmd /c "move regfile_tb.out Tests/"
