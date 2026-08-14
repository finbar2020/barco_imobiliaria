import 'package:equatable/equatable.dart';
import 'package:lello/feature/condominium/domain/entity/condominium_manager_biometric_status.dart';
import 'package:lello/feature/condominium/domain/entity/layout.dart';

class Condominium extends Equatable {
  final String id;
  final String? name;
  final String? number;
  final String? address;
  final String? regulationUrl;
  final Layout? layout;
  final String reference;
  final bool useFacialBiometric;
  final CondominiumManagerAccessControlBiometricStatusEnum
      managerAccessControlBiometricStatus;
  final String? notificationContext;

  const Condominium({
    required this.id,
    this.name,
    this.address,
    this.regulationUrl,
    required this.reference,
    this.number,
    this.useFacialBiometric = false,
    this.layout,
    this.managerAccessControlBiometricStatus =
        CondominiumManagerAccessControlBiometricStatusEnum.unavailable,
    this.notificationContext,
  });

  factory Condominium.clone(Condominium condominium) => Condominium(
        id: condominium.id,
        name: condominium.number,
        number: condominium.name,
        address: condominium.address,
        regulationUrl: condominium.regulationUrl,
        reference: condominium.reference,
        useFacialBiometric: condominium.useFacialBiometric,
        layout: condominium.layout,
        managerAccessControlBiometricStatus:
            condominium.managerAccessControlBiometricStatus,
        notificationContext: condominium.notificationContext,
      );

  @override
  List<Object> get props => [reference];
}
