# bench-cerebro.ps1 -- mede a VELOCIDADE REAL do cerebro neural local (porta 8540)
param(
  [string]$Rotulo = "BENCH",
  [int]$Aquecer = 0,
  [int]$MaxTok = 160
)
$ErrorActionPreference = "Continue"
$url = "http://127.0.0.1:8540/v1/chat/completions"
$msg = "Conte em voz alta de um a trinta, so os numeros separados por espaco."
$corpo = '{"model":"ia-brasil","max_tokens":' + $MaxTok + ',"temperature":0,"messages":[{"role":"user","content":"' + $msg + '"}]}'

function MedeUmaVez([string]$tag) {
  try {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $r = Invoke-RestMethod -Uri $url -Method Post -Body $corpo -ContentType "application/json" -TimeoutSec 600
    $sw.Stop()
    $tg = 0; if ($r.usage.completion_tokens) { $tg = $r.usage.completion_tokens }
    $pt = 0; if ($r.usage.prompt_tokens) { $pt = $r.usage.prompt_tokens }
    $tps = 0
    if ($sw.Elapsed.TotalSeconds -gt 0 -and $tg -gt 0) { $tps = [math]::Round($tg / $sw.Elapsed.TotalSeconds, 2) }
    Write-Output ("{0}|ms_total={1}|prompt_tok={2}|gerados={3}|tok_s={4}" -f $tag, [math]::Round($sw.Elapsed.TotalMilliseconds,0), $pt, $tg, $tps)
    if ($r.timings) {
      Write-Output ("{0}|SERVIDOR|tok_s={1}|prefill_tok_s={2}" -f $tag, [math]::Round($r.timings.predicted_per_second,2), [math]::Round($r.timings.prompt_per_second,2))
    }
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
