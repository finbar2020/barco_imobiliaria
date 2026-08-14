import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_route.dart';

class ExpirationDialog extends StatefulWidget {
  const ExpirationDialog({
    required this.onRenewalRequestPressed,
    required this.onChecked,
    required this.isOwner,
    Key? key,
  }) : super(key: key);

  final ValueChanged<bool> onChecked;
  final bool isOwner;
  final VoidCallback onRenewalRequestPressed;

  @override
  State<ExpirationDialog> createState() => _ExpirationDialogState();
}

class _ExpirationDialogState extends State<ExpirationDialog> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: widget.isOwner
                ? SvgPicture.asset('assets/expiration_image.svg')
                : SvgPicture.asset('assets/expiration.svg'),
          ),
          SizedBox(height: Dimens.spacing),
          Flexible(
            child: AutoSizeText(
              widget.isOwner
                  ? 'Atenção:\nacesso prestes a expirar'
                  : 'Seus acessos estão próximos de expirar!',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: LelloTextStyles.title(theme)?.copyWith(fontSize: 25),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Flexible(
            child: AutoSizeText(
              widget.isOwner
                  ? 'Um dos moradores da sua unidade está com o acessos prestes a vencer. Renove antes que ele seja bloqueado'
                  : 'Solicite a renovação do seu período de acesso antes que seja bloqueado ou entre em contato com seu proprietário.',
              textAlign: TextAlign.center,
              maxLines: 3,
              style: LelloTextStyles.bodyBold(theme),
            ),
          ),
          SizedBox(height: Dimens.spacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                  value: isChecked,
                  onChanged: (_) {
                    setState(() {
                      isChecked = !isChecked;
                    });
                    widget.onChecked(isChecked);
                  }),
              Text(
                'Não mostrar isso novamente',
                style: LelloTextStyles.bodyBold(theme),
              ),
            ],
          ),
          SizedBox(height: Dimens.spacing),
          PrimaryButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (widget.isOwner) {
                Navigator.of(context).pushNamed(ApplicationRoute.subUser);
              } else {
                widget.onRenewalRequestPressed();
              }
            },
            text: widget.isOwner ? 'Renovar agora' : 'Solicitar renovação',
          ),
          SizedBox(height: Dimens.spacing),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Fechar',
              style: LelloTextStyles.bodyBold(theme),
            ),
          ),
        ],
      ),
    );
  }
}
