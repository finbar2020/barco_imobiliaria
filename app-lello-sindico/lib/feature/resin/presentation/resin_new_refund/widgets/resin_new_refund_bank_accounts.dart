import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_refunds_steps_enum.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/bloc/resin_new_refund_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/bloc/resin_new_refund_state.dart';
import 'package:lello/feature/resin/presentation/resin_new_refund/controller/resin_new_refund_controller.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_bank_accounts_widget.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ResinNewRefundBankAccounts extends StatefulWidget {
  final Function(ResinRefundsStepsEnum step) updateStep;
  final ResinNewRefundController controller;
  const ResinNewRefundBankAccounts({
    Key? key,
    required this.updateStep,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinNewRefundBankAccounts> createState() =>
      _ResinNewRefundBankAccountsState();
}

class _ResinNewRefundBankAccountsState
    extends State<ResinNewRefundBankAccounts> {
  late ThemeData theme;
  late SessionBloc sessionBloc;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    if (firstBuild) {
      _setUpPage();
    }

    return BlocConsumer<ResinNewRefundBloc, ResinNewRefundState>(
      bloc: widget.controller.bloc,
      listener: (context, state) {
        _showSnackBar(context, state.flushbarMessageKey);
      },
      builder: (context, state) {
        if (state is ResinNewRefundLoadingState) {
          return const Column(
            children: [
              Expanded(child: LoadingWidget()),
            ],
          );
        }

        if (state is ResinNewRefundErrorState) {
          return ErrorMessageWidget(
              message: getString(context, state.errorMessageKey));
        }

        if (state is ResinNewRefundLoadedState) {
          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                    left: Dimens.spacingMedium,
                    right: Dimens.spacingMedium,
                    top: Dimens.spacingMedium,
                    bottom: Dimens.spacingMedium),
                child: StepIndicator(numberOfSteps: 4, currentStep: 0),
              ),
              Expanded(
                child: ResinBankAccountsWidget(
                  bankAccounts: state.bankAccounts,
                  uploadBankAccounts: widget.controller.resinGetBankAccounts,
                  onAccountSelected: (ResinBankAccount account) {
                    widget.controller.resinRefund.destinationAccount = account;
                    widget.updateStep(ResinRefundsStepsEnum.valueDescription);
                  },
                  isUpdating: state.loadingRemote,
                  deleteAccountFunction: (ResinBankAccount account) {
                    widget.controller.resinDeleteBankAccount(account);
                  },
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }

  void _setUpPage() {
    firstBuild = false;
    theme = Theme.of(context);
    sessionBloc = BlocProvider.of(context);
    widget.controller.resinGetBankAccounts();
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
