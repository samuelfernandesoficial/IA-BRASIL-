@echo off
chcp 65001 >nul
rem ============================================================
rem  IA BRASIL(R) - ativacao TURBO do nucleo neural local
rem  4 nucleos fisicos + prioridade ALTA (o modelo fica intacto)
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

if not defined SERV (echo [ERRO] servidor neural nao encontrado em %RAIZ%\CEREBRO-LOCAL & exit /b 1)
if not defined MODELO (echo [ERRO] modelo nao encontrado em %RAIZ%\modelos & exit /b 1)

taskkill /f /im "%SERV%" >nul 2>&1
ping -n 3 127.0.0.1 >nul
echo [%date% %time%] TURBO: reinicio com -t 4 nucleos fisicos + prioridade ALTA >> servidor_log.txt
start "CEREBRO-TURBO" /min cmd /c ""%RAIZ%\CEREBRO-LOCAL\%SERV%" -m "%MODELO%" -t 4 --threads-batch 4 -c 32768 -np 1 --flash-attn on --cache-type-k q8_0 --cache-type-v q8_0 --cache-reuse 256 --host 127.0.0.1 --port 8540 --jinja >> servidor_log.txt 2>&1"
set /a CONT=0
:espera
ping -n 11 127.0.0.1 >nul
set /a CONT+=1
curl -s -m 10 http://127.0.0.1:8540/health | findstr /c:"ok" >nul
if %errorlevel%==0 goto prioridade
if %CONT% GEQ 30 goto falhou
goto espera
:prioridade
powershell -NoProfile -Command "Get-Process | Where-Object { $_.ProcessName -eq '%SERVBASE%' } | ForEach-Object { $_.PriorityClass = 'High'; $_.ProcessorAffinity = 85 }"
echo TURBO_NO_AR
exit /b 0
:falhou
echo TURBO_FALHOU_SUBIDA
exit /b 1
