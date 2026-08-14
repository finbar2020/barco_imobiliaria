import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/accountability/domain/entity/accountability.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_question_type_solicitation.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_details_page.dart';
import 'package:lello/feature/accountability/presentation/question_create/widget/question_create_attach_files_widget.dart';
import 'package:lello/feature/accountability/presentation/question_create/widget/question_create_list_widget.dart';

import '../../../../../core/dependency/application_container.dart';
import '../controller/question_create_controller.dart';

class QuestionCreateFormWidget extends StatefulWidget {
  final AccountabilityDoubt accountabilityDoubt;
  final List<AccountabilityQuestionType> types;

  final Accountability accountability;
  final Function() onChanged;

  const QuestionCreateFormWidget({
    Key? key,
    required this.accountabilityDoubt,
    required this.types,
    required this.accountability,
    required this.onChanged,
  }) : super(key: key);

  @override
  _QuestionCreateStateWidget createState() => _QuestionCreateStateWidget();
}

class _QuestionCreateStateWidget extends State<QuestionCreateFormWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final NumberFormat currencyFormat = NumberFormat.currency(symbol: "R\$");
    final controller =
        ApplicationContainer.instance().resolve<QuestionCreateController>();
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(getString(context, "accounttability_question_related_subject"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacingXSmall),
          DropdownButtonFormField(
            isExpanded: true,
            validator: (value) {
              if (value == null) {
                return getString(context, "validation_required");
              }
              return null;
            },
            hint: Text(getString(context, 'gdp_quick_fix_select'),
                style: LelloTextStyles.body(theme),
                overflow: TextOverflow.ellipsis),
            value: widget.accountabilityDoubt.doubtType?.id,
            items: widget.types
                .map(
                  (e) => DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(
                () {
                  widget.accountabilityDoubt.doubtType = widget.types
                      .cast<AccountabilityQuestionType?>()
                      .firstWhere(
                        (element) => element?.id == value,
                        orElse: () => null,
                      );
                  for (var element in widget.accountability.groupedEntries) {
                    for (var element in element.accounts) {
                      for (var element in element.entries) {
                        element.checked = false;
                      }
                    }
                  }
                  controller.doubtSelected = widget.accountabilityDoubt;
                  controller.doubtSelected?.noEnterieSelected = false;
                  controller.doubtSelected?.entiries = [];
                  formKey.currentState?.validate();
                },
              );
            },
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          SizedBox(height: Dimens.spacingMedium),
          if (widget.accountabilityDoubt.doubtType != null)
            FormField(
              validator: (value) {
                if (widget.accountabilityDoubt.noEnterieSelected == false &&
                    widget.accountabilityDoubt.entiries.isEmpty) {
                  return getString(context, "validation_required");
                }
                return null;
              },
              builder: (FormFieldState state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DottedBorder(
                      options: RectDottedBorderOptions(
                        strokeWidth: 1,
                        dashPattern: const [3.0, 3.0],
                        color: LelloTheme.palleteOf(theme).secondary(),
                      ),
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            _showModalQuestionCreateList();
                          },
                          child: Container(
                            padding: EdgeInsets.all(Dimens.spacing),
                            alignment: Alignment.center,
                            child: Text(
                                getString(context,
                                    "accounttability_question_select_release"),
                                style: LelloTextStyles.bodyBold(theme)),
                          ),
                        ),
                      ),
                    ),
                    state.hasError
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              state.errorText ?? "",
                              textAlign: TextAlign.left,
                              style: LelloTextStyles.error(theme)?.copyWith(
                                  fontSize: 12, color: const Color(0xFFd32f2f)),
                            ),
                          )
                        : Container()
                  ],
                );
              },
            ),
          SizedBox(height: Dimens.spacingMedium),
          if (widget.accountabilityDoubt.doubtType?.idRequestPpc != null)
            Builder(
              builder: (context) {
                List<AccountabilityGroupedAccaountEntrie> lista = [];
                final groupedEntries = widget.accountability.groupedEntries
                    .cast<AccountabilityGrouped?>()
                    .firstWhere(
                      (element) =>
                          element?.id ==
                          widget.accountabilityDoubt.doubtType?.idRequestPpc,
                      orElse: () => null,
                    );
                if (groupedEntries == null) {
                  return const SizedBox.shrink();
                }

                for (var acc in groupedEntries.accounts) {
                  for (var ent in acc.entries) {
                    if (ent.checked) lista.add(ent);
                  }
                }

                widget.accountabilityDoubt.entiries = lista;

                if (lista.isEmpty == true) return const SizedBox.shrink();

                return Column(
                  children: List.generate(
                    lista.length,
                    (index) {
                      final ThemeData theme = Theme.of(context);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: LelloTheme.palleteOf(theme).greyCard(),
                            child: Row(
                              children: [
                                SizedBox(width: Dimens.spacingSmall),
                                Expanded(
                                  child: Text(
                                      "${currencyFormat.format(lista[index].value)} - ${lista[index].history}",
                                      style: LelloTextStyles.bodyBold(theme),
                                      textAlign: TextAlign.left),
                                ),
                                Card(
                                  color: theme.primaryColor,
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      icon: SvgPicture.asset(
                                        "assets/ic_close.svg",
                                        width: 3,
                                        height: 12,
                                      ),
                                      onPressed: () {
                                        lista[index].checked = false;
                                        controller.doubtSelected =
                                            widget.accountabilityDoubt;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            getString(context, "question_text_field_riquered"),
            style: LelloTextStyles.bodyBold(theme),
          ),
          SizedBox(height: Dimens.spacingXSmall),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return getString(context, "validation_required");
              }
              return null;
            },
            initialValue: widget.accountabilityDoubt.message,
            onChanged: (val) {
              widget.accountabilityDoubt.message = val;
            },
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: Dimens.spacing),
          QuestionCreateAttachFilesWidget(),
          SizedBox(height: Dimens.spacingMedium),
          PrimaryButton(
            text: getString(context, "next"),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pushNamed(
                  ApplicationRoute.accountabilityDoubtSummaryPage,
                  arguments: QuestionCreateDetailsPageArg(
                    doubt: widget.accountabilityDoubt,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showModalQuestionCreateList() async {
    final group = widget.accountability.groupedEntries
        .cast<AccountabilityGrouped?>()
        .firstWhere(
          (element) =>
              element?.id == widget.accountabilityDoubt.doubtType!.idRequestPpc,
          orElse: () => null,
        );

    if (widget.accountabilityDoubt.doubtType == null) {
      Flushbar(
        message: getString(
            context, 'accounttability_question_not_selected_menssage'),
        isDismissible: true,
        duration: const Duration(seconds: 5),
        onTap: (flush) {
          flush.dismiss();
        },
      ).show(context);

      return;
    }
    Modal.showBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: QuestionCreateListWidget(
          accountability: group,
          onChanged: widget.onChanged,
          doubt: widget.accountabilityDoubt,
        ),
      ),
    );
  }
}
