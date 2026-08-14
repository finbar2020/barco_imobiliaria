# Plano de teste — Higienização / padronização de BLoCs (App Síndico)

Documento para QA manual **feature a feature** após a higienização e
padronização de blocs/cubits no `app-lello-sindico`.

Objetivo: validar que a refatoração estrutural (fusão abs/impl, Equatable,
`Initial` no lugar de `Idle`, remoção de `print`/`mapEventToState`, DI)
**não quebrou fluxos reais** de tela, loading, erro, cache e troca de
condomínio.

---

## 0. Como usar este plano

| Campo | Como preencher |
|---|---|
| Ambiente | Homolog / Dev (indicar build) |
| Versão / commit | |
| Dispositivo | Android / iOS + modelo |
| Conta de teste | CPF com acesso às features (síndico) |
| Condomínio de teste | Preferir 1 com dados e 1 “vazio” |

### Critérios gerais de sucesso (vale para todas as features)

- [ ] App abre sem crash após login
- [ ] Loading aparece e some (não trava em loading infinito)
- [ ] Troca de condomínio atualiza os dados da tela
- [ ] Pull-to-refresh / botão atualizar (quando existir) funciona
- [ ] Erro de rede (modo avião) mostra estado de falha ou mantém cache, sem tela branca
- [ ] Voltar (back) não deixa a tela “presa” no estado anterior errado
- [ ] Sem crash ao abrir/fechar a feature várias vezes

### O que NÃO é escopo deste plano

- Validar regra de negócio completa de cada módulo
- Testes de performance / carga
- Validar visual pixel-perfect
- Features **ainda não higienizadas** (podem ser smoke leve no final)

### Prioridade sugerida

1. **P0 — núcleo** (login → sessão → home → saldo)
2. **P1 — features 100/100** (já padronizadas)
3. **P2 — features parciais** (ainda com dívida no scanner)
4. **P3 — smoke restante**

Marque cada cenário: `OK` / `NOK` / `N/A` + observação.

---

## 1. P0 — Núcleo (obrigatório antes do restante)

### 1.1 `session` — Login / sessão / condomínio

**Notas scanner:** Higiene 100 · Padronização 100  
**Por que testar:** sessão alimenta quase todas as outras features.

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| S1 | Login feliz | Abrir app → autenticar com biometria/senha | Entra na home com condomínio selecionado | |
| S2 | Sessão após kill | Logar → matar app → reabrir | Mantém sessão / pede biometria conforme config; não fica em loading eterno | |
| S3 | Troca de condomínio | No seletor da home, trocar condomínio | Loading breve → dados da home/cards batem com o novo condo | |
| S4 | Falha de switch role | (se possível) condo sem permissão / token inválido | Mensagem/erro coerente; não “trava” a sessão | |
| S5 | Logout | Sair da conta | Volta para autenticação; reabrir app não entra logado | |
| S6 | Sem rede no load | Modo avião no cold start (com cache prévio) | Usa cache ou falha controlada; sem crash | |

**Sinais de regressão:** tela preta após login; home sem condo; troca de condo não dispara reload.

---

### 1.2 `home` — Home + dialogs + app bar

**Notas:** 100 / 100  
**Entrada:** após login (aba Home).

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| H1 | Render inicial | Entrar na home | Cards/menu carregam; seletor de condo visível quando aplicável | |
| H2 | Abrir seletor | Tocar no seletor de condomínio | Lista abre; fechar colapsa sem crash | |
| H3 | Dialog permissão notificação | App com permissão negada / nunca pedida | Dialog de permissão (quando devido); fechar segue fluxo | |
| H4 | Dialog comodidades | Conta elegível para “Seu Condomínio” | Dialog aparece no momento certo; fechar não bloqueia home | |
| H5 | Alert switch role | Trocar para condo que exige switch | Alert/fluxo de switch aparece e conclui | |
| H6 | FCM / push args | Abrir app por notificação (se disponível) | Redireciona sem crash | |
| H7 | Scroll app bar | Scrollar lista da home | App bar / lock de scroll não “pula” nem congela | |

**Sinais de regressão:** dialogs em loop; seletor não abre/fecha; crash ao trocar condo na home.

---

### 1.3 `condominium` — Saldo do condomínio + detalhe

**Notas:** 100 / 100  
**Entrada:** card/widget de saldo na home ou hub do condomínio → detalhe do saldo.

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| C1 | Widget saldo na home | Abrir home com condo válido | Saldo carrega (ou skeleton → valor); sem erro permanente | |
| C2 | Cache → remoto | Abrir home com cache antigo | Mostra cache e atualiza quando remoto chega | |
| C3 | Sem condo selecionado | (raro) sessão sem selected | Estado de falha, sem crash | |
| C4 | Detalhe do saldo | Abrir tela de detalhe do saldo | Loading → lista/totais; filtro abre | |
| C5 | Filtro | Aplicar filtro de período/tipo | Lista atualiza conforme filtro | |
| C6 | Troca de condo no detalhe | Com detalhe aberto, trocar condo (se possível) | Recarrega dados do novo condo | |
| C7 | Falha remota com cache | Avião após já ter cache | Mantém dados locais ou indica falha remota | |

**Sinais de regressão:** saldo sempre vazio; detalhe em loading infinito; filtro não aplica.

---

## 2. P1 — Features já padronizadas (100/100 ou ~100)

Testar **smoke + 1 fluxo feliz + 1 fluxo de erro** em cada uma.
Ordem sugerida: da mais usada para a menos usada.

---

### 2.1 `income` — Receitas / boletos / dashboard financeiro

**Notas:** 100 / 100

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| I1 | Dashboard de income | Abrir módulo de receitas/boletos | Cards/gráficos ou lista carregam | |
| I2 | Lista de boletos | Abrir listagem | Itens aparecem; empty state se não houver | |
| I3 | Detalhe de boleto | Abrir um boleto | Detalhe carrega; download (se houver) inicia | |
| I4 | Troca de condo | Trocar condo e voltar | Dados batem com o condo novo | |
| I5 | Erro de rede | Avião na lista | Mensagem/erro ou cache; sem crash | |

---

### 2.2 `unit` — Unidades

**Notas:** 100 / 100

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| U1 | Lista de unidades | Abrir Unidades | Lista carrega / empty state | |
| U2 | Detalhe | Abrir uma unidade | Detalhe carrega | |
| U3 | Convite / vínculo (se existir na conta) | Fluxo de convite até sucesso ou falha | Telas de sucesso/erro corretas | |
| U4 | Troca de condo | Trocar e reabrir lista | Lista do novo condo | |

---

### 2.3 `accountability` — Prestação de contas

**Notas:** 100 / 100

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| A1 | Lista / entrada | Abrir Prestação de contas | Lista ou empty | |
| A2 | Detalhe | Abrir um item | Detalhe carrega | |
| A3 | Aprovação (se perfil permitir) | Aprovar/rejeitar (homolog) | Feedback de sucesso/erro; lista atualiza | |
| A4 | Erro de rede | Avião no detalhe | Estado de falha controlado | |

---

### 2.4 `resin` — Resin (adiantamento / reembolso)

**Notas:** 100 / 100

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| R1 | Menu Resin | Abrir menu Resin | Opções visíveis conforme permissão | |
| R2 | Histórico adiantamento | Abrir histórico | Lista carrega | |
| R3 | Histórico reembolso | Abrir histórico | Lista carrega | |
| R4 | Novo adiantamento (rascunho) | Iniciar criação e voltar | Não crash; estado limpo ao reabrir | |
| R5 | Novo reembolso (rascunho) | Idem | Idem | |
| R6 | Detalhe de recibo | Abrir um recibo | Detalhe carrega | |

---

### 2.5 `staff_access_management` — Acessos de funcionários

**Notas:** 100 / 100 (poucos arquivos de bloc)

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| SA1 | Lista | Abrir gestão de acessos | Lista carrega | |
| SA2 | Adicionar | Abrir formulário de inclusão e cancelar | Volta sem crash | |
| SA3 | Editar | Abrir edição de um item e cancelar | Volta sem crash | |
| SA4 | Fluxo completo (homolog) | Criar/editar com dados válidos | Sucesso ou erro de API esperado | |

---

### 2.6 `gdp` — Gestão de pessoas (funcionários / férias)

**Notas:** 100 / 100 · **19 blocs** (alta cobertura)

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| G1 | Lista de funcionários | Abrir GDP / funcionários | Lista carrega; busca (se houver) filtra | |
| G2 | Detalhe funcionário | Abrir um funcionário | Detalhe carrega | |
| G3 | Férias — lista | Abrir férias | Lista de períodos/funcionários | |
| G4 | Férias — agendar (rascunho) | Iniciar agendamento e voltar | Sem crash; formulário reabre limpo | |
| G5 | Troca de condo | Trocar condo dentro do GDP | Listas recarregam | |
| G6 | Erro de rede | Avião na lista | Falha controlada | |

---

### 2.7 `space` — Espaços / áreas comuns

**Notas:** 100 / 100 · **15 blocs**

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| SP1 | Menu espaços | Abrir módulo | Menu/lista aparece | |
| SP2 | Lista | Abrir lista de espaços | Itens / empty | |
| SP3 | Detalhe | Abrir um espaço | Detalhe carrega | |
| SP4 | Cadastro/edição (rascunho) | Abrir formulário e voltar | Sem crash | |
| SP5 | Troca de condo | Trocar e reabrir | Dados do novo condo | |

---

### 2.8 `payment` — Pagamentos / aprovações / pendências

**Notas:** Higiene 100 · Padronização 95 · **14 blocs**

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| P1 | Lista de pagamentos | Abrir módulo | Lista carrega | |
| P2 | Detalhe / aprovação | Abrir item pendente | Tela de aprovação carrega | |
| P3 | Formulário (passo 1) | Iniciar novo pagamento e avançar 1 passo | Navegação entre steps ok | |
| P4 | Parcelas (passo 2) | Abrir step de parcelas e voltar | Estado do form preservado ou limpo de forma previsível | |
| P5 | Pendência + token (se existir) | Fluxo de token | Validação ok/erro sem crash | |
| P6 | Troca de condo | Trocar e reabrir lista | Lista correta | |

---

### 2.9 `vox` — Vox (comunicações)

**Notas:** Hig. 97 · Padr. 100

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| V1 | Menu / seletor | Abrir Vox | Métodos/opções aparecem | |
| V2 | Nova solicitação (rascunho) | Iniciar request e selecionar destinatários | UI responde; voltar ok | |
| V3 | Histórico | Abrir histórico | Lista carrega | |
| V4 | Detalhe | Abrir um item | Detalhe carrega | |

---

### 2.10 `maintenance_management` — Manutenção (padrão canônico)

**Notas:** Hig. 100 · Padr. 90 · **19 blocs + 5 cubits** (mais crítica)

| # | Cenário | Passos | Resultado esperado | Status |
|---|---------|--------|--------------------|--------|
| M1 | Entrada do módulo | Abrir Manutenção | Hub/lista carrega | |
| M2 | Lista de tarefas | Abrir tarefas | Lista / filtros | |
| M3 | Detalhe da tarefa | Abrir uma tarefa | Detalhe + histórico (se houver) | |
| M4 | Iniciar step / execução | Entrar no fluxo de execução e voltar | Sem crash; progressão coerente | |
| M5 | Editar tarefa (rascunho) | Abrir edição e cancelar | Volta à lista/detalhe | |
| M6 | Relatório | Abrir relatório da tarefa | Carrega / empty | |
| M7 | Charts / dashboards internos | Abrir telas com gráficos (cubits) | Gráficos renderizam ou empty | |
| M8 | Troca de condo | Trocar condo no módulo | Dados recarregam | |
| M9 | Erro de rede | Avião em lista e detalhe | Falha controlada nos dois | |

---

## 3. P2 — Features ainda com dívida no scanner (smoke + atenção)

Estas **não** foram o foco principal da higienização recente, mas aparecem no
app. Fazer smoke curto; bugs aqui podem ser pré-existentes.

| Feature | Hig / Padr | Smoke mínimo |
|---|---|---|
| `dashboard` | 95 / 97 | Abrir dashboard da home; cards carregam; 1 drill-down |
| `dashboard_preferences` | 98 / 97 | Abrir preferências; salvar/cancelar |
| `reports_book` | 98 / 93 | Lista → abrir report → preview/reply se existir |
| `me` | 98 / 94 | Perfil / meus dados carrega; editar foto se existir |
| `access_management` | 98 / 94 | Lista acessos; abrir item |
| `agreements` | 98 / 94 | Lista acordos; abrir item |
| `nonpayment` | 98 / 94 | Lista inadimplência; abrir item |
| `payroll` | 96 / 88 | Lista folha; abrir detalhe/entry |

Para cada uma acima, registrar só:

- [ ] Abre sem crash  
- [ ] Loading resolve  
- [ ] Troca de condo ok (se aplicável)

---

## 4. Matriz rápida de handoff (checklist por feature)

Use esta tabela no dia do teste para status consolidado.

| Feature | Prioridade | Hig/Padr | Testador | Data | Resultado (OK/NOK) | Bugs |
|---|---|---|---|---|---|---|
| session | P0 | 100/100 | | | | |
| home | P0 | 100/100 | | | | |
| condominium | P0 | 100/100 | | | | |
| income | P1 | 100/100 | | | | |
| unit | P1 | 100/100 | | | | |
| accountability | P1 | 100/100 | | | | |
| resin | P1 | 100/100 | | | | |
| staff_access_management | P1 | 100/100 | | | | |
| gdp | P1 | 100/100 | | | | |
| space | P1 | 100/100 | | | | |
| payment | P1 | 100/95 | | | | |
| vox | P1 | 97/100 | | | | |
| maintenance_management | P1 | 100/90 | | | | |
| dashboard | P2 | 95/97 | | | | |
| dashboard_preferences | P2 | 98/97 | | | | |
| reports_book | P2 | 98/93 | | | | |
| me | P2 | 98/94 | | | | |
| access_management | P2 | 98/94 | | | | |
| agreements | P2 | 98/94 | | | | |
| nonpayment | P2 | 98/94 | | | | |
| payroll | P2 | 96/88 | | | | |

---

## 5. Como reportar bug (modelo)

```
Feature:
Cenário (# do plano):
Severidade: Blocker / Alta / Média / Baixa
Dispositivo / SO:
Build / commit:
Passos:
Resultado obtido:
Resultado esperado:
Print/vídeo:
Observação (apareceu após troca de condo? sem rede? primeiro acesso?):
```

### Severidades sugeridas

| Severidade | Exemplo |
|---|---|
| Blocker | Crash ao abrir a feature; impossível logar |
| Alta | Loading infinito; dados de outro condomínio; ação principal falha sempre |
| Média | Empty errado; refresh não atualiza; dialog em loop ocasional |
| Baixa | Glitch visual; mensagem genérica; edge case raro |

---

## 6. Roteiro de 1 dia (sugestão para 1 testador)

| Bloco | Tempo | Escopo |
|---|---|---|
| Manhã 1 | 45–60 min | P0: session + home + condominium |
| Manhã 2 | 60–90 min | income + unit + accountability + payment |
| Tarde 1 | 60–90 min | gdp + space + maintenance_management |
| Tarde 2 | 45–60 min | resin + vox + staff_access + P2 smoke |
| Final | 20 min | Consolidar matriz + abrir bugs |

Se houver só **meio dia**, faça apenas **P0 + payment + maintenance_management + gdp**.

---

## 7. Evidências mínimas a anexar

- [ ] Print da home com condo selecionado
- [ ] Print de 1 tela de lista e 1 de detalhe por feature P0/P1 testada
- [ ] 1 vídeo curto (≤30s) de troca de condomínio na home
- [ ] Log/crashlytics se houver crash

---

*Gerado para acompanhar a higienização de BLoCs do App Síndico.
Notas de scanner referem-se ao `analysis.json` do `dashboard_analise`.*
