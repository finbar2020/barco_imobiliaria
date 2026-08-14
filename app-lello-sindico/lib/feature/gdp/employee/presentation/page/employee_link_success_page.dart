import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/employee/presentation/bloc/employee/employee_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class EmployeeLinkSuccessPage extends StatefulWidget {
  final EmployeeSendInviteLinkSuccessState state;
  const EmployeeLinkSuccessPage({Key? key, required this.state})
      : super(key: key);

  @override
  State<EmployeeLinkSuccessPage> createState() =>
      _EmployeeLinkSuccessPageState();
}

class _EmployeeLinkSuccessPageState extends State<EmployeeLinkSuccessPage> {
  SessionBloc sessionBloc = ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).success(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/ic_success.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "residents_link_success"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor())),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                  '${sessionBloc.state.session?.selectedCondominium?.name ?? ''} - ${sessionBloc.state.session?.selectedCondominium?.reference ?? ''}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor()),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Column(
                  children: [
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              LelloTheme.palleteOf(theme).customColor(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          getString(context, "residents_copy_link"),
                          style: LelloTextStyles.button(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).text()),
                        ),
                        onPressed: () {
                          Clipboard.setData(
                                  ClipboardData(text: widget.state.link))
                              .then((value) {
                            return Flushbar(
                              duration: Duration(seconds: 1),
                              message:
                                  getString(context, "residents_copied_link"),
                            )..show(context)
                                .then((value) => Navigator.pop(context));
                          });
                        },
                      ),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: Builder(
                        builder: (buttonContext) => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                LelloTheme.palleteOf(theme).customColor(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(
                            getString(context, "residents_share_link"),
                            style: LelloTextStyles.button(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).text()),
                          ),
                          onPressed: () {
                            final box = buttonContext.findRenderObject() as RenderBox?;
                            final rect = box != null
                                ? box.localToGlobal(Offset.zero) & box.size
                                : null;
                            shareText(widget.state.link, sharePositionOrigin: rect);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          getString(context,
                              "accounttability_question_select_conclude"),
                          style: LelloTextStyles.button(theme)!
                              .copyWith(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
