
@echo off

SETLOCAL

call conda activate %1
suite2p
conda deactivate

ENDLOCAL