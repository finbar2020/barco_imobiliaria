import 'package:essentials/essentials.dart';
import 'package:morar/feature/sub_user/presentation/pages/pending_requests/pending_requests_enum.dart';

class PendingRequestEntity extends Equatable {
  final int id;
  final String typeOfLink;
  final String linkDescription;
  final String requestStatus;
  final DateTime? requestDate;
  final RegistrationOrigin registrationOrigin;
  final DateTime? expirationDate;
  final int unitId;
  final String cpfCnpj;
  final String email;
  final String phone;
  final String name;
  final String remainingDays;

  const PendingRequestEntity({
    required this.id,
    required this.typeOfLink,
    required this.linkDescription,
    required this.requestStatus,
    required this.requestDate,
    required this.registrationOrigin,
    required this.expirationDate,
    required this.unitId,
    required this.cpfCnpj,
    required this.email,
    required this.phone,
    required this.name,
    required this.remainingDays,
  });

  PendingRequestEntity copyWith({
    int? id,
    String? typeOfLink,
    String? linkDescription,
    String? requestStatus,
    DateTime? requestDate,
    RegistrationOrigin? registrationOrigin,
    DateTime? expirationDate,
    int? unitId,
    String? cpfCnpj,
    String? email,
    String? phone,
    String? name,
    String? remainingDays,
  }) {
    return PendingRequestEntity(
      id: id ?? this.id,
      typeOfLink: typeOfLink ?? this.typeOfLink,
      linkDescription: linkDescription ?? this.linkDescription,
      requestStatus: requestStatus ?? this.requestStatus,
      requestDate: requestDate ?? this.requestDate,
      registrationOrigin: registrationOrigin ?? this.registrationOrigin,
      expirationDate: expirationDate ?? this.expirationDate,
      unitId: unitId ?? this.unitId,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      remainingDays: remainingDays ?? this.remainingDays,
    );
  }

  @override
  List<Object?> get props => [
        id,
        typeOfLink,
        linkDescription,
        requestStatus,
        requestDate,
        registrationOrigin,
        expirationDate,
        unitId,
        cpfCnpj,
        email,
        phone,
        name,
        remainingDays,
      ];
}
