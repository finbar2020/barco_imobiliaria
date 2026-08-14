enum LedgerAccountType {
  all,
  ordinary,
  extraordinary,
}

String ledgerAccountTypeToString(LedgerAccountType type) {
  switch (type) {
    case LedgerAccountType.all:
      return 'Todos';
    case LedgerAccountType.ordinary:
      return 'Ordinária';
    case LedgerAccountType.extraordinary:
      return 'Extraordinária';
    default:
      return 'Ordinária';
  }
}

List<LedgerAccountType> getLedgerAccountTypes() {
  return [
    LedgerAccountType.ordinary,
    LedgerAccountType.extraordinary,
    LedgerAccountType.all
  ];
}
