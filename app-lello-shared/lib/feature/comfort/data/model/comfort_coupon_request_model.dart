import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_coupon_request_param_model.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';

part 'comfort_coupon_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ComfortCouponRequestModel {
  String idRequest;
  List<ComfortCouponRequestParamModel?> params;
  String linkRedirectPartner;
  bool redirectExternal;
  String cta;

  ComfortCouponRequestModel({
    this.idRequest = "",
    this.params = const [],
    this.linkRedirectPartner = "",
    this.redirectExternal = false,
    this.cta = "cupom",
  });

  factory ComfortCouponRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ComfortCouponRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComfortCouponRequestModelToJson(this);

  static ComfortCouponRequestModel? fromEntity(ComfortCouponRequest? entity) =>
      entity == null
          ? null
          : (ComfortCouponRequestModel()
            ..idRequest = entity.idRequest
            ..params = entity.params.isEmpty
                ? []
                : entity.params
                    .map((e) => ComfortCouponRequestParamModel.fromEntity(e))
                    .toList()
            ..linkRedirectPartner = entity.linkRedirectPartner
            ..redirectExternal = entity.redirectExternal
            ..cta = enumToString(entity.cta) ?? "cupom");

  ComfortCouponRequest toEntity() => ComfortCouponRequest(
        idRequest: this.idRequest,
        params: this.params.isEmpty
            ? []
            : this.params.map((e) => e?.toEntity()).toList(),
        linkRedirectPartner: this.linkRedirectPartner,
        redirectExternal: this.redirectExternal,
        cta: stringToEnum(ComfortCTA.values, this.cta) ?? ComfortCTA.cupom,
      );
}
