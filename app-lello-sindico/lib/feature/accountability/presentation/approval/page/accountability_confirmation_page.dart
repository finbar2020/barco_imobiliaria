import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/presentation/failure_message.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/presentation/approval/bloc/accountability_approval_state.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_page.dart';

import '../controller/accountability_approval_controller.dart';

class AccountabilityConfirmationPage extends StatefulWidget {
  @override
  _AccountabilityConfirmationPageState createState() =>
      _AccountabilityConfirmationPageState();
}

class _AccountabilityConfirmationPageState
    extends State<AccountabilityConfirmationPage> {
  final dateFormat = DateFormat("MMMM yyyy");
  final AccountabilityApprovalController controller =
      ApplicationContainer.instance()
          .resolve<AccountabilityApprovalController>();
  var loaded = false;
  Accountability? accountability;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!loaded) {
      accountability =
          ModalRoute.of(context)!.settings.arguments as Accountability;
      controller.setup(accountability: accountability!);
      loaded = true;
    }

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: getString(
            context,
            "accountability_title",
          ),
          theme: theme,
        ),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: BlocConsumer(
            bloc: controller.bloc,
            listener: (context, state) {
              if (state is AccountabilityApprovalApprovedState) {
                Navigator.pushReplacementNamed(
                    context, ApplicationRoute.accountabilitySuccess);
              }
            },
            builder: (context, state) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SvgPicture.asset("assets/ic_accountability_confirmation.svg"),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                      "${getString(context, "accountability_confirmation")} ${accountability!.period != null ? dateFormat.format(accountability!.period!) : ""}?",
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)),
                  SizedBox(height: Dimens.spacingLarge),
                  Visibility(
                    visible: (state is! AccountabilityApprovalLoadingState),
                    replacement:
                        const Center(child: CircularProgressIndicator()),
                    child: PrimaryButton(
                        text: getString(context, "accountability_approve"),
                        onPressed: () async {
                          await controller.approve(
                            accountability: accountability!,
                          );
                        }),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  Visibility(
                    visible: (state is! AccountabilityApprovalFailedState),
                    child: Text(
                        state is AccountabilityApprovalFailedState
                            ? FailureMessage.get(context, state.error)
                            : "",
                        style: LelloTextStyles.error(theme),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  SecondaryButton(
                    buttonBorderColor: LelloTheme.palleteOf(theme).accent(),
                    text: getString(context, "accountability_send_question"),
                    onPressed: () {
                      final period = accountability!.period;
                      if (period != null) {
                        Navigator.of(context).pushNamed(
                          ApplicationRoute.accountabilityNewQuestion,
                          arguments: QuestionCreatePageArg(
                            accountability: accountability!,
                            period: accountability!.period!,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
