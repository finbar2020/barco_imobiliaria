import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

/// Insert a network image link as property.
/// This widget will get the network image using standard app base url.
/// User can use different base url, adding value to [differenBaseUrl]
class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    Key? key,
    required this.link,
    required this.applicationContainer,
    this.customHeader,
    this.errorImageAssetsPath,
    this.padding,
    this.fit,
  }) : super(key: key);

  final String? link;
  final String? errorImageAssetsPath;
  final Map<String, String>? customHeader;
  final SharedApplicationContainer applicationContainer;
  final EdgeInsetsGeometry? padding;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    final authenticationStore =
        applicationContainer.resolve<AuthenticationStore>();
    Map<String, String>? customHeader = authenticationStore.getCustomHeader();

    return (link != null && customHeader != null)
        ? CachedNetworkImage(
            httpHeaders: customHeader,
            imageUrl: "${applicationContainer.getBaseUrl()}$link",
            placeholder: (context, url) => new Center(
                child: Padding(
              padding: padding ?? EdgeInsets.all(Dimens.spacingSmall),
              child: CircularProgressIndicator(),
            )),
            errorWidget: (context, url, error) => SvgPicture.asset(
              errorImageAssetsPath ??
                  "assets/custom_image_network_placeholder.svg",
            ),
            fit: fit,
          )
        : SvgPicture.asset(
            errorImageAssetsPath ??
                "assets/custom_image_network_placeholder.svg",
          );
  }
}
