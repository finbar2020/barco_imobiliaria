import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/rating_bar_widget.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/request_rating_widgets/rate_request_opinion_widget.dart';
import 'package:shared_features/shared_features.dart';

class ReviewRequestDialog extends StatefulWidget {
  final ComfortPartner partner;
  final ComfortRequestPurchase requestPurchase;
  final SharedApplicationContainer applicationContainer;
  final Function({
    required String requestId,
    required double rate,
    String? comment,
  }) sendRequestReview;
  ReviewRequestDialog({
    Key? key,
    required this.sendRequestReview,
    required this.partner,
    required this.requestPurchase,
    required this.applicationContainer,
  }) : super(key: key);

  @override
  State<ReviewRequestDialog> createState() => _ReviewRequestDialogState();
}

class _ReviewRequestDialogState extends State<ReviewRequestDialog> {
  double rating = 0.0;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    FocusNode textFieldFocusNode = FocusNode();
    return Dialog(
      child: GestureDetector(
        onTap: () {
          if (textFieldFocusNode.hasPrimaryFocus) {
            textFieldFocusNode.unfocus();
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.spacingMedium),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
                  child: CustomCachedNetworkImage(
                      applicationContainer: widget.applicationContainer,
                      link: widget.partner.partnerIntro.partnerImageLink),
                ),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                  widget.partner.partnerIntro.title,
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).grey(),
                  ),
                ),
                if (widget.requestPurchase.purchaseDate != null)
                  Text(
                    (getString(context, "comfort_purchase_completed_date"))
                        .replaceAll("###",
                            widget.requestPurchase.formattedPurchaseDate),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).grey(),
                    ),
                  ),
                SizedBox(height: Dimens.spacingMedium),
                Center(
                  child: RatingBarWidget(
                    allowHalfRating: false,
                    setRating: (newRating) {
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                ),
                RateRequestOpinionWidget(
                  controller: textEditingController,
                  focusNode: textFieldFocusNode,
                  hintText: getString(
                      context, 'comfort_purchase_completed_rate_comment'),
                ),
                SizedBox(height: Dimens.spacingSmall),
                _sendReviewButton(context),
                SizedBox(height: Dimens.spacingMedium),
                _reviewAfterButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _reviewAfterButton(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
      child: SecondaryButton(
        child:
            Text(getString(context, "comfort_purchase_completed_rate_after")),
        buttonBorderColor: LelloTheme.palleteOf(theme).primary(),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Padding _sendReviewButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
      child: PrimaryButton(
        child: Text(getString(context, "comfort_purchase_completed_rate")),
        onPressed: rating == 0
            ? null
            : () {
                String? comment = textEditingController.text.trim().isEmpty
                    ? null
                    : textEditingController.text.trim();
                widget.sendRequestReview(
                  rate: rating,
                  comment: comment,
                  requestId: widget.requestPurchase.requestId,
                );
                Navigator.pop(context, true);
              },
      ),
    );
  }
}
