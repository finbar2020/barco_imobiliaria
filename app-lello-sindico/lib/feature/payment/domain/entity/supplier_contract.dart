class SupplierContract {
  int? id;
  String? code;

  SupplierContract({
    this.id,
    this.code,
  });
  @override
  String toString() {
    return 'SupplierContract(id: $id, code: $code)';
  }
}
