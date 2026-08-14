import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/resin/domain/entity/resin_advances_steps_enum.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_state.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/controller/resin_new_advance_controller.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_bank_accounts_widget.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ResinNewAdvanceBankAccounts extends StatefulWidget {
  final Function(ResinAdvancesStepsEnum step) updateStep;
  final ResinNewAdvanceController controller;
  const ResinNewAdvanceBankAccounts({
    Key? key,
    required this.updateStep,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinNewAdvanceBankAccounts> createState() =>
      _ResinNewAdvanceBankAccountsState();
}

class _ResinNewAdvanceBankAccountsState
    extends State<ResinNewAdvanceBankAccounts> {
  late ThemeData theme;
  late SessionBloc sessionBloc;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      _setUpPage();
    }

    return BlocConsumer<ResinNewAdvanceBloc, ResinNewAdvanceState>(
      bloc: widget.controller.bloc,
      listener: (context, state) {
        _showSnackBar(context, state.flushbarMessageKey);
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

        if (state is ResinNewAdvanceLoadedState)
          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: Dimens.spacingMedium,
                    right: Dimens.spacingMedium,
                    top: Dimens.spacingMedium,
                    bottom: Dimens.spacingMedium),
                child: StepIndicator(numberOfSteps: 3, currentStep: 0),
              ),
              Expanded(
                child: ResinBankAccountsWidget(
                  bankAccounts: state.bankAccounts,
                  uploadBankAccounts: widget.controller.getBankAccounts,
                  onAccountSelected: (ResinBankAccount account) {
                    widget.controller.resinRefund.destinationAccount = account;
                    widget.updateStep(ResinAdvancesStepsEnum.valueDescription);
                  },
                  isUpdating: state.loadingRemote,
                  deleteAccountFunction: (ResinBankAccount account) {
                    widget.controller.deleteBankAccount(account);
                  },
                ),
              ),
            ],
          );

        return Container();
      },
    );
  }

  void _setUpPage() {
    firstBuild = false;
    theme = Theme.of(context);
    sessionBloc = BlocProvider.of(context);
    widget.controller..getBankAccounts();
  }

  void _showSnackBar(BuildContext context, String? textKey) {
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
