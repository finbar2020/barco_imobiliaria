import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../change_ownership/presentation/widget/change_ownership_generic_input.dart';

class NoExpirationDateDialog extends StatefulWidget {
  const NoExpirationDateDialog({
    required this.onApproveAccess,
    Key? key,
  }) : super(key: key);

  final ValueSetter<DateTime> onApproveAccess;

  @override
  State<NoExpirationDateDialog> createState() => _NoExpirationDateDialogState();
}

class _NoExpirationDateDialogState extends State<NoExpirationDateDialog> {
  DateTime? _selectedDate;
  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Não identificamos uma data de expiração',
              textAlign: TextAlign.center,
              style: LelloTextStyles.headline(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).primary()),
            ),
            const SizedBox(height: 16),
            Text(
              'Escolha uma data de expiração para aprovar o acesso.',
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitleBold(theme),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final date = await datePicker(
                  context,
                  selectedDate: _selectedDate,
                  firstDate: DateTime.now(),
                );
                if (date.isAfter(DateTime.now())) {
                  setState(() {
                    _selectedDate = date;
                    _dateController.text = DateFormat('dd/MM/yyyy').format(date);
                  });
                }
              },
              child: AbsorbPointer(
                child: ChangeOwnershipGenericInput(
                  isRequired: true,
                  selectTypePerson: '',
                  controller: _dateController,
                  title: 'Data de expiração de acesso',
                  hint: 'Selecione',
                  formatter: [fullDateFormatter()],
                  keyboardType: TextInputType.numberWithOptions(),
                  validator: null,
                  selectDate: () async {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Essa data é importante para determinar o tempo de acesso do inquilino ou imobiliária',
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitleBold(theme),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Aprovar acesso',
              onPressed: _selectedDate != null ? () {
                Navigator.of(context).pop();
                widget.onApproveAccess(_selectedDate!);
              } : null,
            ),
            const SizedBox(height: 16),
            SecondaryButton(
              text: 'Não, quero voltar',
              buttonBorderColor: LelloTheme.palleteOf(theme).primary(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}
