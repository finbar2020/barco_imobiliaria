import 'package:lello/feature/payment/domain/entity/update_transaction_installments_entity.dart';

class UpdateInstallmentLancamentoEntity {
  final String status;
  final String motivo;
  final String canal;
  final List<UpdateTransactionInstallmentsEntity> lancamentos;

  UpdateInstallmentLancamentoEntity({
    required this.status,
    required this.motivo,
    required this.canal,
    required this.lancamentos,
  });

  UpdateInstallmentLancamentoEntity copyWith({
    String? status,
    String? motivo,
    String? canal,
    List<UpdateTransactionInstallmentsEntity>? lancamentos,
  }) {
    return UpdateInstallmentLancamentoEntity(
      status: status ?? this.status,
      motivo: motivo ?? this.motivo,
      canal: canal ?? this.canal,
      lancamentos: lancamentos ?? this.lancamentos,
    );
  }
}
