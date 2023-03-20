@ECHO OFF
cmd /c "update_deps.bat"
cmd /c "iverilog -o proc.out -c deps.f -s Wrapper_tb -P Wrapper_tb.FILE=\""sort\"""
cmd /c "move proc.out Tests/"
