import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_summary_list_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';

class ReservationSummaryFilterWidget extends StatefulWidget {
  final VoidCallback? onClose;
  final void Function(ReservationSummaryListFilter)? onApply;
  final ReservationSummaryListFilter entity;

  const ReservationSummaryFilterWidget(
      {Key? key, this.onClose, required this.entity, this.onApply})
      : super(key: key);

  @override
  _ReservationSummaryFilterWidgetState createState() =>
      _ReservationSummaryFilterWidgetState();
}

class _ReservationSummaryFilterWidgetState
    extends State<ReservationSummaryFilterWidget> {
  final _formKey = GlobalKey<FormState>();
  String? error;
  final dateFormat = DateFormat.yMd();

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.dark;
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(getString(context, "space_reservation_category"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacing),
          DropdownButtonFormField(
            onSaved: (value) => widget.entity.type = value as ReservationType?,
            value: widget.entity.type,
            items: [
              DropdownMenuItem<String>(
                  value: null,
                  child: Text(getString(context, "space_reservation_all"))),
//							DropdownMenuItem(child: Text(getString(context, "space_reservation_raffle")), value: ReservationType.raffle), // TODO: Return this for raffle - app v2
              DropdownMenuItem(
                  value: ReservationType.maintenance,
                  child: Text(
                      getString(context, "space_reservation_maintenance"))),
              DropdownMenuItem(
                  value: ReservationType.reservation,
                  child: Text(
                      getString(context, "space_reservation_reservation"))),
            ],
            onChanged: (value) {},
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
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
    );
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
