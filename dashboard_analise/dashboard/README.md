# Lello Morar · Análise Arquitetural

Dashboard Flutter Web para inspecionar os projetos do monorepo
`app-lello-morar` com foco em **arquitetura** e **gerenciamento de estado**.

## Como funciona

Duas partes:

1. **Scanner Dart** (`tool/analyze_projects.dart`)
   Percorre a pasta pai (`../../`, ou seja `app-lello-morar/`), inspeciona
   cada projeto Flutter/Dart encontrado e gera um relatório em
   `assets/analysis.json`. O próprio projeto `dashboard_analise` é excluído.

2. **App Flutter Web** (`lib/`)
   Consome `assets/analysis.json` e mostra:
   - KPIs globais (projetos, LOC, arquivos, features, Flutter FVM, cobertura média)
   - Cobertura de testes **separada por projeto** (lcov.info)
   - Versão Flutter pinada no `.fvmrc` (a que o time atualizou)
   - Bibliotecas em uso (versões pinadas — sem marcar como desatualizadas)
   - Distribuição de padrões arquiteturais
   - Distribuição de padrões arquiteturais
   - Distribuição de gerenciamento de estado
   - LOC e features por projeto
   - Cobertura Clean Architecture nas features (%)
   - Grafo do monorepo (path deps)
   - Ranking de pacotes usados
   - Card por projeto com **análise detalhada** ao clicar

## Uso

```bash
# 1. Instalar dependências
flutter pub get

# 2. Regenerar o relatório sempre que o código dos projetos mudar
dart run tool/analyze_projects.dart

# 3. Rodar em desenvolvimento
flutter run -d chrome

# ou gerar o build estático
flutter build web
```

## O que é detectado

### Arquitetura

- `Feature-first + Clean Architecture` — quando existe `lib/feature/` (ou
  `features/`, `modules/`) e a maioria das features tem `data/`, `domain/`
  e `presentation/`
- `Feature-first` — features detectadas sem estrutura Clean consistente
- `Layer-first` — top-level `screens/`, `widgets/`, `models/`, etc
- `Flat` / `Misto/Indefinido` — quando nada bate

Para cada feature: presença das três camadas, arquivos, LOC, e subpastas
canônicas de `presentation/` (bloc, cubit, controllers, pages, widgets...).

### Gerenciamento de estado

Score combinado de:
- pacotes no pubspec (`flutter_bloc`, `provider`, `flutter_riverpod`,
  `mobx`, `get`, etc)
- **uso real no código**:
  - `extends Bloc<>` / `extends Cubit<>`
  - `extends ChangeNotifier` + `Provider.of` / `Consumer` / `context.watch`
  - `ConsumerWidget` / `WidgetRef` (Riverpod)
  - `extends GetxController` (GetX)
  - `@observable` / `@action` (MobX)
  - `setState()` (fallback)

O padrão “primário” é o que teve maior score. Isso é útil no monorepo em
que os apps não declaram `flutter_bloc` diretamente — ele vem via
`essentials`, mas o scan de código identifica corretamente.

### Higiene e padronização de BLoC

O scanner gera duas notas por feature (0–100) e agrega no projeto
(média ponderada por blocs+cubits). A referência é o **Síndico
higienizado** — não um checklist que penaliza o próprio padrão:

- **Higiene** (`grade`) — events/states em arquivos próprios e sem
  `print`. O par abstract+impl **é o padrão** (não é fricção).
  `mapEventToState`, Equatable e `const` não entram na nota: atualizar
  isso quebra o app.
- **Padronização** (`standardization.grade`) — sufixos `State`/`Event`
  e `Initial` (não `Idle`). Estado único de form, base sem `const` e
  ausência de Equatable são aceitos.

As penalidades são **proporcionais** (desvio / total), para um app com
dezenas de blocs não zerar a nota por poucos casos pontuais.

### Cobertura de testes

Lê `coverage/lcov.info` de cada app (quando existir) e mostra o % de linhas
coberto, separado por projeto. Também conta arquivos de teste e imagens
golden (`test/**/goldens/*.png`). Sem lcov, o card aparece como “sem dados”.

### Flutter (versão atualizada)

Lê `.fvmrc` / `.fvm/fvm_config.json` — essa é a versão que o time pinou
(FVM). Complementa com constraints de Dart/Flutter do `pubspec.yaml` e
`pubspec.lock`.

### Bibliotecas em uso

Mostra as versões **pinadas** no `pubspec.yaml` de cada projeto. Não marca
como desatualizadas: o time não sobe essas libs porque a atualização
quebra o app.

### Branches deste trabalho

Lê o Git de cada app e destaca as três branches que criamos:

- `feature/all_tests` — testes (unitário, integração, interação, golden)
- `feature/libs-upgrade-wave0` — upgrade de libs (versões pinadas)
- `feature/bloc-9-migration` — higienização e padronização dos BLoCs

Mostra em quais apps cada uma existe e qual está checkout no momento.

### Outros dados

- Plataformas suportadas (android/ios/web/windows/macos/linux)
- Dependências categorizadas (Estado, DI, HTTP, Firebase, Storage local,
  Roteamento, Monitoramento, UI, Utilidades)
- Path dependencies destacadas (monorepo)
- Arquivos gerados (`.g.dart`, `.freezed.dart`, `.chopper.dart`, `.gr.dart`)

## Estrutura do dashboard

```
lib/
├── main.dart
├── app.dart
├── models/
│   └── analysis_data.dart      # Modelos que espelham o JSON
├── services/
│   └── analysis_loader.dart    # Lê assets/analysis.json
├── theme/
│   └── app_theme.dart          # Tema dark + paleta de charts
├── screens/
│   ├── overview_screen.dart    # Métricas globais
│   └── project_detail_screen.dart
└── widgets/
    ├── section_card.dart
    ├── metric_tile.dart
    ├── project_card.dart
    ├── labeled_progress.dart
    └── charts/
        ├── distribution_pie.dart
        └── horizontal_bar_chart.dart

tool/
└── analyze_projects.dart       # Scanner CLI

assets/
└── analysis.json               # (gerado)
```

## Regenerar apontando para outra pasta

```bash
dart run tool/analyze_projects.dart "C:\\caminho\\outra\\pasta"
```

O scanner exclui automaticamente qualquer pasta chamada `dashboard_analise`.
