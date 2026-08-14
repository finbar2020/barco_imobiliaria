import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/sub_user/domain/entity/pending_request.dart';
import 'package:morar/feature/sub_user/presentation/bloc/sub_users_bloc.dart';
import 'package:morar/feature/sub_user/presentation/pages/pending_requests/pending_requests_enum.dart';
import 'package:morar/feature/sub_user/presentation/pages/pending_requests/update_access_request_status_success.dart.dart';
import 'package:morar/feature/sub_user/presentation/widget/update_access_request_status_confirm_dialog.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../generated/l10n.dart';
import '../../../../session/presentation/bloc/session_bloc.dart';
import '../../controllers/sub_user_controller.dart';
import '../../widget/no_expiration_date_dialog.dart';

class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage({Key? key}) : super(key: key);

  @override
  State<PendingRequestsPage> createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends State<PendingRequestsPage> {
  late final SubUserController controller;
  late final SessionBloc sessionBloc;
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  void initState() {
    super.initState();
    controller = ApplicationContainer.instance().resolve<SubUserController>();
    sessionBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: CustomAppBar(
          title: S.of(context).pending_requests,
          useGetString: false,
          actions: [
            IconButton(
              onPressed: () {
                _showFeatureMovedFullscreenDialog(theme);
              },
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.question_mark,
                  size: 16,
                ),
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: controller.getSubUsers,
          child: BlocConsumer(
            bloc: controller.bloc,
            listener: (context, state) async {
              if (state is UpdateAccessStatusRequestSuccessState) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UpdateRequestStatusSuccessPage(status: state.status),
                  ),
                );
                controller.getSubUsers();
              }
            },
            builder: (context, state) {
              if (state is SubUserLoadingState ||
                  state is UpdateStatusRequestLoadingState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: LoadingWidget(),
                );
              }

              if (state is SubUserErrorState) {
                return _buildErrorWidget(context, state.error?.error.toString(),
                    state.error?.code.toString());
              }

              if (state is UpdateAccessStatusRequestErrorState) {
                return _buildErrorWidget(context, state.error?.error.toString(),
                    state.error?.code.toString());
              }

              if (state is SubUserLoadedState) {
                if (state.pendingRequests.isEmpty) {
                  Navigator.of(context).pop();
                }
                return _buildContent(theme, context, state.pendingRequests);
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    BuildContext context,
    List<PendingRequestEntity> pending,
  ) =>
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          S.of(context).clickTo,
                          style: LelloTextStyles.body(theme),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          S.of(context).approve.toLowerCase(),
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check_circle,
                          color: LelloTheme.palleteOf(theme).success(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          S.of(context).or,
                          style: LelloTextStyles.body(theme),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          getString(context, 'block').toLowerCase(),
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.cancel,
                          color: LelloTheme.palleteOf(theme).error(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          S.of(context).aRequest,
                          style: LelloTextStyles.body(theme),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: pending.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => _buildCard(
                        context,
                        theme,
                        pending[index],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget _buildCard(
      BuildContext context, ThemeData theme, PendingRequestEntity entity) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Card(
          color: LelloTheme.palleteOf(theme).background(),
          elevation: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  start: BorderSide(
                    color: entity.registrationOrigin.name == "CADASTRO"
                        ? Color(0xFFC20332)
                        : entity.registrationOrigin.color(theme),
                    width: 6,
                  ),
                ),
              ),
              child: ExpandablePanel(
                header: _buildCardHeader(context, theme, entity),
                collapsed: _buildCardCollapsedContent(context, theme, entity),
                expanded: _buildCardExpandedContent(context, theme, entity),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(
      BuildContext context, ThemeData theme, PendingRequestEntity entity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: entity.registrationOrigin.name == "CADASTRO"
                  ? Color(0xFFC20332)
                  : entity.registrationOrigin.color(theme),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              entity.registrationOrigin.name,
              style: LelloTextStyles.captionBold(theme)
                  ?.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              entity.remainingDays,
              style: LelloTextStyles.captionBold(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).grey(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardCollapsedContent(
      BuildContext context, ThemeData theme, PendingRequestEntity entity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              S.of(context).profileWithTwoDots,
              style: LelloTextStyles.subtitle(theme),
            ),
            const SizedBox(width: 8),
            Text(
              entity.linkDescription,
              style: LelloTextStyles.subtitleBold(theme),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          entity.name,
          style: LelloTextStyles.subtitle(theme),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCardExpandedContent(
      BuildContext context, ThemeData theme, PendingRequestEntity entity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              S.of(context).profileWithTwoDots,
              style: LelloTextStyles.subtitle(theme),
            ),
            const SizedBox(width: 8),
            Text(
              entity.linkDescription,
              style: LelloTextStyles.subtitleBold(theme),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          entity.name,
          style: LelloTextStyles.subtitle(theme),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      getString(context, 'block'),
                      style: LelloTextStyles.button(theme)
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      content: UpdateAccessRequestStatusConfirmDialog(
                        name: entity.name,
                        type: entity.linkDescription,
                        origin: entity.registrationOrigin,
                        status: 'REPROVADA_PROPRIETARIO',
                        onConfirm: () async {
                          final id = entity.id;
                          controller.updateAccessRenewalRequestStatus(
                            id,
                            'REPROVADA_PROPRIETARIO',
                            entity.expirationDate,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PrimaryButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).approve,
                      style: LelloTextStyles.button(theme)
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      content: entity.registrationOrigin ==
                              RegistrationOrigin.registrationWithoutContract
                          ? NoExpirationDateDialog(
                              onApproveAccess: (date) async {
                                final id = entity.id;
                                controller.updateAccessRenewalRequestStatus(
                                  id,
                                  'APROVADA_PROPRIETARIO',
                                  date,
                                );
                              },
                            )
                          : UpdateAccessRequestStatusConfirmDialog(
                              name: entity.name,
                              type: entity.linkDescription,
                              status: 'APROVADA_PROPRIETARIO',
                              origin: entity.registrationOrigin,
                              onConfirm: () async {
                                final id = entity.id;
                                controller.updateAccessRenewalRequestStatus(
                                  id,
                                  'APROVADA_PROPRIETARIO',
                                  entity.expirationDate,
                                );
                              },
                            ),
                    ),
                  );
                },
                buttonColor: LelloTheme.palleteOf(theme).success(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
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

  void _showFeatureMovedFullscreenDialog(
    ThemeData theme,
  ) =>
      showModalBottomSheet(
        context: context,
        useSafeArea: false,
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (context) => FractionallySizedBox(
          heightFactor: 0.9,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height + 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: AutoSizeText(
                        'Entenda os tipos de solicitações',
                        style: LelloTextStyles.titleBold(theme),
                      ),
                    ),
                    const SizedBox(height: 16),
                    AutoSizeText(
                      'Alguns acessos vão precisar da sua aprovação antes de serem liberado.\n\nAbaixo você encontra os tipos de aprovações, organizados de acordo com a origem de cada um, junto com as principais diferenças entre eles:',
                      style: LelloTextStyles.body(theme),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SvgPicture.asset('assets/pending_request1.svg'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 7),
                          height: 8,
                          width: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: LelloTheme.palleteOf(theme).primary(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: RichText(
                            maxLines: 3,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Cadastro administradora: ',
                                  style: LelloTextStyles.bodyBold(theme),
                                ),
                                TextSpan(
                                  text:
                                      'O acesso será liberado automaticamente em até 2 dias, a menos que você recuse antes desse prazo.',
                                  style: LelloTextStyles.body(theme),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SvgPicture.asset('assets/pending_request2.svg'),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 7),
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0058a0),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: RichText(
                              maxLines: 4,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Cadastro Portaria: ',
                                    style: LelloTextStyles.bodyBold(theme),
                                  ),
                                  TextSpan(
                                    text:
                                        'O acesso será liberado automaticamente em até 2 dias, a menos que você recuse antes desse prazo.',
                                    style: LelloTextStyles.body(theme),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: SvgPicture.asset('assets/pending_request3.svg'),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 7),
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF8D3393),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: RichText(
                              maxLines: 10,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Troca de titularidade: ',
                                    style: LelloTextStyles.bodyBold(theme),
                                  ),
                                  TextSpan(
                                    text:
                                        'O acesso será bloqueado automaticamente em até 5 dias, a menos que você aprove antes desse prazo. Todos os moradores cadastrado por ele também serão aprovados ou bloqueados.',
                                    style: LelloTextStyles.body(theme),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Flexible(
                      child: SvgPicture.asset('assets/pending_request4.svg'),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 7),
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: LelloTheme.palleteOf(theme).warning(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: RichText(
                              maxLines: 3,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Cadastro sem contrato: ',
                                    style: LelloTextStyles.bodyBold(theme),
                                  ),
                                  TextSpan(
                                    text:
                                        'Só será liberado se você aprovar. Se ninguém tomar ação, permanecerá pendente.',
                                    style: LelloTextStyles.body(theme),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: 'Entendi',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
