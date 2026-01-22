
@echo off

SETLOCAL

echo %1
call %1
call phy template-gui params.py

ENDLOCAL