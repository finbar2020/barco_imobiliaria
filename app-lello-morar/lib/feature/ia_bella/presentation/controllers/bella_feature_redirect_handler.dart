import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/home/presentation/controllers/home_navigation_redirect_resolver.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_deeplink_enum.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

class BellaFeatureRedirectHandler {
  static final Map<String, BellaDeeplinkEnum> _deeplinkAliases = {
    'moradores': BellaDeeplinkEnum.moradoresCadastrados,
    'moradoresacessou': BellaDeeplinkEnum.moradoresCadastrados,
  };
  static bool redirect({
    required BuildContext context,
    required String href,
    required SessionBloc sessionBloc,
  }) {
    final featureRoute = _resolveFeatureRoute(href);
    if (featureRoute == null) return false;
    final resolver = HomeNavigationRedirectResolver(
      sessionBloc: sessionBloc,
      isGeneric: false,
    );

    final result = resolver.resolve(
      SharedApplicationRedirectRoute(
        rote: enumToString(featureRoute) ?? '',
        context: sessionBloc.state.session?.unity?.notificationContext,
        notificationId: '',
      ),
    );

    switch (result.action) {
      case HomeRedirectAction.navigateRoute:
        if (result.route != null) {
          Navigator.pushNamed(context, result.route!,
              arguments: result.arguments);
          return true;
        }
        return false;
      case HomeRedirectAction.none:
      case HomeRedirectAction.openNotifications:
      case HomeRedirectAction.openComoditiesTab:
        return false;
    }
  }

  static FeaturesRoutesEnum? _resolveFeatureRoute(String href) {
    final deeplink = _resolveDeeplink(href);
    if (deeplink != null) return deeplink.featuresRoute;

    final normalizedHref = _normalizeEnumToken(href);
    return FeaturesRoutesEnum.values.cast<FeaturesRoutesEnum?>().firstWhere(
      (candidate) {
        final enumName = enumToString(candidate);
        if (enumName == null) return false;
        return _normalizeEnumToken(enumName) == normalizedHref;
      },
      orElse: () => null,
    );
  }

  static BellaDeeplinkEnum? _resolveDeeplink(String href) {
    final normalizedHref = _normalizeEnumToken(href);
    final aliased = _deeplinkAliases[normalizedHref];
    if (aliased != null) return aliased;

    return BellaDeeplinkEnum.values.cast<BellaDeeplinkEnum?>().firstWhere(
      (candidate) {
        final enumName = enumToString(candidate);
        if (enumName == null) return false;
        return _normalizeEnumToken(enumName) == normalizedHref;
      },
      orElse: () => null,
    );
  }

  static String _normalizeEnumToken(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }
}
