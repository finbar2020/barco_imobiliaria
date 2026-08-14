import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/payment/data/model/installment_approver_model.dart';
import 'package:lello/feature/payment/data/model/installment_ledger_account_model.dart';
import 'package:lello/feature/payment/data/model/installment_supplier_model.dart';
import 'package:lello/feature/payment/domain/entity/lancamento.dart';

part 'lancamento_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LancamentoModel {
  int? transactionId;
  InstallmentSupplierModel? supplier;
  List<InstallmentApproverModel>? approvers;
  InstallmentLedgerAccountModel? ledgerAccount;
  String? status;
  String? registrationDate;
  String? documentNumber;
  double? totalValue;
  String? dueDate;
  int? approverId1;
  int? approverId2;
  int? approverId3;
  double? netValue;

  LancamentoModel();

  factory LancamentoModel.fromJson(Map<String, dynamic> json) =>
      _$LancamentoModelFromJson(json);

  Map<String, dynamic> toJson() => _$LancamentoModelToJson(this);

  static LancamentoModel? fromEntity(LancamentoEntity? entity) => entity == null
      ? null
      : (LancamentoModel()
        ..transactionId = entity.transactionId
        ..supplier = InstallmentSupplierModel.fromEntity(entity.supplier)
        ..approvers = entity.approvers
            ?.map(InstallmentApproverModel.fromEntity)
            .toList() as List<InstallmentApproverModel>?
        ..ledgerAccount =
            InstallmentLedgerAccountModel.fromEntity(entity.ledgerAccount)
        ..registrationDate = entity.registrationDate
        ..documentNumber = entity.documentNumber
        ..totalValue = entity.totalValue
        ..dueDate = entity.dueDate
        ..status = entity.status
        ..approverId1 = entity.approverId1
        ..approverId2 = entity.approverId2
        ..approverId3 = entity.approverId3
        ..netValue = entity.netValue);

  LancamentoEntity toEntity() => LancamentoEntity(
        transactionId: transactionId,
        status: status,
        supplier: supplier?.toEntity(),
        approvers: approvers?.map((e) => e.toEntity()).toList(),
        ledgerAccount: ledgerAccount?.toEntity(),
        registrationDate: registrationDate,
        documentNumber: documentNumber,
        totalValue: totalValue,
        dueDate: dueDate,
        approverId1: approverId1,
        approverId2: approverId2,
        approverId3: approverId3,
        netValue: netValue,
      );
}
