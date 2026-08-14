import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_all_info.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_day_quotas_dialog.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_no_avaible.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_quota_available_card.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_approved_proposal_bottom.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreements_rejected_proposal_bottom.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AgreementsPageArgs {
  bool didAnimateTo = false;
  String? agreementsNotificationContext;
  AgreementAllInfo? agreementAllInfo;
  AgreementsPageArgs({
    this.agreementsNotificationContext,
    this.agreementAllInfo,
  });
}

class AgreementsPage extends StatefulWidget {
  const AgreementsPage({Key? key}) : super(key: key);

  @override
  _AgreementsPageState createState() => _AgreementsPageState();
}

class _AgreementsPageState extends State<AgreementsPage>
    with SingleTickerProviderStateMixin {
  static const MAX_CARDS = 0;
  late TabController controller;

  List<bool> checkList = [];
  List<bool> checkeds = [];
  List pending = [];
  bool firstLoad = true;
  int selectedTab = 0;

  AgreementCreated agreement = AgreementCreated();
  AgreementsPageArgs? arguments;
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final bloc = ApplicationContainer.instance().resolve<AgreementsBloc>();

  @override
  void initState() {
    super.initState();
    final SessionBloc sessionBloc = BlocProvider.of(context);
    if (!bloc.isFirstMadeCall) {
      bloc.getQuotaAvailable();
      bloc.isFirstMadeCall = true;
    }
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {
        selectedTab = controller.index;
        if (selectedTab == 1 && !bloc.isFirstMadeCall) {
          bloc.getQuotaAvailable();
          bloc.isFirstMadeCall = true;
        }
      });
      _registerAnalyticsEvent(selectedTab, sessionBloc);
    });
  }

  @override
  void dispose() {
    bloc.isFirstMadeCall = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    arguments =
        ModalRoute.of(context)?.settings.arguments as AgreementsPageArgs?;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocProvider.value(
            value: bloc,
            child: BlocConsumer(
              bloc: bloc,
              builder: (context, AgreementsState state) {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  if (arguments?.agreementsNotificationContext?.isNotEmpty ==
                          true &&
                      arguments?.didAnimateTo == false &&
                      mounted) {
                    arguments?.didAnimateTo = true;
                    controller.animateTo(1);
                  }
                });
                return Scaffold(
                  appBar: _buildAppBar(context, theme),
                  body: state is! AgreementsQuotaErrorState
                      ? TabBarView(
                          controller: controller,
                          children: [
                            _agreementsAvailableBody(theme, state, bloc),
                            _agreementsMadeBody(theme, state, bloc),
                          ],
                        )
                      : Padding(
                          padding: EdgeInsets.all(Dimens.spacingMedium),
                          child: ErrorHandlingWidget(
                            reTryFunction: () {
                              bloc.getQuotaAvailable();
                            },
                            backFunction: () => Navigator.pop(context, true),
                            isProduction: env.isProduction,
                            error: "",
                            errorCode: "",
                          ),
                        ),
                );
              },
              listener: (context, state) {
                if (state is AgreementsQuotaErrorState &&
                    state.errorMessageKey ==
                        "agreement_not_avaliable_failure") {
                  Navigator.pop(context, new Exception(state.errorMessageKey));
                }
              },
            )),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: Text(
        getString(context, "agreements"),
        textAlign: TextAlign.center,
        style: TextStyle(color: LelloTheme.palleteOf(theme).customColor()),
      ),
      centerTitle: true,
      iconTheme:
          IconThemeData(color: LelloTheme.palleteOf(theme).customColor()),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12))),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            color: LelloTheme.palleteOf(theme).backgroundDark(),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(-12),
              topRight: Radius.circular(-12),
            ),
          ),
          child: TabBar(
            labelColor: theme.primaryColor,
            labelStyle: LelloTextStyles.subBody(theme),
            unselectedLabelColor: LelloTheme.palleteOf(theme).textOpaque(),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: theme.primaryColor,
              ),
            ),
            controller: controller,
            tabs: [
              Tab(
                text: getString(context, "agreements_available"),
              ),
              Tab(
                text: getString(context, "agreements_made"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _agreementsAvailableBody(
      ThemeData theme, AgreementsState state, AgreementsBloc bloc) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.getQuotaAvailable();
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getString(context, 'available_quotas_title'),
                          style:
                              LelloTextStyles.titleSmallBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).hubText(),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(getString(context, 'description_available_quota'),
                            style: LelloTextStyles.subtitle(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).hubText(),
                            )),
                        SizedBox(height: Dimens.spacingSmall),
                        if (state is AgreementsQuotaLoadingState)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 60.0),
                                child: Center(child: LoadingWidget()),
                              ),
                            ],
                          ),
                        if (state is AgreementsQuotaAvailableLoadedState)
                          _viewListQuota(state, theme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (state is AgreementsQuotaAvailableLoadedState) _nextButton(state)
          ],
        ),
      ),
    );
  }

  Widget _agreementsMadeBody(ThemeData theme, AgreementsState state, bloc) {
    return RefreshIndicator(
      onRefresh: () async {
        bloc.getQuotaAvailable();
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getString(context, 'agreements_made_title'),
                          style:
                              LelloTextStyles.titleSmallBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).hubText(),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        if (state is AgreementsQuotaLoadingState)
                          Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Center(child: LoadingWidget()),
                          ),
                        if (state is AgreementsQuotaAvailableLoadedState)
                          _viewListAgreement(
                              state, arguments?.agreementsNotificationContext),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _viewListQuota(
      AgreementsQuotaAvailableLoadedState state, ThemeData theme) {
    if (state.agreementsQuotaAvailable.isEmpty)
      return Expanded(child: AgreementsNoAvailableWidget());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(getString(context, 'description_available_quota_subtitle'),
            style: LelloTextStyles.subtitle(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            )),
        SizedBox(height: Dimens.spacingSmall),
        ...List.generate(
            state.agreementsQuotaAvailable.length,
            (index) => IgnorePointer(
                  ignoring: checkIgnoringPointer(index, state),
                  child: Opacity(
                    opacity: checkOpacity(index, state),
                    child: GestureDetector(
                      onTap: () => _checkIndex(state, index),
                      child: AgreementsQuotaAvailableWidget(
                        agreementQuota: state.agreementsQuotaAvailable[index],
                        isChecked: state.checkList[index],
                        onChanged: (bool? value) {
                          _checkIndex(state, index);
                        },
                        dialogOnPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                )),
      ],
    );
  }

  bool checkIgnoringPointer(
      int index, AgreementsQuotaAvailableLoadedState state) {
    if (index == 0) {
      return false;
    } else if (MAX_CARDS > 0 && index + 1 > MAX_CARDS) {
      return true;
    } else {
      if (state.checkList[index] != 0) {
        if (state.checkList[index - 1]) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    }
  }

  double checkOpacity(int index, AgreementsQuotaAvailableLoadedState state) {
    if (index == 0) {
      return 1.0;
    } else if (MAX_CARDS > 0 && index + 1 > MAX_CARDS) {
      return 0.3;
    } else {
      if (state.checkList[index] != 0) {
        if (state.checkList[index - 1]) {
          return 1.0;
        } else {
          return 0.3;
        }
      } else {
        return 1.0;
      }
    }
  }

  Widget _viewListAgreement(AgreementsQuotaAvailableLoadedState state,
      String? agreementsNotificationContext) {
    if (state.agreements.isEmpty)
      return Expanded(child: AgreementsNoAvailableWidget(agreement: true));
    if (agreementsNotificationContext != null) {
      var agreement = state.agreements.cast<Agreement?>().firstWhere(
          (element) =>
              element?.notificationParameter == agreementsNotificationContext ||
              element?.id == agreementsNotificationContext,
          orElse: () => null);
      if (agreement != null) {
        agreement.highlight = true;
      }
      arguments?.agreementsNotificationContext = null;
    } else {
      showBottomSheet(state);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
            state.agreements.length,
            (index) => AgreementCard(
                  agreement: state.agreements[index],
                  agreementCreated: agreement,
                  bloc: bloc,
                  anotherContext: context,
                )),
      ],
    );
  }

  showBottomSheet(AgreementsQuotaAvailableLoadedState state) {
    if (selectedTab == 1 && state.agreements[0].isReleased && firstLoad) {
      firstLoad = false;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return AgreementsApprovedProposalBottom();
          },
        );
      });
    } else if (selectedTab == 1 &&
        state.agreements[0].isRejected &&
        firstLoad) {
      firstLoad = false;
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return AgreementsRejectedProposalBottom(
                agreement: state.agreements[0]);
          },
        );
      });
    }
  }

  Widget _nextButton(AgreementsQuotaAvailableLoadedState state) {
    return Container(
      width: double.infinity,
      height: 52.0,
      padding: const EdgeInsets.only(top: 10.0),
      child: IgnorePointer(
        ignoring: agreement.totalValue == 0.0,
        child: Opacity(
          opacity: agreement.totalValue == 0.0 ? 0.3 : 1.0,
          child: PrimaryButton(
            text: getString(context, "next"),
            onPressed: () {
              bloc.getChoicePayment();
              Navigator.pushNamed(
                context,
                ApplicationRoute.agreementsChoicePayment,
                arguments: [bloc, agreement],
              );
            },
          ),
        ),
      ),
    );
  }

  _checkIndex(AgreementsQuotaAvailableLoadedState state, int index) {
    if (index == 0) {
      _checkFirtsIndex(state, index);
    } else {
      if (state.checkList[index - 1]) {
        if (!state.checkList[index] &&
            (MAX_CARDS == 0 || checkeds.length < MAX_CARDS)) {
          setState(() {
            state.checkList[index] = true;
            agreement.receiptList
                .add(state.agreementsQuotaAvailable[index].receipt);
            agreement.totalValue +=
                state.agreementsQuotaAvailable[index].valorTotal;
          });
        } else {
          setState(() {
            state.checkList = List.generate(state.checkList.length, (i) {
              if (i >= index && state.checkList[i]) {
                agreement.totalValue -=
                    state.agreementsQuotaAvailable[i].valorTotal;
                String receipt = state.agreementsQuotaAvailable[i].receipt;
                agreement.receiptList.remove(receipt);
              }
              return i >= index ? false : state.checkList[i];
            });
          });
        }
      }
    }

    checkeds = state.checkList.where((element) => element == true).toList();
  }

  _checkFirtsIndex(AgreementsQuotaAvailableLoadedState state, int index) {
    if (state.agreements.isNotEmpty) {
      pending = state.agreements.where((element) => element.isPending).toList();
    }
    if (pending.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AgreementDayQuotasDialog(
          pendingAgreement: true,
        ),
      );
    } else if (state.checkList[index]) {
      setState(() {
        state.checkList =
            List.generate(state.checkList.length, (index) => false);
        agreement.totalValue = 0;
        agreement.receiptList = [];
      });
    } else {
      setState(() {
        state.checkList[index] = true;
      });
      agreement.receiptList = [
        state.agreementsQuotaAvailable[index].receipt
      ];
      agreement.totalValue += state.agreementsQuotaAvailable[index].valorTotal;
    }
  }

  void _registerAnalyticsEvent(selectedTab, SessionBloc sessionBloc) {
    if (selectedTab == 0 || selectedTab == 1) {
      OwnerAnalyticsLogEvents.logEvent(
        userId: sessionBloc.state.session?.me?.id ?? "",
        event: selectedTab == 0
            ? AnalyticsEventsOwner.acordosAcessarCotasDisponiveis()
            : AnalyticsEventsOwner.acordosAcessarAcordosRealizados(),
        unitValue:
            sessionBloc.state.session!.unity?.namedTitle.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
    }
  }
}
