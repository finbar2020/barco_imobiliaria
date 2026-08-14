import 'package:flutter/material.dart';

class RegisterFormStepIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const RegisterFormStepIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        Color color;
        if (index < currentStep) {
          color = Colors.green; // Passado
        } else if (index == currentStep) {
          color = Colors.blue; // Atual
        } else {
          color = Colors.grey; // Futuro
        }
        return Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: color,
            ),
            if (index < totalSteps - 1)
              Container(
                width: 20,
                height: 4,
                color: Colors.grey,
              ),
          ],
        );
      }),
    );
  }
}
