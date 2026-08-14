import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class InfoBannerWidget extends StatelessWidget {
  final VoidCallback onClose;
  final ThemeData theme;

  const InfoBannerWidget({
    Key? key,
    required this.onClose,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      color: LelloTheme.palleteOf(theme).buttonSystem(),
      child: Row(
        children: [
          Expanded(
            child: Text(
              getString(context, "payment_pendency_banner_info"),
              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: SvgPicture.asset("assets/ic_close_white.svg"),
          ),
        ],
      ),
    );
  }
}
