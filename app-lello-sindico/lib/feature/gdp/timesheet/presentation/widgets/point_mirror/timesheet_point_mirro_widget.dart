import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_details_list/timesheet_details_list_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_point_mirror/timesheet_point_mirror_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_point_mirror_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_point_mirror_success_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_signature_failed_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/point_mirror/timesheet_point_mirror_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/point_mirror/timesheet_point_mirror_dropdown.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class TimesheetPointMirrorWidget extends StatefulWidget {
  final TimesheetPointMirrorController controller;
  final DateTime date;
  const TimesheetPointMirrorWidget({
    super.key,
    required this.date,
    required this.controller,
  });

  @override
  State<TimesheetPointMirrorWidget> createState() =>
      _TimesheetPointMirrorWidgetState();
}

class _TimesheetPointMirrorWidgetState
    extends State<TimesheetPointMirrorWidget> {
  bool selectAll = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocConsumer(
      bloc: widget.controller.bloc,
      listener: (context, state) {
        if (state is TimesheetPointMirrorLoadedState && state.saveSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimesheetPointMirrorSuccessPage(),
            ),
          );
        } else if (state is TimesheetPointMirrorLoadedState &&
            state.saveFailed) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimesheetSignatureFailedPage(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is TimesheetPointMirrorLoadingState) {
          return const Expanded(child: Center(child: LoadingWidget()));
        } else if (state is TimesheetPointMirrorLoadedState ||
            state is TimesheetVacationsLoadedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {});
          return Expanded(
            child: DismissKeyboard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is TimesheetPointMirrorLoadedState &&
                      state.list.isNotEmpty)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            selectAll
                                ? Row(
                                    children: [
                                      Checkbox(
                                          value: selectAll,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          onChanged: (value) {
                                            setState(() {
                                              selectAll = false;
                                              widget.controller.selectedValue =
                                                  null;
                                            });
                                          }),
                                      Text(
                                          getString(context,
                                              "gdp_timesheet_detail_select"),
                                          style: LelloTextStyles.subBody(theme)!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                    ],
                                  )
                                : widget.controller.showMassActionOption
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectAll = true;
                                            widget.controller
                                                    .employesSelecteds =
                                                List.generate(state.list.length,
                                                    (index) => false);
                                            widget.controller.individualAction =
                                                List.generate(state.list.length,
                                                    (index) => '');
                                          });
                                        },
                                        child: Text(
                                            getString(context,
                                                "gdp_timesheet_detail_select"),
                                            style:
                                                LelloTextStyles.subBody(theme)!
                                                    .copyWith(
                                              color: theme.primaryColor,
                                            )),
                                      )
                                    : Container(),
                            if (selectAll)
                              TimesheetPointMirrorDropdown(
                                isNotify:
                                    widget.controller.showNotifyDropdown(),
                                hintText: getString(context,
                                    "gdp_timesheet_detail_mass_action"),
                                selectedValue: widget.controller.selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    widget.controller.selectedValue = value;
                                  });
                                },
                              ),
                          ],
                        ),
                        SizedBox(height: Dimens.spacing),
                      ],
                    ),
                  if (state is TimesheetPointMirrorLoadedState)
                    Expanded(
                      child: state.list.isEmpty
                          ? Center(
                              child: Text(
                                  getString(context,
                                      "gdp_timesheet_mark_day_dont_find"),
                                  style: LelloTextStyles.subBody(theme)))
                          : Scrollbar(
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...List.generate(
                                      state.list.length,
                                      (index) => TimesheetPointMirrorCard(
                                        isNotify: widget.controller
                                            .isNotify(state.list[index].action),
                                        entity: state.list[index],
                                        massAction: selectAll,
                                        selectedValue: widget.controller
                                                .individualAction[index].isEmpty
                                            ? null
                                            : widget.controller
                                                .individualAction[index],
                                        selectIndividualAction: (value) {
                                          setState(() {
                                            widget.controller
                                                    .individualAction[index] =
                                                value ?? "";
                                          });
                                        },
                                        indexCheckBox: widget.controller
                                            .employesSelecteds[index],
                                        selectCheckBox: (value) {
                                          setState(() {
                                            widget.controller
                                                    .employesSelecteds[index] =
                                                !widget.controller
                                                    .employesSelecteds[index];
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                ],
              ),
            ),
          );
        } else if (state is TimesheetPointMirrorFailedState) {
          return Expanded(
            child: Center(
              child: ErrorMessageWidget(
                  message: getString(context, "request_fine_error_message")),
            ),
          );
        }
        return Container();
      },
    );
  }
}
