@ECHO OFF
cmd /c "update_deps.bat"
cmd /c "iverilog -o multdiv_tb.out -f deps.f multdiv_tb.v"
cmd /c "move multdiv_tb.out Tests/"
