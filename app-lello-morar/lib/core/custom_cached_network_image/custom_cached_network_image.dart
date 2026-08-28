import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
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
  }) : super(key: key);

  final String? link;
  final String? errorImageAssetsPath;

  ///Another baseUrl, different of app's base url.
  final String? differentBaseUrl;

  @override
  Widget build(BuildContext context) {
    final authenticationStore =
        ApplicationContainer.instance().resolve<AuthenticationStore>();
    Map<String, String>? customHeader = authenticationStore.getCustomHeader();

    final SessionBloc sessionBloc = BlocProvider.of(context);
    String baseUrl = sessionBloc.getBaseUrl();
    bool canLoad = customHeader != null;
    if (differentBaseUrl != null) {
      baseUrl = differentBaseUrl!;

      ///Must not send customHeader to another baseUrl.
      customHeader = null;
      canLoad = true;
    }

    return (link?.isNotEmpty == true && canLoad)
        ? CachedNetworkImage(
            httpHeaders: customHeader,
            imageUrl: "$baseUrl$link",
            placeholder: (context, url) => new Center(
                child: Padding(
              padding: EdgeInsets.all(Dimens.spacingSmall),
              child: CircularProgressIndicator(),
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
