import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_event.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_state.dart';
import 'package:morar/feature/change_ownership/presentation/controller/ownership_controller.dart';
import 'package:morar/feature/change_ownership/presentation/page/change_ownership_sucess_page.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ChangeOwnershipResumePageArgs {
  final OwnershipController controller;
  ChangeOwnershipResumePageArgs({required this.controller});
}

class ChangeOwnershipResumePage extends StatefulWidget {
  const ChangeOwnershipResumePage({super.key});

  @override
  State<ChangeOwnershipResumePage> createState() =>
      _ChangeOwnershipResumePageState();
}

class _ChangeOwnershipResumePageState extends State<ChangeOwnershipResumePage> {
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments
        as ChangeOwnershipResumePageArgs;
    OwnershipController controller = arguments.controller;
    final theme = Theme.of(context);
    return Scaffold(
        appBar: CustomAppBar(title: "change_ownership_app_bar"),
        body: BlocConsumer(
            bloc: controller.bloc,
            builder: (context, state) {
              if (state is ChangeOwnershipLoadingState) {
                return Center(child: LoadingWidget());
              }
              if (state is ChangeOwnershipFailureState) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Dimens.spacingMedium),
                        child: ErrorHandlingWidget(
                          reTryFunction: () {
                            controller.postChange();
                          },
                          backFunction: () => controller.bloc
                              .add(ChangeOwnershipLoadedEvent(canChange: true)),
                          isProduction: env.isProduction,
                          error: state.errorMessageKey,
                          errorCode: "",
                          textReturnButton: "back",
                        ),
                      ),
                    ),
                  ],
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getString(context, "change_ownership_resume_title"),
                            style: LelloTextStyles.body(theme)!.copyWith(
                                color: LelloTheme.palleteOf(theme).primary()),
                          ),
                          SizedBox(height: Dimens.spacingLarge),
                          Text(
                            getString(context, "change_ownership_person_type"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.personType ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "change_ownership_cpf_or_cnpj"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.document ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "change_ownership_registration"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.registration ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "change_ownership_full_name"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.name ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "change_ownership_date"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.date ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "change_ownership_email"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.email ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "change_ownership_nationality"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.nationality ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "change_ownership_profession"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.profession ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(
                                context, "change_ownership_marital_status"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.maritalStatus ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "change_ownership_phone"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.phone ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "change_ownership_cellphone"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          Text(
                            controller.entity.cellphone ?? "-",
                            style: LelloTextStyles.subBody(theme),
                          ),
                          SizedBox(height: Dimens.spacingLarge),
                          Text(
                            getString(context, "change_ownership_bottom_info"),
                            style: LelloTextStyles.body(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "reports_attached_file"),
                            style: LelloTextStyles.subtitleBold(theme),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: Dimens.spacing),
                          _buildImageItem(theme, controller.entity.attachment,
                              controller.entity.attachmentType, controller),
                          SizedBox(height: Dimens.spacingXLarge),
                          PrimaryButton(
                            text: getString(context, "send"),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(Dimens.spacingLarge),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Alteração de Titularidade",
                                              style: LelloTextStyles.bodyBold(
                                                  theme),
                                            ),
                                            SizedBox(height: Dimens.spacing),
                                            Center(
                                              child: Text(
                                                '${controller.sessionBloc.state.session?.condominium?.name ?? ''} - ${controller.sessionBloc.state.session?.unity?.title ?? ''}',
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    LelloTextStyles.body(theme),
                                              ),
                                            ),
                                            SizedBox(height: Dimens.spacing),
                                            Text(
                                              "Tem certeza que deseja alterar a titularidade deste imóvel?",
                                              style:
                                                  LelloTextStyles.body(theme)!
                                                      .copyWith(fontSize: 15),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                                height: Dimens.spacingLarge),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    getString(context, "back")
                                                        .toUpperCase(),
                                                    style:
                                                        LelloTextStyles.subBody(
                                                                theme)!
                                                            .copyWith(
                                                      color:
                                                          LelloTheme.palleteOf(
                                                                  theme)
                                                              .text(),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    controller.postChange();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "CONFIRMAR",
                                                    style:
                                                        LelloTextStyles.subBody(
                                                                theme)!
                                                            .copyWith(
                                                      color: theme.primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                          SizedBox(height: Dimens.spacing),
                          SecondaryButton(
                            text: "Voltar para edição",
                            buttonBorderColor: Colors.black,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            listener: (context, state) {
              if (state is ChangeOwnershipSuccessState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ChangeOwnershipSuccessPage();
                    },
                  ),
                );
              }
            }));
  }

  Widget _buildImageItem(ThemeData theme, File? attachment,
      String? attachmentType, OwnershipController controller) {
    if (attachment == null || attachmentType == null) return Container();
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: Wrap(
        children: <Widget>[
          Stack(children: [
            attachmentType.contains("image")
                ? Container(
                    width: 100.0,
                    height: 100.0,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: FileImage(attachment)))),
                  )
                : Container(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/ic_documents.svg",
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
          ]),
          SizedBox(width: Dimens.spacingMedium)
        ],
      ),
    );
  }
}
