class Bank {
  int? id;
  String? name;
  String? code;

  Bank({
    this.id,
    this.name,
    this.code,
  });
  @override
  String toString() {
    return 'Bank(id: $id, name: $name, code: $code)';
  }
}
