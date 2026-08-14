import 'package:essentials/auto_size_text/auto_size_text_widget.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/pages/comfort_rate_request_page.dart';
import 'package:shared_features/shared_features.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    Key? key,
    required this.request,
    required this.comfortMyRequestsController,
    required this.applicationContainer,
  }) : super(key: key);

  final ComfortCompletedRequest? request;
  final ComfortMyRequestsController comfortMyRequestsController;
  final SharedApplicationContainer applicationContainer;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return request == null
        ? Container()
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 8,
              backgroundColor: LelloTheme.palleteOf(theme).greyCard(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.all(Dimens.spacingSmall),
            ),
            onPressed: () {},
            child: Container(
              height: 300,
              padding: EdgeInsets.all(Dimens.spacingSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: LelloTheme.palleteOf(theme).greyCard(),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomCachedNetworkImage(
                        applicationContainer: applicationContainer,
                        link: request!.partner.partnerIntro.partnerImageLink),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        request!.partner.partnerIntro.title,
                        style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).grey()),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  if (request!.getRequestDateFormatted != null)
                    AutoSizeTextWidget(
                      text: request!.getRequestDateFormatted!,
                      style: LelloTextStyles.body(theme)
                          ?.copyWith(color: LelloTheme.palleteOf(theme).grey()),
                      maxLines: 1,
                    ),
                  SizedBox(height: Dimens.spacingSmall),
                  Expanded(
                    flex: 3,
                    child: RateButton(context, request!),
                  ),
                ],
              ),
            ),
          );
  }

  Widget RateButton(BuildContext context, ComfortCompletedRequest request) {
    ThemeData theme = Theme.of(context);
    if (!request.purchased) {
      return Center(
        child: RichText(
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text:
                  "${(getString(context, "comfort_my_requests_not_possible_to_rate"))}",
              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).grey(),
              ),
            )
          ]),
        ),
      );
    }
    if (request.rating != null)
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingSmall),
        child: PrimaryButton(
          child: Container(
            padding: EdgeInsets.all(Dimens.spacingXSmall),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                getString(context, "comfort_my_requests_rated"),
              ),
            ),
          ),
          onPressed: null,
        ),
      );
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingSmall),
      child: SecondaryButton(
          child: Container(
            child: Text(
              getString(context, "comfort_my_requests_rate"),
            ),
          ),
          buttonBorderColor: theme.primaryColor,
          onPressed: () {
            comfortMyRequestsController.goToRateRequestPage(request);
            Navigator.pushNamed(
              context,
              SharedApplicationRoute.comfortRateRequest,
              arguments:
                  ComfortRateRequestPageArgs(comfortMyRequestsController),
            );
          }),
    );
  }
}
