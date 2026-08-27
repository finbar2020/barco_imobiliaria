import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

import '../controllers/sub_user_edit_controller.dart';

class SubUserOwnerCardWidget extends StatelessWidget {
  final SubUser model;

  SubUserOwnerCardWidget({
    Key? key,
    required this.model,
  }) : super(key: key);
  final CircuitBreakerController circuitBreakController =
      ApplicationContainer.instance().resolve<CircuitBreakerController>();
  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();
  final controller =
      ApplicationContainer.instance().resolve<SubUserEditController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          controller.userSelected = model;
          Navigator.pushNamed(
            context,
            ApplicationRoute.subUserEdit,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          width: double.infinity,
          height: Dimens.homeBalanceHeightCollapsed,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
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
                            borderRadius: BorderRadius.circular(10000.0),
                            child: CustomCachedNetworkImage(
                              link: controller.session.me!.pictureLink,
                              errorImageAssetsPath:
                                  "assets/user_placeholder.svg",
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 56.0,
                        height: 56.0,
                        child: SvgPicture.asset(
                          "assets/user_placeholder.svg",
                          width: 32,
                        ),
                      ),
              ),
              SizedBox(width: Dimens.spacingSmall),
              Expanded(
                flex: controller.useFacialBiometric ? 2 : 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        model.name ?? "",
                        softWrap: true,
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                        style: LelloTextStyles.subtitle(theme),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingXSmall),
                    Text(
                      model.roleDescription!,
                      overflow: TextOverflow.ellipsis,
                      style: LelloTextStyles.caption(theme),
                    ),
                  ],
                ),
              ),
              if (controller.useFacialBiometric)
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      SizedBox(width: Dimens.spacingSmall),
                      Expanded(
                        flex: 3,
                        child: model.useFacialBiometric!
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/biometric_registered_icon.svg'),
                                        SizedBox(width: Dimens.spacingSmall),
                                        Flexible(
                                          child: Text(
                                            getString(context,
                                                "residents_register_sub_user_biometric_registered"),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: LightPallete().success(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: StreamBuilder<List<CircuitItemRule>>(
                                      stream: circuitBreakController
                                          .ruleStream.stream,
                                      builder: (context, snapshot) {
                                        return CircuitBreakerWidget(
                                            appContainer:
                                                ApplicationContainer.instance(),
                                            reference: sessionBloc.state.session
                                                ?.condominium?.reference,
                                            applicationRbac: ApplicationRbac
                                                .morarMoradoresBiometriaRecadastro,
                                            rbacEnabled: true,
                                            child: InkWell(
                                              onTap: () async {
                                                await controller.checkService();
                                                controller.getSubUsers();
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical:
                                                        Dimens.spacingSmall),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        getString(context,
                                                            "residents_send_new_photo"),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: LightPallete()
                                                              .warning(),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ));
                                      }),
                                  ),
                                ],
                              )
                            : IgnorePointer(
                                ignoring: false,
                                child: InkWell(
                                  onTap: () async {
                                    await controller.checkService();
                                    controller.getSubUsers();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: Dimens.spacingSmall),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(model
                                                      .useFacialBiometric!
                                                  ? 'assets/biometric_registered_icon.svg'
                                                  : 'assets/biometric_not_registered_icon.svg'),
                                              SizedBox(
                                                  width: Dimens.spacingSmall),
                                              Flexible(
                                                child: Text(
                                                  model.useFacialBiometric!
                                                      ? getString(context,
                                                          "residents_register_sub_user_biometric_registered")
                                                      : getString(context,
                                                          "residents_register_sub_user_biometric_not_registered"),
                                                  style: (model.mainUser &&
                                                          model
                                                              .useFacialBiometric!)
                                                      ? TextStyle(
                                                          color: LightPallete()
                                                              .success(),
                                                        )
                                                      : TextStyle(
                                                          color: LightPallete()
                                                              .warning(),
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationColor:
                                                              LightPallete()
                                                                  .warning(),
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.arrow_forward_ios, size: 15),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
