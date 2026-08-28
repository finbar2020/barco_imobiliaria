import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_state.dart';
import 'package:morar/feature/vehicles/presentation/controllers/vehicle_controller.dart';

class AddVehiclePage extends StatefulWidget {
  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  String? indexType;
  String? indexColor;
  TextEditingController plateController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController additionalInfoController = TextEditingController();
  final bool canChange = false;
  bool rentedSpace = false;
  final RegExp _plateRegex =
      RegExp(r'^[A-Z]{3}-?[0-9]{4}$|^[A-Z]{3}[0-9][A-Z][0-9]{2}$');
  final int _maxLength = 50;

  bool _plateFieldTouched = false;
  bool _isSubmitting = false;

  VehicleController controller =
      ApplicationContainer.instance().resolve<VehicleController>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WhiteAppBar(
        isGetString: true,
        title: "me_vehicles_add_vehicle",
        onPressed: () {
          Navigator.pushReplacementNamed(context, ApplicationRoute.vehiclePage);
        },
      ),
      body: BlocConsumer(
        bloc: controller.vehicleBloc,
        listener: (context, state) {
          if (state is VehicleAddedState) {
            Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.vehicleSucceeded,
            );
          }
          if (state is VehicleAddingFailedState) {
            Navigator.pushNamed(
              context,
              ApplicationRoute.vehicleErrorPage,
            );
          }
        },
        builder: (context, state) {
          if (state is VehicleLoadingAddInProgressState) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: LoadingWidget()),
              ],
            );
          }
          return DismissKeyboard(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(shrinkWrap: true, children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(getString(context, "payroll_type"),
                        style: LelloTextStyles.bodyBold(theme)),
                  ),
                ),
                SizedBox(height: 6),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: LelloTheme.palleteOf(theme).textOpaque()),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: LelloTheme.palleteOf(theme).textOpaque(),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      filled: false,
                      hintStyle: TextStyle(
                          color: LelloTheme.palleteOf(theme).textOpaque()),
                      hintText: getString(context, "choose_type"),
                      labelStyle: TextStyle(
                        fontSize: 16,
                      )),
                  onChanged: (String? value) {
                    setState(() {
                      indexType = value;
                    });
                  },
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  value: indexType,
                  items: type
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                ),
                if (indexType != getString(context, "me_vehicles_bike"))
                  SizedBox(height: Dimens.spacingLarge),
                if (indexType != getString(context, "me_vehicles_bike"))
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        getString(context, "me_vehicles_plate"),
                        style: LelloTextStyles.bodyBold(theme),
                      ),
                    ),
                  ),
                if (indexType != getString(context, "me_vehicles_bike"))
                  SizedBox(height: 6),
                if (indexType != getString(context, "me_vehicles_bike"))
                  Container(
                    child: TextField(
                      textInputAction: TextInputAction.done,
                      controller: plateController,
                      focusNode: FocusNode(
                        canRequestFocus: false,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: LelloTheme.palleteOf(theme).textOpaque(),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: LelloTheme.palleteOf(theme).textOpaque(),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        errorText: (_plateFieldTouched || _isSubmitting)
                            ? (plateController.text.isEmpty
                                ? getString(context, 'validation_required')
                                : !_plateRegex.hasMatch(plateController.text)
                                    ? getString(
                                        context, 'invalid_license_plate_format')
                                    : null)
                            : null,
                        filled: true,
                        fillColor: LelloTheme.palleteOf(theme).customColor(),
                        hintText: 'AAA-0000 ou AAA0A00',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: LelloTheme.palleteOf(theme).textOpaque(),
                        ),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        // Converte para maiusculas antes do filtro, senao as
                        // minusculas digitadas seriam descartadas.
                        TextInputFormatter.withFunction((oldValue, newValue) =>
                            newValue.copyWith(
                                text: newValue.text.toUpperCase())),
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9-]')),
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
                    child: Text(
                      getString(context, "color"),
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: LelloTheme.palleteOf(theme).textOpaque(),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: LelloTheme.palleteOf(theme).textOpaque(),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      filled: false,
                      hintStyle: TextStyle(
                        color: LelloTheme.palleteOf(theme).textOpaque(),
                      ),
                      hintText: getString(context, "choose_color"),
                      labelStyle: TextStyle(
                        fontSize: 16,
                      )),
                  onChanged: (String? value) {
                    setState(() {
                      indexColor = value;
                    });
                  },
                  value: indexColor,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  items: color
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: Text(
                      getString(context, "me_vehicles_model_field"),
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Container(
                  child: TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    textInputAction: TextInputAction.done,
                    controller: modelController,
                    maxLength: _maxLength,
                    focusNode: FocusNode(
                      canRequestFocus: false,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: LelloTheme.palleteOf(theme).textOpaque(),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: LelloTheme.palleteOf(theme).textOpaque(),
                        ),
                      ),
                      filled: true,
                      fillColor: LelloTheme.palleteOf(theme).customColor(),
                      hintText:
                          getString(context, 'me_vehicles_model_write_field'),
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
                      style: LelloTextStyles.bodyBold(theme),
                    ),
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
                                      ? theme.primaryColor
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0)),
                                  border: Border.all(
                                      color: rentedSpace
                                          ? LelloTheme.palleteOf(theme)
                                              .primary()
                                          : LelloTheme.palleteOf(theme)
                                              .hubText())),
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
                                        : LelloTheme.palleteOf(theme).primary(),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    border: Border.all(
                                      color: rentedSpace
                                          ? LelloTheme.palleteOf(theme)
                                              .hubText()
                                          : LelloTheme.palleteOf(theme)
                                              .primary(),
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
                SizedBox(height: Dimens.spacingLarge),
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
                      fillColor: LelloTheme.palleteOf(theme).customColor(),
                      hintText: getString(
                          context, 'me_vehicles_additional_info_text_field'),
                    ),
                  ),
                ),
                SizedBox(height: Dimens.spacingXLarge),
                Container(
                  width: double.infinity,
                  child: PrimaryButton(
                    buttonColor: theme.primaryColor,
                    text: getString(context, "add"),
                    onPressed: () {
                      setState(() {
                        _isSubmitting = true;
                      });

                      FocusScope.of(context).requestFocus(new FocusNode());

                      addVehicle(context);
                    },
                  ),
                )
              ]),
            ),
          );
        },
      ),
    );
  }

  void addVehicle(BuildContext context) {
    if (indexType == getString(context, "me_vehicles_bike")) {
      plateController.text = '';
    }
    Vehicle vehicle = getVehicleObject(context);
    if (vehicle.isNotValid != null) {
      Flushbar(
        message: getString(context, vehicle.isNotValid!),
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      controller.postVehicle(vehicle);
    }
  }

  Vehicle getVehicleObject(BuildContext context) {
    Vehicle vehicle = Vehicle();
    vehicle = Vehicle(
        type: vehicle.setType(context, indexType),
        identificationNumber:
            plateController.text.isNotEmpty ? plateController.text : null,
        model: modelController.text,
        rentedSpace: rentedSpace,
        color: vehicle.setTypeCor(context, indexColor),
        unitId: '${controller.sessionBloc.state.session!.unity!.id}',
        additionalInfo: additionalInfoController.text);
    return vehicle;
  }
}
