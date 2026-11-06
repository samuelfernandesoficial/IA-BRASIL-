@echo off
chcp 65001 >nul
title MEDIR VELOCIDADE DO NUCLEO IA BRASIL(R)
rem ============================================================
rem  IA BRASIL(R) - MEDICAO OFICIAL DE VELOCIDADE DO NUCLEO
rem  Marca Registrada - Samuel Ribeiro Fernandes
rem  Requer: variavel IA_BRASIL_NUCLEO_URL definida pelo titular
rem  (configuracao privada; o nucleo nunca via publico).
rem ============================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0bench-nucleo.ps1" -Rotulo MEDICAO -Aquecer 1
echo.
echo MEDICAO CONCLUIDA - IA BRASIL(R)
pause
