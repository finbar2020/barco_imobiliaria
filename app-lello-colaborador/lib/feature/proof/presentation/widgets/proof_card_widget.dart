import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ProofCardWidget extends StatefulWidget {
  final VoidCallback onTap;
  final String dateTimeClockIn;

  const ProofCardWidget(
      {Key? key, required this.onTap, required this.dateTimeClockIn})
      : super(key: key);

  @override
  State<ProofCardWidget> createState() => _ProofCardWidgetState();
}

class _ProofCardWidgetState extends State<ProofCardWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: widget.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/ic_proof.svg",
            height: 25,
          ),
          SizedBox(width: Dimens.spacingLarge),
          Expanded(
              child: Text(widget.dateTimeClockIn,
                  style: LelloTextStyles.bodyBold(theme))),
          Icon(
            Icons.keyboard_arrow_right,
            size: 35.0,
            color: LelloTheme.palleteOf(theme).grey(),
          ),
        ],
      ),
    );
  }
}
