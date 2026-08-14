import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_details_page/accountability_info_details_entry_widget.dart';
import 'package:morar/feature/accountability/presentation/widgets/accountability_info_details_page/accountability_info_details_summary_widget.dart';

class AccountabilityInfoDetailsPageArgs {
  final AccountabilityGrouped accountabilityGrouped;

  AccountabilityInfoDetailsPageArgs({
    required this.accountabilityGrouped,
  });
}

class AccountabilityInfoDetailsPage extends StatefulWidget {
  const AccountabilityInfoDetailsPage({Key? key}) : super(key: key);

  @override
  _AccountabilityInfoDetailsPageState createState() =>
      _AccountabilityInfoDetailsPageState();
}

class _AccountabilityInfoDetailsPageState
    extends State<AccountabilityInfoDetailsPage> {
  @override
  Widget build(BuildContext context) {
    AccountabilityInfoDetailsPageArgs arguments = ModalRoute.of(context)
        ?.settings
        .arguments as AccountabilityInfoDetailsPageArgs;
    AccountabilityGrouped accountabilityGrouped =
        arguments.accountabilityGrouped;

    return Scaffold(
      appBar: CustomAppBar(title: "accountability_title"),
      body: _buildBody(context, accountabilityGrouped),
    );
  }

  Widget _buildBody(BuildContext context, AccountabilityGrouped entity) {
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Text(
            getString(context, "accountability_historial_releases"),
            style: LelloTextStyles.title(theme),
          ),
        ),
        SizedBox(width: Dimens.spacing),
        AccountabilityInfoDetailsSummaryWidget(accountabilityGrouped: entity),
        Expanded(child: _buildAccountItens(context, entity))
      ],
    );
  }

  Widget _buildAccountItens(
      BuildContext context, AccountabilityGrouped entity) {
    ThemeData theme = Theme.of(context);
    return ListView.separated(
      itemBuilder: (context, index) {
        return AccountabilityInfoDetailsEntryWidget(
            accountabilityGroupedAccount: entity.accounts[index]);
      },
      itemCount: entity.accounts.length,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: LelloTheme.palleteOf(theme).separator(),
        thickness: 2,
        height: 0,
      ),
    );
  }
}
