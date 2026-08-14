class SupplierLedgerAccount {
  int? id;
  String? name;

  SupplierLedgerAccount({
    this.id,
    this.name,
  });

  @override
  String toString() {
    return 'SupplierLedgerAccount(id: $id, name: $name)';
  }
}
