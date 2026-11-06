# bench-nucleo.ps1 -- mede a VELOCIDADE REAL do nucleo IA Brasil (R)
# O endereco do nucleo vem da variavel de ambiente IA_BRASIL_NUCLEO_URL
# (configuracao privada do titular; o script nao carrega endereco, porta
# nem detalhe de motor — o nucleo e tecnologia proprietaria IA Brasil (R)).
param(
  [string]$Rotulo = "BENCH",
  [int]$Aquecer = 0,
  [int]$MaxTok = 160
)
$ErrorActionPreference = "Continue"
$url = $env:IA_BRASIL_NUCLEO_URL
if (-not $url) {
  Write-Output "ERRO|defina a variavel IA_BRASIL_NUCLEO_URL (configuracao privada do titular)"
  exit 1
}
$msg = "Conte em voz alta de um a trinta, so os numeros separados por espaco."
$corpo = '{"max_tokens":' + $MaxTok + ',"temperature":0,"messages":[{"role":"user","content":"' + $msg + '"}]}'

function MedeUmaVez([string]$tag) {
  try {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $r = Invoke-RestMethod -Uri $url -Method Post -Body $corpo -ContentType "application/json" -TimeoutSec 600
    $sw.Stop()
    $tg = 0; if ($r.usage.completion_tokens) { $tg = $r.usage.completion_tokens }
    $pt = 0; if ($r.usage.prompt_tokens) { $pt = $r.usage.prompt_tokens }
    $tps = 0
    if ($sw.Elapsed.TotalSeconds -gt 0 -and $tg -gt 0) { $tps = [Math]::Round($tg / $sw.Elapsed.TotalSeconds, 2) }
    Write-Output ("{0}|ms_total={1}|prompt_tok={2}|gerados={3}|tok_s={4}" -f $tag, [Math]::Round($sw.Elapsed.TotalMilliseconds,0), $pt, $tg, $tps)
    $txt = ""
    if ($r.choices[0].message.content) { $txt = $r.choices[0].message.content }
    if ($txt.Length -gt 60) { $txt = $txt.Substring(0,60) }
    Write-Output ("{0}|RESPOSTA|{1}" -f $tag, $txt)
  } catch {
    Write-Output ("{0}|ERRO|{1}" -f $tag, $_.Exception.Message)
  }
}

if ($Aquecer -eq 1) { MedeUmaVez "AQUECIMENTO" }
MedeUmaVez $Rotulo
