# Padrões de Desenvolvimento — app-lello-sindico

Guia para novas features. O objetivo é manter o código **fácil de manter e de
entender**, seguindo um padrão único de arquitetura e de gerenciamento de estado
(BLoC) em todo o app.

> Antes de abrir PR, rode o checklist do final. A aderência a estes padrões é
> medida pelo dashboard de análise (`dashboard_analise/`), na seção
> **"Higiene e padronização de blocs/cubits"**.

---

## 1. Princípios

- **Feature-first + Clean Architecture**: cada feature é isolada em
  `lib/feature/<feature>/` e dividida em três camadas: `domain`, `data`,
  `presentation`.
- **Dependências apontam para dentro**: `presentation` → `domain` ← `data`.
  A `domain` não conhece Flutter, HTTP nem models. A `data` implementa os
  contratos da `domain`.
- **BLoC (event-driven)** como padrão de gerenciamento de estado.
- **Injeção de dependência** centralizada no `ApplicationContainer` (GetIt).
- **Sem regra de negócio na UI**: a `presentation` só reage a estados e
  dispara eventos.

---

## 2. Estrutura de pastas de uma feature

```
lib/feature/<feature>/
├── domain/
│   ├── entity/                      # Entidades puras (sem json, sem Flutter)
│   │   └── <entidade>.dart
│   ├── repository/                  # Contratos (abstract)
│   │   └── <feature>_repository.dart
│   └── use_case/
│       └── <acao>/
│           ├── <acao>.dart          # Contrato: extends UseCase<Result, Param>
│           └── <acao>_impl.dart     # Implementação
├── data/
│   ├── model/                       # DTOs (json) + toEntity()
│   │   ├── <entidade>_model.dart
│   │   └── <entidade>_model.g.dart  # gerado (build_runner)
│   ├── data_source/
│   │   └── remote/
│   │       ├── <feature>_remote_data_source.dart       # contrato
│   │       └── <feature>_remote_data_source_impl.dart  # implementação
│   └── repository/
│       └── <feature>_repository_impl.dart
└── presentation/
    └── <tela>/
        ├── bloc/
        │   ├── <tela>_bloc.dart
        │   ├── <tela>_event.dart
        │   └── <tela>_state.dart
        ├── page/
        │   └── <tela>_page.dart
        └── widgets/
```

Regras:

- Uma pasta por **tela/fluxo** dentro de `presentation` (ex.: `list`, `detail`,
  `create`). Cada uma tem seu próprio bloc.
- Arquivos de bloc **sempre** dentro de `bloc/` e nomeados
  `<x>_bloc.dart`, `<x>_event.dart`, `<x>_state.dart`.

---

## 3. Camada `presentation` — o padrão BLoC canônico

Este é o coração da padronização. Use **`Bloc<Event, State>`** com **estados em
subclasses** e `Equatable`.

### 3.1 State

```dart
import 'package:essentials/essentials.dart';
import '../../../domain/entity/notice.dart';

abstract class NoticeListState extends Equatable {
  const NoticeListState();

  @override
  List<Object?> get props => [];
}

class NoticeListInitialState extends NoticeListState {
  const NoticeListInitialState();
}

class NoticeListLoadingState extends NoticeListState {
  const NoticeListLoadingState();
}

class NoticeListLoadedState extends NoticeListState {
  final List<Notice> notices;

  const NoticeListLoadedState({required this.notices});

  @override
  List<Object?> get props => [notices];
}

class NoticeListErrorState extends NoticeListState {
  final String message;

  const NoticeListErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
```

Regras do State:

- Base `abstract class XxxState extends Equatable` com **construtor `const`** e
  `props`.
- Todas as subclasses são **`const`**, com campos **`final`** e sobrescrevem
  `props` com todos os campos.
- Sufixo **`State`** em **todas** as subclasses.
- Estado inicial chamado **`InitialState`** (nunca `Idle`).
- Ciclo padrão: `Initial → Loading → Loaded → Error`. Use `EmptyState` quando
  "vazio" for visualmente diferente de "carregado".
- Erro representado por um **`XxxErrorState` dedicado** com `String message`.

### 3.2 Event

```dart
import 'package:essentials/essentials.dart';

abstract class NoticeListEvent extends Equatable {
  const NoticeListEvent();

  @override
  List<Object?> get props => [];
}

class LoadNoticeListEvent extends NoticeListEvent {
  const LoadNoticeListEvent();
}

class RefreshNoticeListEvent extends NoticeListEvent {
  const RefreshNoticeListEvent();
}
```

Regras do Event:

- Base `abstract class XxxEvent extends Equatable` com `const` e `props`.
- Sufixo **`Event`** em **todas** as subclasses.
- Subclasses `const`, campos `final`, `props` preenchido.

### 3.3 Bloc

```dart
import 'package:essentials/essentials.dart';
import '../../../domain/use_case/list_notices/list_notices.dart';
import 'notice_list_event.dart';
import 'notice_list_state.dart';

class NoticeListBloc extends Bloc<NoticeListEvent, NoticeListState> {
  final ListNotices listNotices;

  NoticeListBloc({required this.listNotices})
      : super(const NoticeListInitialState()) {
    on<LoadNoticeListEvent>(_onLoad);
    on<RefreshNoticeListEvent>(_onLoad);
  }

  Future<void> _onLoad(
    NoticeListEvent event,
    Emitter<NoticeListState> emit,
  ) async {
    emit(const NoticeListLoadingState());

    final result = await listNotices(
      const ListNoticesParam(condominiumId: ''),
    );

    result.fold(
      (failure) => emit(NoticeListErrorState(_messageFor(failure))),
      (notices) => emit(NoticeListLoadedState(notices: notices)),
    );
  }

  String _messageFor(Failure failure) =>
      failure is KnownFailure ? failure.message : 'notice_list_generic_error';
}
```

Regras do Bloc:

- `extends Bloc<Event, State>`. **Não** usar `Cubit` para telas com múltiplos
  eventos (Cubit só para casos triviais de estado local).
- **Sem** `mapEventToState` (API antiga do bloc). Use `on<Event>(handler)`.
- **Sem** `print` — use o logger padrão do app quando necessário.
- **Sem** `abstract` + `_impl` para bloc. O bloc é concreto e recebe os
  use cases pelo construtor.
- Importe via `package:essentials/essentials.dart` (reexporta `bloc`,
  `equatable`, `Failure`, `Try`, etc.).

### 3.4 Exibir feedback (snackbar/flushbar) — NÃO mutar o estado

Mostre mensagens de feedback no **`listener` do `BlocConsumer`** (dispara uma
vez por mudança de estado). **Nunca** mute o estado na UI (ex.:
`bloc.state.message = null`) — isso quebra a imutabilidade e o `Equatable`.

```dart
BlocConsumer<NoticeListBloc, NoticeListState>(
  listener: (context, state) {
    if (state is NoticeListErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getString(context, state.message))),
      );
    }
  },
  builder: (context, state) {
    if (state is NoticeListLoadingState) return const LoadingWidget();
    if (state is NoticeListErrorState) return ErrorHandlingWidget(/* ... */);
    if (state is NoticeListLoadedState) return _buildList(state.notices);
    return const SizedBox.shrink();
  },
);
```

### 3.5 Exceção: estado único para formulários/wizards

Para **formulários e wizards** (muitos campos, um fluxo), é aceitável um
**estado único** com `status` enum + `copyWith` (ex.: `vox`, e os form-blocs de
`maintenance_management`). Regras:

- Campos `final`, construtor `const`, `copyWith`, `factory Xxx.initial()`.
- Um enum de `status` (`loading`, `ready`, `submitting`, `success`, `failure`).
- **Atenção com `Equatable`**: se o fluxo depende de reemitir um estado
  "igual" para forçar rebuild (ex.: `emit(state.copyWith())` ao mudar um campo),
  **não** use `Equatable` nesse state — o bloc descartaria o emit igual. Nesse
  caso, o estado único **sem** `Equatable` é a escolha correta.

---

## 4. Camada `domain`

### 4.1 Entity

Entidade pura, sem json e sem Flutter. Representa o conceito de negócio.

```dart
class Notice {
  final String id;
  final String title;
  final String body;
  final DateTime? publishedAt;

  const Notice({
    required this.id,
    required this.title,
    required this.body,
    this.publishedAt,
  });
}
```

### 4.2 Repository (contrato)

```dart
import 'package:essentials/essentials.dart';
import '../entity/notice.dart';

abstract class NoticeRepository {
  Future<Try<List<Notice>>> listNotices(String condominiumId);
}
```

- Sempre retorne `Future<Try<T>>` (`Try` = `Success | Rejection`, do essentials).

### 4.3 Use Case

Um use case por ação. Contrato estende `UseCase<Result, Param>`.

```dart
// list_notices.dart
import 'package:essentials/essentials.dart';
import '../../entity/notice.dart';

abstract class ListNotices extends UseCase<List<Notice>, ListNoticesParam> {}

class ListNoticesParam {
  final String condominiumId;

  const ListNoticesParam({required this.condominiumId});
}
```

```dart
// list_notices_impl.dart
import 'package:essentials/essentials.dart';
import '../../entity/notice.dart';
import '../../repository/notice_repository.dart';
import 'list_notices.dart';

class ListNoticesImpl extends ListNotices {
  final NoticeRepository repository;

  ListNoticesImpl({required this.repository});

  @override
  Future<Try<List<Notice>>> call(ListNoticesParam? params) async {
    final error = _validate(params);
    if (error != null) return Rejection(error);

    return repository.listNotices(params!.condominiumId);
  }

  Failure? _validate(ListNoticesParam? params) {
    if (params == null) return InvalidParamFailure();
    if (params.condominiumId.isEmpty) return InvalidParamFailure();
    return null;
  }
}
```

---

## 5. Camada `data`

### 5.1 Model (DTO)

Usa `json_serializable`. Sempre expõe `toEntity()` para converter para a
entidade da `domain`.

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entity/notice.dart';

part 'notice_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NoticeModel {
  final String? id;
  final String? title;
  final String? body;
  final String? publishedAt;

  NoticeModel({this.id, this.title, this.body, this.publishedAt});

  factory NoticeModel.fromJson(Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);
  Map<String, dynamic> toJson() => _$NoticeModelToJson(this);

  Notice toEntity() => Notice(
        id: id ?? '',
        title: title ?? '',
        body: body ?? '',
        publishedAt: DateTime.tryParse(publishedAt ?? ''),
      );
}
```

> Após criar/alterar models, rode: `dart run build_runner build --delete-conflicting-outputs`

### 5.2 Data Source (remoto)

```dart
// notice_remote_data_source.dart
import '../../model/notice_model.dart';

abstract class NoticeRemoteDataSource {
  Future<List<NoticeModel>> listNotices(String condominiumId);
}
```

```dart
// notice_remote_data_source_impl.dart
import '../../model/notice_model.dart';
import 'notice_remote_data_source.dart';

class NoticeRemoteDataSourceImpl extends NoticeRemoteDataSource {
  final NoticeApi api;

  NoticeRemoteDataSourceImpl({required this.api});

  @override
  Future<List<NoticeModel>> listNotices(String condominiumId) async {
    final response = await api.listNotices(condominiumId);
    return response.body ?? [];
  }
}
```

### 5.3 Repository (implementação)

Converte model → entity e **encapsula erros** em `Try` (nunca deixa exceção
vazar).

```dart
import 'package:essentials/essentials.dart';
import '../data_source/remote/notice_remote_data_source.dart';
import '../../domain/entity/notice.dart';
import '../../domain/repository/notice_repository.dart';

class NoticeRepositoryImpl extends NoticeRepository {
  final NoticeRemoteDataSource remoteDataSource;

  NoticeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Try<List<Notice>>> listNotices(String condominiumId) async {
    try {
      final result = await remoteDataSource.listNotices(condominiumId);
      return Success(result.map((m) => m.toEntity()).toList());
    } catch (err) {
      return Rejection(UnknownFailure(err));
    }
  }
}
```

---

## 6. Tratamento de erros

- Fluxo de dados sempre em `Try<T>` (`Success(data)` / `Rejection(failure)`).
- Falhas conhecidas: `KnownFailure` (tem `.message`), `InvalidParamFailure`.
  Genéricas: `UnknownFailure(err)`.
- No bloc, extraia a mensagem de forma consistente:

```dart
String _messageFor(Failure failure) =>
    failure is KnownFailure ? failure.message : 'chave_de_erro_generico';
```

- Na `presentation`, o estado de erro é sempre um `XxxErrorState(message)`.

---

## 7. Injeção de dependência (`ApplicationContainer`)

Registre a stack da feature no `ApplicationContainer`
(`lib/core/dependency/application_container.dart`). Padrão: **`registerFactory`**
para data source, repository, use cases e blocs.

```dart
// API / Data source
locator.registerFactory<NoticeApi>(() => NoticeApi.create(resolve()));
locator.registerFactory<NoticeRemoteDataSource>(
    () => NoticeRemoteDataSourceImpl(api: resolve()));

// Repository
locator.registerFactory<NoticeRepository>(
    () => NoticeRepositoryImpl(remoteDataSource: resolve()));

// Use cases
locator.registerFactory<ListNotices>(
    () => ListNoticesImpl(repository: resolve()));

// Bloc
locator.registerFactory<NoticeListBloc>(
    () => NoticeListBloc(listNotices: resolve()));
```

Regras:

- **Registre sempre** o bloc no container (não deixe blocs órfãos criados
  soltos na rota). Exceção: blocs que dependem de parâmetros de runtime (ex.:
  um `id`) podem ser criados na rota, passando o(s) use case(s) via `resolve()`.
- Use `registerLazySingleton` apenas para estado que deve **persistir** entre
  telas (ex.: caches). O padrão é `registerFactory`.

### 7.1 Provendo o bloc na tela

```dart
BlocProvider<NoticeListBloc>(
  create: (_) => ApplicationContainer.instance().resolve<NoticeListBloc>()
    ..add(const LoadNoticeListEvent()),
  child: const NoticeListView(),
);
```

---

## 8. Exemplo completo (todas as camadas)

Feature fictícia **`notice`** (mural de avisos), tela de listagem. Junta tudo o
que foi mostrado acima:

```
lib/feature/notice/
├── domain/
│   ├── entity/notice.dart                                   # §4.1
│   ├── repository/notice_repository.dart                    # §4.2
│   └── use_case/list_notices/
│       ├── list_notices.dart                                # §4.3
│       └── list_notices_impl.dart                           # §4.3
├── data/
│   ├── model/notice_model.dart (+ .g.dart)                  # §5.1
│   ├── data_source/remote/
│   │   ├── notice_remote_data_source.dart                   # §5.2
│   │   └── notice_remote_data_source_impl.dart              # §5.2
│   └── repository/notice_repository_impl.dart               # §5.3
└── presentation/list/
    ├── bloc/
    │   ├── notice_list_bloc.dart                            # §3.3
    │   ├── notice_list_event.dart                           # §3.2
    │   └── notice_list_state.dart                           # §3.1
    └── page/notice_list_page.dart
```

`notice_list_page.dart`:

```dart
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import '../bloc/notice_list_bloc.dart';
import '../bloc/notice_list_event.dart';
import '../bloc/notice_list_state.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoticeListBloc>(
      create: (_) => ApplicationContainer.instance().resolve<NoticeListBloc>()
        ..add(const LoadNoticeListEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Avisos')),
        body: BlocConsumer<NoticeListBloc, NoticeListState>(
          listener: (context, state) {
            if (state is NoticeListErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(getString(context, state.message))),
              );
            }
          },
          builder: (context, state) {
            if (state is NoticeListLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NoticeListLoadedState) {
              return ListView.builder(
                itemCount: state.notices.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(state.notices[i].title),
                  subtitle: Text(state.notices[i].body),
                ),
              );
            }
            if (state is NoticeListErrorState) {
              return Center(child: Text(getString(context, state.message)));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

---

## 9. Checklist antes do PR

Estado / Evento:

- [ ] Base `abstract ... extends Equatable` com construtor `const` e `props`.
- [ ] Subclasses `const`, campos `final`, `props` com todos os campos.
- [ ] Sufixo `State` / `Event` em **todas** as subclasses.
- [ ] Estado inicial chamado `InitialState` (não `Idle`).
- [ ] Erro em `XxxErrorState(message)` dedicado.

Bloc:

- [ ] `extends Bloc<Event, State>`, `on<Event>()` (sem `mapEventToState`).
- [ ] Sem `print`. Sem `abstract` + `_impl` de bloc.
- [ ] Use cases injetados via construtor.
- [ ] Import via `package:essentials/essentials.dart`.

UI:

- [ ] Feedback (snackbar/flushbar) no `listener`, **nunca** mutando o estado.

Domain / Data:

- [ ] Entidade pura (sem json/Flutter). Model com `toEntity()`.
- [ ] Repositório retorna `Try<T>`; impl encapsula exceções em `Rejection`.
- [ ] Use case `extends UseCase<Result, Param>` com `validate`.

DI:

- [ ] Data source, repository, use cases e bloc registrados no
      `ApplicationContainer` (`registerFactory`, salvo caches).

Geral:

- [ ] `dart run build_runner build --delete-conflicting-outputs` (se mexeu em model).
- [ ] `flutter analyze` sem issues.

---

## 10. Referência

- Features já 100% padronizadas (use como referência de código):
  `accountability`, `resin`, `income`.
- Padrão de estado único (form/wizard): `vox`,
  `maintenance_management/.../task/bloc/init_step`.
- Métricas de aderência: `dashboard_analise/` (rode
  `dart run tool/analyze_projects.dart` e veja a seção "Higiene e padronização
  de blocs/cubits").
