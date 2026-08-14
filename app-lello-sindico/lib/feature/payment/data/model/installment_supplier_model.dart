import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_supplier.dart';
part 'installment_supplier_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InstallmentSupplierModel {
  int? supplierId;
  String? supplierDocument;
  String? cellPhone;
  String? block;
  String? email;
  String? tradeName;
  String? legalName;
  String? phone1;
  String? phone2;

  InstallmentSupplierModel();

  factory InstallmentSupplierModel.fromJson(Map<String, dynamic> json) =>
      _$InstallmentSupplierModelFromJson(json);
  Map<String, dynamic> toJson() => _$InstallmentSupplierModelToJson(this);

  static InstallmentSupplierModel? fromEntity(
          PaymentInstallmentSupplier? entity) =>
      entity == null
          ? null
          : (InstallmentSupplierModel()
            ..supplierId = entity.supplierId
            ..supplierDocument = entity.supplierDocument
            ..cellPhone = entity.cellPhone
            ..block = entity.block
            ..email = entity.email
            ..tradeName = entity.tradeName
            ..legalName = entity.legalName
            ..phone1 = entity.phone1
            ..phone2 = entity.phone2);

  PaymentInstallmentSupplier toEntity() => PaymentInstallmentSupplier(
        supplierId: supplierId,
        supplierDocument: supplierDocument,
        cellPhone: cellPhone,
        block: block,
        email: email,
        tradeName: tradeName,
        legalName: legalName,
        phone1: phone1,
        phone2: phone2,
      );
}
