
@echo off

SETLOCAL

call conda activate %1
call phy template-gui params.py
conda deactivate

ENDLOCAL