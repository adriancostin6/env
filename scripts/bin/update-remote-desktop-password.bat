@echo off

setlocal enabledelayedexpansion

set arg_count=0
for %%x in (%*) do (
   set /A arg_count+=1
)

if %arg_count% NEQ 2 goto :usage


cmdkey /generic:TERMSRV/%2 /user:%1 /pass:
exit /b

:usage
echo usage: update-remote-desktop-password user host
