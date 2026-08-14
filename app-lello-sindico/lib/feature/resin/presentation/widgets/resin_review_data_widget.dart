import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipts_carousel.dart';

class ResinReviewDataWidget extends StatefulWidget {
  final ResinRefund refund;
  const ResinReviewDataWidget({
    Key? key,
    required this.refund,
  }) : super(key: key);

  @override
  State<ResinReviewDataWidget> createState() => _ResinReviewDataWidgetState();
}

final Validator validator = ApplicationContainer.instance().resolve();

class _ResinReviewDataWidgetState extends State<ResinReviewDataWidget> {
  final CarouselSliderController carouselController = CarouselSliderController();
  final NumberFormat formatCurrency = NumberFormat.currency(symbol: "R\$");
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ResinRefund refund = widget.refund;

    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${getString(context, "resin_review_data_value")} ',
            style: LelloTextStyles.subtitle(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
          ),
          SizedBox(height: Dimens.spacingSmall),
          Text(
            formatCurrency.format(refund.value),
            style: LelloTextStyles.titleBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
          if (refund.description != null)
            _buildTitleSubTitle(
                getString(context, "resin_review_data_description"),
                refund.description!),
          _buildTitleSubTitle(
            getString(context, "resin_review_data_to_who"),
            refund.destinationAccount?.supplierName ?? "-",
          ),
          _buildTitleSubTitle(
            getString(context, "resin_review_data_account"),
            refund.destinationAccount?.accountNumber ?? "-",
          ),
          _buildTitleSubTitle(
            getString(context, "resin_review_data_date"),
            refund.requestDateFormatted,
          ),
          if (refund.receipts.isNotEmpty)
            ResinReceiptsCarousel(
              carouselController: carouselController,
              receipts: refund.receipts,
            ),
        ],
      ),
    );
  }

  Column _buildTitleSubTitle(String title, String subtitle) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.spacingMedium),
        Text(
          title,
          style: LelloTextStyles.subtitle(theme)
              ?.copyWith(color: LelloTheme.palleteOf(theme).textOpaque()),
        ),
        SizedBox(height: Dimens.spacingSmall),
        Text(
          subtitle,
          style: LelloTextStyles.subtitle(theme)
              ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
        ),
      ],
    );
  }
}
