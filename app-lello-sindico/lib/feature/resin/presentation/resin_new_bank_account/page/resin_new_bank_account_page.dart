import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/controller/resin_new_bank_account_controller.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_widget.dart';

class ResinNewBankAccountPage extends StatefulWidget {
  const ResinNewBankAccountPage({Key? key}) : super(key: key);

  @override
  State<ResinNewBankAccountPage> createState() =>
      _ResinNewBankAccountPageState();
}

class _ResinNewBankAccountPageState extends State<ResinNewBankAccountPage> {
  ResinNewBankAccountController controller =
      ApplicationContainer.instance().resolve();

  @override
  void initState() {
    controller.resinNewBankAccountSetUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocProvider.value(
        value: controller.bloc,
        child: DismissKeyboard(
          child: Scaffold(
            appBar: PrimaryAppBar(
              iconColor: theme.primaryColor,
              title: getString(context, "resin_new_account"),
              theme: theme,
            ),
            body: ResinNewBankAccountWidget(controller: controller),
          ),
        ));
  }
}
