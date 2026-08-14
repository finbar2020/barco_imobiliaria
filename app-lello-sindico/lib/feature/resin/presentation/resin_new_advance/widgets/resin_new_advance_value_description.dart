import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/resin/domain/entity/resin_advances_steps_enum.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/presentation/resin_attention_page/page/resin_attention_page.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_state.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/controller/resin_new_advance_controller.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/page/resin_new_advance_page.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_value_description_widget.dart';

class ResinNewAdvanceValueDescription extends StatefulWidget {
  final Function(ResinAdvancesStepsEnum step) updateStep;
  final ResinParams resinParams;
  final ResinNewAdvanceController controller;
  const ResinNewAdvanceValueDescription({
    Key? key,
    required this.updateStep,
    required this.resinParams,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinNewAdvanceValueDescription> createState() =>
      _ResinNewAdvanceValueDescriptionState();
}

class _ResinNewAdvanceValueDescriptionState
    extends State<ResinNewAdvanceValueDescription> {
  late ThemeData theme;
  late ResinNewAdvanceBloc resinNewAdvanceBloc;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      _setUpPage();
    }

    return BlocConsumer<ResinNewAdvanceBloc, ResinNewAdvanceState>(
      bloc: resinNewAdvanceBloc,
      listener: (context, state) {
        if (state is ResinCheckValuesAdvanceSuccessState) {
          if (state.checkMaxValueParam.canRequest) {
            widget.updateStep(ResinAdvancesStepsEnum.reviewData);
          } else {
            Navigator.pushNamed(context, ApplicationRoute.resinAttentionLimit,
                    arguments: ResinAttentionPageArgs(
                      subtitle: state.checkMaxValueParam.message,
                    ))
                .then((value) => Navigator.popAndPushNamed(
                    context, ApplicationRoute.resinAdvanceNew,
                    arguments: ResinNewAdvancePageArgs(
                        resinParams: widget.resinParams)));
          }
        }
      },
      builder: (context, state) {
        if (state is ResinNewAdvanceLoadingState)
          return Column(
            children: [
              Expanded(child: LoadingWidget()),
            ],
          );

        if (state is ResinNewAdvanceErrorState)
          return ErrorMessageWidget(
              message: getString(context, state.errorMessageKey));
        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: Dimens.spacingMedium,
                  right: Dimens.spacingMedium,
                  top: Dimens.spacingMedium,
                  bottom: Dimens.spacingMedium),
              child: StepIndicator(numberOfSteps: 3, currentStep: 1),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ResinValueDescriptionWidget(
                      refund: widget.controller.resinRefund,
                      resinParams: widget.resinParams,
                    ),
                    _buildButtons(context),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        children: [
          PrimaryButton(
            onPressed: () {
              if (_validateFields()) {
                widget.controller.checkMaxValues(widget.controller.resinRefund);
              }
            },
            text: getString(context, "next"),
          ),
          SizedBox(height: Dimens.spacingMedium),
          SecondaryButton(
            onPressed: () {
              widget.updateStep(ResinAdvancesStepsEnum.bankAccount);
            },
            buttonBorderColor: Colors.white,
            child: Text(getString(context, "back")),
          ),
        ],
      ),
    );
  }

  void _setUpPage() {
    firstBuild = false;
    theme = Theme.of(context);
    resinNewAdvanceBloc = BlocProvider.of(context);
  }

  bool _validateFields() {
    if (widget.controller.resinRefund.value == 0.0) {
      _showSnackBar("resin_value_description_fill_value_field");
      return false;
    }
    if ((widget.controller.resinRefund.description ?? "").trim().isEmpty) {
      _showSnackBar("resin_value_description_fill_description_field");
      return false;
    }
    return true;
  }

  void _showSnackBar(String? textKey) {
    if (textKey == null) {
      return null;
    }
    String text = getString(context, textKey);
    if (text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
      ));
    }
  }
}
