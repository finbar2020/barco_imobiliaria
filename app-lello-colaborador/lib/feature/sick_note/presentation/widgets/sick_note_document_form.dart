import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:essentials/essentials.dart' hide Animation;
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/dependency/application_container.dart';

class SickNoteDocumentForm extends StatefulWidget {
  final Function() sendSickNoteFunction;
  final maxFileSizePermitted;
  final SickNoteEntity sickNote;
  const SickNoteDocumentForm(
      {Key? key,
      required this.sendSickNoteFunction,
      required this.sickNote,
      required this.maxFileSizePermitted})
      : super(key: key);

  @override
  State<SickNoteDocumentForm> createState() => _SickNoteDocumentFormState();
}

class _SickNoteDocumentFormState extends State<SickNoteDocumentForm>
    with TickerProviderStateMixin {
  List<int> days = [];
  late AnimationController animation;

  @override
  void initState() {
    super.initState();
    days = List<int>.generate(365, (i) => i + 9 + 1);
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
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(getString(context, "sick_note_subtitle"),
              textAlign: TextAlign.start,
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              )),
          SizedBox(height: Dimens.spacingMedium),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 230.0),
            child: TextFormField(
              autofocus: false,
              keyboardType: TextInputType.datetime,
              validator: (valid) {
                if (widget.sickNote.date == null) {
                  return getString(context, "validation_required");
                }
                return null;
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: widget.sickNote.date != null
                    ? DateFormat("dd/MM/yyyy").format(widget.sickNote.date!)
                    : getString(context, "sick_note_document_date"),
                hintStyle: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
                suffixIcon: const Icon(
                  Icons.calendar_today,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: LelloTheme.palleteOf(theme).grey()),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: LelloTheme.palleteOf(theme).primary(), width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.sickNote.date ?? DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 730)),
                    lastDate: DateTime.now());
                setState(() {
                  if (selectedDate != null) {
                    widget.sickNote.date = selectedDate;
                  }
                });
              },
            ),
          ),
          SizedBox(height: Dimens.spacingSmall),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(getString(context, "sick_note_days"),
                textAlign: TextAlign.start,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                )),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: const BorderSide(width: 0.5),
            value: widget.sickNote.isChecked,
            activeColor: LelloTheme.palleteOf(theme).primary(),
            onChanged: (bool? value) {
              setState(() {
                widget.sickNote.isChecked = value!;
                if (!widget.sickNote.isChecked) {
                  widget.sickNote.sickNoteDays = null;
                }
              });
            },
          ),
          if (widget.sickNote.isChecked)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimens.spacingSmall),
                FadeTransition(
                  opacity: animation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150.0),
                    child: DropdownButtonFormField<int>(
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                        hint:
                            Text(getString(context, "sick_note_how_many_days")),
                        value: widget.sickNote.sickNoteDays,
                        items: days.map((int days) {
                          return DropdownMenuItem<int>(
                            value: days,
                            child: Text(days.toString()),
                          );
                        }).toList(),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        onChanged: (value) {
                          setState(() {
                            widget.sickNote.sickNoteDays = value;
                          });
                        }),
                  ),
                ),
              ],
            ),
          widget.sickNote.isChecked
              ? SizedBox(height: Dimens.spacingMedium)
              : SizedBox(height: Dimens.spacingXLarge),
          Expanded(
            child: Column(
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            AttachFilesBottomSheet.show(
                              appContainer: ApplicationContainer.instance(),
                              showAttachment: false,
                              context: context,
                              aspectRatioPresets: [
                                CropAspectRatioPreset.original
                              ],
                              maxFileSizePermitted: widget.maxFileSizePermitted,
                            ).then((filesList) {
                              setState(() {
                                if (filesList.isNotEmpty) {
                                  widget.sickNote.file = filesList.first;
                                }
                              });
                            });
                          },
                          child: Center(
                            child: widget.sickNote.file == null
                                ? SvgPicture.asset(
                                    "assets/image_selector_sick_note.svg",
                                    height: 240.0,
                                    width: double.infinity)
                                : FileIcon(
                                    file: widget.sickNote.file!,
                                    deleteFile: () => setState(() {
                                      widget.sickNote.file = null;
                                    }),
                                    imageIconSize: 240.0,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimens.spacing),
          _buildButtons(context)
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Dimens.spacingMedium),
      child: Column(
        children: [
          PrimaryButton(
            onPressed: widget.sickNote.isValid && widget.sickNote.isDaysChecked
                ? () {
                    if (widget.sickNote.isValid &&
                        widget.sickNote.isDaysChecked) {
                      widget.sendSickNoteFunction();
                    }
                  }
                : null,
            text: getString(
                context,
                widget.sickNote.file != null
                    ? "sick_note_send"
                    : "sick_note_add"),
          ),
        ],
      ),
    );
  }

  void _showSnackBar() {
    String text = getString(context, "sick_note_send");
    if (text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
      ));
    }
  }
}
