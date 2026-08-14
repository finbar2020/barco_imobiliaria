import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_state.dart';
import 'package:morar/feature/vehicles/presentation/controllers/vehicle_controller.dart';
import 'package:morar/feature/vehicles/presentation/pages/sucess_remove_case_page.dart';
import 'package:morar/feature/vehicles/presentation/pages/sucess_update_case_page.dart';

class EditVehiclePage extends StatefulWidget {
  final Vehicle? vehicle;

  EditVehiclePage({this.vehicle});

  @override
  _EditVehiclePageState createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  String? indexType = "";
  String? indexColor;
  bool firstBuild = true;
  TextEditingController plateController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController additionalInfoController = TextEditingController();
  final RegExp _plateRegex =
      RegExp(r'^[A-Z]{3}-?[0-9]{4}$|^[A-Z]{3}[0-9][A-Z][0-9]{2}$');
  final int _maxLength = 50;

  bool _plateFieldTouched = false;
  bool _isSubmitting = false;

  var editBloc;
  bool rentedSpace = false;

  VehicleController controller =
      ApplicationContainer.instance().resolve<VehicleController>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  void initState() {
    super.initState();
    _plateFieldTouched = false;
    _isSubmitting = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context) != null && mounted) {
        Vehicle vehicle = ModalRoute.of(context)!.settings.arguments as Vehicle;
        setState(() {
          plateController.text = vehicle.identificationNumber ?? '';
          modelController.text = vehicle.model ?? "";
          indexType = vehicle.type;
          indexColor = vehicle.color;
          rentedSpace = vehicle.rentedSpace ?? false;
          firstBuild = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Vehicle vehicle = ModalRoute.of(context)!.settings.arguments as Vehicle;
    List<String> type = [
      getString(context, "me_vehicles_motorcycle"),
      getString(context, "me_vehicles_car"),
      getString(context, "me_vehicles_bike"),
    ];
    List<String> color = [
      getString(context, "blue"),
      getString(context, "brown"),
      getString(context, "green"),
      getString(context, "red"),
      getString(context, "white"),
      getString(context, "yellow"),
      getString(context, "silver"),
      getString(context, "black"),
      getString(context, "gray"),
      getString(context, "accountability_others"),
    ];
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WhiteAppBar(
        isGetString: true,
        title: "me_vehicles_edit",
        onPressed: () {
          Navigator.pushReplacementNamed(context, ApplicationRoute.vehiclePage);
        },
      ),
      body: BlocConsumer(
        bloc: controller.vehicleBloc,
        listener: (context, state) {
          if (state is VehicleRemovedState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleRemovedSucessPage(),
              ),
            );
          }
          if (state is VehicleUpdatedState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VehicleUpdateSucessPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is VehicleLoadingDeleteInProgressState ||
              state is VehicleLoadingUpdateInProgressState) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: LoadingWidget()),
              ],
            );
          }
          if (state is VehicleAddingFailedState) {
            return Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: ErrorHandlingWidget(
                errorCode: state.message,
                error: state.message,
                title: state.message,
                subTitle: "",
                reTryFunction: () => controller.restartState(),
                backFunction: () => controller.restartState(),
                isProduction: env.isProduction,
              ),
            );
          }
          if (state is DeleteVehicleErrorState ||
              state is VehicleLoadingFailedState) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(getString(context, "warning_failed_message"))),
              ],
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: DismissKeyboard(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(getString(context, "payroll_type"),
                                style: LelloTextStyles.bodyBold(theme)),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: LelloTheme.palleteOf(theme)
                                        .textOpaque()),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: LelloTheme.palleteOf(theme)
                                        .textOpaque()),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              filled: false,
                              hintStyle: TextStyle(
                                  color: LelloTheme.palleteOf(theme).text()),
                              hintText: "${vehicle.type}",
                              labelStyle: TextStyle(
                                fontSize: 16,
                              )),
                          onChanged: (String? value) {
                            setState(() {
                              indexType = value;
                            });
                          },
                          items: type
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text('$e')))
                              .toList(),
                        ),
                        if (indexType!.toUpperCase() !=
                            getString(context, "me_vehicles_bike")
                                .toUpperCase())
                          SizedBox(height: Dimens.spacingLarge),
                        if (indexType!.toUpperCase() !=
                            getString(context, "me_vehicles_bike")
                                .toUpperCase())
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              child: Text(
                                  getString(context, "me_vehicles_plate"),
                                  style: LelloTextStyles.bodyBold(theme)),
                            ),
                          ),
                        if (indexType!.toUpperCase() !=
                            getString(context, "me_vehicles_bike")
                                .toUpperCase())
                          SizedBox(
                            height: 6,
                          ),
                        if (indexType!.toUpperCase() !=
                            getString(context, "me_vehicles_bike")
                                .toUpperCase())
                          Container(
                            child: TextField(
                              textInputAction: TextInputAction.done,
                              controller: plateController,
                              // focusNode: FocusNode(
                              //   canRequestFocus: false,
                              // ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: LelloTheme.palleteOf(theme)
                                        .textOpaque(),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: LelloTheme.palleteOf(theme)
                                        .textOpaque(),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                errorText: (_plateFieldTouched || _isSubmitting)
                                    ? (plateController.text.isEmpty
                                        ? getString(
                                            context, 'validation_required')
                                        : !_plateRegex
                                                .hasMatch(plateController.text)
                                            ? getString(context,
                                                'invalid_license_plate_format')
                                            : null)
                                    : null,
                                filled: true,
                                fillColor:
                                    LelloTheme.palleteOf(theme).customColor(),
                                hintText: 'AAA-0000 ou AAA0A00',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color:
                                      LelloTheme.palleteOf(theme).textOpaque(),
                                ),
                              ),
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[A-Z0-9-]')),
                                LengthLimitingTextInputFormatter(8),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _plateFieldTouched = true;
                                  plateController.value = plateController.value
                                      .copyWith(text: value.toUpperCase());
                                });
                              },
                            ),
                          ),
                        SizedBox(height: Dimens.spacingLarge),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(getString(context, "color"),
                                style: LelloTextStyles.bodyBold(theme)),
                          ),
                        ),
                        SizedBox(height: 6),
                        DropdownButtonFormField(
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: LelloTheme.palleteOf(theme)
                                        .textOpaque()),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: LelloTheme.palleteOf(theme)
                                        .textOpaque()),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              filled: false,
                              hintStyle: TextStyle(
                                  color: LelloTheme.palleteOf(theme).text()),
                              hintText: "${vehicle.getCor(context, vehicle.color)}",
                              labelStyle: TextStyle(
                                fontSize: 16,
                              )),
                          onChanged: (String? value) {
                            indexColor = value;
                          },
                          items: color
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text('$e')))
                              .toList(),
                        ),
                        SizedBox(height: Dimens.spacingLarge),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                                getString(context, "me_vehicles_model_field"),
                                style: LelloTextStyles.bodyBold(theme)),
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          child: TextField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            textInputAction: TextInputAction.done,
                            controller: modelController,
                            maxLength: _maxLength,
                            // focusNode: FocusNode(
                            //   canRequestFocus: false,
                            // ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      LelloTheme.palleteOf(theme).textOpaque(),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      LelloTheme.palleteOf(theme).textOpaque(),
                                ),
                              ),
                              filled: true,
                              fillColor:
                                  LelloTheme.palleteOf(theme).customColor(),
                              hintText: getString(
                                  context, 'me_vehicles_model_write_field'),
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: LelloTheme.palleteOf(theme).textOpaque(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingLarge),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Text(
                                getString(context, "me_vehicles_rented_space"),
                                style: LelloTextStyles.bodyBold(theme)),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  rentedSpace = true;
                                });
                              },
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                        color: rentedSpace
                                            ? LelloTheme.palleteOf(theme)
                                                .primary()
                                            : Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        border: Border.all(
                                          color: rentedSpace
                                              ? LelloTheme.palleteOf(theme)
                                                  .primary()
                                              : LelloTheme.palleteOf(theme)
                                                  .hubText(),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimens.spacingSmall),
                                  Text(
                                    getString(context, "yes"),
                                    style: LelloTextStyles.subtitle(theme),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Dimens.spacing),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      rentedSpace = false;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          height: 30.0,
                                          width: 30.0,
                                          decoration: BoxDecoration(
                                              color: rentedSpace
                                                  ? Colors.white
                                                  : LelloTheme.palleteOf(theme)
                                                      .primary(),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0)),
                                              border: Border.all(
                                                  color: rentedSpace
                                                      ? LelloTheme.palleteOf(
                                                              theme)
                                                          .hubText()
                                                      : LelloTheme.palleteOf(
                                                              theme)
                                                          .primary())),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: Dimens.spacingSmall),
                                      Text(
                                        getString(context, "no"),
                                        style: LelloTextStyles.subtitle(theme),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        Text(
                          getString(context, "me_vehicles_additional_info"),
                          style: LelloTextStyles.subtitleBold(theme),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Container(
                          height: 200.0,
                          child: TextField(
                            controller: additionalInfoController,
                            maxLength: 256,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              labelStyle: LelloTextStyles.subtitle(theme),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor:
                                  LelloTheme.palleteOf(theme).customColor(),
                              hintStyle: TextStyle(
                                color: LelloTheme.palleteOf(theme).text(),
                              ),
                              hintText: vehicle.additionalInfo != null
                                  ? vehicle.additionalInfo
                                  : getString(context,
                                      'me_vehicles_additional_info_empty'),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingXLarge),
                        GestureDetector(
                          onTap: () {
                            _showDialogBlockUser(
                              context,
                              controller.sessionBloc,
                              () {
                                Navigator.pop(context);
                                controller.excludedVehicle(vehicle.id!);
                              },
                              theme,
                            );
                          },
                          child: Center(
                            child: Text(
                                getString(context, "me_vehicles_delete"),
                                style: LelloTextStyles.body(theme)!.copyWith(
                                  color: LelloTheme.palleteOf(theme).error(),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      LelloTheme.palleteOf(theme).error(),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Container(
                    width: double.infinity,
                    child: PrimaryButton(
                        buttonColor: theme.primaryColor,
                        text: getString(context, 'conclude'),
                        onPressed: () {
                          setState(() {
                            _isSubmitting =
                                true; // Marcar como enviando para ativar validações
                          });

                          Vehicle vehicleEdit =
                              getVehicleObject(context, vehicle);
                          if (vehicleEdit.isNotValid != null) {
                            Flushbar(
                              message:
                                  getString(context, vehicleEdit.isNotValid!),
                              duration: Duration(seconds: 3),
                            )..show(context);
                          } else {
                            controller.updateVehicle(vehicleEdit);
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Vehicle getVehicleObject(BuildContext context, Vehicle vehicle) {
    Vehicle vehicleEdit = Vehicle();
    if (indexType!.toUpperCase() ==
        getString(context, "me_vehicles_bike").toUpperCase()) {
      plateController.text = '';
    }
    vehicleEdit = Vehicle(
        id: vehicle.id,
        type: vehicleEdit.setType(context, indexType),
        identificationNumber:
            plateController.text.isNotEmpty ? plateController.text : null,
        model: modelController.text,
        rentedSpace: rentedSpace,
        color: vehicle.setTypeCor(context, indexColor),
        unitId: '${controller.sessionBloc.state.session!.unity!.id}',
        additionalInfo: additionalInfoController.text);
    return vehicleEdit;
  }

  Future _showDialogBlockUser(
    BuildContext context,
    SessionBloc sessionBloc,
    VoidCallback onPressed,
    ThemeData theme,
  ) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                getString(context, "me_vehicles_delete"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.titleSmall(theme)!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: Dimens.spacingSmall),
              Text(
                '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.body(theme),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Text(
                getString(context, "me_vehicles_sure_delete"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      getString(context, "back").toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onPressed,
                    child: Text(
                      getString(context, "confirm").toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
