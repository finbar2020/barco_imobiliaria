import 'package:essentials/essentials.dart' hide Image;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/bloc/preferences_zero_paper_state.dart';
import 'package:morar/feature/preferences/presentation/pages/zero_paper/controllers/preferences_zero_paper_controller.dart';
import 'package:morar/feature/preferences/presentation/widget/preferences_checkbox.dart';
import 'package:morar/feature/preferences/presentation/widget/preferences_success_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class PreferencesZeroPaperPage extends StatefulWidget {
  const PreferencesZeroPaperPage({Key? key}) : super(key: key);

  @override
  _PreferencesZeroPaperPageState createState() =>
      _PreferencesZeroPaperPageState();
}

class _PreferencesZeroPaperPageState extends State<PreferencesZeroPaperPage> {
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final PreferencesZeroPaperController controller =
      ApplicationContainer.instance().resolve<PreferencesZeroPaperController>();
  bool allUnits = false;
  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
    controller.getZeroPaper();
  }

  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme.copyWith(highlightColor: theme.primaryColor),
        child: BlocProvider.value(
          value: controller.bloc,
          child: BlocConsumer(
            bloc: controller.bloc,
            listener: (context, state) {
              if (state is PreferencesZeroPaperSuccessState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreferencesSuccessPage(),
                    ));
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: CustomAppBar(title: "preferences"),
                body: _scaffoldBody(sessionBloc, theme, context,
                    state as PreferencesZeroPaperState),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _scaffoldBody(
    SessionBloc sessionBloc,
    ThemeData theme,
    BuildContext context,
    PreferencesZeroPaperState state,
  ) {
    if (state is PreferencesZeroPaperFailureState) {
      return _buildError();
    } else if (state is PreferencesZeroPaperLoadedState) {
      return _buildBody(sessionBloc, theme, context, state);
    }

    return Column(
      children: [
        Expanded(
          child: LoadingWidget(),
        ),
      ],
    );
  }

  Widget _buildBody(
    SessionBloc sessionBloc,
    ThemeData theme,
    BuildContext context,
    PreferencesZeroPaperLoadedState state,
  ) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: LelloTheme.palleteOf(theme).backgroundDark(),
              width: double.infinity,
              height: Dimens.spacingLarge,
              child: Center(
                child: Text(
                  '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.body(theme),
                ),
              ),
            ),
            SizedBox(height: Dimens.spacing),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/ic_page_zero_paper.png"),
                      SizedBox(width: Dimens.spacingMedium),
                      Text(
                        getString(context, "preferences_zero_paper_campaign"),
                        style: LelloTextStyles.subtitle(theme)!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Text(
                    getString(context, "preferences_zero_paper_description_1"),
                    style: LelloTextStyles.body(theme),
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                    getString(context, "preferences_zero_paper_description_2"),
                    style: LelloTextStyles.body(theme),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Opacity(
                            opacity: 0.0,
                            child: Text(
                              //Apenas para alinhar a coluna
                              'Apenas para espaçamento',
                              style: LelloTextStyles.body(theme),
                            ),
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          Text(
                            getString(context,
                                "preferences_zero_paper_announcements"),
                            style: LelloTextStyles.body(theme),
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          Text(
                            getString(
                                context, "preferences_zero_paper_minutes"),
                            style: LelloTextStyles.body(theme),
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          Text(
                            getString(context, "preferences_zero_paper_slips"),
                            style: LelloTextStyles.body(theme),
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          Text(
                            getString(
                                context, "preferences_zero_paper_statements"),
                            style: LelloTextStyles.body(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                        ],
                      )),
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getString(
                                context, "preferences_zero_paper_digital"),
                            textAlign: TextAlign.center,
                            style: LelloTextStyles.body(theme)!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          PreferencesCheckBox(
                            onTap: () {
                              if (state.digitalAnnouncements == true &&
                                  state.printedAnnouncements == false) {
                                return;
                              } else {
                                setState(() {
                                  state.digitalAnnouncements =
                                      !state.digitalAnnouncements;
                                });
                              }
                            },
                            checked: state.digitalAnnouncements,
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          PreferencesCheckBox(
                            onTap: () {
                              if (state.digitalActs == true &&
                                  state.printedActs == false) {
                                return;
                              } else {
                                setState(() {
                                  state.digitalActs = !state.digitalActs;
                                });
                              }
                            },
                            checked: state.digitalActs,
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          PreferencesCheckBox(
                            onTap: () {
                              if (state.digitalSlips == true &&
                                  state.printedSlips == false) {
                                return;
                              } else {
                                setState(() {
                                  state.digitalSlips = !state.digitalSlips;
                                });
                              }
                            },
                            checked: state.digitalSlips,
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          PreferencesCheckBox(
                            onTap: () {
                              if (state.digitalStatements == true &&
                                  state.printedStatements == false) {
                                return;
                              } else {
                                setState(() {
                                  state.digitalStatements =
                                      !state.digitalStatements;
                                });
                              }
                            },
                            checked: state.digitalStatements,
                          ),
                          SizedBox(height: Dimens.spacing),
                        ],
                      )),
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            getString(
                                context, "preferences_zero_paper_printed"),
                            textAlign: TextAlign.center,
                            style: LelloTextStyles.body(theme)!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          PreferencesCheckBox(
                            onTap: () {
                              if (state.printedAnnouncements == true &&
                                  state.digitalAnnouncements == false) {
                                return;
                              } else {
                                setState(() {
                                  state.printedAnnouncements =
                                      !state.printedAnnouncements;
                                });
                              }
                            },
                            checked: state.printedAnnouncements,
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          PreferencesCheckBox(
                            onTap: () {
                              if (state.printedActs == true &&
                                  state.digitalActs == false) {
                                return;
                              } else {
                                setState(() {
                                  state.printedActs = !state.printedActs;
                                });
                              }
                            },
                            checked: state.printedActs,
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          PreferencesCheckBox(
                            onTap: () {
                              if (state.printedSlips == true &&
                                  state.digitalSlips == false) {
                                return;
                              } else {
                                setState(() {
                                  state.printedSlips = !state.printedSlips;
                                });
                              }
                            },
                            checked: state.printedSlips,
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          PreferencesCheckBox(
                            onTap: () {
                              if (state.printedStatements == true &&
                                  state.digitalStatements == false) {
                                return;
                              } else {
                                setState(() {
                                  state.printedStatements =
                                      !state.printedStatements;
                                });
                              }
                            },
                            checked: state.printedStatements,
                          ),
                          SizedBox(height: Dimens.spacing),
                        ],
                      )),
                    ],
                  ),
                  SizedBox(height: Dimens.spacing),
                  InkWell(
                    onTap: () {
                      setState(() {
                        allUnits = !allUnits;
                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 20.0,
                          width: 20.0,
                          decoration: BoxDecoration(
                              color:
                                  allUnits ? theme.primaryColor : Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0)),
                              border: Border.all(
                                  color: allUnits
                                      ? theme.primaryColor
                                      : LelloTheme.palleteOf(theme).hubText())),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        ),
                        SizedBox(width: Dimens.spacingSmall),
                        Expanded(
                          child: Text(
                            getString(context,
                                "preferences_zero_paper_apply_all_units"),
                            style: LelloTextStyles.body(theme),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                    getString(context, "preferences_zero_paper_description_3"),
                    style: LelloTextStyles.body(theme)!
                        .copyWith(color: LelloTheme.palleteOf(theme).hubText()),
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  PrimaryButton(
                    text: getString(context, "save"),
                    onPressed: () {
                      controller.putZeroPaper(state, allUnits);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildError() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: ErrorHandlingWidget(
              reTryFunction: () {
                controller.getZeroPaper();
              },
              backFunction: () => Navigator.pop(context, true),
              isProduction: env.isProduction,
              error: "",
              errorCode: "",
              textReturnButton: "back_to_the_previous_page",
            ),
          ),
        ),
      ],
    );
  }
}
