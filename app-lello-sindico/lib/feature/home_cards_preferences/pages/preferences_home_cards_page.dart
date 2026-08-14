import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:lello/feature/home/domain/entity/home_item_enum.dart';
import 'package:lello/feature/home_cards_preferences/bloc/preferences_home_cards_state.dart';
import 'package:lello/feature/home_cards_preferences/controller/preferences_home_cards_controller.dart';
import 'package:lello/feature/home_cards_preferences/pages/preferences_home_cards_onboarding_page.dart';
import 'package:lello/feature/home_cards_preferences/widgets/preferences_home_cards_widget.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/shared_features.dart';

class PreferencesHomeCardsPage extends StatefulWidget {
  const PreferencesHomeCardsPage({super.key});

  @override
  State<PreferencesHomeCardsPage> createState() =>
      _PreferencesHomeCardsPageState();
}

class _PreferencesHomeCardsPageState extends State<PreferencesHomeCardsPage> {
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final PreferencesHomeCardsController controller =
      ApplicationContainer.instance().resolve<PreferencesHomeCardsController>();
  late ScrollController _scrollController;

  //TODO: Reavaliar ScrollIndicator
  bool showScrollIndicator = false;
  bool isScrollable = true;
  late DashboardBloc dashBoardBloc;

  @override
  void initState() {
    controller.getCards(context);
    dashBoardBloc = ApplicationContainer.instance().resolve();
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(title: "preferences"),
      body: BlocListener(
        bloc: controller.bloc,
        listener: (context, state) {
          if (state is PreferencesHomeCardsLoadedState && state.success) {
            dashBoardBloc.add(DashboardGetMostAccessedEvent());
            Navigator.of(context).popUntil(
              ModalRoute.withName(SharedApplicationRoute.home),
            );
          } else if (state is PreferencesHomeCardsLoadedState &&
              state.showOnboarding) {
            controller.saveOnboardingInfo(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreferencesHomeCardsOnboardingPage(
                  controller: controller,
                ),
              ),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getString(context, "preferences_cards_tile"),
                    style: LelloTextStyles.titleSmallBold(theme),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(
                    getString(context, "preferences_cards_home_title"),
                    style: LelloTextStyles.body(theme),
                  ),
                  SizedBox(height: Dimens.spacingXSmall),
                  BlocBuilder(
                    bloc: controller.bloc,
                    builder: (context, state) {
                      return (state as PreferencesHomeCardsState).cards.length >
                              4
                          ? Text(
                              getString(context, "preferences_cards_home_rule"),
                              style: LelloTextStyles.subBody(theme)!
                                  .copyWith(color: const Color(0xFFE5073E)),
                            )
                          : Container();
                    },
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                ],
              ),
            ),
            BlocBuilder(
              bloc: controller.bloc,
              builder: (context, state) {
                if (state is PreferencesHomeCardsLoadingState) {
                  return const Expanded(
                    child: LoadingWidget(),
                  );
                }
                if (state is PreferencesHomeCardsFailedState) {
                  return Expanded(child: _buildError());
                }
                if (state is PreferencesHomeCardsLoadedState) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      setState(() {
                        isScrollable =
                            _scrollController.position.maxScrollExtent != 0;
                      });
                    }
                  });
                  return Expanded(
                    child: Stack(alignment: Alignment.center, children: [
                      if (showScrollIndicator && isScrollable)
                        const Positioned(
                          //right: 10,
                          //bottom: 70,
                          child: ScrollIndicator(),
                        ),
                      ListView(
                        shrinkWrap: true,
                        controller: _scrollController,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.start,
                            children: List.generate(
                                state.cards.length,
                                (index) => PreferencesHomeCardWidget(
                                      imagePath: state.cards[index].icon,
                                      sessionBloc: controller.sessionBloc,
                                      text: state.cards[index].title,
                                      isFavorite: state.favorites
                                          .contains(state.cards[index]),
                                      onTap: () {
                                        controller.onTap(index);
                                      },
                                    )),
                          ),
                        ],
                      ),
                    ]),
                  );
                }
                return Container();
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: BlocBuilder(
                bloc: controller.bloc,
                builder: (context, state) {
                  return PrimaryButton(
                      text: getString(context, "save"),
                      onPressed:
                          (state as PreferencesHomeCardsState).cards.length > 4
                              ? state.favorites.length < 4
                                  ? null
                                  : () {
                                      controller.savePreferences(context);
                                    }
                              : () {
                                  controller.savePreferences(context);
                                });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    if (showScrollIndicator == false) return;
    if (_scrollController.position.isScrollingNotifier.value) {
      setState(() {
        showScrollIndicator = false;
      });
      return;
    }
  }

  Column _buildError() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: ErrorHandlingWidget(
              reTryFunction: () {
                controller.getCards(context);
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
