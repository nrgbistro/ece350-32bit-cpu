@ECHO OFF
cmd /c "update_deps.bat"
cmd /c "iverilog -Wtimescale -o alu.out -f deps.f"
