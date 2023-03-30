@ECHO OFF
IF EXIST .\deps.f DEL /F deps.f

@REM for /r %%i in (*) do ( echo %%~nxi )

for /R %%F in ("*.v?") do (
    echo %%~nxF | find "_tb.v" > nul
    if errorlevel 1 (
        echo %%F | find "vivado" > nul
        if errorlevel 1 (
            call :Sub %%~F
        )
    )
)
ECHO .\Wrapper_tb.v >> deps.f

goto :eof

:Sub
set str=%*
set str=%str:C:\Users\nolan\Duke\ece350\ece350-32bit-cpu\=.\%
echo.%str% >> deps.f

