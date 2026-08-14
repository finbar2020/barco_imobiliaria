import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';

class ChangeOwnershipDocumentInput extends StatefulWidget {
  final TextEditingController documentController;
  final String? selectType;
  final List<String> types;
  final Function(String)? onChanged;
  final bool isIndividuals;
  const ChangeOwnershipDocumentInput({
    required this.documentController,
    required this.selectType,
    required this.types,
    required this.onChanged,
    required this.isIndividuals,
    super.key,
  });

  @override
  State<ChangeOwnershipDocumentInput> createState() =>
      _ChangeOwnershipDocumentInputState();
}

class _ChangeOwnershipDocumentInputState
    extends State<ChangeOwnershipDocumentInput> {
  final _validator = ApplicationContainer.instance().resolve<Validator>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    return IgnorePointer(
      ignoring: _choicePersonType(),
      child: Opacity(
        opacity: _choicePersonType() ? 0.3 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _choicePersonType()
                  ? "${getString(context, "change_ownership_cpf_or_cnpj")}*"
                  : widget.isIndividuals
                      ? "${getString(context, "cpf")}*"
                      : "${getString(context, "cnpj")}*",
              style: LelloTextStyles.bodyBold(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            TextFormField(
              controller: widget.documentController,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.numberWithOptions(),
              onChanged: widget.onChanged,
              inputFormatters:
                  widget.isIndividuals ? [cpfFormatter()] : [cnpjFormatter()],
              validator: widget.isIndividuals
                  ? _validator.validateCPF
                  : _validator.validateCNPJ,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: _choicePersonType()
                    ? ""
                    : widget.isIndividuals
                        ? "000.000.000-00"
                        : "00.000.000/0000-00",
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _choicePersonType() {
    return widget.selectType == null;
  }
}
