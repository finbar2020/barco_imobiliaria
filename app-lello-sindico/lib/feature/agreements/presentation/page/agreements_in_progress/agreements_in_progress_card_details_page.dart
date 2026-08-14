import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_introduction_details_card.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_payment_details.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_quote_details.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../controllers/agreements_controller.dart';

class AgreementsInProgressCardDetailsPage extends StatelessWidget {
  const AgreementsInProgressCardDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<AgreementsController>();
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "agreements_in_progress"),
          theme: theme,
        ),
        body: Column(
          children: [
            IntroductionDetailsCard(
                theme: theme, agreement: controller.agreement!),
            Expanded(
              flex: 11,
              child: ListView.builder(
                itemCount: controller.agreement!.quotes.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return AgreementsQuoteDetails(
                    theme: theme,
                    index: index + 1,
                    quote: controller.agreement!.quotes[index],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacingLarge),
              child: const Divider(height: 2),
            ),
            Expanded(
              flex: 5,
              child: PaymentDetailsCard(
                installments: controller.agreement!.installments,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
