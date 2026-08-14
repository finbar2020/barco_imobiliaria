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
   - KPIs globais (projetos, LOC, arquivos, features)
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
(média ponderada por blocs+cubits):

- **Higiene** (`grade`) — fricção técnica: Equatable, events/states
  separados, sem `print`, sem `mapEventToState`, sem pares abstract+impl.
- **Padronização** (`standardization.grade`) — aderência ao padrão canônico
  (`PADROES_DE_DESENVOLVIMENTO.md`): sufixos `State`/`Event`, `InitialState`
  (não `Idle`), base `const`, sem `Outcome` enum; estado único de form é
  aceitável.

O dashboard mostra ambas na overview, nos cards de projeto e no detalhe.

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
