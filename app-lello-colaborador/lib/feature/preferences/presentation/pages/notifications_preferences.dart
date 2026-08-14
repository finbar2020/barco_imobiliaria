import 'package:colaborador/core/dependency/application_container.dart';

import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_state.dart';
import 'package:colaborador/feature/preferences/presentation/controller/preferences_notification_controller.dart';
import 'package:colaborador/feature/preferences/presentation/widget/preferences_notification_checkbox.dart';
import 'package:colaborador/feature/preferences/presentation/widget/preferences_success_page.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class PreferencesNotificationPage extends StatefulWidget {
  const PreferencesNotificationPage({Key? key}) : super(key: key);

  @override
  State<PreferencesNotificationPage> createState() =>
      _PreferencesNotificationPageState();
}

class _PreferencesNotificationPageState
    extends State<PreferencesNotificationPage> {
  final PreferencesNotificationController controller =
      ApplicationContainer.instance()
          .resolve<PreferencesNotificationController>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  void initState() {
    super.initState();
    controller.getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: BlocProvider.value(
        value: controller.bloc,
        child: BlocConsumer(
          bloc: controller.bloc,
          listener: (context, state) {
            if (state is PreferencesNotificationSuccessState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreferencesSuccessPage(),
                  ));
            }
          },
          builder: (context, state) {
            return Scaffold(
                appBar: const CustomAppBar(title: "preferences"),
                body: _scaffoldBody(
                    theme, context, state as PreferencesNotificationState),
                bottomNavigationBar: state is PreferencesNotificationLoadedState
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: PrimaryButton(
                          text: getString(context, "save"),
                          onPressed: () {
                            controller.putPreferences(state);
                          },
                        ),
                      )
                    : const SizedBox());
          },
        ),
      ),
    );
  }

  Widget _scaffoldBody(
    ThemeData theme,
    BuildContext context,
    PreferencesNotificationState state,
  ) {
    if (state is PreferencesNotificationFailureState) {
      return Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: ErrorHandlingWidget(
                reTryFunction: () {
                  controller.getPreferences();
                },
                backFunction: () => Navigator.pop(context, true),
                isProduction: env.isProduction,
                error: state.failure?.error.toString() ?? "",
                errorCode: state.failure?.code.toString() ?? "",
              ),
            ),
          ),
        ],
      );
    } else if (state is PreferencesNotificationLoadedState) {
      return _buildBody(theme, state);
    }

    return const Column(
      children: [
        Expanded(
          child: LoadingWidget(),
        ),
      ],
    );
  }

  Widget _buildBody(ThemeData theme, PreferencesNotificationLoadedState state) {
    return RawScrollbar(
      thumbVisibility: true,
      thumbColor: theme.primaryColor,
      thickness: 4.0,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getString(context, "notification"),
                style: LelloTextStyles.titleSmallBold(theme),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "preferences_notification_subtitle"),
                style: LelloTextStyles.body(theme),
              ),
              SizedBox(height: Dimens.spacingLarge),
              ...List.generate(state.preferences.length,
                  (index) => buildItem(state.preferences[index])),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(PreferencesNotificationEntity item) {
    var title = toBeginningOfSentenceCase(
        item.title == "" ? item.module : getString(context, item.title));
    if (title == null) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: PreferencesNotificationCheckBox(
        checked: item.active!,
        title: title,
        onTap: () {
          setState(() {
            item.active = !item.active!;
          });
        },
      ),
    );
  }
}
