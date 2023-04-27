@ECHO OFF

SET PROG=%~1

cmd /c ".\asm.exe -i custom_instructions.csv -r custom_registers.csv .\%PROG%.s"
move ".\%PROG%.mem" "..\Memory Files"
cd "..\..\.."
cmd /c "build_testbench.bat %PROG%"
cd "Tests"
cmd /c "vvp proc.out"
cd "CPU Test Files\Assembly Files"
