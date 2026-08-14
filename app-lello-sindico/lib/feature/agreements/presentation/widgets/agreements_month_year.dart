import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';

class AgreementsMonthYear extends StatelessWidget {
  final int index;
  final List<Agreement> agreements;
  const AgreementsMonthYear(
      {Key? key, required this.index, required this.agreements})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (index == 0 ||
        (index != 0 &&
            agreements[index]
                    .getDateMonthWritten(context, onlyMonthYear: true) !=
                agreements[index - 1]
                    .getDateMonthWritten(context, onlyMonthYear: true))) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index != 0)
            Divider(
              height: 2.0,
            ),
          Padding(
            padding: EdgeInsets.only(
                left: Dimens.spacingMedium, top: Dimens.spacingMedium),
            child: Text(
              " ${agreements[index].getDateMonthWritten(context, onlyMonthYear: true)}",
              style: LelloTextStyles.subtitle(theme)!
                  .copyWith(color: LelloTheme.palleteOf(theme).grey()),
            ),
          )
        ],
      );
    }

    return Container();
  }
}
