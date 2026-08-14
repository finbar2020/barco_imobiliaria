import 'package:essentials/essentials.dart';

import '../../domain/entity/pending_request.dart';
import '../../presentation/pages/pending_requests/pending_requests_enum.dart';

part 'pending_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class PendingRequestModel {
  final int? id;
  final String? typeOfLink;
  final String? linkDescription;
  final String? requestStatus;
  final DateTime? requestDate;
  final String? registrationOrigin;
  final DateTime? expirationDate;
  final int? unitId;
  final String? cpfCnpj;
  final String? email;
  final String? phone;
  final String? name;
  final String? remainingDays;

  const PendingRequestModel({
    this.id,
    this.typeOfLink,
    this.linkDescription,
    this.requestStatus,
    this.requestDate,
    this.registrationOrigin,
    this.expirationDate,
    this.unitId,
    this.cpfCnpj,
    this.email,
    this.phone,
    this.name,
    this.remainingDays,
  });

  factory PendingRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PendingRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$PendingRequestModelToJson(this);
}

extension PendingRequestModelX on PendingRequestModel {
  PendingRequestEntity toEntity() {
    return PendingRequestEntity(
      id: this.id ?? 0,
      typeOfLink: typeOfLink ?? '',
      linkDescription: linkDescription ?? '',
      requestStatus: requestStatus ?? '',
      requestDate: requestDate,
      registrationOrigin: RegistrationOrigin.values.firstWhere(
        (e) => e.value.toLowerCase() == registrationOrigin?.toLowerCase(),
        orElse: () => RegistrationOrigin.lelloRegistration,
      ),
      expirationDate: expirationDate,
      unitId: unitId ?? 0,
      cpfCnpj: cpfCnpj ?? '',
      email: email ?? '',
      phone: phone ?? '',
      name: name ?? '',
      remainingDays: remainingDays ?? '',
    );
  }
}
