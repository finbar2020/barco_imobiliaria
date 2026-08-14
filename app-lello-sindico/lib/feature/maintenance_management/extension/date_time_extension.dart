extension DateTimeRelative on DateTime {
  /// Calcula o texto relativo para data de criação baseado na diferença de tempo
  /// Seguindo os critérios:
  /// - "Criada hoje" para data presente
  /// - "Criada há 1 dia" / "Criada há X dias" 
  /// - "Criada há 1 mês" / "Criada há X meses"
  /// - "Criada há 1 ano" / "Criada há X anos"
  String get createdRelativeText {
    final now = DateTime.now();
    return createdRelativeTextFrom(now);
  }

  /// Calcula o texto relativo para data de criação baseado em uma data de referência específica
  /// Útil para planejamento rápido onde comparamos com a data selecionada no calendário
  String createdRelativeTextFrom(DateTime referenceDate) {
    final difference = referenceDate.difference(this);
    
    print('Created: $this, Reference: $referenceDate, Difference: ${difference.inDays} days'); // Debug
    
    // Se foi criada hoje (mesma data)
    if (difference.inDays == 0) {
      return 'Criada hoje';
    }
    
    // Se foi criada há X dias (menos que um mês)
    if (difference.inDays < 30) {
      final days = difference.inDays;
      return days == 1 ? 'Criada há 1 dia' : 'Criada há $days dias';
    }
    
    // Se foi criada há X meses (menos que um ano)
    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? 'Criada há 1 mês' : 'Criada há $months meses';
    }
    
    // Se foi criada há X anos
    final years = (difference.inDays / 365).floor();
    return years == 1 ? 'Criada há 1 ano' : 'Criada há $years anos';
  }
}