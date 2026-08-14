import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

/// Insert a network image link as property.
/// This widget will get the network image using standard app base url.
/// User can use different base url, adding value to [differenBaseUrl]
class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    Key? key,
    required this.link,
    this.errorImageAssetsPath,
    this.differentBaseUrl,
    this.isAnonymous = false,
  }) : super(key: key);

  final String? link;
  final String? errorImageAssetsPath;

  ///Another baseUrl, different of app's base url.
  final String? differentBaseUrl;
  final bool isAnonymous;

  @override
  Widget build(BuildContext context) {
    final AuthenticationStore authenticationStore =
        ApplicationContainer.instance().resolve();
    Map<String, String>? customHeader = authenticationStore.getCustomHeader();

    final SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();
    String baseUrl = sessionBloc.getBaseUrl();
    if (differentBaseUrl != null) {
      baseUrl = differentBaseUrl!;

      ///Must not send customHeader to another baseUrl.
      customHeader = null;
    }

    return (link != null && (isAnonymous || customHeader != null))
        ? CachedNetworkImage(
            httpHeaders: customHeader,
            imageUrl: "$baseUrl$link",
            placeholder: (context, url) => Center(
                child: Padding(
              padding: EdgeInsets.all(Dimens.spacingSmall),
              child: const CircularProgressIndicator(),
            )),
            errorWidget: (context, url, error) => SvgPicture.asset(
              errorImageAssetsPath ??
                  "assets/custom_image_network_placeholder.svg",
            ),
          )
        : SvgPicture.asset(
            errorImageAssetsPath ??
                "assets/custom_image_network_placeholder.svg",
          );
  }
}
