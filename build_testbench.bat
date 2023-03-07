@ECHO OFF
cmd /c "update_deps.bat"
cmd /c "iverilog -Wimplicit -o wrapper_tb.out -f deps.f Wrapper_tb.v"
cmd /c "move wrapper_tb.out Tests/"
