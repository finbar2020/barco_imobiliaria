import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class VacationTextFieldSchudele extends StatelessWidget {
  final date;
  final text;
  const VacationTextFieldSchudele(
      {Key? key, required this.date, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          getString(context, text),
          style: LelloTextStyles.caption(theme)!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Dimens.spacingSmall),
        IgnorePointer(
          ignoring: true,
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: LelloTheme.palleteOf(theme).text()),
              hintText: date,
              suffixIcon: Icon(
                Icons.calendar_today,
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
