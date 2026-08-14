import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/city.dart';
import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:essentials/essentials.dart' hide Animation;
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

class EmployeeReferralPageBodyWidget extends StatefulWidget {
  final Function() registerEmployeeReferral;
  final fileMaxSizePermitted;
  final EmployeeReferralEntity employeeReferral;
  final List<CityEntity> cities;
  const EmployeeReferralPageBodyWidget({
    super.key,
    required this.registerEmployeeReferral,
    required this.employeeReferral,
    required this.fileMaxSizePermitted,
    required this.cities,
  });

  @override
  State<EmployeeReferralPageBodyWidget> createState() =>
      _EmployeeReferralPageBodyWidgetState();
}

class _EmployeeReferralPageBodyWidgetState
    extends State<EmployeeReferralPageBodyWidget>
    with TickerProviderStateMixin {
  late AnimationController animation;
  final dropdownKey = GlobalKey();

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    animation.addListener(() {
      if (animation.isCompleted) {
        animation.reverse();
      } else {
        animation.forward();
      }
    });
    animation.repeat();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(
        getString(context, "employee_referral_name"),
        textAlign: TextAlign.start,
        style: LelloTextStyles.subtitle(theme)!.copyWith(
          color: LelloTheme.palleteOf(theme).text(),
        ),
      ),
      SizedBox(height: Dimens.spacingSmall),
      SizedBox(
        width: 30,
        child: TextFormField(
          initialValue: widget.employeeReferral.description ?? "",
          maxLength: 50,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: getString(context, 'employee_referral_hint_name'),
            floatingLabelStyle: TextStyle(
              color: LelloTheme.palleteOf(theme).text(),
            ),
            contentPadding: const EdgeInsets.all(10),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: LelloTheme.palleteOf(theme).grey(),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: LelloTheme.palleteOf(theme).text(), width: 2.0),
            ),
          ),
          onChanged: (value) {
            setState(() {
              widget.employeeReferral.description = value;
            });
          },
        ),
      ),
      SizedBox(height: Dimens.spacingMedium),
      Text(
        getString(context, "employee_referral_city"),
        textAlign: TextAlign.start,
        style: LelloTextStyles.subtitle(theme)!.copyWith(
          color: LelloTheme.palleteOf(theme).text(),
        ),
      ),
      SizedBox(height: Dimens.spacingXSmall),
      Text(
        getString(context, "employee_referral_city_note"),
        textAlign: TextAlign.start,
        style: LelloTextStyles.caption(theme)!.copyWith(
          color: LelloTheme.palleteOf(theme).text(),
        ),
      ),
      SizedBox(height: Dimens.spacingSmall),
      DropdownSearch<String>(
        key: dropdownKey,
        popupProps: PopupProps.menu(
          showSearchBox: true,
          showSelectedItems: true,
          disabledItemFn: (String s) => s.startsWith('I'),
        ),
        items: (filter, loadProps) => widget.cities.map((e) => e.name).toList(),
        selectedItem: widget.employeeReferral.city,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            //hintText: getString(context, "select"),
            labelText: getString(context, "select"),
            //hintText: "country in menu mode",
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
          ),
        ),
        onSelected: (value) {
          if (value != null) {
            setState(() {
              widget.employeeReferral.city = value;
              int index =
                  widget.cities.indexWhere((item) => item.name == value);
              if (widget.cities[index].regions.toList().isNotEmpty) {
                widget.employeeReferral.regions =
                    widget.cities[index].regions.toList();
                widget.employeeReferral.hasRegion = true;
                return;
              }
              if (widget.cities[index].regions.toList().isEmpty) {
                widget.employeeReferral.regions = [];
                widget.employeeReferral.region = null;
                widget.employeeReferral.hasRegion = false;
                return;
              }
            });
          }
        },
      ),
      if (widget.employeeReferral.regions.isNotEmpty)
        FadeTransition(
          opacity: animation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Dimens.spacingMedium),
              Text(
                getString(context, "employee_referral_region"),
                textAlign: TextAlign.start,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              if (widget.employeeReferral.regions.isNotEmpty)
                SizedBox(height: Dimens.spacingSmall),
              DropdownButtonFormField<String>(
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                  hint: Text(
                    getString(context, "select"),
                  ),
                  items: widget.employeeReferral.regions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  value: widget.employeeReferral.region,
                  onTap: () {
                    FocusScope.of(context).requestFocus(
                      FocusNode(),
                    );
                  },
                  onChanged: (value) {
                    setState(() {
                      if (value != "") {
                        widget.employeeReferral.region = value;
                      }
                    });
                  }),
            ],
          ),
        ),
      SizedBox(height: Dimens.spacingMedium),
      Text(
        getString(context, "employee_referral_add_curriculum"),
        textAlign: TextAlign.start,
        style: LelloTextStyles.subtitle(theme)!.copyWith(
          color: LelloTheme.palleteOf(theme).text(),
        ),
      ),
      SizedBox(height: Dimens.spacingSmall),
      Column(
        children: [
          GestureDetector(
            onTap: () {
              AttachFilesBottomSheet.show(
                appContainer: ApplicationContainer.instance(),
                context: context,
                aspectRatioPresets: [CropAspectRatioPreset.original],
                maxFileSizePermitted: widget.fileMaxSizePermitted,
              ).then((filesList) {
                setState(() {
                  if (filesList.isNotEmpty) {
                    widget.employeeReferral.file = filesList.first;
                  }
                });
              });
            },
            child: Center(
              child: widget.employeeReferral.file == null
                  ? SvgPicture.asset(
                      "assets/image_selector_employee_referral.svg",
                      height: 240.0,
                      width: double.infinity)
                  : FileIcon(
                      file: widget.employeeReferral.file!,
                      deleteFile: () => setState(() {
                        widget.employeeReferral.file = null;
                      }),
                      imageIconSize: 240.0,
                    ),
            ),
          ),
        ],
      ),
      SizedBox(height: Dimens.spacing),
      _buildButtons(context)
    ]);
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingMedium),
      child: Column(
        children: [
          PrimaryButton(
            onPressed: widget.employeeReferral.isValid &&
                    widget.employeeReferral.isRegionValid
                ? () {
                    widget.registerEmployeeReferral();
                  }
                : null,
            text: getString(context, "send"),
          ),
        ],
      ),
    );
  }
}
