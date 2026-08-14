import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class RateRequestOpinionWidget extends StatefulWidget {
  RateRequestOpinionWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hintText;

  @override
  State<RateRequestOpinionWidget> createState() =>
      _RateRequestOpinionWidgetState();
}

class _RateRequestOpinionWidgetState extends State<RateRequestOpinionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    String? hintText =
        widget.hintText ?? getString(context, 'comfort_rate_write_here');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 240.0,
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: TextField(
            controller: widget.controller,
            maxLength: 256,
            maxLines: 10,
            focusNode: widget.focusNode,
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelStyle: LelloTextStyles.subtitle(theme),
              border: OutlineInputBorder(),
              filled: true,
              fillColor: LelloTheme.palleteOf(theme).customColor(),
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }
}
