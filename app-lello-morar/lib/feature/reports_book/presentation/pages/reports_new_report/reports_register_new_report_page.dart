import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_message_widget.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class RegisterNewReportPageArgs {
  final ReportsController controller;
  final bool isSucess;

  RegisterNewReportPageArgs({
    required this.controller,
    this.isSucess = false,
  });
}

class RegisterNewReportPage extends StatefulWidget {
  const RegisterNewReportPage({Key? key}) : super(key: key);

  @override
  _RegisterNewReportPageState createState() => _RegisterNewReportPageState();
}

class _RegisterNewReportPageState extends State<RegisterNewReportPage>
    with SingleTickerProviderStateMixin {
  var _itemSelecionado;

  @override
  Widget build(BuildContext context) {
    RegisterNewReportPageArgs arguments =
        ModalRoute.of(context)!.settings.arguments as RegisterNewReportPageArgs;
    List<String> subjects = [
      getString(context, "reports_type_compliment"),
      getString(context, "reports_type_suggestion"),
      getString(context, "reports_type_complaint"),
      getString(context, "reports_type_others"),
    ];
    final ReportsController controller = arguments.controller;
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        _onPop(context, arguments);
        return false;
      },
      child: Theme(
        data: theme,
        child: BlocBuilder(
          bloc: controller.reportsBloc,
          builder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state is SendReportState) {
                if (state.flushbarMessage == null) {
                  return null;
                }
                String text = getString(context, state.flushbarMessage!);
                if (text.isNotEmpty) {
                  _showSnackBar(context, state.flushbarMessage!);
                }
              }
            });
            return Scaffold(
              appBar: WhiteAppBar(
                  isGetString: false,
                  title: getString(context, 'reports_new_report'),
                  onPressed: () {
                    _onPop(context, arguments);
                  }),
              bottomNavigationBar: Container(
                color: LelloTheme.palleteOf(theme).customColor(),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    height: 54.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        getString(context, "reports_next"),
                        style: LelloTextStyles.button(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor(),
                        ),
                      ),
                      onPressed: () {
                        if (state is SendReportState) {
                          if (state.report?.typeReport == null) {
                            Flushbar(
                              message: getString(context,
                                  "reports_empty_content_type_flushbar"),
                              duration: Duration(seconds: 2),
                            )..show(context);
                          } else if (state.content.content?.trim() == "" ||
                              state.content.content == null) {
                            Flushbar(
                              message: getString(
                                  context, "reports_empty_content_flushbar"),
                              duration: Duration(seconds: 2),
                            )..show(context);
                          } else {
                            controller.previewReport(
                              report: state.report!,
                              content: state.content,
                            );
                            Navigator.pushNamed(context,
                                ApplicationRoute.reviewNewReport, arguments: [
                              controller
                            ]).then((value) => {
                                  if (value is Report)
                                    {Navigator.pop(context, value)}
                                });
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
              body: _scaffoldBody(
                  context, theme, subjects, controller, sessionBloc),
            );
          },
        ),
      ),
    );
  }

  void _onPop(BuildContext context, RegisterNewReportPageArgs arguments) {
    if (arguments.isSucess) {
      arguments.controller.getAllReports();
    } else {
      arguments.controller.showFirstEvent();
    }
    Navigator.pop(context);
  }

  Widget _scaffoldBody(
      BuildContext context,
      ThemeData theme,
      List<String> subjects,
      ReportsController controller,
      SessionBloc sessionBloc) {
    if (controller.reportsBloc.state is ReportsInitialState ||
        controller.reportsBloc.state is ReportsLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    OwnerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsOwner.ocorrenciasRegistrarNovaOcorrencia(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
      referenceValue:
          sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
    );
    if (controller.reportsBloc.state is SendReportState) {
      return _buildBody(context, theme, subjects, controller,
          controller.reportsBloc.state as SendReportState);
    }
    if (controller.reportsBloc.state is ReportsFailureState) {
      return _buildError();
    }
    return Container();
  }

  SingleChildScrollView _buildBody(
      BuildContext context,
      ThemeData theme,
      List<String> subjects,
      ReportsController controller,
      SendReportState state) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getString(context, "reports_subject"),
                  style: LelloTextStyles.subtitleBold(theme),
                ),
                SizedBox(height: Dimens.spacingSmall),
                _buildDropDown(subjects, state, theme),
              ],
            ),
          ),
          ReportMessageWidget(
            theme: theme,
            content: state.content,
            controller: controller,
            report: state.report!,
          ),
        ],
      ),
    );
  }

  Column _buildError() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                getString(context, "reports_error"),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropDown(
      List<String> subjects, SendReportState state, ThemeData theme) {
    if (state.report?.typeReport != null) {
      _itemSelecionado = getString(context, state.report!.getTypeReport);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: LelloTheme.palleteOf(theme).customColor(),
        border:
            Border.all(width: 1.0, color: LelloTheme.palleteOf(theme).grey()),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: DropdownButton(
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down),
          underline: SizedBox.shrink(),
          hint: Text(getString(context, "reports_choose_type")),
          value: _itemSelecionado,
          items: subjects.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(
                dropDownStringItem,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          onChanged: (value) {
            _dropDownItemSelected(value as String, state);
          }),
    );
  }

  void _dropDownItemSelected(String selectedType, SendReportState state) {
    state.report!.setTypeReport(selectedType);
    setState(() {
      this._itemSelecionado = selectedType;
    });
  }

  _showSnackBar(BuildContext context, String? textKey) {
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
