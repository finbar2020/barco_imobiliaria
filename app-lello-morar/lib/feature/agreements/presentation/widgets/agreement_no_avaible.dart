import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AgreementsNoAvailableWidget extends StatelessWidget {
  final bool agreement;
  const AgreementsNoAvailableWidget({
    Key? key,
    this.agreement = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
        child: Container(
      height: 40.0,
      child: Row(
        children: [
          SvgPicture.asset("assets/ic_information_gray.svg"),
          SizedBox(width: Dimens.spacingSmall),
          Expanded(
            child: Text(
              getString(context,
                  agreement ? "you_have_no_agreements" : 'you_have_no_quotas'),
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textLight(),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
