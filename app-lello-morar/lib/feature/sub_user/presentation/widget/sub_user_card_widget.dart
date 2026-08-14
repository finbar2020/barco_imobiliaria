import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_invite_forward_type.dart';
import 'package:morar/feature/access_control/domain/entity/access_control_send_invite.dart';
import 'package:morar/feature/access_control/domain/entity/access_invite_user_type_enum.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:essentials/essentials.dart' as essentials;
import 'package:morar/feature/sub_user/domain/entity/sub_user_app_access_enum.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

import '../../../../core/custom_cached_network_image/custom_cached_network_image.dart';

class SubUserCardWidget extends StatelessWidget {
  final SubUser model;
  final bool isList;
  final bool isEdit;
  final bool isBlocked;
  final showExpirationLabel;

  final VoidCallback? onPressed;
  final SessionBloc sessionBloc;

  const SubUserCardWidget({
    Key? key,
    required this.model,
    required this.sessionBloc,
    this.onPressed,
    this.isList = false,
    this.isEdit = false,
    this.isBlocked = false,
    this.showExpirationLabel = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final SessionBloc sessionBloc = essentials.BlocProvider.of(context);
    final SubUserController controller =
        ApplicationContainer.instance().resolve<SubUserController>();
    return InkWell(
      onTap: isEdit ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isEdit)
                    Opacity(
                      opacity: isBlocked ? 0.5 : 1.0,
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: essentials.Dimens.spacingLarge),
                        child: model.mainUser
                            ? Container(
                                width: 56.0,
                                height: 56.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10000.0),
                                    child: CustomCachedNetworkImage(
                                      link: sessionBloc
                                          .state.session?.me?.pictureLink,
                                      errorImageAssetsPath:
                                          "assets/user_placeholder.svg",
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: 56.0,
                                height: 56.0,
                                child: essentials.SvgPicture.asset(
                                  "assets/user_placeholder.svg",
                                  width: 32,
                                ),
                              ),
                      ),
                    ),
                  Expanded(
                    flex: 1,
                    child: Opacity(
                      opacity: isBlocked ? 0.5 : 1.0,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                controller.getFormattedName(
                                    name: model.name ?? ""),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                style:
                                    essentials.LelloTextStyles.subtitle(theme),
                              ),
                            ),
                            SizedBox(height: essentials.Dimens.spacingXSmall),
                            Text(
                              model.roleDescription ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: essentials.LelloTextStyles.caption(theme),
                            ),
                            SizedBox(height: essentials.Dimens.spacingXSmall),
                            if (showExpirationLabel &&
                                (expired(model) || aboutToExpire(model)))
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_outlined,
                                    color: Colors.red,
                                    size: 14,
                                  ),
                                  SizedBox(
                                      width: essentials.Dimens.spacingXSmall),
                                  Text(
                                    expired(model)
                                        ? "Acesso expirado"
                                        : "Acesso a expirar",
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        essentials.LelloTextStyles.captionBold(
                                                theme)
                                            ?.copyWith(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: essentials.Dimens.spacingXSmall),
                  if (!model.mainUser)
                    Expanded(
                      flex: 1,
                      child: isEdit
                          ? InkWell(
                              onTap: onPressed,
                              child: Container(
                                width: 150,
                                height: 36.0,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: essentials.AutoSizeText(
                                      model.blocked!
                                          ? essentials.getString(
                                              context, "resident_unlock")
                                          : essentials.getString(
                                              context, "block"),
                                      style: TextStyle(
                                        color: model.blocked!
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: model.blocked!
                                            ? Colors.green
                                            : Colors.red),
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            )
                          : CircuitBreakerWidget(
                              applicationRbac: ApplicationRbac
                                  .morarMoradoresSubmoradoresDetalhes,
                              reference:
                                  controller.session.condominium?.reference ??
                                      "",
                              appContainer: ApplicationContainer.instance(),
                              rbacEnabled: controller.sessionBloc.checkRback(
                                ApplicationRbac
                                    .morarMoradoresSubmoradoresDetalhes,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buildAppAccessWidget(context, model, theme),
                                  if (controller.useFacialBiometric &&
                                      !model.blocked!)
                                    SizedBox(
                                        height: essentials.Dimens.spacingSmall),
                                  if (controller.useFacialBiometric &&
                                      !model.blocked!)
                                    IgnorePointer(
                                      ignoring: false,
                                      child: UseBiometricsWidget(
                                        useFacialBiometric:
                                            model.useFacialBiometric ?? false,
                                        model: model,
                                        controller: controller,
                                      ),
                                    ),
                                  if (model.flagBoletoEmail == true) ...[
                                    SizedBox(
                                        height: essentials.Dimens.spacingSmall),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        essentials.SvgPicture.asset(
                                          'assets/ic_phone_billet.svg',
                                        ),
                                        SizedBox(
                                            width:
                                                essentials.Dimens.spacingSmall),
                                        Flexible(
                                          child: Text(
                                            essentials.getString(
                                                context, "billet_by_email"),
                                            style: TextStyle(
                                              color: essentials.LightPallete()
                                                  .error(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]
                                ],
                              ),
                            ),
                    ),
                  if (!isEdit && onPressed != null)
                    Row(
                      children: [
                        SizedBox(width: essentials.Dimens.spacingSmall),
                        Icon(Icons.arrow_forward_ios, size: 15),
                      ],
                    ),
                ],
              ),
            ),
            if (isEdit && model.creator != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    SizedBox(height: essentials.Dimens.spacing),
                    Text(
                      model.descriptionText(context),
                      style: essentials.LelloTextStyles.caption(theme)
                          ?.copyWith(
                              color: essentials.LelloTheme.palleteOf(theme)
                                  .purpleText()),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppAccessWidget(
          BuildContext context, SubUser model, ThemeData theme) =>
      AppAccessWidget(appAccess: _getAppAccess(model));

  SubUserAppAccessEnum _getAppAccess(SubUser model) {
    if (model.blocked ?? false) {
      return SubUserAppAccessEnum.blockedAccess;
    } else if (model.useApp ?? false) {
      return model.registered ?? false
          ? SubUserAppAccessEnum.registered
          : SubUserAppAccessEnum.withAccess;
    } else {
      return SubUserAppAccessEnum.withoutAccess;
    }
  }

  bool expired(SubUser subUser) {
    if (subUser.expiresAt == null) return false;
    final now = DateTime.now();
    final expirationDate = subUser.expiresAt!;
    return expirationDate.isBefore(now);
  }

  bool aboutToExpire(SubUser subUser) {
    if (subUser.expiresAt == null) return false;
    final now = DateTime.now();
    final expirationDate = subUser.expiresAt!;
    final difference = expirationDate.difference(now).inDays;
    return difference <= 30;
  }
}

class AppAccessWidget extends StatelessWidget {
  final SubUserAppAccessEnum appAccess;

  const AppAccessWidget({
    Key? key,
    required this.appAccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (appAccess) {
      case SubUserAppAccessEnum.blockedAccess:
        return _buildStatusRow(
          context,
          'assets/bi_phone_blocked.svg',
          'resident_blocked_access_app',
          essentials.LelloTheme.palleteOf(theme).error(),
        );
      case SubUserAppAccessEnum.withoutAccess:
        return _buildStatusRow(
          context,
          'assets/bi_phone_blocked.svg',
          'resident_without_access_app',
          essentials.LelloTheme.palleteOf(theme).error(),
        );
      case SubUserAppAccessEnum.registered:
        return _buildStatusRow(
          context,
          'assets/bi_phone.svg',
          'resident_installed_access_app',
          essentials.LelloTheme.palleteOf(theme).success(),
        );
      case SubUserAppAccessEnum.withAccess:
      default:
        return _buildStatusRow(
          context,
          'assets/bi_phone.svg',
          'resident_with_access_app',
          essentials.LelloTheme.palleteOf(theme).success(),
        );
    }
  }

  Widget _buildStatusRow(
      BuildContext context, String iconPath, String textKey, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        essentials.SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        SizedBox(width: essentials.Dimens.spacingSmall),
        Flexible(
          child: Text(
            essentials.getString(context, textKey),
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }
}

class UseBiometricsWidget extends StatelessWidget {
  final bool useFacialBiometric;
  final SubUser model;
  final SubUserController controller;

  const UseBiometricsWidget(
      {Key? key,
      required this.useFacialBiometric,
      required this.model,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(
      builder: (context) {
        if (!useFacialBiometric) {
          return InkWell(
            onTap: () {
              if (model.phone != null) {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            essentials.SvgPicture.asset(
                                'assets/biometric_registered_icon.svg'),
                            SizedBox(height: essentials.Dimens.spacing),
                            Text(
                              essentials.getString(
                                  context, "residents_invite_dialog_title"),
                              textAlign: TextAlign.center,
                              style: essentials.LelloTextStyles.subtitle(theme)!
                                  .copyWith(
                                color: essentials.LelloTheme.palleteOf(theme)
                                    .textOpaque(),
                              ),
                            ),
                            SizedBox(height: essentials.Dimens.spacing),
                            Text(
                              essentials.getString(
                                  context, "residents_invite_dialog_subtitle"),
                              textAlign: TextAlign.center,
                              style: essentials.LelloTextStyles.subtitle(theme)!
                                  .copyWith(
                                color: essentials.LelloTheme.palleteOf(theme)
                                    .textOpaque(),
                              ),
                            ),
                            SizedBox(height: essentials.Dimens.spacingLarge),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    essentials
                                        .getString(context, "back")
                                        .toUpperCase(),
                                    style: essentials.LelloTextStyles.subBody(
                                            theme)!
                                        .copyWith(
                                      color:
                                          essentials.LelloTheme.palleteOf(theme)
                                              .text(),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.userSelected = model;
                                    controller.subUserSendInvite(
                                        entity: AccessControlSendInviteEntity(
                                      cpf: model.cpf,
                                      name: model.name,
                                      phone: model.phone,
                                      forwardType:
                                          AccessControlInviteForwardType.sms,
                                      userType:
                                          AccessControlInviteUserType.resident,
                                    ));
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    essentials
                                        .getString(context, "ok")
                                        .toUpperCase(),
                                    style: essentials.LelloTextStyles.subBody(
                                            theme)!
                                        .copyWith(
                                      color:
                                          essentials.LelloTheme.palleteOf(theme)
                                              .text(),
                                    ),
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
              } else {
                essentials.Flushbar(
                  duration: Duration(seconds: 5),
                  message: essentials.getString(
                      context, "residents_invite_empty_phone"),
                )..show(context);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                essentials.SvgPicture.asset(
                  'assets/biometric_registered_icon.svg',
                  colorFilter: ColorFilter.mode(
                    essentials.LelloTheme.palleteOf(theme).warning(),
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: essentials.Dimens.spacingSmall),
                Flexible(
                  child: Text(
                    essentials.getString(context, "send_invite"),
                    style: TextStyle(
                      color: essentials.LightPallete().warning(),
                      decoration: TextDecoration.underline,
                      decorationColor: essentials.LightPallete().warning(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            essentials.SvgPicture.asset('assets/biometric_registered_icon.svg'),
            SizedBox(width: essentials.Dimens.spacingSmall),
            Flexible(
              child: Text(
                textAlign: TextAlign.left,
                essentials.getString(context,
                    "residents_register_sub_user_biometric_registered"),
                style: TextStyle(
                  color: essentials.LightPallete().success(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
