// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_error.dart';
import 'package:morar/feature/sub_user/presentation/pages/send_invite/sub_user_send_invite_success.dart.dart';

import 'package:essentials/essentials.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../../../../generated/l10n.dart';
import '../../../domain/entity/sub_user.dart';
import '../../bloc/sub_users_bloc.dart';
import '../../controllers/sub_user_controller.dart';

class SubUserSendInviteParams {
  final SubUser subUser;

  SubUserSendInviteParams({required this.subUser});
}

class SubUserSendInvitePage extends StatefulWidget {
  SubUserSendInvitePage({
    Key? key,
  }) : super(key: key);

  @override
  State<SubUserSendInvitePage> createState() => _SubUserSendInvitePageState();
}

class _SubUserSendInvitePageState extends State<SubUserSendInvitePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    final SubUserSendInviteParams args = arguments as SubUserSendInviteParams;
    final controller =
        ApplicationContainer.instance().resolve<SubUserController>();

    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: WhiteAppBar(
          title: getString(context, "resident_send_invite"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocConsumer(
          bloc: controller.bloc,
          listener: (context, state) {
            if (state is SubUserInviteSuccessState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SendInviteSuccessPage(),
                ),
              );
            } else if (state is InsertSubUserErrorState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SendInviteErrorPage(
                    failure: state.failure,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is SubUserInviteLoadingState) {
              return Column(
                children: [
                  Expanded(
                    child: LoadingWidget(),
                  ),
                ],
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    color: LelloTheme.palleteOf(theme).backgroundDark(),
                    width: double.infinity,
                    height: Dimens.spacingLarge,
                    child: Center(
                      child: Text(
                        '${controller.session.condominium?.name ?? ''} - ${controller.session.unity?.title ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        style: LelloTextStyles.body(theme),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Center(
                            child: Text(
                              getString(context, "resident_review_info"),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        Text(
                          '${args.subUser.name}',
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.subtitle(theme),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Divider(
                          height: 1,
                        ),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          getString(
                            context,
                            (args.subUser.cpf?.length ?? 0) > 14
                                ? "cnpj"
                                : "email",
                          ),
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(
                          args.subUser.cpf ??
                              getString(context, "not_informed"),
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.body(theme),
                        ),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          getString(
                            context,
                            "profile_update_email",
                          ),
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(
                          args.subUser.email ??
                              getString(context, "not_informed"),
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.body(theme),
                        ),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          getString(
                            context,
                            "registration_lello_user_phone_title",
                          ),
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(
                          args.subUser.phone ??
                              getString(context, "not_informed"),
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.body(theme),
                        ),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          getString(
                            context,
                            "resident_access_profile",
                          ),
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(
                          args.subUser.roleDescription ??
                              getString(context, "not_informed"),
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.body(theme),
                        ),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          S.of(context).expirationAccessDate,
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(
                          args.subUser.expiresAt != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(args.subUser.expiresAt!)
                              : getString(context, "not_informed"),
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.body(theme),
                        ),
                        SizedBox(height: Dimens.homeMenuIconSize),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: isLoading
            ? SizedBox.shrink()
            : Container(
                height: Dimens.homeBalanceHeightCollapsed,
                width: double.infinity,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    width: double.infinity,
                    child: PrimaryButton(
                      text: getString(context, "conclude"),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        await controller.inviteResident(
                          subUser: args.subUser,
                        );
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
