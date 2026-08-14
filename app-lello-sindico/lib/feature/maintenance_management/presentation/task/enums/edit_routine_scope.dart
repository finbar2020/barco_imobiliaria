/// Enum para definir o escopo de edição de uma rotina
enum EditRoutineScope {
  /// Editar apenas a tarefa atual (THIS)
  current,

  /// Editar a partir desta tarefa (NEXT)
  fromThis;

  /// Valor para enviar na API
  String get apiValue {
    switch (this) {
      case EditRoutineScope.current:
        return 'THIS';
      case EditRoutineScope.fromThis:
        return 'NEXT';
    }
  }

  /// Título para exibir na UI
  String get displayTitle {
    switch (this) {
      case EditRoutineScope.current:
        return 'Editar tarefa atual';
      case EditRoutineScope.fromThis:
        return 'Editar a partir desta';
    }
  }

  /// Descrição para o info box
  String get infoDescription {
    switch (this) {
      case EditRoutineScope.current:
        return 'Edite apenas a tarefa atual, sem mudar a frequência da rotina.';
      case EditRoutineScope.fromThis:
        return 'Edite o agendamento desta rotina a partir da data desta tarefa.';
    }
  }

  /// Título do card de edição
  String get cardTitle {
    switch (this) {
      case EditRoutineScope.current:
        return 'Editar tarefa atual';
      case EditRoutineScope.fromThis:
        return 'Edite o agendamento a partir desta tarefa';
    }
  }
}
