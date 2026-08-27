import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedbackRow extends StatefulWidget {
  final Future<bool> Function(bool?) onFeedbackSelected;
  final Future Function() onSendFeedback;

  const FeedbackRow({
    Key? key,
    required this.onFeedbackSelected,
    required this.onSendFeedback,
  }) : super(key: key);

  @override
  _FeedbackRowState createState() => _FeedbackRowState();
}

class _FeedbackRowState extends State<FeedbackRow> {
  String? selectedFeedback;
  bool negativeFeedbackSent = false;
  bool isLoading = false;

  void _handleFeedback(bool isPositive) async {
    setState(() {
      isLoading = true;
    });

    String? newSelection = selectedFeedback == (isPositive ? 'up' : 'down')
        ? null
        : isPositive
            ? 'up'
            : 'down';

    bool success = await widget.onFeedbackSelected(newSelection == 'up'
        ? true
        : newSelection == 'down'
            ? false
            : null);

    if (success) {
      setState(() {
        selectedFeedback = newSelection;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _handleSendFeedback() async {
    // `onSendFeedback` devolve `null` quando o dialogo e fechado sem enviar
    // ("Voltar"); trata como cancelamento.
    final success = await widget.onSendFeedback();
    if (success == true) {
      setState(() {
        negativeFeedbackSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isLoading) ...[
          CircularProgressIndicator(),
        ] else if (negativeFeedbackSent) ...[
          IconButton(
            icon: SvgPicture.asset(
              'assets/ic_thumbs_down_selected.svg',
              width: 40,
              height: 40,
            ),
            onPressed: () => null,
          ),
          SizedBox(width: Dimens.spacingSmall),
          IconButton(
            onPressed: null,
            icon: SvgPicture.asset(
              'assets/send_feedback_button.svg',
              width: 40,
              height: 40,
            ),
          ),
        ] else if (selectedFeedback == null) ...[
          IconButton(
            icon: SvgPicture.asset(
              'assets/ic_thumbs_up.svg',
              width: 40,
              height: 40,
            ),
            onPressed: () => _handleFeedback(true),
          ),
          SvgPicture.asset('assets/divider.svg', width: 20, height: 20),
          IconButton(
            icon: SvgPicture.asset(
              'assets/ic_thumbs_down.svg',
              width: 40,
              height: 40,
            ),
            onPressed: () => _handleFeedback(false),
          ),
        ] else if (selectedFeedback == 'up') ...[
          IconButton(
            icon: SvgPicture.asset(
              'assets/ic_thumbs_up_selected.svg',
              width: 40,
              height: 40,
            ),
            onPressed: () => _handleFeedback(true),
          ),
        ] else if (selectedFeedback == 'down') ...[
          IconButton(
            icon: SvgPicture.asset(
              'assets/ic_thumbs_down_selected.svg',
              width: 40,
              height: 40,
            ),
            onPressed: () => _handleFeedback(false),
          ),
          SizedBox(width: Dimens.spacingSmall),
          IconButton(
            onPressed: negativeFeedbackSent ? null : _handleSendFeedback,
            icon: SvgPicture.asset(
              'assets/send_feedback_button.svg',
              width: 40,
              height: 40,
            ),
          ),
        ],
      ],
    );
  }
}
