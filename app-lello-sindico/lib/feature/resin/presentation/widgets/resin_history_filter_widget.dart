import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/resin/data/model/resin_refund_filter_model.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_inconcistency.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';

class ResinHistoryFilterWidget extends StatefulWidget {
  final ResinRefundFilter filter;
  final ResinParams params;
  final VoidCallback onSearch;
  ResinHistoryFilterWidget({
    Key? key,
    required this.filter,
    required this.params,
    required this.onSearch,
  }) : super(key: key);

  @override
  State<ResinHistoryFilterWidget> createState() =>
      _ResinHistoryFilterWidgetState();
}

class _ResinHistoryFilterWidgetState extends State<ResinHistoryFilterWidget> {
  ThemeData themeDark = LelloTheme.dark;
  List<String> status = [];
  List<String> inconsistency = [];
  TextEditingController protocolController = TextEditingController();

  var dateInit;
  var dateLast;
  late final ResinRefundFilter _filter;

  @override
  void initState() {
    super.initState();
    protocolController.text = widget.filter.protocol ?? '';
    _filter = ResinRefundFilterModel.fromEntity(widget.filter).toEntity();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    status = [
      getString(context, "sended"),
      getString(context, "processed"),
      getString(context, "paid"),
      getString(context, "inconsistency"),
      getString(context, "canceled"),
      getString(context, "closing"),
    ];
    inconsistency = [
      getString(context, "resin_inconsistency_registration"),
      getString(context, "resin_inconsistency_payment"),
      getString(context, "resin_inconsistency_document_illegible"),
      getString(context, "resin_inconsistency_duplicity"),
      getString(context, "resin_inconsistency_value_above_limit"),
    ];
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
                            _datePicker(context),
                            SizedBox(height: Dimens.spacingMedium),
                            _blockProtocol(),
                            SizedBox(height: Dimens.spacingMedium),
                            _blockStatus(),
                            SizedBox(height: Dimens.spacingMedium),
                            _blocInconsistence(),
                            SizedBox(height: Dimens.spacingMedium),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Container(
                                height: 54.0,
                                child: Center(
                                  child: Text(
                                    getString(context, 'find'),
                                    style: LelloTextStyles.button(themeDark)!
                                        .copyWith(
                                            color:
                                                LelloTheme.palleteOf(themeDark)
                                                    .button()),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.filter.protocol =
                                      protocolController.text;
                                });
                                Navigator.pop(context);
                                widget.onSearch();
                              },
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimens.spacingMedium),
                              width: double.infinity,
                              child: PrimaryButton(
                                  buttonColor: Colors.white,
                                  text: 'Limpar filtros',
                                  onPressed: () {
                                    clearFilter();
                                  }),
                            ),
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
      protocolController.text = '';
      widget.filter.protocol = null;
      widget.filter.status = null;
      widget.filter.inconsistency = null;
      widget.filter.startDate = widget.params.filterStartDate;
      widget.filter.endDate = widget.params.filterEndDate;
    });
  }

  backFilter() {
    setState(() {
      protocolController.text = '';
      widget.filter.protocol = _filter.protocol;
      widget.filter.status = _filter.status;
      widget.filter.inconsistency = _filter.inconsistency;
      widget.filter.startDate = _filter.startDate;
      widget.filter.endDate = _filter.endDate;
    });
  }

  Column _blocInconsistence() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getString(context, "inconsistency"),
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
              value: enumToStringInconsistency(widget.filter.inconsistency),
              items: inconsistency.map((String dropDownStringItem) {
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
                  widget.filter.inconsistency =
                      stringToEnumInconsistency(value as String);
                });
              }),
        ),
      ],
    );
  }

  Column _blockStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getString(context, "gdp_status", defaultText: "Status"),
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
                  widget.filter.status = stringToEnumStatus(value as String);
                });
              }),
        ),
      ],
    );
  }

  Column _blockProtocol() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getString(context, "protocol_number"),
            style: LelloTextStyles.bodyBold(themeDark)),
        SizedBox(height: Dimens.spacingSmall),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(color: themeDark.hintColor),
          ),
          child: Theme(
            data: Theme.of(context),
            child: PrimaryTextFormField(
                controller: protocolController,
                onChanged: (value) {},
                textInputType: TextInputType.number,
                action: TextInputAction.done,
                hint: "-"),
          ),
        ),
      ],
    );
  }

  Row _datePicker(BuildContext context) {
    return Row(
      children: [
        Expanded(
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
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: widget.filter.endDate ?? DateTime.now());
                if (selected != null) {
                  setState(() {
                    widget.filter.startDate = selected;
                  });
                }
              }),
        ),
        SizedBox(width: Dimens.spacing),
        Expanded(
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
                  firstDate: widget.filter.startDate ??
                      DateTime.now().subtract(Duration(days: 365)),
                  lastDate: DateTime.now());
              if (selected != null) {
                setState(() {
                  widget.filter.endDate = selected;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  ResinRefundStatus stringToEnumStatus(String? value) {
    if (value == getString(context, "sended")) {
      return ResinRefundStatus.sended;
    } else if (value == getString(context, "processed")) {
      return ResinRefundStatus.processed;
    } else if (value == getString(context, "paid")) {
      return ResinRefundStatus.paid;
    } else if (value == getString(context, "inconsistency")) {
      return ResinRefundStatus.inconsistency;
    } else if (value == getString(context, "canceled")) {
      return ResinRefundStatus.canceled;
    } else {
      return ResinRefundStatus.closing;
    }
  }

  String? enumToStringStatus(ResinRefundStatus? status) {
    if (status == ResinRefundStatus.sended) {
      return getString(context, "sended");
    } else if (status == ResinRefundStatus.processed) {
      return getString(context, "processed");
    } else if (status == ResinRefundStatus.paid) {
      return getString(context, "paid");
    } else if (status == ResinRefundStatus.inconsistency) {
      return getString(context, "inconsistency");
    } else if (status == ResinRefundStatus.canceled) {
      return getString(context, "canceled");
    } else if (status == ResinRefundStatus.closing) {
      return getString(context, "closing");
    } else {
      return null;
    }
  }

  ResinRefundInconcistency stringToEnumInconsistency(String? value) {
    if (value == getString(context, "resin_inconsistency_registration")) {
      return ResinRefundInconcistency.registration;
    } else if (value == getString(context, "resin_inconsistency_payment")) {
      return ResinRefundInconcistency.payment;
    } else if (value ==
        getString(context, "resin_inconsistency_document_illegible")) {
      return ResinRefundInconcistency.documentIllegible;
    } else if (value == getString(context, "resin_inconsistency_duplicity")) {
      return ResinRefundInconcistency.duplicity;
    } else {
      return ResinRefundInconcistency.valueAboveLimit;
    }
  }

  String? enumToStringInconsistency(ResinRefundInconcistency? status) {
    if (status == ResinRefundInconcistency.registration) {
      return getString(context, "resin_inconsistency_registration");
    } else if (status == ResinRefundInconcistency.payment) {
      return getString(context, "resin_inconsistency_payment");
    } else if (status == ResinRefundInconcistency.documentIllegible) {
      return getString(context, "resin_inconsistency_document_illegible");
    } else if (status == ResinRefundInconcistency.duplicity) {
      return getString(context, "resin_inconsistency_duplicity");
    } else if (status == ResinRefundInconcistency.valueAboveLimit) {
      return getString(context, "resin_inconsistency_value_above_limit");
    } else {
      return null;
    }
  }
}
