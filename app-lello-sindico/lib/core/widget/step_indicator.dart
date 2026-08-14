import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StepIndicator extends StatelessWidget {
  final int numberOfSteps;
  final int currentStep;

  StepIndicator({Key? key, this.numberOfSteps = 1, this.currentStep = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _buildItems(theme);
    return Container(
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: items),
    );
  }

  List<Widget> _buildItems(ThemeData theme) {
    List<Widget> items = [];
//		final step = min(currentStep, numberOfSteps - 1);
    List.generate(numberOfSteps, (i) {
      if (i < currentStep) {
        items.add(_buildCompletedStep(theme));
      } else if (i > currentStep) {
        items.add(_buildUncompletedStep(theme));
      } else {
        items.add(_buildCurrentStep(theme));
      }
      if (i + 1 < numberOfSteps) {
        items.add(_buildSeparator(theme));
      }
    });
    return items;
  }

  Widget _buildSeparator(ThemeData theme) {
    return SizedBox(
      width: Dimens.spacingSmall,
      height: 2,
      child: Container(color: LelloTheme.palleteOf(theme).separator()),
    );
  }

  Widget _buildCompletedStep(ThemeData theme) {
    return Container(
      width: Dimens.spacing,
      height: Dimens.spacing,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: LelloTheme.palleteOf(theme).separator(),
          shape: BoxShape.rectangle,
          borderRadius:
              BorderRadius.all(Radius.circular(Dimens.spacing / 2.0))),
      child: SvgPicture.asset("assets/ic_check_small.svg", width: 8),
    );
  }

  Widget _buildCurrentStep(ThemeData theme) {
    return Container(
      width: Dimens.spacing,
      height: Dimens.spacing,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: LelloTheme.palleteOf(theme).success(),
          shape: BoxShape.rectangle,
          borderRadius:
              BorderRadius.all(Radius.circular(Dimens.spacing / 2.0))),
      child: SvgPicture.asset("assets/ic_check_small.svg", width: 8),
    );
  }

  Widget _buildUncompletedStep(ThemeData theme) {
    return Container(
        width: Dimens.spacing,
        height: Dimens.spacing,
        decoration: BoxDecoration(
            color: LelloTheme.palleteOf(theme).separator(),
            shape: BoxShape.rectangle,
            borderRadius:
                BorderRadius.all(Radius.circular(Dimens.spacing / 2.0))));
  }
}
