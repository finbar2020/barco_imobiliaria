import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_ocurrence_entity.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_occurrence/timesheet_occurrence_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_occurrence_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_detail_list_failed_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_detail_list_success_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/occurrences/timesheet_occurrence_card.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class TimesheetOccurrenceWidget extends StatefulWidget {
  final TimesheetOccurrenceController controller;
  final DateTime date;
  final String? selectedValue;
  final bool selectAll;
  const TimesheetOccurrenceWidget({
    super.key,
    required this.date,
    required this.controller,
    required this.selectAll,
    this.selectedValue,
  });

  @override
  State<TimesheetOccurrenceWidget> createState() =>
      _TimesheetOccurrenceWidgetState();
}

class _TimesheetOccurrenceWidgetState extends State<TimesheetOccurrenceWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocConsumer(
      bloc: widget.controller.bloc,
      listener: (context, state) {
        if (state is TimesheetOccurrenceLoadedState && state.saveSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimesheetDetailListSuccessPage(),
            ),
          );
        } else if (state is TimesheetOccurrenceLoadedState &&
            state.saveFailed) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimesheetDetailListFailedPage(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is TimesheetOccurrenceLoadingState) {
          return const Expanded(child: Center(child: LoadingWidget()));
        } else if (state is TimesheetOccurrenceLoadedState) {
          var list = widget.controller.individualAction
              .where((element) => element.isNotEmpty)
              .toList();
          return Expanded(
            child: DismissKeyboard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: state.list.isEmpty
                        ? Center(
                            child: Text(
                                getString(
                                    context, "gdp_timesheet_occurrence_failed"),
                                style: LelloTextStyles.subBody(theme)))
                        : Scrollbar(
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ...List.generate(
                                    state.list.length,
                                    (index) => TimesheetOccurrenceCard(
                                      entity: state.list[index],
                                      massAction: widget.selectAll,
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
                                      indexCheckBox: widget
                                          .controller.employesSelecteds[index],
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimens.spacing),
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
                                style: LelloTextStyles.subBody(theme)!.copyWith(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      SizedBox(height: Dimens.spacing),
                      PrimaryButton(
                          onPressed:
                              widget.selectedValue == null && list.isEmpty
                                  ? null
                                  : () {
                                      buttonAction(
                                          theme, widget.controller, state.list);
                                    },
                          text: getString(context, "save")),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is TimesheetOccurrenceFailedState) {
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

  buttonAction(ThemeData theme, TimesheetOccurrenceController controller,
      List<TimesheetOccurrenceEntity> list) {
    if (widget.selectedValue != null && widget.selectAll) {
      if (widget.selectedValue!.contains("Inserir")) {
        Modal.showBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => TimesheetOccurrenceBottomSheet(
                  controller: controller,
                  list: list,
                ));
      } else {
        widget.controller
            .saveControlOccurrence(massActionValue: widget.selectedValue);
      }
    } else if (widget.controller.individualAction
        .where((element) => element.isNotEmpty)
        .toList()
        .isNotEmpty) {
      widget.controller.saveControlOccurrence();
    } else {
      Flushbar(
        message: getString(context, "gdp_timesheet_detail_flush_message"),
        duration: const Duration(seconds: 4),
        flushbarPosition: FlushbarPosition.BOTTOM,
      ).show(context);
    }
  }
}

class TimesheetOccurrenceBottomSheet extends StatefulWidget {
  final TimesheetOccurrenceController controller;
  final List<TimesheetOccurrenceEntity> list;
  const TimesheetOccurrenceBottomSheet({
    required this.controller,
    required this.list,
    super.key,
  });

  @override
  State<TimesheetOccurrenceBottomSheet> createState() =>
      _TimesheetOccurrenceBottomSheetState();
}

class _TimesheetOccurrenceBottomSheetState
    extends State<TimesheetOccurrenceBottomSheet> {
  String selectedValue = 'Esquecimento';
  List<String> items = ["Esquecimento", "Falha"];
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.keyboard_arrow_down_rounded,
                      size: 40.0,
                      color: LelloTheme.palleteOf(theme).textLight()),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Inserir horário padrão",
                  style: LelloTextStyles.titleSmallBold(theme),
                ),
                SizedBox(height: Dimens.spacing),
                Text(
                  "Você está inserindo horário padrão para mais de um funcionário.",
                  style: LelloTextStyles.subtitle(theme),
                ),
                SizedBox(height: Dimens.spacing),
                Text(
                  "Qual justificativa deseja adicionar?",
                  style: LelloTextStyles.subtitle(theme),
                ),
                SizedBox(height: Dimens.spacingMedium),
                Row(
                  children: [
                    Icon(Icons.notes_outlined),
                    SizedBox(width: Dimens.spacing),
                    Text(
                      "Justificativa",
                      style: LelloTextStyles.subtitle(theme),
                    ),
                  ],
                ),
                SizedBox(height: Dimens.spacingMedium),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    alignment: AlignmentDirectional.centerEnd,
                    items: items
                        .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: LelloTextStyles.subtitle(theme)!
                                    .copyWith(color: Colors.black),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value!;
                      });
                    },
                    iconStyleData: IconStyleData(
                        icon: Icon(Icons.keyboard_arrow_down_outlined)),
                    buttonStyleData: ButtonStyleData(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 60,
                    ),
                  ),
                ),
                SizedBox(height: Dimens.spacingMedium),
                PrimaryButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.controller
                          .saveDefaultHour(selectedValue, widget.list);
                    },
                    text: getString(context, "save")),
                SizedBox(height: Dimens.spacing),
                SecondaryButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: getString(context, "cancel")),
                SizedBox(height: Dimens.spacing),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
