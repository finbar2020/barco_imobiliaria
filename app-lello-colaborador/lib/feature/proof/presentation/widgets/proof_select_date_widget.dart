import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ProofSelectDateWidget extends StatefulWidget {
  final Function(DateTime date) onTap;
  final TextEditingController controller;
  const ProofSelectDateWidget({
    Key? key,
    required this.onTap,
    required this.controller,
  }) : super(key: key);

  @override
  State<ProofSelectDateWidget> createState() => _ProofSelectDateWidgetState();
}

class _ProofSelectDateWidgetState extends State<ProofSelectDateWidget> {
  DateTime initialDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(getString(context, "proof_page_subtitle"),
            textAlign: TextAlign.start,
            style: LelloTextStyles.subtitle(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            )),
        SizedBox(height: Dimens.spacingMedium),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 230.0),
          child: TextFormField(
            controller: widget.controller,
            autofocus: false,
            keyboardType: TextInputType.datetime,
            readOnly: true,
            decoration: InputDecoration(
              hintStyle: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).hubText(),
              ),
              suffixIcon: const Icon(
                Icons.calendar_today,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
            onTap: () {
              showDatePicker(
                      context: context,
                      initialDate: initialDate,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now())
                  .then((value) {
                if (value != null) {
                  setState(() {
                    initialDate = value;
                    widget.onTap(value);
                  });
                }
              });
            },
          ),
        ),
      ],
    );
  }
}
