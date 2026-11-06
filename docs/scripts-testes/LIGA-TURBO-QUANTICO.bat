@echo off
chcp 65001 >nul
title TURBO QUANTICO IA BRASIL(R) - velocidade maxima do nucleo
rem ============================================================
rem  IA BRASIL(R) - MODO TURBO QUANTICO
rem  Marca Registrada - Samuel Ribeiro Fernandes
rem
rem  O ligador do nucleo neural e PRIVADO (nao distribuido):
rem  coloque o seu LIGA-NUCLEO-TURBO.bat na raiz da instalacao.
rem  Este script publico apenas ativa o turbo e mede a
rem  velocidade REAL resultante do nucleo IA Brasil (R).
rem ============================================================
set "RAIZ=D:\IA-BRASIL"
cd /d "%RAIZ%"

if not exist "%RAIZ%\LIGA-NUCLEO-TURBO.bat" (
  echo [ERRO] LIGA-NUCLEO-TURBO.bat nao encontrado na raiz %RAIZ%
  echo        O ligador do nucleo e privado do titular da marca.
  pause
  exit /b 1
)

echo [1/2] Ativando o nucleo em modo TURBO (ligador privado)...
call "%RAIZ%\LIGA-NUCLEO-TURBO.bat"

echo [2/2] Medindo a velocidade REAL do nucleo IA Brasil (R)...
set IA_BRASIL_NUCLEO_URL=%IA_BRASIL_NUCLEO_URL%
powershell -NoProfile -ExecutionPolicy Bypass -File "%RAIZ%\docs\scripts-testes\bench-nucleo.ps1" -Rotulo TURBO -Aquecer 1

echo.
echo ==================================================
echo   IA BRASIL(R) - TURBO QUANTICO ATIVO
echo   A linha TURBO^|tok_s= acima e a velocidade REAL
echo   de geracao do seu nucleo IA (R) nesta maquina.
echo ==================================================
pause
