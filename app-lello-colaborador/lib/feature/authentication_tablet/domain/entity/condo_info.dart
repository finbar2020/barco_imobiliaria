class CondoInfo {
  final String reference;
  final String name;
  final String picturehash;
  final String status;

  ///Referencia sem hash da c# para busca do firebase
  final String ref;

  CondoInfo({
    required this.reference,
    required this.name,
    required this.picturehash,
    required this.status,
    required this.ref,
  });
}
