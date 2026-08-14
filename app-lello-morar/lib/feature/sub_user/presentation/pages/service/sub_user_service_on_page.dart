import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';

import 'package:essentials/essentials.dart' hide Image;

import '../../../domain/entity/sub_user.dart';
import '../../bloc/sub_users_bloc.dart';
import '../facial_biometric/sub_user_facial_biometric_error.dart';
import '../facial_biometric/sub_user_facial_biometric_success.dart';

class SubUserServiceOnPageArgs {
  final SubUser subUser;
  SubUserServiceOnPageArgs({
    required this.subUser,
  });
}

class SubUserServiceOnPage extends StatefulWidget {
  const SubUserServiceOnPage({Key? key}) : super(key: key);

  @override
  State<SubUserServiceOnPage> createState() => _SubUserServiceOnPageState();
}

class _SubUserServiceOnPageState extends State<SubUserServiceOnPage> {
  bool checkedBox = false;
  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<SubUserController>();
    final theme = Theme.of(context);
    var arguments = ModalRoute.of(context)!.settings.arguments;
    final SubUserServiceOnPageArgs args = arguments as SubUserServiceOnPageArgs;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(
          context,
          ApplicationRoute.subUserEdit,
          //arguments: controller,
        );
        return true;
      },
      child: Theme(
          data: theme,
          child: BlocConsumer(
            bloc: controller.bloc,
            listener: (context, state) {
              if (state is FacialBiometricLoadedState) {
                Navigator.pushReplacementNamed(
                    context, ApplicationRoute.subUserFacialBiometricSuccess,
                    arguments: SubUserFacialSuccessPageArgs(
                      controller: controller,
                      subUser: args.subUser,
                    ));
              }
              if (state is FacialBiometricErrorState) {
                Navigator.pushReplacementNamed(
                    context, ApplicationRoute.subUserFacialBiometricError,
                    arguments: SubUserFacialBiometricErrorPageArgs(
                      controller: controller,
                      subUser: args.subUser,
                      code: state.code,
                      message: state.message,
                    ));
              }
            },
            builder: (context, state) {
              if (state is FacialBiometricLoadingState) {
                return Scaffold(
                  appBar: WhiteAppBar(
                    title: getString(context, "edit"),
                    onPressed: () {
                      Navigator.pop(
                        context,
                        ApplicationRoute.subUserEdit,
                        //arguments: controller,
                      );
                    },
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: LoadingWidget(),
                      ),
                    ],
                  ),
                );
              }
              return Scaffold(
                appBar: WhiteAppBar(
                  title: getString(context, "edit"),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      ApplicationRoute.subUserEdit,
                      //arguments: controller,
                    );
                  },
                ),
                body: Padding(
                  padding: EdgeInsets.all(Dimens.spacingLarge),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset("assets/ic_gestao.png"),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            getString(context, "residents_facial_capture"),
                            textAlign: TextAlign.center,
                            style: LelloTextStyles.titleSmall(theme),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              getString(
                                  context, "residents_facial_capture_subtitle"),
                              textAlign: TextAlign.center,
                              style: LelloTextStyles.body(theme)!.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                activeColor:
                                    LelloTheme.palleteOf(theme).button(),
                                onChanged: (value) {
                                  if (checkedBox) {
                                    setState(() {
                                      checkedBox = value!;
                                    });
                                  } else {
                                    setState(() {
                                      checkedBox = value!;
                                    });
                                  }
                                },
                                value: checkedBox,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    //todo:: direcionar para pagina de leitura do aviso de privacidade
                                  },
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: getString(context,
                                            "residents_facial_capture_attention_subtitle"),
                                        style: LelloTextStyles.subBody(theme)!
                                            .copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            " ${getString(context, "residents_facial_capture_attention_subtitle2")}",
                                        style: LelloTextStyles.subBody(theme)!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue[700]),
                                      )
                                    ]),
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
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    height: 54.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        getString(context, "next"),
                        style: LelloTextStyles.button(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).customColor()),
                      ),
                      onPressed: checkedBox
                          ? () {
                              controller.getFacialBiometric();
                            }
                          : null,
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
