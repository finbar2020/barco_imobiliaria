import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/resident/controller/residents_controller.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';
import 'package:lello/feature/vox/presentation/request/widget/vox_recipient_units.dart';

/// Lista os destinatários já selecionados (fora do botão, que só dispara a
/// seleção/edição). Unidades exibem os moradores; blocos exibem só o rótulo.
/// Escuta o `residentsBloc` para preencher os moradores assim que o cache do
/// `ResidentsController` carregar.
class VoxSelectedRecipients extends StatefulWidget {
  final RecipientType mode;
  final Map<String, String> recipientListMap;

  /// Singular (advertência/multa, uma unidade) vs plural (comunicado).
  final bool single;

  const VoxSelectedRecipients({
    Key? key,
    required this.mode,
    required this.recipientListMap,
    required this.single,
  }) : super(key: key);

  @override
  State<VoxSelectedRecipients> createState() => _VoxSelectedRecipientsState();
}

class _VoxSelectedRecipientsState extends State<VoxSelectedRecipients> {
  final ResidentsController _controller =
      ApplicationContainer.instance().resolve<ResidentsController>();

  @override
  void initState() {
    super.initState();
    // Blocos exibem só o rótulo (a chave); não precisam carregar moradores.
    if (widget.mode != RecipientType.block) {
      _controller.getResidents(hasLoadAll: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.recipientListMap.isEmpty) return const SizedBox.shrink();
    return BlocBuilder(
      bloc: _controller.residentsBloc,
      builder: (context, _) => Padding(
        padding: EdgeInsets.only(top: Dimens.spacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.single
                  ? "Destinatário selecionado"
                  : "Destinatários selecionados",
              style: LelloTextStyles.caption(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).grey(),
              ),
            ),
            ..._tiles(theme),
          ],
        ),
      ),
    );
  }

  List<Widget> _tiles(ThemeData theme) {
    final map = widget.recipientListMap;
    if (widget.mode == RecipientType.block) {
      // Chave = nome do bloco (o valor agora guarda o id que vai no fio).
      return map.keys.map((label) => _tile(theme, label, null)).toList();
    }
    final units = {for (final u in voxGroupUnits(_controller)) u.key: u};
    return map.entries.map((entry) {
      final unit = units[entry.key];
      final label = unit?.label ?? entry.value;
      final residents = (unit != null && unit.residents.isNotEmpty)
          ? unit.residentsText
          : null;
      return _tile(theme, label, residents);
    }).toList();
  }

  Widget _tile(ThemeData theme, String label, String? residents) {
    return Container(
      margin: EdgeInsets.only(top: Dimens.spacingSmall),
      padding: EdgeInsets.all(Dimens.spacing),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: LelloTextStyles.bodyBold(theme)),
          if (residents != null) ...[
            SizedBox(height: Dimens.spacingSmall),
            Text(residents, style: LelloTextStyles.body(theme)),
          ],
        ],
      ),
    );
  }
}
