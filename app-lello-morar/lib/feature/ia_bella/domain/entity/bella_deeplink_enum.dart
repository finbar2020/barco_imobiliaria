import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';

enum BellaDeeplinkEnum {
  assembleia,
  boletos,
  acordos,
  moradoresCadastrados,
  minhaConta,
  trocaTitularidade,
}

extension BellaDeeplinkEnumX on BellaDeeplinkEnum {
  FeaturesRoutesEnum get featuresRoute {
    switch (this) {
      case BellaDeeplinkEnum.boletos:
        return FeaturesRoutesEnum.BOLETOS;
      case BellaDeeplinkEnum.acordos:
        return FeaturesRoutesEnum.ACORDO_PROPOSTA;
      case BellaDeeplinkEnum.moradoresCadastrados:
        return FeaturesRoutesEnum.MORADORES_ACESSOU;
      case BellaDeeplinkEnum.minhaConta:
        return FeaturesRoutesEnum.MINHA_CONTA;
      case BellaDeeplinkEnum.trocaTitularidade:
        return FeaturesRoutesEnum.TROCA_TITULARIDADE;
      case BellaDeeplinkEnum.assembleia:
        return FeaturesRoutesEnum.ASSEMBLEIA;
    }
  }
}
