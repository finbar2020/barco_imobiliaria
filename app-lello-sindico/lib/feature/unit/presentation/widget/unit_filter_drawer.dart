import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/condominium/domain/entity/block_simple.dart';
import 'package:lello/feature/unit/domain/entity/unit_simple.dart';
import 'package:lello/feature/unit/presentation/controllers/unit_controller.dart';
import 'package:lello/feature/vehicles/domain/enums/vehicle_type.dart';

import '../../../../core/dependency/application_container.dart';

class UnitFilterDrawer extends StatefulWidget {
  const UnitFilterDrawer({Key? key}) : super(key: key);

  @override
  State<UnitFilterDrawer> createState() => _UnitFilterDrawerState();
}

class _UnitFilterDrawerState extends State<UnitFilterDrawer> {
  final UnitsController controller =
      ApplicationContainer.instance().resolve<UnitsController>();

  final dateFormat = DateFormat.yMd();
  final _formKey = GlobalKey<FormState>();

  BlockSimple? blockSelected;
  UnitSimple? unitSelected;
  List<UnitSimple> unitsFilter = [];
  List<BlockSimple> blocksFilter = [];
  bool? hasAppInstalled;
  bool showOnlyUnitsWithBiometrics = false;
  bool filterOnlyWithTenant = false;
  String? vehicleIdentification;
  String? vehicleTypeSelected;

  @override
  void initState() {
    blockSelected = controller.blockSelected;
    unitSelected = controller.unitSelected;
    blocksFilter = controller.blocks;
    unitsFilter = controller.unitsFilter;
    hasAppInstalled = controller.hasAppInstalled;
    showOnlyUnitsWithBiometrics = controller.showOnlyUnitsWithBiometrics;
    filterOnlyWithTenant = controller.filterOnlyWithTenant;
    vehicleIdentification = controller.vehicleIdentification;
    vehicleTypeSelected = controller.vehicleTypeSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeDark = LelloTheme.dark;
    final size = MediaQuery.of(context).size;
    final themeContext = Theme.of(context);
    themeDark = themeDark.copyWith(
      colorScheme: themeDark.colorScheme.copyWith(
        primary: themeContext.primaryColor,
      ),
      primaryColor: themeContext.primaryColor,
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeDark.colorScheme.surface,
      body: Drawer(
        backgroundColor: const Color(0xFF2D2D2D),
        width: size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: Dimens.spacingLarge),
          physics: const BouncingScrollPhysics(),
          child: Theme(
            data: themeDark,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(Dimens.spacing),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getString(context, "payment_filter_title"),
                          style: LelloTextStyles.title(LelloTheme.dark),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: SvgPicture.asset("assets/ic_close_white.svg"),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      getString(context, 'units_group'),
                      style: LelloTextStyles.bodyBold(themeDark),
                    ),
                    SizedBox(height: Dimens.spacing),
                    DropdownButtonFormField<BlockSimple>(
                      value: blockSelected,
                      isExpanded: true,
                      items: blocksFilter
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        blockSelected = value;
                        unitSelected = null;

                        setState(() {
                          unitsFilter = blockSelected!.units;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(
                      getString(context, 'units_unit'),
                      style: LelloTextStyles.bodyBold(themeDark),
                    ),
                    SizedBox(height: Dimens.spacing),
                    DropdownButtonFormField<UnitSimple?>(
                      value: unitSelected,
                      isExpanded: true,
                      items: unitsFilter
                          .map(
                            (e) => DropdownMenuItem<UnitSimple?>(
                              value: e,
                              child: Text(e.title),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        unitSelected = value;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      getString(context, 'is_app_installed'),
                      style: LelloTextStyles.bodyBold(themeDark),
                    ),
                    SizedBox(height: Dimens.spacing),
                    DropdownButtonFormField<bool>(
                      value: hasAppInstalled,
                      isExpanded: true,
                      items: [true, false]
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e
                                    ? getString(context, "yes")
                                    : getString(context, "no"),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        hasAppInstalled = value ?? false;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    InkWell(
                      onTap: () {
                        setState(() {
                          filterOnlyWithTenant = !filterOnlyWithTenant;
                        });
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IgnorePointer(
                            child: Checkbox(
                              value: filterOnlyWithTenant,
                              activeColor: themeDark.primaryColor,
                              side: const BorderSide(
                                color: Colors.white,
                              ),
                              onChanged: (bool? value) {
                                setState(() {
                                  filterOnlyWithTenant = value ?? false;
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: Text(
                              getString(context, "show_unit_with_occupant"),
                              style: LelloTextStyles.body(themeDark),
                            ),
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                        ],
                      ),
                    ),
                    if (controller.hasBiometrics)
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                showOnlyUnitsWithBiometrics =
                                    !showOnlyUnitsWithBiometrics;
                              });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IgnorePointer(
                                  child: Checkbox(
                                    value: showOnlyUnitsWithBiometrics,
                                    activeColor: themeContext.primaryColor,
                                    onChanged: (bool? value) {},
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    getString(
                                        context, "show_unit_with_biometrics"),
                                    style: LelloTextStyles.body(themeDark),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimens.spacing),
                        ],
                      ),
                    const Divider(
                      thickness: 1,
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      getString(context, "filter_by_vehicle"),
                      style: LelloTextStyles.subtitleBold(LelloTheme.dark),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(
                      getString(context, 'type'),
                      style: LelloTextStyles.bodyBold(themeDark),
                    ),
                    SizedBox(height: Dimens.spacing),
                    DropdownButtonFormField<String>(
                      value: vehicleTypeSelected,
                      isExpanded: true,
                      items: controller.vehicleType
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.toApi(),
                              child: Text(
                                getString(
                                  context,
                                  e.toFormattedStringKey(),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          vehicleTypeSelected = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(
                      getString(context, 'vehicle_identification'),
                      style: LelloTextStyles.bodyBold(themeDark),
                    ),
                    SizedBox(height: Dimens.spacing),
                    TextFormField(
                      controller: controller.vehicleIdentificationController,
                      onChanged: (value) {
                        vehicleIdentification = value;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingLarge),
                    Theme(
                      data: themeContext,
                      child: PrimaryButton(
                        text: getString(context, "find"),
                        onPressed: () async {
                          controller.setBlock(blockSelected);
                          controller.setUnit(unitSelected);
                          controller.setHasAppInstalled(hasAppInstalled);
                          controller.setUnitsFilter(unitsFilter);
                          controller
                              .setFilterOnlyWithTenant(filterOnlyWithTenant);
                          controller
                              .setShowBiometrics(showOnlyUnitsWithBiometrics);
                          controller.setVehicleType(vehicleTypeSelected);

                          controller
                              .setVehicleIdentification(vehicleIdentification);

                          Navigator.pop(context);
                          await controller.getUnits(clearUnits: true);
                        },
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all(
                          const BorderSide(color: Colors.white),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Colors.transparent,
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        controller.clearFilters();
                        await controller.getUnits(clearUnits: true);
                      },
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.spacingSmall),
                          child: Text(
                            getString(context, "report_clear_filters"),
                            style: LelloTextStyles.button(themeDark)!.copyWith(
                              color: LelloTheme.palleteOf(themeDark)
                                  .contrastBackground(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
