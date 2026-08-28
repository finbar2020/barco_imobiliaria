import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/change_ownership/domain/entity/ownership_entity.dart';
import 'package:morar/feature/change_ownership/presentation/bloc/change_ownership_state.dart';
import 'package:morar/feature/change_ownership/presentation/controller/ownership_controller.dart';
import 'package:morar/feature/change_ownership/presentation/page/change_ownership_resume_page.dart';
import 'package:morar/feature/change_ownership/presentation/widget/cant_change_dialog.dart';
import 'package:morar/feature/change_ownership/presentation/widget/change_ownership_document_input.dart';
import 'package:morar/feature/change_ownership/presentation/widget/change_ownership_dropdown.dart';
import 'package:morar/feature/change_ownership/presentation/widget/change_ownership_generic_input.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ChangeOwnership extends StatefulWidget {
  const ChangeOwnership({super.key});

  @override
  State<ChangeOwnership> createState() => _ChangeOwnershipState();
}

class _ChangeOwnershipState extends State<ChangeOwnership> {
  String? _selectTypePerson;
  String? _selectSex;
  String? _selectNationality;
  String? _selectMaritalStatus;
  List<String> personTypes = ["Pessoa Física", "Pessoa Jurídica"];
  List<String> sexTypes = ["Feminino", "Masculino"];
  List<String> nationalityTypes = ["Brasileiro", "Estrangeiro"];
  List<String> maritalStatusType = ["Casado", "Solteiro"];

  final documentController = new TextEditingController();
  final registrationController = new TextEditingController();
  final nameController = new TextEditingController();
  final rgController = new TextEditingController();
  final dateController = new TextEditingController();
  final emailController = new TextEditingController();
  final professionController = new TextEditingController();
  final phoneController = new TextEditingController();
  final cellphoneController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _validator = ApplicationContainer.instance().resolve<Validator>();

  final OwnershipController controller =
      ApplicationContainer.instance().resolve<OwnershipController>();

  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  void initState() {
    controller.getCanChange();
    super.initState();
  }

  @override
  void dispose() {
    controller.entity = OwnershipEntity();
    documentController.dispose();
    registrationController.dispose();
    nameController.dispose();
    rgController.dispose();
    dateController.dispose();
    emailController.dispose();
    professionController.dispose();
    phoneController.dispose();
    cellphoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    return Scaffold(
      appBar: CustomAppBar(title: "change_ownership_app_bar"),
      body: BlocConsumer(
        bloc: controller.bloc,
        listener: (context, state) {
          if (state is ChangeOwnershipLoadedState) {
            if (state.canChange == false) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) =>
                      CantChangeDialog(message: state.cantChangeMessage));
            }
          }
        },
        builder: (context, state) {
          if (state is ChangeOwnershipLoadingState) {
            return Center(child: LoadingWidget());
          } else if (state is ChangeOwnershipFailureState) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: ErrorHandlingWidget(
                      reTryFunction: () {
                        controller.getCanChange();
                      },
                      backFunction: () => Navigator.pop(context),
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
          return DismissKeyboard(
            child: SingleChildScrollView(
              child: Column(children: [
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimens.spacingSmall),
                        Text(
                          getString(context, "change_ownership_title"),
                          style: LelloTextStyles.subtitle(theme),
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipDropdown(
                          isRequired: true,
                          selectTypePerson: personTypes[0],
                          title: getString(
                              context, "change_ownership_person_type"),
                          value: _selectTypePerson,
                          items: personTypes,
                          validator: _validator.validateRequired,
                          onChanged: (value) {
                            if (value != _selectTypePerson) {
                              setState(() {
                                _selectTypePerson = value;
                              });

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _formKey.currentState?.reset();
                              });
                            }
                          },
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipDocumentInput(
                          isIndividuals: _isIndividuals(),
                          documentController: documentController,
                          selectType: _selectTypePerson,
                          types: personTypes,
                          onChanged: (value) {},
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipGenericInput(
                          isRequired: true,
                          selectTypePerson: _selectTypePerson,
                          controller: registrationController,
                          title: getString(
                              context, "change_ownership_registration"),
                          validator: _validator.validateRequired,
                          keyboardType: TextInputType.numberWithOptions(),
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipGenericInput(
                          isRequired: true,
                          selectTypePerson: _selectTypePerson,
                          controller: nameController,
                          title:
                              getString(context, "change_ownership_full_name"),
                          validator: _validator.validateRequired,
                        ),
                        SizedBox(height: Dimens.spacing),
                        LayoutBuilder(
                          builder: (BuildContext context,
                                  BoxConstraints constraints) =>
                              Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: constraints.maxWidth * 0.45,
                                child: ChangeOwnershipDropdown(
                                  isRequired: _isIndividuals(),
                                  selectTypePerson: _selectTypePerson,
                                  title: getString(
                                      context, "change_ownership_sex"),
                                  value: _selectSex,
                                  items: sexTypes,
                                  validator: _isIndividuals()
                                      ? _validator.validateRequired
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectSex = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: constraints.maxWidth * 0.10),
                              Container(
                                width: constraints.maxWidth * 0.45,
                                child: ChangeOwnershipGenericInput(
                                  isRequired: _isIndividuals(),
                                  selectTypePerson: _selectTypePerson,
                                  controller: rgController,
                                  title:
                                      getString(context, "change_ownership_rg"),
                                  validator: _isIndividuals()
                                      ? (value) => _validator.validateMinLength(
                                          value, 12)
                                      : null,
                                  formatter: [rgFormatter()],
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipGenericInput(
                          isRequired: _isIndividuals(),
                          selectTypePerson: _selectTypePerson,
                          controller: dateController,
                          title: getString(context, "change_ownership_date"),
                          formatter: [fullDateFormatter()],
                          keyboardType: TextInputType.numberWithOptions(),
                          validator: (date) => _isIndividuals()
                              ? (_validator.validateRequired(date) ??
                                  _validator.validateDateBeforeToday(date))
                              : null,
                          selectDate: () async {
                            final date = await datePicker(context,
                                lastDate: DateTime.now());
                            if (date != DateTime.now()) {
                              String format =
                                  DateFormat.yMd("pt_BR").format(date);
                              setState(() {
                                dateController.text = format;
                              });
                            }
                          },
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipGenericInput(
                          isRequired: true,
                          selectTypePerson: _selectTypePerson,
                          controller: emailController,
                          title: getString(context, "change_ownership_email"),
                          validator: _validator.validateEmail,
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipDropdown(
                          isRequired: _isIndividuals(),
                          selectTypePerson: _selectTypePerson,
                          title: getString(
                              context, "change_ownership_nationality"),
                          value: _selectNationality,
                          items: nationalityTypes,
                          validator: _isIndividuals()
                              ? _validator.validateRequired
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _selectNationality = value;
                            });
                          },
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipGenericInput(
                          isRequired: _isIndividuals(),
                          selectTypePerson: _selectTypePerson,
                          controller: professionController,
                          title:
                              getString(context, "change_ownership_profession"),
                          validator: _isIndividuals()
                              ? _validator.validateRequired
                              : null,
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipDropdown(
                          isRequired: _isIndividuals(),
                          selectTypePerson: _selectTypePerson,
                          title: getString(
                              context, "change_ownership_marital_status"),
                          value: _selectMaritalStatus,
                          items: maritalStatusType,
                          validator: _isIndividuals()
                              ? _validator.validateRequired
                              : null,
                          onChanged: (value) {
                            setState(() {
                              _selectMaritalStatus = value;
                            });
                          },
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipGenericInput(
                          isRequired: true,
                          selectTypePerson: _selectTypePerson,
                          controller: phoneController,
                          formatter: [landlinePhoneWithDDDFormatter()],
                          keyboardType: TextInputType.numberWithOptions(),
                          validator: _validator.validateLandlinePhone,
                          title: getString(context, "change_ownership_phone"),
                        ),
                        SizedBox(height: Dimens.spacing),
                        ChangeOwnershipGenericInput(
                          isRequired: true,
                          selectTypePerson: _selectTypePerson,
                          controller: cellphoneController,
                          formatter: [cellphoneWithDDDFormatter()],
                          keyboardType: TextInputType.numberWithOptions(),
                          validator: _validator.validateCellPhone,
                          title:
                              getString(context, "change_ownership_cellphone"),
                        ),
                        SizedBox(height: Dimens.spacingLarge),
                        Text(
                          getString(context, "change_ownership_bottom_info"),
                          style: LelloTextStyles.body(theme),
                        ),
                        SizedBox(height: Dimens.spacingLarge),
                        IgnorePointer(
                          ignoring: _choicePersonType(),
                          child: Opacity(
                            opacity: _choicePersonType() ? 0.3 : 1.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${getString(context, "reports_attach_file")}*",
                                  style: LelloTextStyles.subtitleBold(theme),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: Dimens.spacing),
                                controller.entity.attachment == null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Flexible(
                                              child: Column(
                                            children: [
                                              InkWell(
                                                child: SvgPicture.asset(
                                                  "assets/ic_photo_bold.svg",
                                                  height: 32,
                                                ),
                                                onTap: () async {
                                                  bool takedPhoto =
                                                      await controller
                                                          .beginTakePhoto(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
                                                  if (takedPhoto)
                                                    setState(() {});
                                                },
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(
                                                  getString(context,
                                                      "reports_request_pick_image_from_gallery"),
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      LelloTextStyles.bodyBold(
                                                          theme)),
                                            ],
                                          )),
                                          Flexible(
                                              child: Column(
                                            children: [
                                              InkWell(
                                                child: SvgPicture.asset(
                                                  "assets/ic_camera_bold.svg",
                                                  height: 32,
                                                ),
                                                onTap: () async {
                                                  bool takedPhoto =
                                                      await controller
                                                          .beginTakePhoto(
                                                              source:
                                                                  ImageSource
                                                                      .camera);
                                                  if (takedPhoto)
                                                    setState(() {});
                                                },
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(
                                                  getString(context,
                                                      "reports_camera"),
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      LelloTextStyles.bodyBold(
                                                          theme)),
                                            ],
                                          )),
                                          Flexible(
                                              child: Column(
                                            children: [
                                              InkWell(
                                                child: SvgPicture.asset(
                                                  "assets/ic_attachment_bold.svg",
                                                  height: 32,
                                                ),
                                                onTap: () async {
                                                  bool takedPhoto =
                                                      await controller
                                                          .beginTakeFile();
                                                  if (takedPhoto)
                                                    setState(() {});
                                                },
                                              ),
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              Text(
                                                  getString(context,
                                                      "reports_create_attachment"),
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      LelloTextStyles.bodyBold(
                                                          theme)),
                                            ],
                                          )),
                                        ],
                                      )
                                    : _buildImageItem(
                                        theme,
                                        controller.entity.attachment!,
                                        controller.entity.attachmentType!),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingXLarge),
                        PrimaryButton(
                          text: getString(context, "next"),
                          onPressed: _choicePersonType()
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    if (controller.entity.attachment == null) {
                                      Flushbar(
                                        duration: Duration(seconds: 5),
                                        message:
                                            "Obrigatório anexar um documento",
                                      )..show(context);
                                    } else {
                                      _setData();
                                      Navigator.pushNamed(
                                        context,
                                        ApplicationRoute.changeOwnershipResume,
                                        arguments:
                                            ChangeOwnershipResumePageArgs(
                                                controller: controller),
                                      );
                                    }
                                  }
                                },
                        )
                      ],
                    ),
                  ),
                )
              ]),
            ),
          );
        },
      ),
    );
  }

  bool _choicePersonType() {
    return _selectTypePerson == null;
  }

  _isIndividuals() {
    return _selectTypePerson == personTypes[0];
  }

  Widget _buildImageItem(
      ThemeData theme, File attachment, String attachmentType) {
    final editBulletSize = 32.0;
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
            Positioned(
              right: 0,
              bottom: 0,
              top: 0 - (editBulletSize * 2),
              child: Container(
                  width: editBulletSize,
                  height: editBulletSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: LelloTheme.palleteOf(theme).background(),
                        width: 3),
                    color: theme.primaryColor,
                  ),
                  child: IconButton(
                      icon: SvgPicture.asset("assets/ic_close.svg",
                          width: 3, height: 12),
                      onPressed: () {
                        setState(() {
                          controller.entity.attachment = null;
                        });
                      })),
            ),
          ]),
          SizedBox(width: Dimens.spacingMedium)
        ],
      ),
    );
  }

  _setData() {
    controller.entity.personType = _isIndividuals() ? "FISICA" : "JURIDICA";
    controller.entity.document =
        documentController.text.isEmpty ? null : documentController.text;
    controller.entity.registration = registrationController.text;
    controller.entity.name = nameController.text;
    controller.entity.sex = _selectSex?.toUpperCase();
    controller.entity.rg = rgController.text.isEmpty ? null : rgController.text;
    controller.entity.date =
        dateController.text.isEmpty ? null : dateController.text;
    controller.entity.email = emailController.text;
    controller.entity.nationality = _selectNationality?.toUpperCase();
    controller.entity.profession =
        professionController.text.isEmpty ? null : professionController.text;
    controller.entity.maritalStatus = _selectMaritalStatus?.toUpperCase();
    controller.entity.phone = phoneController.text;
    controller.entity.cellphone = cellphoneController.text;
  }
}
