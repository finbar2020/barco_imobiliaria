import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/me/presentation/bloc/me_state.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_review_data_widget.dart';

import '../controller/me_controller.dart';
import '../widget/me_edit_phone_info.dart';

class MeEditPage extends StatefulWidget {
  const MeEditPage({super.key});

  @override
  MeEditPageState createState() => MeEditPageState();
}

class MeEditPageState extends State<MeEditPage> {
  final _formKey = GlobalKey<FormState>();
  final Validator _validator = ApplicationContainer.instance().resolve();
  final editController =
      ApplicationContainer.instance().resolve<MeController>();
  final controller = ApplicationContainer.instance().resolve<MeController>();
  final dddNode = FocusNode();
  final phoneNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    return Scaffold(
      appBar: PrimaryAppBar(
        title: getString(context, "profile_title"),
        theme: theme,
        actions: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(right: Dimens.spacing),
              child: Text(
                "${controller.lastGetMeUpdateDifference}${controller.lastSwitchRolesUpdateDifference}",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: LelloTheme.palleteOf(theme).grey(), fontSize: 10),
              ),
            ),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          controller.getMe(forceUpdate: true);
          return true;
        },
        child: SingleChildScrollView(
          child: BlocListener(
            bloc: controller.meBloc,
            listener: (context, state) {
              if (state is MeEditPhoneChangedState) {
                Modal.showBottomSheet<bool>(
                  context: context,
                  builder: (context) => MeEditPhoneInfoWidget(
                    isChangingEmail: state.isChangingEmail,
                    isChangingPhone: state.isChangingPhone,
                  ),
                ).then((value) {
                  if (value != true) {
                    controller.cancelValidation();
                  }
                });
              }
              if (state is MeEditSucceededState) {
                Navigator.pushNamed(context, ApplicationRoute.meSuccess);
              }
              if (state is MeEditFailedState) {
                Navigator.pushNamed(context, ApplicationRoute.meFailure);
              }
            },
            child: Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Form(
                key: _formKey,
                child: DismissKeyboard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(getString(context, "name"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacingSmall),
                      TextFormField(
                        autofocus: true,
                        initialValue: controller.name,
                        validator: _validator.validateRequired,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            controller.name = value;
                          });
                        },
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: getString(context, "type_name")),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      Text(getString(context, "profile_update_email"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacingSmall),
                      TextFormField(
                        initialValue: controller.email,
                        validator: _validator.validateEmail,
                        onFieldSubmitted: (_) =>
                            FocusScope.of(context).nextFocus(),
                        onChanged: (value) {
                          setState(() {
                            controller.email = value;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: getString(context, "type_email")),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      Text(getString(context, "cellphone_number"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacingSmall),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 60,
                            child: TextFormField(
                              initialValue: controller.ddd,
                              focusNode: dddNode,
                              validator: validator.validateRequired,
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                if (value.length == 2) {
                                  FocusScope.of(context)
                                      .requestFocus(phoneNode);
                                }
                                setState(() {
                                  controller.ddd = value;
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "00",
                                counterText: "",
                              ),
                            ),
                          ),
                          SizedBox(width: Dimens.spacing),
                          Expanded(
                            child: TextFormField(
                              focusNode: phoneNode,
                              initialValue: controller.phone,
                              validator: validator.validateCellPhone,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLength: 9,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  FocusScope.of(context).requestFocus(dddNode);
                                }
                                setState(() {
                                  controller.phone = value;
                                });
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "999999999",
                                counterText: "",
                              ),
                            ),
                          )
                        ],
                      ),
                      // PhoneFormField(
                      //   initialValue: controller.phone,
                      //   onFieldSubmitted: (value) {
                      //     controller.phone = value;
                      //     setState(() {});
                      //   },
                      //   onSaved: (value) {
                      //     controller.phone = value ?? '';
                      //     setState(() {});
                      //   },
                      //   widgetValidator: _validator,
                      // ),
                      SizedBox(height: Dimens.spacingMedium),
                      Visibility(
                        visible: controller.meBloc.state is! MeEditLoadingState,
                        replacement:
                            const Center(child: CircularProgressIndicator()),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            PrimaryButton(
                              buttonColor: theme.primaryColor,
                              text: getString(context, "save"),
                              onPressed:
                                  controller.mustSave ? () => save() : null,
                            ),
                            SizedBox(height: Dimens.spacingSmall),
                            SecondaryButton(
                              text: getString(context, "edit_password"),
                              onPressed: () => Navigator.pushNamed(
                                context,
                                ApplicationRoute.meEditPassword,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void save() {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      controller.saveAccount(codeValidation: null);
    }
  }
}
