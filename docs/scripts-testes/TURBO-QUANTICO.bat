@echo off
chcp 65001 >nul
title TURBO QUANTICO IA BRASIL(R) - 4 nucleos fisicos + prioridade ALTA
rem ============================================================
rem  IA BRASIL(R) - MODO TURBO QUANTICO
rem  Ajuste RAIZ para a pasta da SUA instalacao.
rem ============================================================
set "RAIZ=D:\IA-BRASIL"
cd /d "%RAIZ%\CEREBRO-LOCAL" 2>nul || cd /d "%RAIZ%"

rem Descobre o modelo e o servidor na sua maquina (sem nomes fixos aqui)
set "MODELO="
for /f "delims=" %%M in ('dir /b /a-d /o-s "%RAIZ%\modelos\*.*" 2^>nul') do if not defined MODELO set "MODELO=%RAIZ%\modelos\%%M"
set "SERV="
for /f "delims=" %%S in ('dir /b /a-d "%RAIZ%\CEREBRO-LOCAL\*server*.exe" 2^>nul') do if not defined SERV set "SERV=%%S"
set "SERVBASE=%SERV:.exe=%"

echo ==================================================
echo    IA BRASIL(R) - MODO TURBO QUANTICO
echo    Nucleo quantico local + cerebro neural no maximo
echo    4 nucleos fisicos + prioridade ALTA (era 2/baixa)
echo ==================================================
echo.
if not defined SERV (echo [ERRO] servidor neural nao encontrado em %RAIZ%\CEREBRO-LOCAL & pause & exit /b 1)
if not defined MODELO (echo [ERRO] modelo nao encontrado em %RAIZ%\modelos & pause & exit /b 1)

echo [1/5] Parando nucleo antigo...
taskkill /f /im "%SERV%" >nul 2>&1
ping -n 3 127.0.0.1 >nul

echo [2/5] Subindo CEREBRO em TURBO (-t 4 + flash-attn + KV q8_0)...
echo [%date% %time%] TURBO-QUANTICO: nucleo neural -t 4 nucleos fisicos, prioridade ALTA >> servidor_log.txt
start "CEREBRO-TURBO" /min cmd /c ""%RAIZ%\CEREBRO-LOCAL\%SERV%" -m "%MODELO%" -t 4 --threads-batch 4 -c 32768 -np 1 --flash-attn on --cache-type-k q8_0 --cache-type-v q8_0 --cache-reuse 256 --host 127.0.0.1 --port 8540 --jinja >> servidor_log.txt 2>&1"

echo [3/5] Aguardando nucleo subir (modelo 6,17 GB: 1-3 min)...
:espera
ping -n 11 127.0.0.1 >nul
curl -s -m 10 http://127.0.0.1:8540/health | findstr /c:"ok" >nul
if %errorlevel%==0 goto prioridade
echo ......ainda carregando
goto espera

:prioridade
echo [4/5] Aplicando prioridade ALTA + afinidade nos 4 nucleos fisicos (0,2,4,6)...
powershell -NoProfile -Command "Get-Process | Where-Object { $_.ProcessName -eq '%SERVBASE%' } | ForEach-Object { $_.PriorityClass = 'High'; $_.ProcessorAffinity = 85 }"

echo [5/5] AQUECENDO cerebro e medindo velocidade real...
powershell -NoProfile -ExecutionPolicy Bypass -File "%RAIZ%\bench-cerebro.ps1" -Rotulo TURBO -Aquecer 1

echo.
echo ==================================================
echo    TURBO QUANTICO NO AR: http://127.0.0.1:8540
echo    Confira a linha TURBO|tok_s= acima: essa e a
echo    velocidade REAL de geracao do seu nucleo IA.
echo ==================================================
pause
