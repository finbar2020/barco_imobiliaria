import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_delete_bank_account_dialog.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_updating_widget.dart';

class ResinBankAccountsWidget extends StatelessWidget {
  final List<ResinBankAccount> bankAccounts;
  final Function(ResinBankAccount account) onAccountSelected;
  final Function(ResinBankAccount account) deleteAccountFunction;
  final VoidCallback uploadBankAccounts;
  final bool isUpdating;
  const ResinBankAccountsWidget({
    Key? key,
    required this.bankAccounts,
    required this.onAccountSelected,
    required this.deleteAccountFunction,
    required this.uploadBankAccounts,
    this.isUpdating = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: LelloTheme.palleteOf(theme).greyCard(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: Text(
                    getString(context, "resin_bank_accounts"),
                    style: LelloTextStyles.titleSmall(theme)
                        ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                            context, ApplicationRoute.resinNewBankAccount)
                        .then((value) {
                      if (value == true) {
                        uploadBankAccounts();
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.spacing),
                    child: Text(
                      getString(context, "resin_new_account"),
                      style: LelloTextStyles.subtitleBold(theme)
                          ?.copyWith(color: theme.primaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isUpdating)
          Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(
                  vertical: Dimens.spacingXSmall,
                  horizontal: Dimens.spacingMedium),
              child: ResinUpdatingWidget()),
        Divider(height: 0),
        Expanded(
          child: bankAccounts.isEmpty
              ? Center(
                  child: Text(
                    getString(context, "resin_bank_accounts_empty"),
                    style: LelloTextStyles.body(theme)
                        ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                  ),
                )
              : ListView.separated(
                  itemCount: bankAccounts.length,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              onAccountSelected(bankAccounts[index]);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(Dimens.spacingSmall),
                              child: ListTile(
                                leading: SvgPicture.asset(
                                    'assets/ic_mask_group.svg'),
                                title: Text(
                                  bankAccounts[index].supplierName,
                                  style: LelloTextStyles.subtitleBold(theme)
                                      ?.copyWith(
                                          color: LelloTheme.palleteOf(theme)
                                              .text()),
                                ),
                                subtitle: Text(
                                  '${bankAccounts[index].bank?.bankName ?? ""} | ${bankAccounts[index].accountNumber}',
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                      color:
                                          LelloTheme.palleteOf(theme).text()),
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  ResinDeleteBankAccountDialog(
                                      confirmationFunction: () {
                                deleteAccountFunction(
                                  bankAccounts[index],
                                );
                              }),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(16),
                            width: 56,
                            height: 56,
                            child: SvgPicture.asset("assets/ic_delete.svg"),
                          ),
                        ),
                      ],
                    );
                  }),
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(height: 0)),
        )
      ],
    );
  }
}
