import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/domain/entity/pending_request.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_error.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_success.dart.dart';
import 'package:morar/feature/sub_user/presentation/pages/service/sub_user_service_off_page.dart';
import 'package:morar/feature/sub_user/presentation/pages/service/sub_user_service_on_page.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_bottom_button.dart';
import 'package:morar/feature/sub_user/presentation/widget/sub_user_card_widget.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

import '../../../../generated/l10n.dart';
import '../bloc/sub_user_edit_bloc.dart';
import '../bloc/sub_users_bloc.dart';
import '../controllers/sub_user_edit_controller.dart';
import '../widget/sub_user_owner_card_widget.dart';

class SubUserPageArgs {
  String? subUserNotificationContext;

  SubUserPageArgs({this.subUserNotificationContext});
}

class SubUserPage extends StatefulWidget {
  const SubUserPage({Key? key}) : super(key: key);

  @override
  _SubUserPageState createState() => _SubUserPageState();
}

class _SubUserPageState extends State<SubUserPage> {
  final controller =
      ApplicationContainer.instance().resolve<SubUserController>();
  final editController =
      ApplicationContainer.instance().resolve<SubUserEditController>();
  SubUserPageArgs? arguments;
  late SessionBloc sessionBloc;

  Environment env = ApplicationContainer.instance().resolve<Environment>();

  String? currentUserId;

  @override
  void initState() {
    super.initState();
    controller.getSubUsers();
    currentUserId = controller.sessionBloc.state.session?.me?.id;
    sessionBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)?.settings.arguments as SubUserPageArgs?;
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: WhiteAppBar(
          title: getString(context, "resident_access_app"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottomNavigationBar: Container(
          height: Dimens.homeBalanceHeightCollapsed,
          width: double.infinity,
          child: Center(
            child: CircuitBreakerWidget(
              reference:
                  sessionBloc.state.session?.condominium?.reference ?? "",
              appContainer: ApplicationContainer.instance(),
              applicationRbac: ApplicationRbac.morarMoradoresAdicionarUsuario,
              rbacEnabled: sessionBloc
                  .checkRback(ApplicationRbac.morarMoradoresAdicionarUsuario),
              child: SubUserBottomButton(
                title: getString(context, "add_user"),
                onTap: () {
                  OwnerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsOwner.moradoresAdicionarNovoUsuario(),
                    userId: sessionBloc.state.session?.me?.id ?? "",
                    unitValue: controller
                            .sessionBloc.state.session!.unity?.title
                            .toString() ??
                        "",
                    referenceValue: controller
                            .sessionBloc.state.session!.condominium?.reference
                            ?.toString() ??
                        "",
                  );

                  Navigator.pushNamed(
                    context,
                    ApplicationRoute.subUserNewContact,
                  );
                },
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: controller.getSubUsers,
          child: SingleChildScrollView(
            physics:
                AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: BlocConsumer(
              bloc: controller.bloc,
              listener: (context, state) async {
                if (state is SubUserLoadedState && state.sucess) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendInviteSuccessPage(),
                    ),
                  );
                }
                if (state is SendInviteSuccessState) {
                  controller.userSelected = controller.userSelected
                      .copyWith(useFacialBiometric: true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendInviteSuccessPage(),
                    ),
                  );
                }
                if (state is SendInviteFailedState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SendInviteErrorPage(),
                    ),
                  );
                }
                if (state is CheckServiceOnlineState) {
                  await Navigator.pushNamed(
                      context, ApplicationRoute.subUserServiceOn,
                      arguments: SubUserServiceOnPageArgs(
                        subUser: controller.mainUser,
                      ));
                  controller.getSubUsers();
                }
                if (state is CheckServiceOfflineState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubUserServiceOffPage(),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is SubUserEmptyState ||
                    state is SubUserLoadingState ||
                    state is SubUserEditLoadingState) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: LoadingWidget(),
                  );
                }

                if (state is SubUserLoadedState) {
                  List<SubUser> users;
                  List<PendingRequestEntity> pending;
                  try {
                    if (currentUserId == null)
                      throw Exception("main user not found");

                    users = state.subUsers
                        .where(
                          (element) => element.id != currentUserId,
                        )
                        .toList();
                    pending = state.pendingRequests;

                    controller.mainUser = state.subUsers.singleWhere(
                      (element) => element.id == currentUserId,
                    );
                  } catch (ex) {
                    controller.bloc.add(SubUserErrorEvent(
                        error: UnknownFailure("user not found")));
                    return SizedBox.shrink();
                  }

                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    if (arguments?.subUserNotificationContext?.isNotEmpty ==
                            true &&
                        mounted) {
                      var item = state.subUsers.cast<SubUser?>().firstWhere(
                          (element) =>
                              element?.notificationParameter ==
                                  arguments?.subUserNotificationContext ||
                              element?.id ==
                                  arguments?.subUserNotificationContext,
                          orElse: () => null);
                      if (item != null) {
                        editController.userSelected = item;
                        Navigator.pushNamed(
                          context,
                          ApplicationRoute.subUserEdit,
                        );
                      }
                      arguments?.subUserNotificationContext = null;
                    }
                  });
                  return Column(
                    children: [
                      if (sessionBloc.checkRback(ApplicationRbac
                              .morarMoradoresSubmoradoresDetalhes) &&
                          pending.isNotEmpty &&
                          controller.mainUser.role == 'morar.proprietario')
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ApplicationRoute.subUserPendingRequests,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 16.0,
                            ),
                            color: LelloTheme.palleteOf(theme).warning(),
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                S.of(context).pendingRequestsCounter(
                                      pending.length,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                style:
                                    LelloTextStyles.bodyBold(theme)?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        color: LelloTheme.palleteOf(theme).backgroundDark(),
                        width: double.infinity,
                        height: Dimens.spacingLarge,
                        child: Center(
                          child: Text(
                            '${controller.sessionBloc.state.session?.condominium?.name ?? ''} - ${controller.sessionBloc.state.session?.unity?.title ?? ''}',
                            overflow: TextOverflow.ellipsis,
                            style: LelloTextStyles.body(theme),
                          ),
                        ),
                      ),
                      SubUserOwnerCardWidget(model: controller.mainUser),
                      Divider(height: 0),
                      CircuitBreakerWidget(
                        applicationRbac:
                            ApplicationRbac.morarMoradoresSubmoradores,
                        reference:
                            controller.session.condominium?.reference ?? "",
                        appContainer: ApplicationContainer.instance(),
                        rbacEnabled: controller.sessionBloc.checkRback(
                            ApplicationRbac.morarMoradoresSubmoradores),
                        child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) =>
                              Divider(height: 1),
                          itemBuilder: (BuildContext context, int index) {
                            final subUser = users[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: SubUserCardWidget(
                                model: subUser,
                                sessionBloc: controller.sessionBloc,
                                isList: true,
                                showExpirationLabel:
                                    controller.mainUser.id != subUser.id &&
                                        controller.mainUser.role ==
                                            'morar.proprietario',
                                onPressed: sessionBloc.checkRback(
                                        ApplicationRbac
                                            .morarMoradoresSubmoradoresDetalhes)
                                    ? () async {
                                        editController.userSelected = subUser;
                                        Navigator.pushNamed(
                                          context,
                                          ApplicationRoute.subUserEdit,
                                        );
                                      }
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                if (state is SubUserErrorState) {
                  return _buildErrorWidget(
                      context,
                      state.error?.error.toString(),
                      state.error?.code.toString());
                } else {
                  return _buildErrorWidget(context,
                      "currentState: ${state.toString()}", "No state Defined");
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildErrorWidget(
      BuildContext context, String? error, String? errorCode) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.7,
        child: ErrorHandlingWidget(
          reTryFunction: () {
            controller.getSubUsers();
          },
          error: error ?? "",
          errorCode: errorCode ?? "",
          backFunction: () => Navigator.pop(context, true),
          isProduction: env.isProduction,
        ),
      ),
    );
  }
}
