import 'package:essentials/ui/widget/button/inverted_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class NegativeFeedbackDialog extends StatefulWidget {
  final TextEditingController textController;
  final Function() onConfirm;
  final Function() onCancel;
  const NegativeFeedbackDialog(
      {super.key,
      required this.textController,
      required this.onConfirm,
      required this.onCancel});

  @override
  State<NegativeFeedbackDialog> createState() => _NegativeFeedbackDialogState();
}

class _NegativeFeedbackDialogState extends State<NegativeFeedbackDialog> {
  bool isLoading = false;

  void _handleOnConfirm() async {
    setState(() {
      isLoading = true;
    });

    await widget.onConfirm();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Porque esta resposta foi insatisfatória?",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryTextFormField(
              initialValue: widget.textController.text,
              hint: "Escreva aqui",
              textInputType: TextInputType.multiline,
              maxLength: 200,
              onChanged: (value) {
                setState(() {
                  widget.textController.text = value;
                });
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${widget.textController.text.length}/200',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InvertedPrimaryButton(
                  onPressed: widget.onCancel,
                  text: "Voltar",
                  width: 100,
                  buttonColor: theme.primaryColor,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : PrimaryButton(
                        onPressed: () => widget.textController.text.isNotEmpty
                            ? _handleOnConfirm()
                            : null,
                        text: "Enviar",
                        width: 100,
                        buttonColor: widget.textController.text.isNotEmpty
                            ? theme.primaryColor
                            : Colors.grey,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
