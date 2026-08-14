import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/staff_access_management/domain/entity/building_manager_user.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_event.dart';
import 'package:lello/feature/staff_access_management/presentation/bloc/staff_access_management_state.dart';
import 'package:lello/feature/staff_access_management/presentation/controller/staff_access_management_controller.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_management_edit_page.dart';
import 'package:lello/feature/staff_access_management/presentation/pages/staff_access_sucess_page.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/access_profiles_info_dialog.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_cpf_dialog.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_dropdown.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_generic_input.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/staff_access_management_info_button.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class StaffAccessManagementAddPageArgs {
  final StaffAccessManagementController controller;
  StaffAccessManagementAddPageArgs({required this.controller});
}

class StaffAccessManagementAddPage extends StatefulWidget {
  const StaffAccessManagementAddPage({
    Key? key,
  }) : super(key: key);

  @override
  _StaffAccessManagementAddPageState createState() =>
      _StaffAccessManagementAddPageState();
}

class _StaffAccessManagementAddPageState
    extends State<StaffAccessManagementAddPage> {
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final cellphoneController = TextEditingController();

  final _validator = ApplicationContainer.instance().resolve<Validator>();

  String? _selectAccessProfiles;
  String? _selectGender;

  String cpf = "";

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments
        as StaffAccessManagementAddPageArgs;
    final theme = Theme.of(context);
    _validator.context = context;
    return Scaffold(
      appBar: PrimaryAppBar(
        title: getString(context, "staff_access_management_add_appbar"),
        theme: theme,
      ),
      body: BlocConsumer(
        bloc: arguments.controller.bloc,
        listener: (context, state) {
          if (state is LoadedNonManagerUserState && state.addNonUserSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return StaffAccessManagementSuccessPage(
                    controller: arguments.controller,
                    pageTitleText: 'staff_access_management_add_success',
                  );
                },
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is LoadingStaffAccessManagementState) {
            return const Center(
              child: LoadingWidget(),
            );
          } else if (state is FailureNonManagerUserState &&
              state.addNonUserError) {
            return Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: ErrorHandlingWidget(
                reTryFunction: () {
                  arguments.controller.postNonUser();
                },
                backFunction: () =>
                    arguments.controller.bloc.add(FailureNonManagerUserEvent(
                  failure: null,
                  addNonUserError: false,
                )),
                isProduction: arguments.controller.env.isProduction,
                error: state.failure?.error.toString() ?? "",
                errorCode: state.failure?.code.toString() ?? "",
              ),
            );
          } else {
            return DismissKeyboard(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getString(
                              context, "staff_access_management_add_title"),
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          getString(
                              context, "staff_access_management_add_sub_title"),
                          style: LelloTextStyles.body(theme),
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        StaffAccessManagementGenericInput(
                          controller: nameController,
                          title: getString(
                              context, "staff_access_management_add_full_name"),
                          validator: _validator.validateRequired,
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: Dimens.spacing),
                        StaffAccessManagementDropdown(
                          title: getString(
                              context, "staff_access_management_add_sex"),
                          value: _selectGender,
                          items: arguments.controller.genderTypes,
                          validator: _validator.validateRequired,
                          onChanged: (value) {
                            setState(() {
                              _selectGender = value;
                            });
                            reassemble();
                          },
                        ),
                        SizedBox(height: Dimens.spacing),
                        StaffAccessManagementGenericInput(
                          controller: dateController,
                          title: getString(context, "gdp_dob"),
                          formatter: [fullDateFormatter()],
                          action: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(),
                          validator: (date) =>
                              _validator.validateRequired(date) ??
                              _validator.validateDateBeforeToday(date),
                          selectDate: () async {
                            final date = await datePicker(context,
                                lastDate: DateTime.now());
                            if (DateUtils.dateOnly(date) !=
                                DateUtils.dateOnly(DateTime.now())) {
                              String format =
                                  DateFormat.yMd("pt_BR").format(date);
                              setState(() {
                                dateController.text = format;
                              });
                            }
                          },
                        ),
                        SizedBox(height: Dimens.spacing),
                        StaffAccessManagementGenericInput(
                          controller: cpfController,
                          title: getString(context, "cpf"),
                          action: TextInputAction.next,
                          keyboardType: const TextInputType.numberWithOptions(),
                          formatter: [cpfFormatter()],
                          validator: _validator.validateCPF,
                          onChanged: (value) {
                            cpf = value;
                            if (cpf.length == 14) {
                              var user = hasUserWithThisCpf(arguments);
                              if (user != null) {
                                showDialogCpf(user, arguments);
                              }
                            }
                          },
                        ),
                        SizedBox(height: Dimens.spacing),
                        StaffAccessManagementGenericInput(
                          controller: emailController,
                          title: getString(context, "payment_approval_email"),
                          action: TextInputAction.next,
                          validator: _validator.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: Dimens.spacing),
                        StaffAccessManagementGenericInput(
                          controller: cellphoneController,
                          title: getString(
                              context, "staff_access_management_add_cellphone"),
                          validator: _validator.validateCellPhone,
                          formatter: [cellphoneWithDDDFormatter()],
                          keyboardType: const TextInputType.numberWithOptions(),
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        StaffAccessManagementDropdown(
                          title: getString(context,
                              "staff_access_management_add_access_profile"),
                          value: _selectAccessProfiles,
                          items: arguments.controller.accessProfiles,
                          validator: _validator.validateRequired,
                          onChanged: (value) {
                            setState(() {
                              _selectAccessProfiles = value;
                            });
                            reassemble();
                          },
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        StaffAccessManagementInfoButton(
                          title: getString(context,
                              "staff_access_management_add_info_access_profile"),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  const AccessProfilesInfoDialog(),
                            );
                          },
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        PrimaryButton(
                          text: getString(context, "sign_up"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var user = hasUserWithThisCpf(arguments);
                              if (user != null) {
                                showDialogCpf(user, arguments);
                                return;
                              }
                              _showTerms(theme, arguments);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _showTerms(
    ThemeData theme,
    StaffAccessManagementAddPageArgs args,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimens.spacing),
              Text(
                  "${getString(context, "staff_access_management_add_terms")}!",
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitleBold(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).primary())),
              SizedBox(height: Dimens.spacingMedium),
              Text(
                  getString(
                      context, "staff_access_management_add_iterms_subtitle"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textLightest())),
              SizedBox(height: Dimens.spacingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        getString(context, "cancel").toUpperCase(),
                        style: LelloTextStyles.bodyBold(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).text(),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      postNonUser(args);
                      Navigator.pop(context);
                    },
                    child: Row(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getString(context,
                              "staff_access_management_add_info_accept_button_dialog"),
                          textAlign: TextAlign.center,
                          style: LelloTextStyles.bodyBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).primary(),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  BuildingManagerUser? hasUserWithThisCpf(
      StaffAccessManagementAddPageArgs args) {
    if (cpf.isNotEmpty) {
      String result = cpf.replaceAll(RegExp('[^A-Za-z0-9]'), '');

      var user = args.controller.activeUsers.where((element) =>
          element.cpf?.replaceAll(RegExp('[^A-Za-z0-9]'), '') == result);
      if (user.isNotEmpty) {
        return user.first;
      }
    }

    return null;
  }

  showDialogCpf(
      BuildingManagerUser user, StaffAccessManagementAddPageArgs args) {
    showDialog(
      context: context,
      builder: (context) => StaffAccessManagementCpfDialog(
        onTap: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(
            context,
            ApplicationRoute.staffAccessManagementEdit,
            arguments: StaffAccessManagementEditPageArgs(
                controller: args.controller, buildingManagerUser: user),
          );
        },
      ),
    );
  }

  postNonUser(StaffAccessManagementAddPageArgs args) {
    StaffAccessManagementController controller = args.controller;

    controller.nonUser = controller.nonUser.copyWith(
        name: nameController.text,
        gender: _selectGender == controller.genderTypes[0] ? "F" : "M",
        birthday: dateController.text,
        cpf: cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        email: emailController.text,
        phone: cellphoneController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        accessType:
            controller.setAccessType(accessType: _selectAccessProfiles!));

    controller.postNonUser();
  }
}
