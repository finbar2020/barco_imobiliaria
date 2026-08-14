import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/feature/access_management/presentation/bloc/access_management_bloc.dart';
import 'package:lello/feature/access_management/presentation/bloc/access_management_state.dart';
import 'package:lello/feature/access_management/presentation/pages/access_management_facial_biometric_error.dart';
import 'package:lello/feature/access_management/presentation/pages/access_management_facial_biometric_success.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class AccessManagerServiceOnPage extends StatefulWidget {
  final AccessManagementBloc bloc;
  final VoidCallback onTap;
  const AccessManagerServiceOnPage({
    Key? key,
    required this.bloc,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AccessManagerServiceOnPage> createState() =>
      _AccessManagerServiceOnPageState();
}

class _AccessManagerServiceOnPageState
    extends State<AccessManagerServiceOnPage> {
  bool checkedBox = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PrimaryAppBar(
        title: getString(context, "edit"),
        theme: theme,
      ),
      body: BlocConsumer(
        bloc: widget.bloc,
        listener: (context, state) {
          if (state is AccessManagementFacialFailedState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccessManagementFacialBiometricErrorPage(
                  code: state.code,
                  message: state.message,
                ),
              ),
            );
          } else if (state is AccessManagementFacialSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AccessManagementFacialBiometricSuccessPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AccessManagementLoadingState) {
            return Column(
              children: [
                Expanded(
                  child: LoadingWidget(),
                ),
              ],
            );
          }
          return Padding(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Center(
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      getString(context, "residents_facial_capture_subtitle"),
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
                        activeColor: theme.primaryColor,
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
                                style: LelloTextStyles.subBody(theme)!.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " ${getString(context, "residents_facial_capture_attention_subtitle2")}",
                                style: LelloTextStyles.subBody(theme)!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700]),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 54.0,
                      width: double.infinity,
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
                        onPressed: checkedBox ? widget.onTap : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
