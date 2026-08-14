import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/bloc/resin_new_bank_account_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/bloc/resin_new_bank_account_state.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/controller/resin_new_bank_account_controller.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_dialog.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_form_data.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_form_widget.dart';

class ResinNewBankAccountWidget extends StatefulWidget {
  final ResinNewBankAccountController controller;
  const ResinNewBankAccountWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ResinNewBankAccountWidget> createState() =>
      _ResinNewBankAccountWidgetState();
}

class _ResinNewBankAccountWidgetState extends State<ResinNewBankAccountWidget> {
  late ThemeData theme;

  ResinNewBankAccountFormData formData = ResinNewBankAccountFormData(
    agencyController: TextEditingController(),
    accountController: TextEditingController(),
    digitController: TextEditingController(),
  );

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return BlocBuilder<ResinNewBankAccountBloc, ResinNewBankAccountState>(
      bloc: widget.controller.bloc,
      builder: (context, state) {
        if (state is ResinNewBankAccountLoadingState)
          return Column(
            children: [
              Expanded(child: LoadingWidget()),
            ],
          );

        if (state is ResinNewBankAccountErrorState)
          return ErrorMessageWidget(
              message: getString(context, state.errorMessageKey));

        if (state is ResinNewBankAccountLoadedState)
          return _buildBody(state, widget.controller.bloc);

        return Container();
      },
    );
  }

  Widget _buildBody(ResinNewBankAccountLoadedState state,
      ResinNewBankAccountBloc resinNewBankAccountBloc) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSuccessErrorDialog(context, state);
    });
    return SingleChildScrollView(
      child: ResinNewBankAccountFormWidget(
        resinBanks: state.resinBanks,
        resinPeople: state.resinPeople,
        createAccountFunction: widget.controller.resinNewBankAccountCreate,
        formData: formData,
      ),
    );
  }

  void _showSuccessErrorDialog(
      BuildContext context, ResinNewBankAccountLoadedState state) {
    if (state.dialogMessageKey == null) {
      return null;
    }
    String text = getString(context, state.dialogMessageKey!);
    if (text.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ResinNewBankAccountDialog(
          text: text,
        ),
      ).then((value) {
        if (state.isSuccess == true) {
          Navigator.pop(context, true);
        }
      });
    }
  }
}
