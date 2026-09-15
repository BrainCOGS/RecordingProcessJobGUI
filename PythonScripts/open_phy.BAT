
@echo off

SETLOCAL

call conda activate %1
call phy template-gui win_params.py
conda deactivate

ENDLOCAL