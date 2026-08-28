import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_partner_model.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_status.dart';

part 'comfort_completed_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortCompletedRequestModel {
  String idRequest;
  DateTime? dateRequest;
  double? rating;
  bool purchased;
  String imageHash;
  String comfortType;
  ComfortPartnerModel? partner;
  String idPartner;
  bool isFavorite;
  bool isCanCancel;
  bool isCanResend;
  DateTime? resendDate;
  String? comment;
  String? messageType;
  String status;
  DateTime? messageDate;
  DateTime? canceledDate;

  ComfortCompletedRequestModel({
    this.idRequest = "",
    this.dateRequest,
    this.rating,
    this.purchased = false,
    this.imageHash = "",
    this.comfortType = "",
    this.partner,
    this.idPartner = "",
    this.isFavorite = false,
    this.isCanCancel = false,
    this.isCanResend = false,
    this.resendDate,
    this.comment,
    this.messageType,
    this.status = "sended",
    this.messageDate,
    this.canceledDate,
  });

  factory ComfortCompletedRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortCompletedRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortCompletedRequestModelToJson(this);

  static ComfortCompletedRequestModel? fromEntity(
          ComfortCompletedRequest? entity) =>
      entity == null
          ? null
          : (ComfortCompletedRequestModel()
            ..idRequest = entity.idRequest
            ..idPartner = entity.idPartner
            ..dateRequest = entity.dateRequest
            ..rating = entity.rating
            ..purchased = entity.purchased
            ..imageHash = entity.imageHash
            ..comfortType =
                enumToString(entity.partner.partnerIntro.comfortType) ?? ""
            ..partner = ComfortPartnerModel.fromEntity(entity.partner)
            ..isFavorite = false
            ..isCanCancel = entity.isCanCancel
            ..isCanResend = entity.isCanResend
            ..resendDate = entity.resendDate
            ..comment = entity.comment
            ..messageType = enumToString(entity.messageType) ?? ""
            ..status = enumToString(entity.status) ?? ""
            ..messageDate = entity.messageDate
            ..canceledDate = entity.canceledDate);

  ComfortCompletedRequest toEntity() => ComfortCompletedRequest(
        idRequest: this.idRequest,
        idPartner: this.idPartner,
        dateRequest: this.dateRequest ?? DateTime.now(),
        rating: this.rating,
        purchased: this.purchased,
        imageHash: this.imageHash,
        // Sem parceiro no JSON o `partner!` derrubava a conversão: usa um
        // parceiro mínimo com os dados que a própria solicitação já traz.
        partner: (this.partner ??
                ComfortPartnerModel(
                  id: this.idPartner,
                  comfortType: this.comfortType,
                  imageHash: this.imageHash,
                  favorite: this.isFavorite,
                ))
            .toEntity(),
        isCanCancel: this.isCanCancel,
        isCanResend: this.isCanResend,
        resendDate: this.resendDate,
        comment: this.comment,
        messageType:
            stringToEnum(ComfortRequestMessageType.values, this.messageType) ??
                ComfortRequestMessageType.other,
        status: stringToEnum(ComfortRequestStatus.values, this.status) ??
            ComfortRequestStatus.sended,
        messageDate: this.messageDate,
        canceledDate: this.canceledDate,
      );
}
