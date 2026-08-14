import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/dependency/application_container.dart';

class ManualTimeSheetWidget extends StatefulWidget {
  final Function() sendManualTimeSheetFunction;
  final List<DateTime> availableDates;
  final maxFileSizePermitted;
  final ManualTimeSheetEntity manualTimeSheet;
  const ManualTimeSheetWidget(
      {Key? key,
      required this.sendManualTimeSheetFunction,
      required this.manualTimeSheet,
      required this.maxFileSizePermitted,
      required this.availableDates})
      : super(key: key);

  @override
  State<ManualTimeSheetWidget> createState() => _ManualTimeSheetWidgetState();
}

class _ManualTimeSheetWidgetState extends State<ManualTimeSheetWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(getString(context, "manual_timesheet_subtitle"),
              textAlign: TextAlign.start,
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              )),
          SizedBox(height: Dimens.spacingMedium),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 230.0),
            child: DropdownButtonFormField<DateTime>(
              items: _getDropdownItems(widget.availableDates),
              hint: Text(getString(context, "manual_timesheet_document_date")),
              onChanged: (DateTime? value) {
                widget.manualTimeSheet.date = value;
              },
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              value: widget.manualTimeSheet.date,
              icon: const Icon(Icons.keyboard_arrow_down),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: Dimens.spacingLarge),
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
                              context: context,
                              aspectRatioPresets: [
                                CropAspectRatioPreset.original
                              ],
                              maxFileSizePermitted: widget.maxFileSizePermitted,
                            ).then((filesList) {
                              setState(() {
                                if (filesList.isNotEmpty) {
                                  widget.manualTimeSheet.file = filesList.first;
                                }
                              });
                            });
                          },
                          child: Center(
                            child: widget.manualTimeSheet.file == null
                                ? SvgPicture.asset("assets/image_selector.svg",
                                    height: 240.0, width: double.infinity)
                                : FileIcon(
                                    file: widget.manualTimeSheet.file!,
                                    deleteFile: () => setState(() {
                                      widget.manualTimeSheet.file = null;
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
            onPressed: widget.manualTimeSheet.isValid
                ? () {
                    if (widget.manualTimeSheet.isValid) {
                      widget.sendManualTimeSheetFunction();
                    }
                  }
                : null,
            text: getString(
                context,
                widget.manualTimeSheet.file != null
                    ? "manual_timesheet_send"
                    : "manual_timesheet_add"),
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<DateTime>> _getDropdownItems(List<DateTime> dates) {
    List<DropdownMenuItem<DateTime>> list = dates
        .map(
          (date) => DropdownMenuItem<DateTime>(
            value: date,
            child: Text(
              _formatDate(date),
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1,
            ),
          ),
        )
        .toList();
    return list;
  }

  String _formatDate(DateTime date) {
    DateFormat dateFormat = DateFormat("MMMM");
    String upperCase = dateFormat.format(date).substring(0, 1).toUpperCase();
    String lowerCase = dateFormat.format(date).substring(1).toLowerCase();
    return "$upperCase$lowerCase";
  }
}
