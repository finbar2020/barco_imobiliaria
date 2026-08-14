import 'package:colaborador/core/dependency/application_container.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetEmailFillBody extends StatefulWidget {
  final String? emailPrevious;
  final Function(String email) sendEmail;
  const TimesheetEmailFillBody({
    Key? key,
    this.emailPrevious,
    required this.sendEmail,
  }) : super(key: key);

  @override
  State<TimesheetEmailFillBody> createState() => _TimesheetEmailFillBodyState();
}

class _TimesheetEmailFillBodyState extends State<TimesheetEmailFillBody> {
  final formKey = GlobalKey<FormState>();
  final Validator validator = ApplicationContainer.instance().resolve();

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.emailPrevious);
  }

  @override
  Widget build(BuildContext context) {
    validator.context = context;
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
              child: Text(
                getString(context, "timesheet_send_email_description"),
                style: LelloTextStyles.subtitle(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
            ),
            PrimaryTextFormField(
              textInputType: TextInputType.emailAddress,
              action: TextInputAction.done,
              hint: getString(context, "timesheet_send_email_hint",
                  defaultText: "email"),
              validator: validator.validateEmail,
              controller: textEditingController,
            ),
            SizedBox(height: Dimens.spacing),
            InkWell(
              onTap: () {
                validateAndSave();
              },
              child: Container(
                padding: EdgeInsets.all(Dimens.spacing),
                child: Text(
                  getString(context, "send").toUpperCase(),
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).primary(),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(Dimens.spacing),
                child: Text(
                  getString(context, "close").toUpperCase(),
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateAndSave() {
    final form = formKey.currentState;
    if (form != null) {
      if (form.validate()) {
        widget.sendEmail(textEditingController.text);
      }
    }
  }
}
