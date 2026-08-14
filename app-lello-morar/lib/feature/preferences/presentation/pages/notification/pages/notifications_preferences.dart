import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/bloc/preferences_notification_state.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/controller/preferences_notification_controller.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/widget/preferences_notification_toggle.dart';
import 'package:morar/feature/preferences/presentation/widget/preferences_success_page.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class PreferencesNotificationPage extends StatefulWidget {
  const PreferencesNotificationPage({Key? key}) : super(key: key);

  /// Show the notification preferences as a modal bottom sheet.
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) =>
            const PreferencesNotificationPage(),
      ),
    );
  }

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
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    controller.getPreferences();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocProvider.value(
      value: controller.bloc,
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BlocConsumer(
          bloc: controller.bloc,
          listener: (context, state) {
            if (state is PreferencesNotificationSuccessState) {
              Navigator.pop(context); // close the bottom sheet
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreferencesSuccessPage(),
                  ));
            }
          },
          builder: (context, state) {
            return _scaffoldBody(
                theme, context, state as PreferencesNotificationState);
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
      return Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: ErrorHandlingWidget(
          reTryFunction: () => controller.getPreferences(),
          backFunction: () => Navigator.pop(context),
          isProduction: env.isProduction,
          error: "",
          errorCode: "",
          textReturnButton: "back_to_the_previous_page",
        ),
      );
    } else if (state is PreferencesNotificationLoadedState) {
      return _buildBody(theme, state);
    }

    return Column(
      children: [
        Expanded(
          child: LoadingWidget(),
        ),
      ],
    );
  }

  Widget _buildBody(ThemeData theme, PreferencesNotificationLoadedState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/ic_preferences.svg',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  getString(context, "preferences_notification_page_title"),
                  style: LelloTextStyles.titleSmallBold(theme),
                ),
              ],
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              getString(context, "preferences_notification_subtitle"),
              style: LelloTextStyles.body(theme),
            ),
            SizedBox(height: Dimens.spacingLarge),
            PreferencesNotificationToggle(
              value: selectAll,
              style: LelloTextStyles.bodyBold(theme),
              title: getString(context, "preferences_notification_toggle_all"),
              onChanged: (value) {
                setState(() {
                  selectAll = value;
                  for (var e in state.preferences) {
                    e.active = value;
                  }
                });
              },
            ),
            const Divider(),
            ...List.generate(state.preferences.length,
                (index) => _buildItem(state.preferences[index])),
            SizedBox(height: Dimens.spacing),
            PrimaryButton(
              text: getString(context, "save"),
              onPressed: () {
                controller.putPreferences(state);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(PreferencesNotificationEntity item) {
    var title = toBeginningOfSentenceCase(
        item.title == "" ? item.module : getString(context, item.title));
    if (title == null) return Container();
    return PreferencesNotificationToggle(
      value: item.active!,
      title: title,
      onChanged: (value) {
        setState(() {
          item.active = value;
          _updateSelectAll();
        });
      },
    );
  }

  void _updateSelectAll() {
    final bloc = controller.bloc;
    if (bloc.state is PreferencesNotificationLoadedState) {
      final loaded = bloc.state as PreferencesNotificationLoadedState;
      setState(() {
        selectAll = loaded.preferences.every((e) => e.active == true);
      });
    }
  }
}
