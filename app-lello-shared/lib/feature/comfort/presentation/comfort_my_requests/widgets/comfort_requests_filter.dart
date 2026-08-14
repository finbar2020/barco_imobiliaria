import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_features/feature/comfort/data/model/comfort_requests_filter_model.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';

class ComfortRequestsFilterWidget extends StatefulWidget {
  final ComfortRequestsFilter filter;
  final List<ComfortSubcategories> subcategories;
  final Function(ComfortRequestsFilter filter) onSearch;
  ComfortRequestsFilterWidget({
    Key? key,
    required this.filter,
    required this.subcategories,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<ComfortRequestsFilterWidget> createState() =>
      _ResinHistoryFilterWidgetState();
}

class _ResinHistoryFilterWidgetState
    extends State<ComfortRequestsFilterWidget> {
  ThemeData themeDark = LelloTheme.dark;
  List<String> status = [];
  List<String> subcategories = [];

  var dateInit;
  var dateLast;
  late final ComfortRequestsFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = ComfortRequestsFilterModel.fromEntity(widget.filter).toEntity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    status = [
      getString(context, "comfort_request_filter_status_all"),
      getString(context, "comfort_request_filter_status_sent"),
      getString(context, "comfort_request_filter_status_resent"),
      getString(context, "comfort_request_filter_status_canceled")
    ];
    subcategories =
        comfortSubcategoriesToStringList(context, widget.subcategories);
    return WillPopScope(
      onWillPop: () async {
        backFilter();
        return true;
      },
      child: DismissKeyboard(
        child: Container(
          color: themeDark.canvasColor,
          padding: EdgeInsets.only(top: Dimens.spacingMedium),
          child: Theme(
            data: themeDark,
            child: Container(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              color: themeDark.canvasColor,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getString(context, "filter"),
                          style: LelloTextStyles.title(themeDark),
                        ),
                        IconButton(
                          onPressed: () {
                            backFilter();
                            Navigator.of(context).pop();
                          },
                          icon: SvgPicture.asset("assets/ic_close_white.svg"),
                        ),
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimens.spacingMedium),
                              child: Text(
                                getString(context, "reports_choose_date"),
                                style: LelloTextStyles.subtitleBold(themeDark),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(getString(context, "from"),
                                      style:
                                          LelloTextStyles.bodyBold(themeDark)),
                                ),
                                SizedBox(height: Dimens.spacingSmall),
                                Expanded(
                                  child: Text(getString(context, "to"),
                                      style:
                                          LelloTextStyles.bodyBold(themeDark)),
                                ),
                              ],
                            ),
                            _datePickerBuilder(context),
                            SizedBox(height: Dimens.spacingSmall),
                            _datePickerErrorsBuilder(context),
                            SizedBox(height: Dimens.spacingMedium),
                            _subcategoriesDropdown(),
                            SizedBox(height: Dimens.spacingMedium),
                            _statusDropdown(),
                            SizedBox(height: Dimens.spacingMedium),
                            _searchButton(context, theme),
                            _clearFiltersButton(context, theme)
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  clearFilter() {
    setState(() {
      widget.filter.status = ComfortFilterRequestStatus.all;
      widget.filter.subcategories = ComfortType.all;
      widget.filter.startDate = null;
      widget.filter.endDate = null;
    });
  }

  backFilter() {
    setState(() {
      widget.filter.status = _filter.status;
      widget.filter.subcategories = _filter.subcategories;
      widget.filter.startDate = _filter.startDate;
      widget.filter.endDate = _filter.endDate;
    });
  }

  bool areDateFieldsValid() {
    bool startDateSet = widget.filter.startDate != null;
    bool endDateSet = widget.filter.endDate != null;

    return (startDateSet && endDateSet) || (!startDateSet && !endDateSet);
  }

  List<String> comfortSubcategoriesToStringList(
      BuildContext context, List<ComfortSubcategories> comfortSubcategories) {
    List<String> subcategoriesFilter = [];
    subcategoriesFilter.add(ComfortSubcategories.enumToStringSubcategories(
        context, ComfortType.all));
    comfortSubcategories.forEach((e) {
      subcategoriesFilter.add(ComfortSubcategories.enumToStringSubcategories(
          context, e.comfortType));
    });
    return subcategoriesFilter;
  }

// Filter Widgets

  Column _subcategoriesDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getString(context, "comfort_request_filter_subcategories"),
            style: LelloTextStyles.bodyBold(themeDark)),
        SizedBox(height: Dimens.spacingSmall),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(color: themeDark.hintColor),
          ),
          child: DropdownButton(
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down),
              underline: SizedBox.shrink(),
              hint: Text(getString(context, "choose_an_option")),
              value: ComfortSubcategories.enumToStringSubcategories(
                  context, widget.filter.subcategories),
              dropdownColor: Colors.black,
              items: subcategories.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(
                    dropDownStringItem,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              onChanged: (value) {
                setState(() {
                  widget.filter.subcategories =
                      ComfortSubcategories.stringToEnumSubcategories(
                          context, value);
                });
              }),
        ),
      ],
    );
  }

  Column _statusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getString(context, "comfort_request_filter_status"),
            style: LelloTextStyles.bodyBold(themeDark)),
        SizedBox(height: Dimens.spacingSmall),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(color: themeDark.hintColor),
          ),
          child: DropdownButton(
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down),
              underline: SizedBox.shrink(),
              hint: Text(getString(context, "choose_an_option")),
              value: enumToStringStatus(widget.filter.status),
              dropdownColor: Colors.black,
              items: status.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                  value: dropDownStringItem,
                  child: Text(
                    dropDownStringItem,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              onChanged: (value) {
                setState(() {
                  widget.filter.status = stringToEnumStatus(value);
                });
              }),
        ),
      ],
    );
  }

  Expanded _startDateSelector(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(color: themeDark.hintColor),
            ),
            child: Text(
              widget.filter.startDate != null
                  ? DateFormat.yMd().format(widget.filter.startDate!)
                  : '00/00/0000',
              style: LelloTextStyles.subtitle(themeDark)!.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        onTap: () async {
          DateTime? selected = await showDatePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: widget.filter.startDate ?? DateTime.now(),
            firstDate: getTwoYearsAgo(),
            lastDate: widget.filter.endDate ?? DateTime.now(),
          );
          if (selected != null) {
            setState(() {
              widget.filter.startDate = selected;
              if (widget.filter.endDate != null &&
                  selected.isAfter(widget.filter.endDate!)) {
                widget.filter.endDate = null;
              }
            });
          }
        },
      ),
    );
  }

  Expanded _endDateSelector(BuildContext context) {
    return Expanded(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: Border.all(color: themeDark.hintColor),
            ),
            child: Text(
              widget.filter.endDate != null
                  ? DateFormat.yMd().format(widget.filter.endDate!)
                  : '00/00/0000',
              style: LelloTextStyles.subtitle(themeDark)!.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
        onTap: () async {
          DateTime? selected = await showDatePicker(
            context: context,
            initialEntryMode: DatePickerEntryMode.calendarOnly,
            initialDate: widget.filter.endDate ?? DateTime.now(),
            firstDate: widget.filter.startDate ?? getTwoYearsAgo(),
            lastDate: DateTime.now(),
          );
          if (selected != null) {
            setState(() {
              widget.filter.endDate = selected;
            });
          }
        },
      ),
    );
  }

  Row _datePickerBuilder(BuildContext context) {
    return Row(
      children: [
        _startDateSelector(context),
        SizedBox(width: Dimens.spacing),
        _endDateSelector(context)
      ],
    );
  }

  Row _datePickerErrorsBuilder(BuildContext context) {
    bool showEndDateError =
        widget.filter.startDate != null && widget.filter.endDate == null;
    bool showStartDateError =
        widget.filter.startDate == null && widget.filter.endDate != null;

    return Row(
      children: [
        Expanded(
          child: showStartDateError
              ? Text(getString(context, "comfort_request_filter_date_error"),
                  style: LelloTextStyles.error(themeDark))
              : SizedBox.shrink(),
        ),
        SizedBox(height: Dimens.spacingSmall),
        Expanded(
          child: showEndDateError
              ? Text(getString(context, "comfort_request_filter_date_error"),
                  style: LelloTextStyles.error(themeDark))
              : SizedBox.shrink(),
        ),
      ],
    );
  }

DateTime getTwoYearsAgo() {
  return DateTime(DateTime.now().year - 2, DateTime.now().month, DateTime.now().day);
}

  Container _searchButton(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingSmall),
      width: double.infinity,
      child: PrimaryButton(
        buttonColor: LelloTheme.palleteOf(theme).background(),
        text: getString(context, "find"),
        onPressed: () {
          if (widget.filter.isEqualTo(_filter) || !areDateFieldsValid()) {
            log("Campos vazios");
          } else {
            setState(() {});
            Navigator.pop(context);
            widget.onSearch(widget.filter);
          }
        },
      ),
    );
  }

  Container _clearFiltersButton(BuildContext context, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingSmall),
      width: double.infinity,
      child: PrimaryButton(
          buttonColor: LelloTheme.palleteOf(theme).overlay(),
          textStyle: TextStyle(color: LelloTheme.palleteOf(theme).buttonText()),
          text: getString(context, "comfort_request_filter_clear"),
          border: BorderSide(color: Colors.white, width: 1),
          onPressed: () {
            clearFilter();
          }),
    );
  }

// Enum Helpers

  ComfortFilterRequestStatus stringToEnumStatus(String? value) {
    if (value == getString(context, "comfort_request_filter_status_all")) {
      return ComfortFilterRequestStatus.all;
    } else if (value ==
        getString(context, "comfort_request_filter_status_sent")) {
      return ComfortFilterRequestStatus.sended;
    } else if (value ==
        getString(context, "comfort_request_filter_status_resent")) {
      return ComfortFilterRequestStatus.resent;
    } else {
      return ComfortFilterRequestStatus.canceled;
    }
  }

  String? enumToStringStatus(ComfortFilterRequestStatus? status) {
    if (status == ComfortFilterRequestStatus.all) {
      return getString(context, "comfort_request_filter_status_all");
    } else if (status == ComfortFilterRequestStatus.sended) {
      return getString(context, "comfort_request_filter_status_sent");
    } else if (status == ComfortFilterRequestStatus.resent) {
      return getString(context, "comfort_request_filter_status_resent");
    } else if (status == ComfortFilterRequestStatus.canceled) {
      return getString(context, "comfort_request_filter_status_canceled");
    } else {
      return null;
    }
  }
}
