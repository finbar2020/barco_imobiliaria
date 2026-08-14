// ignore_for_file: public_member_api_docs, sort_constructors_first
class City {
  final int ibgeCode;
  final String name;
  City({
    required this.ibgeCode,
    required this.name,
  });

  @override
  bool operator ==(covariant City other) {
    if (identical(this, other)) return true;

    return other.ibgeCode == ibgeCode && other.name == name;
  }

  @override
  int get hashCode => ibgeCode.hashCode ^ name.hashCode;
}
