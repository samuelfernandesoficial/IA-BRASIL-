#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# bench_quantico.py -- VELOCIDADE QUANTICA LOCAL DE VERDADE
# Sem chave, sem internet: simulacao exata (qiskit Statevector) no proprio CPU.
import time, json, hashlib

try:
    from qiskit import QuantumCircuit
    from qiskit.quantum_info import Statevector
    import qiskit
    print("QOK|qiskit|%s" % qiskit.__version__, flush=True)
except Exception as e:
    print("QERRO|qiskit_ausente|%s" % str(e)[:120])
    raise SystemExit(1)

def agora():
    return time.perf_counter()

# PROVA 1 -- Emaranhamento Bell (2 qubits), 1000 circuitos completos
n = 1000
t0 = agora()
for _ in range(n):
    qc = QuantumCircuit(2)
    qc.h(0); qc.cx(0, 1)
    p = Statevector.from_instruction(qc).probabilities_dict()
dt_bell_ms = (agora() - t0) * 1000.0 / n
emb = (p.get("00", 0.0) + p.get("11", 0.0)) * 100.0
print("QBELL|circuitos=%d|%.3f_ms_por_circuito|emaranhamento=%.1f%%" % (n, dt_bell_ms, emb), flush=True)

# PROVA 2 -- NUCLEO DO SISTEMA: GHZ com 20 qubits (o teste oficial IA Brasil)
qc20 = QuantumCircuit(20)
qc20.h(0)
for i in range(19):
    qc20.cx(i, i + 1)
t0 = agora()
st20 = Statevector.from_instruction(qc20)
pr20 = st20.probabilities()
dt20_ms = (agora() - t0) * 1000.0
idx20 = int(pr20.argmax())
print("QGHZ20|qubits=20|amplitudes=%d|montagem_ms=%.1f|estado_dominante=%s|prob=%.1f%%"
      % (len(st20.data), dt20_ms, format(idx20, "020b"), float(pr20.max()) * 100), flush=True)

# PROVA 3 -- CARGA MAXIMA: GHZ 24 qubits = 16.777.216 amplitudes de uma vez
qc24 = QuantumCircuit(24)
qc24.h(0)
for i in range(23):
    qc24.cx(i, i + 1)
t0 = agora()
st24 = Statevector.from_instruction(qc24)
pr24 = st24.probabilities()
soma = float(pr24.sum())
dt24_ms = (agora() - t0) * 1000.0
ok24 = abs(soma - 1.0) < 1e-6
print("QMAX24|qubits=24|amplitudes=%d|tempo_ms=%.1f|norma_ok=%s"
      % (pr24.size, dt24_ms, str(ok24).lower()), flush=True)

res = {"qiskit": qiskit.__version__,
       "bell_ms_por_circuito": round(dt_bell_ms, 4),
       "ghz20_ms": round(dt20_ms, 2),
       "ghz24_ms": round(dt24_ms, 2),
       "emaranhamento_bell_pct": round(emb, 1),
       "quando": time.strftime("%Y-%m-%d %H:%M:%S")}
blob = json.dumps(res, ensure_ascii=False).encode("utf-8")
print("QFIM|resultado_sha256=%s" % hashlib.sha256(blob).hexdigest()[:16], flush=True)
