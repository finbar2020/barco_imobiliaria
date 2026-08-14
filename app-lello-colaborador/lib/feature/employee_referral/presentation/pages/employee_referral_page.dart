import 'dart:convert';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';

import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:colaborador/feature/employee_referral/presentation/bloc/employee_referral_bloc.dart';
import 'package:colaborador/feature/employee_referral/presentation/bloc/employee_referral_state.dart';
import 'package:colaborador/feature/employee_referral/presentation/widgets/employee_referral_page_body_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class EmployeeReferralPage extends StatefulWidget {
  const EmployeeReferralPage({Key? key}) : super(key: key);

  @override
  State<EmployeeReferralPage> createState() => _EmployeeReferralPageState();
}

class _EmployeeReferralPageState extends State<EmployeeReferralPage> {
  final EmployeeReferralEntity employeeReferral = EmployeeReferralEntity();
  late EmployeeReferralBloc employeeReferralBloc;

  @override
  void initState() {
    super.initState();
    employeeReferralBloc = ApplicationContainer.instance().resolve();
  }

  @override
  Widget build(BuildContext context) {
    var fileMaxSizePermitted = _getFileMaxSizePermitted(context);
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "employee_referral_page_title"),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: BlocProvider.value(
            value: employeeReferralBloc,
            child: BlocConsumer<EmployeeReferralBloc, EmployeeReferralState>(
                listener: (context, state) {
              if (state is EmployeeReferralRegisterFailedState) {
                Navigator.pushNamed(
                  context,
                  ApplicationRoute.employeeReferralRegisterError,
                );
              } else if (state is EmployeeReferralRegisterLoadedState) {
                Navigator.pushReplacementNamed(
                  context,
                  ApplicationRoute.employeeReferralRegisterSuccess,
                );
              }
            }, builder: (context, state) {
              if (state is GetCitiesLoadingState ||
                  state is EmployeeReferralRegisterLoadingState) {
                return const Column(
                  children: [
                    Expanded(
                      child: LoadingWidget(),
                    ),
                  ],
                );
              }
              if (state is GetCitiesFailedState) {
                return ErrorHandlingWidget(
                  errorCode: state.errorCode,
                  error: state.errorDescription,
                  reTryFunction: () => employeeReferralBloc.getCities(),
                  backFunction: () => Navigator.pop(context, true),
                  isProduction: env.isProduction,
                );
              }
              return Scrollbar(
                child: SingleChildScrollView(
                  child: EmployeeReferralPageBodyWidget(
                    employeeReferral: employeeReferral,
                    fileMaxSizePermitted: fileMaxSizePermitted,
                    cities: employeeReferralBloc.cities,
                    registerEmployeeReferral: () {
                      employeeReferralBloc.registerEmployeeReferral(
                        description: employeeReferral.description!,
                        city: employeeReferral.city!,
                        file: employeeReferral.file!,
                        region: employeeReferral.region,
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  static _getFileMaxSizePermitted(BuildContext context) {
    SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();
    FirebaseRemoteConfig? remoteConfig = sessionBloc.remoteConfig;
    int defaultValue = 10485760;
    try {
      if (remoteConfig != null) {
        var fileMaxSizePermitted = jsonDecode(remoteConfig
            .getString(CustomFirebaseRemoteConfig.fileMaxSizePermitted));
        return fileMaxSizePermitted ?? defaultValue;
      }
    } catch (err) {
      return defaultValue;
    }
  }
}
