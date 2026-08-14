import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_rules/widgets/agreements_max_installments_bottom_sheet.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_rules/widgets/agreements_payment_days_bottom_sheet.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../controllers/agreements_controller.dart';

class AgreementsRulesPage extends StatefulWidget {
  const AgreementsRulesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AgreementsRulesPage> createState() => _AgreementsRulesPageState();
}

class _AgreementsRulesPageState extends State<AgreementsRulesPage> {
  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<AgreementsController>();
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "agreements_rules"),
          theme: theme,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getString(context, 'agreements_rules_summary'),
                  style: LelloTextStyles.title(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                  getString(context, 'agreements_rules_description'),
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
                SizedBox(height: Dimens.spacingLarge),
                AgreementRule(
                  title: getString(context, 'agreements_payment_method'),
                  subtitle: _getpaymentMethods(
                    context,
                    controller.agreementsRules!.getpaymentMethodsKeyList,
                  ),
                ),
                AgreementRule(
                  title: getString(context, 'agreements_max_installments'),
                  subtitle: controller.agreementsRules!.getMaxInstallments,
                  onTap: () async {
                    await Modal.showBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) =>
                          AgreementsMaxInstallmentsBottomSheet(
                        rules: controller.agreementsRules!,
                        onPressed: (newRules) => controller.changeRules(
                          rules: newRules,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                ),
                AgreementRule(
                  title: getString(context, 'agreements_payment_days'),
                  subtitle: controller.agreementsRules!.getAllowedDays,
                  onTap: () async {
                    await Modal.showBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => AgreementsPaymentDaysBottomSheet(
                        rules: controller.agreementsRules!,
                        onPressed: (newRules) => controller.changeRules(
                          rules: newRules,
                        ),
                      ),
                    );
                    setState(() {});
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getpaymentMethods(
      BuildContext context, List<String> paymentMethodsKeyList) {
    String paymentMethods = "";
    if (paymentMethodsKeyList.isNotEmpty) {
      for (var element in paymentMethodsKeyList) {
        String paymentMethod = getString(context, element);
        if (paymentMethod.isNotEmpty) {
          paymentMethods = "$paymentMethods$paymentMethod, ";
        }
      }
      if (paymentMethods.isNotEmpty) {
        paymentMethods = "$paymentMethods#";
      }
    }
    paymentMethods = paymentMethods.replaceFirst(", #", "");
    return paymentMethods;
  }
}

class AgreementRule extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const AgreementRule({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimens.spacingSmall),
                Text(
                  title.toUpperCase(),
                  style: LelloTextStyles.body(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).grey(),
                  ),
                ),
                SizedBox(height: Dimens.spacingXSmall),
                Text(
                  subtitle,
                  style: LelloTextStyles.body(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
                SizedBox(height: Dimens.spacingLarge),
              ],
            ),
          ),
          if (onTap != null)
            Flexible(
              child: Text(
                getString(context, "agreements_edit"),
                style: LelloTextStyles.body(theme)!.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: LelloTheme.palleteOf(theme).grey(),
                  color: LelloTheme.palleteOf(theme).grey(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
