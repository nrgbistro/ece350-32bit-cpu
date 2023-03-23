@ECHO ON

SET PROG=%~1

cmd /c ".\asm.exe .\%PROG%.s"
move ".\%PROG%.mem" "..\Output Files"
