import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_day_quotas_dialog.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_resume_bottom_sheet.dart';

class AgreementPaydayBottomSheet extends StatefulWidget {
  final List<String> days;
  final AgreementCreated agreement;
  final AgreementsBloc bloc;
  const AgreementPaydayBottomSheet({
    Key? key,
    required this.days,
    required this.agreement,
    required this.bloc,
  }) : super(key: key);

  @override
  State<AgreementPaydayBottomSheet> createState() =>
      _AgreementPaydayBottomSheetState();
}

class _AgreementPaydayBottomSheetState
    extends State<AgreementPaydayBottomSheet> {
  List<int> newPaymentDays = [];
  List<int> days = [];
  @override
  void initState() {
    super.initState();
    days = List.generate(
        widget.days.length, (index) => int.parse(widget.days[index]));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                  child: IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                color: LelloTheme.palleteOf(theme).grey(),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
              Text(
                getString(context, "agreements_day_payment_title_sheet"),
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Wrap(
                children: [
                  RichText(
                    text: new TextSpan(
                      style: LelloTextStyles.subtitle(theme),
                      children: <TextSpan>[
                        TextSpan(
                            text: getString(context,
                                "agreements_day_payment_subtitle_sheet"),
                            style: LelloTextStyles.subtitle(theme)),
                        TextSpan(
                            text: getString(context,
                                "agreements_liked_installments_description_complement"),
                            style: LelloTextStyles.subtitle(theme)!
                                .copyWith(color: theme.primaryColor)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.spacingMedium),
              _buildDays(context),
              SizedBox(height: Dimens.spacingMedium),
              IgnorePointer(
                ignoring: newPaymentDays.isEmpty,
                child: Opacity(
                  opacity: newPaymentDays.isEmpty ? 0.3 : 1.0,
                  child: Container(
                    width: double.infinity,
                    height: 52.0,
                    child: PrimaryButton(
                      text: getString(context, "agreements_accept_next"),
                      onPressed: () {
                        widget.agreement.dueDate = newPaymentDays.first;
                        Navigator.pop(context);
                        Modal.showBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => AgreementResumeBottomSheet(
                                  agreement: widget.agreement,
                                  pendingProposal: true,
                                  bloc: widget.bloc,
                                ));
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDays(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        _buildDaysRow(min: 1),
        _buildDaysRow(min: 8),
        _buildDaysRow(min: 15),
        _buildDaysRow(min: 22),
        _buildDaysRow(min: 29)
      ]),
    );
  }

  Row _buildDaysRow({required int min}) {
    int max = min + 6;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        max - min + 1,
        (index) {
          int day = min + index;

          return InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: days.contains(day)
                ? () {}
                : () {
                    setState(() {
                      newPaymentDays = [];
                      newPaymentDays = [day];
                    });
                    if (day == 29 || day == 30 || day == 31) {
                      showDialog(
                        context: context,
                        builder: (context) => AgreementDayQuotasDialog(),
                      );
                    }
                  },
            child: day <= 31
                ? Padding(
                    padding: EdgeInsets.only(bottom: Dimens.spacingSmall),
                    child: Container(
                      padding: EdgeInsets.all(Dimens.spacingSmall),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        color: _setBackgroundDayColor(day),
                      ),
                      width: 40.0,
                      height: 40.0,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Center(
                          child: Text(
                            day.toString(),
                            style: _setTextDayStyle(day),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: 40.0,
                    height: 40.0,
                  ),
          );
        },
      ),
    );
  }

  Color? _setBackgroundDayColor(int day) {
    ThemeData theme = Theme.of(context);
    if (days.contains(day)) {
      return LelloTheme.palleteOf(theme).textLightest();
    }

    return newPaymentDays.contains(day) ? theme.primaryColor : null;
  }

  TextStyle _setTextDayStyle(int day) {
    ThemeData theme = Theme.of(context);

    return newPaymentDays.contains(day)
        ? LelloTextStyles.body(theme)!.copyWith(color: Colors.white)
        : LelloTextStyles.body(theme)!
            .copyWith(color: LelloTheme.palleteOf(theme).text());
  }
}
