import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/condominium_code_info.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_condominium_step_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_employees_step_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_list_offile_points_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_login_step_widget.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_offline_save_point_widget.dart';
import 'package:flutter/material.dart';

enum LoginTabletSteps {
  condominiumName,
  employees,
  employeeLogin,
  employeeSaveDigitalPoint,
  listOfflinePoints,
}

class LoginTabletLoadedWidget extends StatefulWidget {
  final CondominiumCodeInfo condominiumCodeInfo;
  const LoginTabletLoadedWidget({
    Key? key,
    required this.condominiumCodeInfo,
  }) : super(key: key);

  @override
  State<LoginTabletLoadedWidget> createState() =>
      _LoginTabletLoadedWidgetState();
}

class _LoginTabletLoadedWidgetState extends State<LoginTabletLoadedWidget> {
  LoginTabletSteps currentStep = LoginTabletSteps.condominiumName;
  EmployeeInfo? selectedEmployee;
  final AppConnectivity appConnectivity =
      ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case LoginTabletSteps.condominiumName:
        return LoginTabletCondominiumStepWidget(
          condominiumName: widget.condominiumCodeInfo.condominium.name,

          ///Referencia sem hash para visualização do botão de listagem via firebase
          condoRef: widget.condominiumCodeInfo.condominium.ref,
          changeStep: _stepChanged,
        );
      case LoginTabletSteps.employees:
        return LoginTabletEmployeesStepWidget(
          employees: widget.condominiumCodeInfo.employees,
          changeStep: _stepChanged,
          onEmployeeSelected: (EmployeeInfo employeeInfo) async {
            selectedEmployee = employeeInfo;
            bool connect = await checkConnectivy();
            connect
                ? _stepChanged(LoginTabletSteps.employeeLogin)
                : _stepChanged(LoginTabletSteps.employeeSaveDigitalPoint);
          },
        );
      case LoginTabletSteps.employeeSaveDigitalPoint:
        return LoginTabletLoginOfflineSavePointWidget(
          employee: selectedEmployee!,
          changeStep: _stepChanged,
          condoRef: widget.condominiumCodeInfo.condominium.reference,
        );
      case LoginTabletSteps.listOfflinePoints:
        return LoginTabletListOfflinePoints(
          changeStep: _stepChanged,
          condoRef: widget.condominiumCodeInfo.condominium.reference,
        );
      case LoginTabletSteps.employeeLogin:
        if (selectedEmployee != null) {
          return LoginTabletLoginStepWidget(
            employee: selectedEmployee!,
            changeStep: _stepChanged,
          );
        }
        return Container();
    }
  }

  void _stepChanged(LoginTabletSteps newStep) {
    setState(() {
      currentStep = newStep;
    });
  }

  Future<bool> checkConnectivy() async {
    return await appConnectivity.checkConnectivity();
  }
}
