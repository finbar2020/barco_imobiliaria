import 'package:essentials/ui/widget/button/inverted_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class FinalEvaluationDialog extends StatefulWidget {
  final TextEditingController textController;
  final Function(int) onRatingSelected;
  final Function(bool) onRequestResolvedSelected;
  final Function() onConfirm;
  final Function() onCancel;

  const FinalEvaluationDialog({
    super.key,
    required this.textController,
    required this.onRatingSelected,
    required this.onRequestResolvedSelected,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<FinalEvaluationDialog> createState() => _FinalEvaluationDialogState();
}

class _FinalEvaluationDialogState extends State<FinalEvaluationDialog> {
  bool isLoading = false;
  int selectedRating = 0;
  bool? selectedRequestResolved;

  void _handleOnConfirm() async {
    setState(() {
      isLoading = true;
    });

    await widget.onConfirm();

    setState(() {
      isLoading = false;
    });
  }

  void _handleCancel() {
    setState(() {
      selectedRating = 0;
      selectedRequestResolved = null;
      widget.textController.clear();
    });
    widget.onCancel();
  }

  Widget _buildThumbButton({
    required bool isUp,
    required bool? selected,
    required Color primaryColor,
  }) {
    final bool isSelected = selected == isUp;
    return GestureDetector(
      onTap: () {
        setState(() => selectedRequestResolved = isUp);
        widget.onRequestResolvedSelected(isUp);
      },
      child: Transform.scale(
        scaleX: isUp ? 1.0 : -1.0,
        child: Icon(
          isUp
              ? (isSelected ? Icons.thumb_up : Icons.thumb_up_outlined)
              : (isSelected ? Icons.thumb_down : Icons.thumb_down_outlined),
          size: 36,
          color: isSelected ? primaryColor : const Color(0xFF666666),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool canSubmit =
        selectedRating > 0 && selectedRequestResolved != null;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sua solicitação foi resolvida?",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildThumbButton(
                      isUp: false,
                      selected: selectedRequestResolved,
                      primaryColor: theme.primaryColor),
                  SizedBox(width: Dimens.spacingLarge),
                  _buildThumbButton(
                      isUp: true,
                      selected: selectedRequestResolved,
                      primaryColor: theme.primaryColor),
                ],
              ),
              SizedBox(height: Dimens.spacingMedium),
              Center(
                child: Text(
                  "Avalie este atendimento:",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    int starValue = index + 1;
                    return IconButton(
                      icon: Icon(
                        Icons.star,
                        color: starValue <= selectedRating
                            ? Colors.amber
                            : Colors.grey,
                        size: 42,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRating = starValue;
                        });
                        widget.onRatingSelected(selectedRating);
                      },
                    );
                  }),
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              Text(
                "Faça um comentário:",
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: Dimens.spacing),
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
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              SizedBox(height: Dimens.spacingMedium),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  isLoading
                      ? CircularProgressIndicator()
                      : PrimaryButton(
                          onPressed:
                              canSubmit ? () => _handleOnConfirm() : null,
                          text: "Enviar avaliação e sair",
                          buttonColor:
                              canSubmit ? theme.primaryColor : Colors.grey,
                        ),
                  SizedBox(height: Dimens.spacing),
                  InvertedPrimaryButton(
                    onPressed: _handleCancel,
                    text: "Voltar para a conversa",
                    buttonColor: theme.primaryColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
