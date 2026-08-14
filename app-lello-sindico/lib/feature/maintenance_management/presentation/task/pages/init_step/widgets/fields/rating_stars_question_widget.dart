import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'base_question_widget.dart';

/// Widget para avaliação por estrelas (RATING_STARS)
class RatingStarsQuestionWidget extends BaseQuestionWidget {
  final int? currentAnswer;
  final Function(int) onAnswerChanged;

  const RatingStarsQuestionWidget({
    super.key,
    required super.question,
    this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget buildField(BuildContext context, ThemeData theme, ColorPallete palette) {
    final rating = currentAnswer ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        final isFilled = starValue <= rating;

        return GestureDetector(
          onTap: () => onAnswerChanged(starValue),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              size: 40,
              color: isFilled ? Colors.amber : const Color(0xFF9E9E9E),
            ),
          ),
        );
      }),
    );
  }
}
