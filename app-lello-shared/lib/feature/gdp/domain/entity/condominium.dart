// import 'package:equatable/equatable.dart';

class CondominiumGDP {
  final String id;
  final String? name;
  final String reference;

  CondominiumGDP({
    required this.id,
    this.name,
    required this.reference,
  });

  factory CondominiumGDP.clone(CondominiumGDP condominium) => CondominiumGDP(
        id: condominium.id,
        name: condominium.name,
        reference: condominium.reference,
      );

  factory CondominiumGDP.fromMe(condominium) => CondominiumGDP(
        id: condominium?.id ?? "",
        name: condominium?.name,
        reference: condominium?.condominiumId ?? "",
      );

  List<Object?> get props => [id, name, reference];
}
