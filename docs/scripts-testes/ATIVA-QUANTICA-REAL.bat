@echo off
chcp 65001 >nul
title ATIVA QUANTICA REAL IA BRASIL(R) - nucleo quantico local sem chave
rem Ajuste RAIZ para a pasta da SUA instalacao (onde esta QISKIT-LIB e bench_quantico.py).
set "RAIZ=D:\IA-BRASIL"
set "PYTHONPATH=%RAIZ%\QISKIT-LIB"
if not exist "%RAIZ%\QISKIT-LIB" set "PYTHONPATH="
cd /d "%RAIZ%"

echo ==================================================
echo    IA BRASIL(R) - IA QUANTICA REAL (LOCAL)
echo    Sem chave. Sem internet. No seu proprio CPU.
echo ==================================================
echo.
py -3.12 "%RAIZ%\bench_quantico.py"
if %errorlevel%==0 goto grava
py -3 "%RAIZ%\bench_quantico.py"

:grava
py -3.12 "%RAIZ%\bench_quantico.py" > "%RAIZ%\RESULTADO-QUANTICA-REAL.txt" 2>&1
echo.
echo Resultado gravado em RESULTADO-QUANTICA-REAL.txt
echo IA_QUANTICA_REAL_NO_AR
