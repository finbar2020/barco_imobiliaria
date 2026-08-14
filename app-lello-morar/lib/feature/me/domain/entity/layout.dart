class Layout {
  String cod;
  String name;
  String reference;
  String primary;
  String secondary;
  String logoPath;

  Layout({
    this.cod = "",
    this.name = "",
    this.reference = "",
    this.primary = "",
    this.secondary = "",
    this.logoPath = "",
  });

  String get companyName => name;
}
