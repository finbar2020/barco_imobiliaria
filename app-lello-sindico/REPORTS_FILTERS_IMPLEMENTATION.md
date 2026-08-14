# Implementação dos Novos Filtros para Reports

## Resumo das Alterações

Foi implementado suporte aos novos campos de filtro no endpoint BFF dos dados do gráfico conforme solicitado. A implementação inclui todos os campos mencionados no body de exemplo.

## Arquivos Modificados

### 1. **FormularyByMonthRequestModel** 
`lib/feature/maintenance_management/data/model/formulary_by_month_request_model.dart`

- Adicionadas classes `FormularyByMonthCursorModel` e `FormularyByMonthFiltersModel`
- Incluídos todos os novos campos de filtro:
  - `display`, `displayBy`, `dayCurrent`
  - `cursor` (after, before, first, last)
  - `responsibleIds`, `assetIds`, `localIds`
  - `typeTask`, `status`
  - `localGroupIds`, `procedureIds`, `assetGroupIds`, `sectorIds`

### 2. **GetFormularyByMonthUseCase**
`lib/feature/maintenance_management/domain/use_cases/get_formulary_by_month_use_case.dart`

- Estendido `GetFormularyByMonthParams` para incluir todos os novos parâmetros
- Atualizado `GetFormularyByMonthUseCaseImpl` para repassar os filtros ao repository

### 3. **MaintenanceManagementRepository**
`lib/feature/maintenance_management/domain/repository/maintenance_management_repository.dart`

- Atualizada assinatura do método `getFormularyByMonth` para aceitar todos os novos filtros

### 4. **MaintenanceManagementRepositoryImpl**
`lib/feature/maintenance_management/data/repository/maintenance_management_repository_impl.dart`

- Implementada lógica para construir o request com os filtros estendidos
- Tratamento automático de valores padrão (dayCurrent, cursor, etc.)

### 5. **VisualizeReportsBloc**
- Novos eventos: `LoadFormularyByMonthWithFiltersEvent`
- Método público: `loadFormularyWithFilters()` para facilitar o uso
- Mantida compatibilidade com implementação anterior

### 6. **VisualizeReportsPage**
- Atualizado `_loadReports()` como exemplo de uso dos novos filtros
- Demonstração de como aplicar filtros específicos

## Como Usar

### Exemplo Básico (compatibilidade mantida):
```dart
_reportsBloc.add(LoadFormularyByMonthEvent(
  dtStart: "01/09/2025",
  untilDate: "30/09/2025",
));
```

### Exemplo com Filtros Estendidos:
```dart
_reportsBloc.loadFormularyWithFilters(
  dtStart: "01/09/2025",
  untilDate: "30/09/2025",
  display: "GRUPO",
  displayBy: "GRUPO",
  typeTask: ["ROTINA"],
  status: ["FINALIZADA", "NAO_INICIADA"],
  responsibleIds: ["resp1", "resp2"],
  assetIds: ["asset1", "asset2"],
  localIds: ["local1", "local2"],
  localGroupIds: ["group1", "group2"],
  procedureIds: ["proc1", "proc2"],
  assetGroupIds: ["assetGroup1", "assetGroup2"],
  sectorIds: ["sector1", "sector2"],
);
```

## Body de Request Gerado

O request agora segue exatamente a estrutura solicitada:

```json
{
  "dtStart": "2025-09-10",
  "untilDate": "2025-09-10",
  "filters": {
    "dtStart": "2025-09-10",
    "untilDate": "2025-09-10",
    "display": "GRUPO",
    "dayCurrent": "2025-09-10",
    "displayBy": "GRUPO",
    "cursor": {
      "after": "string",
      "before": "string",
      "first": 1073741824,
      "last": 1073741824
    },
    "responsibleIds": ["string"],
    "assetIds": ["string"],
    "localIds": ["string"],
    "typeTask": ["ROTINA"],
    "status": ["NOT_STARTED"],
    "localGroupIds": ["string"],
    "procedureIds": ["string"],
    "assetGroupIds": ["string"],
    "sectorIds": ["string"]
  }
}
```

## Compatibilidade

- ✅ Mantida compatibilidade com implementação anterior
- ✅ Todos os novos campos são opcionais
- ✅ Valores padrão aplicados automaticamente quando necessário
- ✅ EfficiencyCardWidget continua funcionando normalmente

## Próximos Passos

1. **Gerar arquivos .g.dart**: `flutter packages pub run build_runner build`
2. **Implementar UI para filtros**: Criar interface para usuário configurar filtros
3. **Testes**: Validar integração com backend
4. **Documentação**: Atualizar documentação da API
