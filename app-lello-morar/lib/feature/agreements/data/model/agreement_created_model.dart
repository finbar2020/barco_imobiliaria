import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';

part 'agreement_created_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AgreementCreatedModel {
  String unit;
  int paymentMethod;
  int installmentQuantity;
  int dueDate;
  int reference;
  List<String> receiptList;
  String email;
  String phone;

  AgreementCreatedModel(
      {this.unit = "",
      this.paymentMethod = 0,
      this.installmentQuantity = 0,
      this.dueDate = 0,
      this.reference = 0,
      this.receiptList = const [],
      this.email = "",
      this.phone = ""});

  factory AgreementCreatedModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementCreatedModelFromJson(json);
  Map<String, dynamic> toJson() => _$AgreementCreatedModelToJson(this);

  static AgreementCreatedModel fromEntity(AgreementCreated entity) =>
      (AgreementCreatedModel(
        unit: entity.unit,
        paymentMethod: entity.paymentMethod,
        installmentQuantity: entity.installmentQuantity,
        dueDate: entity.dueDate,
        reference: entity.reference,
        receiptList: entity.receiptList,
        email: entity.email ?? "",
        phone: entity.phone ?? "",
      ));

  AgreementCreated toEntity() => AgreementCreated(
        unit: this.unit,
        paymentMethod: this.paymentMethod,
        installmentQuantity: this.installmentQuantity,
        dueDate: this.dueDate,
        reference: this.reference,
        receiptList: this.receiptList,
        email: this.email,
        phone: this.phone,
      );
}
