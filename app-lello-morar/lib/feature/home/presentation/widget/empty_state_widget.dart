import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/dimens.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? message;
  const EmptyStateWidget({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: Dimens.spacingXLarge),
          SvgPicture.asset(
            'assets/home_empty_state.svg',
            width: 312,
            height: 240,
            fit: BoxFit.contain,
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            message ?? 'Suas ferramentas disponíveis serão exibidas aqui.',
            style: LelloTextStyles.subtitleBold(theme)!
                .copyWith(color: LelloTheme.palleteOf(theme).grey()),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
