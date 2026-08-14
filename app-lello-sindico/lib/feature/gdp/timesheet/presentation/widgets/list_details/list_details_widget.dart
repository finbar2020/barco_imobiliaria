import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_details_list/timesheet_details_list_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/detail_list_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_detail_list_failed_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_detail_list_success_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_details_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_details_dropdown.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_vacations_card.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ListDetailsWidget extends StatefulWidget {
  final ListDetailsController controller;
  final DateTime date;
  final TimesheetOccurrenceTypeEnum type;
  const ListDetailsWidget({
    super.key,
    required this.date,
    required this.controller,
    required this.type,
  });

  @override
  State<ListDetailsWidget> createState() => _ListDetailsWidgetState();
}

class _ListDetailsWidgetState extends State<ListDetailsWidget> {
  bool selectAll = false;

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool isDelayOrFoul = widget.type == TimesheetOccurrenceTypeEnum.delay ||
        widget.type == TimesheetOccurrenceTypeEnum.fouls;
    bool isExtraHour = widget.type == TimesheetOccurrenceTypeEnum.extraHour;
    return BlocConsumer(
      bloc: widget.controller.bloc,
      listener: (context, state) {
        if (state is TimesheetDetailsListLoadedState && state.saveSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimesheetDetailListSuccessPage(),
            ),
          );
        } else if (state is TimesheetDetailsListLoadedState &&
            state.saveFailed) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimesheetDetailListFailedPage(),
            ),
          );
        } else if (state is TimesheetVacationsLoadedState &&
            state.pdf != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(
                pdfFile: state.pdf,
                title: 'Recibo de Férias',
                canDownload: true,
                fileName: state.filename,
              ),
            ),
          );
        } else if (state is TimesheetVacationsLoadedState &&
            state.getArchiveFailed) {
          Flushbar(
            message:
                "Ocorreu um erro ao buscar o recibo. Tente novamente mais tarde",
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      },
      builder: (context, state) {
        if (state is TimesheetDetailsListLoadingState) {
          return const Expanded(child: Center(child: LoadingWidget()));
        } else if (state is TimesheetDetailsListLoadedState ||
            state is TimesheetVacationsLoadedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {});
          return Expanded(
            child: DismissKeyboard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDelayOrFoul &&
                      state is TimesheetDetailsListLoadedState &&
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
                                              selectedValue = null;
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
                                : InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectAll = true;
                                        widget.controller.employesSelecteds =
                                            List.generate(state.list.length,
                                                (index) => true);
                                        widget.controller.individualAction =
                                            List.generate(state.list.length,
                                                (index) => '');
                                      });
                                    },
                                    child: Text(
                                        getString(context,
                                            "gdp_timesheet_detail_select"),
                                        style: LelloTextStyles.subBody(theme)!
                                            .copyWith(
                                          color: theme.primaryColor,
                                        )),
                                  ),
                            if (selectAll)
                              ListDetailsDropdown(
                                width: selectedValue != null ? 145.0 : 170.0,
                                hintText: getString(context,
                                    "gdp_timesheet_detail_mass_action"),
                                selectedValue: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                              ),
                          ],
                        ),
                        SizedBox(height: Dimens.spacing),
                      ],
                    ),
                  if (state is TimesheetDetailsListLoadedState)
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
                                      (index) => ListDetailsCard(
                                        type: widget.type,
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
                  if (state is TimesheetVacationsLoadedState)
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
                                      (index) => ListVacationCard(
                                        entity: state.list[index],
                                        onTap: () {
                                          widget.controller
                                              .getVacationDetailReceipt(state
                                                  .list[index].archiveName);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimens.spacingSmall),
                      if (isExtraHour)
                        InkWell(
                          onTap: () {
                            launchUrl(Uri.parse(
                                "https://portal.lellocondominios.com.br/menuPortal2/"));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Precisa de ajuda com alguma informação?",
                                  style: LelloTextStyles.subBody(theme)!
                                      .copyWith(fontWeight: FontWeight.bold)),
                              Text("Peça para gente!",
                                  style: LelloTextStyles.subBody(theme)!
                                      .copyWith(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      if (!isDelayOrFoul) SizedBox(height: Dimens.spacing),
                      if (!isDelayOrFoul)
                        PrimaryButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: getString(context, "back")),
                      if (!isDelayOrFoul) SizedBox(height: Dimens.spacing),
                      if (isDelayOrFoul)
                        PrimaryButton(
                            onPressed: () {
                              if (selectedValue != null && selectAll) {
                                widget.controller.saveControlOccurrence(
                                    massActionValue: selectedValue);
                              } else if (widget.controller.individualAction
                                  .where((element) => element.isNotEmpty)
                                  .toList()
                                  .isNotEmpty) {
                                widget.controller.saveControlOccurrence();
                              } else {
                                Flushbar(
                                  message: getString(context,
                                      "gdp_timesheet_detail_flush_message"),
                                  duration: const Duration(seconds: 4),
                                ).show(context);
                              }
                            },
                            text: getString(context, "save")),
                      if (isDelayOrFoul) SizedBox(height: Dimens.spacing),
                      if (isDelayOrFoul)
                        SecondaryButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: getString(context, "cancel")),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is TimesheetDetailsListFailedState) {
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
