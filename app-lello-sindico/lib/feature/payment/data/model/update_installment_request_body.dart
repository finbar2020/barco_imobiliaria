import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/data/model/update_transaction_installments.dart';
import 'package:lello/feature/payment/domain/entity/update_installment_lancamento_entity.dart';
part 'update_installment_request_body.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UpdateInstallmentRequestBody {
  final String status;
  final String reason;
  final String channel;
  final List<UpdateTransactionInstallments> installments;

  UpdateInstallmentRequestBody({
    required this.status,
    required this.reason,
    required this.channel,
    required this.installments,
  });

  factory UpdateInstallmentRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateInstallmentRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateInstallmentRequestBodyToJson(this);

  static UpdateInstallmentRequestBody? fromEntity(
      UpdateInstallmentLancamentoEntity? entity) {
    if (entity == null) return null;
    return UpdateInstallmentRequestBody(
      status: entity.status,
      reason: entity.motivo,
      channel: entity.canal,
      installments: entity.lancamentos
          .map(UpdateTransactionInstallments.fromEntity)
          .whereType<UpdateTransactionInstallments>()
          .toList(),
    );
  }

  UpdateInstallmentLancamentoEntity toEntity() {
    return UpdateInstallmentLancamentoEntity(
      status: status,
      motivo: reason,
      canal: channel,
      lancamentos: installments.map((e) => e.toEntity()).toList(),
    );
  }
}
