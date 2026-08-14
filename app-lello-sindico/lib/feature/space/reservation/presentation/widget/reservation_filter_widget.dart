import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_filter.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_filter/reservation_filter_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_filter/reservation_filter_state.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ReservationFilterWidget extends StatefulWidget {
  final VoidCallback? onClose;
  final void Function(ReservationFilter)? onApply;
  final ReservationFilter entity;

  const ReservationFilterWidget(
      {Key? key, this.onClose, required this.entity, this.onApply})
      : super(key: key);

  @override
  _ReservationFilterWidgetState createState() =>
      _ReservationFilterWidgetState();
}

class _ReservationFilterWidgetState extends State<ReservationFilterWidget> {
  final Validator validator = ApplicationContainer.instance().resolve();
  final _formKey = GlobalKey<FormState>();
  String? error;
  final dateFormat = DateFormat.yMd();
  final ReservationFilterBloc bloc = ApplicationContainer.instance().resolve();

  TextEditingController fromDateController = TextEditingController(text: '');
  TextEditingController toDateController = TextEditingController(text: '');
  TextEditingController expirationFromDateController =
      TextEditingController(text: '');
  TextEditingController expirationToDateController =
      TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.dark;
    validator.context = context;

    if (widget.entity.from != null) {
      fromDateController.text = dateFormat.format(widget.entity.from!);
    }
    if (widget.entity.to != null) {
      toDateController.text = dateFormat.format(widget.entity.to!);
    }
    if (widget.entity.expirationFrom != null) {
      expirationFromDateController.text =
          dateFormat.format(widget.entity.expirationFrom!);
    }
    if (widget.entity.expirationTo != null) {
      expirationToDateController.text =
          dateFormat.format(widget.entity.expirationTo!);
    }
    return Theme(
      data: theme,
      child: Container(
        padding: EdgeInsets.all(Dimens.spacing),
        color: theme.colorScheme.surface,
        child: Column(children: [
          SingleChildScrollView(
            child: _buildContent(theme),
          )
        ]),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return BlocBuilder<ReservationFilterBloc, ReservationFilterState>(
      bloc: bloc,
      builder: (context, state) => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(getString(context, "space_reservation_reservation"),
                style: LelloTextStyles.bodyBold(theme)),
            SizedBox(height: Dimens.spacing),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(getString(context, "from"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacing),
                      PrimaryTextFormField(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final date = await datePicker(
                              context,
                              selectedDate: widget.entity.from,
                              lastDate: widget.entity.to,
                            );
                            setState(() {
                              widget.entity.from = date;
                              fromDateController.text = dateFormat.format(date);
                            });
                          },
                          controller: fromDateController,
                          onSaved: (value) =>
                              widget.entity.from = _parseDate(value),
                          onFieldSubmitted: (_) => _nextFocus(),
                          textInputType: TextInputType.number,
                          formatter: fullDateFormatter(),
                          hint: "00/00/0000")
                    ],
                  ),
                ),
                SizedBox(width: Dimens.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(getString(context, "to"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacing),
                      PrimaryTextFormField(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final date = await datePicker(
                              context,
                              selectedDate: widget.entity.to,
                              firstDate: widget.entity.from,
                            );
                            setState(() {
                              widget.entity.to = date;
                              toDateController.text = dateFormat.format(date);
                            });
                          },
                          controller: toDateController,
                          onSaved: (value) =>
                              widget.entity.to = _parseDate(value),
                          onFieldSubmitted: (_) => _nextFocus(),
                          textInputType: TextInputType.number,
                          formatter: fullDateFormatter(),
                          hint: "00/00/0000")
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(getString(context, "space_reservation_expiration"),
                style: LelloTextStyles.bodyBold(theme)),
            SizedBox(height: Dimens.spacing),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(getString(context, "from"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacing),
                      PrimaryTextFormField(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final date = await datePicker(context,
                                selectedDate: widget.entity.expirationFrom);
                            setState(() {
                              widget.entity.expirationFrom = date;
                              expirationFromDateController.text =
                                  dateFormat.format(date);
                            });
                          },
                          controller: expirationFromDateController,
                          onSaved: (value) =>
                              widget.entity.expirationFrom = _parseDate(value),
                          onFieldSubmitted: (_) => _nextFocus(),
                          textInputType: TextInputType.number,
                          formatter: fullDateFormatter(),
                          hint: "00/00/0000")
                    ],
                  ),
                ),
                SizedBox(width: Dimens.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(getString(context, "to"),
                          style: LelloTextStyles.bodyBold(theme)),
                      SizedBox(height: Dimens.spacing),
                      PrimaryTextFormField(
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final date = await datePicker(context,
                                selectedDate: widget.entity.expirationTo);
                            setState(() {
                              widget.entity.expirationTo = date;
                              expirationToDateController.text =
                                  dateFormat.format(date);
                            });
                          },
                          controller: expirationToDateController,
                          onSaved: (value) =>
                              widget.entity.expirationTo = _parseDate(value),
                          onFieldSubmitted: (_) => _nextFocus(),
                          textInputType: TextInputType.number,
                          formatter: fullDateFormatter(),
                          hint: "00/00/0000")
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(getString(context, "space_reservation_area"),
                style: LelloTextStyles.bodyBold(theme)),
            SizedBox(height: Dimens.spacing),
            state is ReservationFilterLoadingState
                ? const Center(child: LoadingWidget())
                : DropdownButtonFormField(
                    onSaved: (value) =>
                        widget.entity.spaceId = value as String?,
                    value: widget.entity.spaceId,
                    items: [
                      DropdownMenuItem<String>(
                          value: null,
                          child: Text(getString(
                              context, "payment_filter_entry_source_all"))),
                      ...state.spaces
                          .map((e) => DropdownMenuItem(
                              value: e.id, child: Text(e.name!)))
                          .toList()
                    ],
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
            SizedBox(height: Dimens.spacingMedium),
            Text(getString(context, "units_unit"),
                style: LelloTextStyles.bodyBold(theme)),
            SizedBox(height: Dimens.spacing),
            state is ReservationFilterLoadingState
                ? const Center(child: LoadingWidget())
                : DropdownButtonFormField(
                    onSaved: (value) => widget.entity.unitId = value as String?,
                    value: widget.entity.unitId,
                    items: [
                      DropdownMenuItem<String>(
                          value: null,
                          child: Text(getString(
                              context, "payment_filter_entry_source_all"))),
                      ...state.units
                          .map((e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(
                                  "${getString(context, "units_unit")} ${e.title}")))
                          .toList()
                    ],
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
            SizedBox(height: Dimens.spacingMedium),
            Text(getString(context, "space_reservation_status"),
                style: LelloTextStyles.bodyBold(theme)),
            SizedBox(height: Dimens.spacing),
            PrimaryTextFormField(
                initialValue: widget.entity.spaceId ?? "-",
                onSaved: (value) => widget.entity.spaceId = value,
                onFieldSubmitted: (_) => _nextFocus(),
                textInputType: TextInputType.number,
                formatter: fullDateFormatter(),
                hint: "-"),
            SizedBox(height: Dimens.spacing),
            Visibility(
              visible: error?.isNotEmpty == true,
              child: Text(
                error ?? "",
                style: LelloTextStyles.error(theme),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: Dimens.spacing),
            PrimaryButton(
              text: getString(context, "find"),
              onPressed: () {
                _submit();
              },
            ),
            SizedBox(height: Dimens.spacingLarge),
          ],
        ),
      ),
    );
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return dateFormat.parse(value);
  }

  void _nextFocus() {
    FocusScope.of(context).nextFocus();
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        error = null;
      });
      if (widget.onApply != null) {
        widget.onApply!(widget.entity);
      }
    } else {
      setState(() {
        error = getString(context, "filter_validation_error");
      });
    }
  }
}
