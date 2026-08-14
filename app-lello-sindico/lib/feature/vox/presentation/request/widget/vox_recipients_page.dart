import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/condominium/domain/entity/block_simple.dart';
import 'package:lello/feature/condominium/domain/use_case/get_simple_condominium/get_simple_condominium.dart';
import 'package:lello/feature/resident/bloc/residents_state.dart';
import 'package:lello/feature/resident/controller/residents_controller.dart';
import 'package:lello/feature/vox/domain/entity/recipient_type.dart';
import 'package:lello/feature/vox/presentation/request/widget/vox_recipient_units.dart';
import 'package:lello/feature/vox/presentation/widget/vox_error_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

/// Tela dedicada de seleção de destinatários, com busca.
///  - [RecipientType.block]: um item por bloco.
///  - [RecipientType.units]: um item por unidade; os moradores aparecem como
///    detalhe (subtitle) do item, não como subitens. A seleção é por unidade.
///
/// Mutaciona [recipientListMap] in place (chave = identificador, valor = rótulo)
/// e confirma no pop. Filtro local sobre os dados já carregados (cache do
/// `ResidentsController`, lazySingleton).
class VoxRecipientsPage extends StatefulWidget {
  final RecipientType mode;
  final Map<String, String> recipientListMap;

  /// Seleção única (radio) em vez de múltipla (checkbox). Advertência/multa são
  /// sempre para uma única unidade.
  final bool singleSelection;

  /// Guarda o id da unidade como valor (criação direta, que vai no fio) em vez
  /// do rótulo (solicitação, que leva texto descritivo).
  final bool useUnitId;

  const VoxRecipientsPage({
    Key? key,
    required this.mode,
    required this.recipientListMap,
    this.singleSelection = false,
    this.useUnitId = false,
  }) : super(key: key);

  @override
  State<VoxRecipientsPage> createState() => _VoxRecipientsPageState();
}

class _VoxRecipientsPageState extends State<VoxRecipientsPage> {
  final ResidentsController _controller =
      ApplicationContainer.instance().resolve<ResidentsController>();
  final GetSimpleCondominiumUsecase _getBlocks =
      ApplicationContainer.instance().resolve<GetSimpleCondominiumUsecase>();
  String _query = "";

  /// Blocos (com id criptografado) carregados sob demanda no modo bloco.
  List<BlockSimple>? _blocks;
  Failure? _blocksError;

  @override
  void initState() {
    super.initState();
    if (widget.mode == RecipientType.block) {
      _loadBlocks();
    } else {
      _controller.getResidents(hasLoadAll: true);
    }
  }

  Future<void> _loadBlocks() async {
    setState(() {
      _blocks = null;
      _blocksError = null;
    });
    final condominiumId =
        _controller.sessionBloc.state.session?.selectedCondominium?.id ?? "";
    final result =
        await _getBlocks(GetSimpleCondominiumParams(id: condominiumId));
    if (!mounted) return;
    result.fold(
      (err) => setState(() => _blocksError = err),
      (data) => setState(() => _blocks = data?.blocks ?? []),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PrimaryAppBar(
        title: widget.mode == RecipientType.block ? "Blocos" : "Unidades",
        theme: theme,
        iconColor: theme.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Dimens.spacing),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                hintText: widget.mode == RecipientType.block
                    ? "Buscar bloco"
                    : "Buscar unidade ou morador",
              ),
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          Expanded(
            child: widget.mode == RecipientType.block
                ? _blockSection(theme)
                : BlocBuilder(
                    bloc: _controller.residentsBloc,
                    builder: (context, state) {
                      // Falha sem dados em cache: mostra erro com "tentar
                      // novamente" em vez de ficar preso no loading.
                      if (state is ResidentsLoadFailedState &&
                          _controller.residents.isEmpty) {
                        return VoxErrorWidget(
                          error: state.failure,
                          onRetry: () =>
                              _controller.getResidents(hasLoadAll: true),
                          onBack: () => Navigator.of(context).pop(),
                          showBackButton: false,
                        );
                      }
                      return _unitList(theme);
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(Dimens.spacing),
              child: SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: "Confirmar",
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blockSection(ThemeData theme) {
    if (_blocksError != null) {
      return VoxErrorWidget(
        error: _blocksError,
        onRetry: _loadBlocks,
        onBack: () => Navigator.of(context).pop(),
        showBackButton: false,
      );
    }
    if (_blocks == null) return const Center(child: LoadingWidget());
    return _blockList(theme);
  }

  Widget _blockList(ThemeData theme) {
    final blocks = _blocks!.where((b) => _matches(b.name)).toList();
    return _emptyOr(blocks.length, (index) {
      final block = blocks[index];
      // Chave = nome (exibição / rótulo no resumo); valor = id do bloco
      // (criptografado), que é o que trafega no fio (`recipient_list`).
      return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: theme.primaryColor,
        value: widget.recipientListMap.containsKey(block.name),
        title: Text(block.name, style: LelloTextStyles.body(theme)),
        onChanged: (value) => _toggle(block.name, block.id, value),
      );
    });
  }

  Widget _unitList(ThemeData theme) {
    final all = voxGroupUnits(_controller);
    if (all.isEmpty) return const Center(child: LoadingWidget());
    final units = all
        .where((u) => _matches(u.label) || _matches(u.residentsText))
        .toList();
    return _emptyOr(units.length, (index) {
      final unit = units[index];
      final selected = widget.recipientListMap.containsKey(unit.key);
      // Criação: guarda o id (vai no fio). Solicitação: guarda o rótulo.
      final unitValue = widget.useUnitId ? (unit.id ?? '') : unit.label;
      return InkWell(
        onTap: () => _toggle(
            unit.key, unitValue, widget.singleSelection ? true : !selected),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.spacing, vertical: Dimens.spacingSmall),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.singleSelection)
                Radio<String>(
                  activeColor: theme.primaryColor,
                  value: unit.key,
                  groupValue: _selectedKey,
                  onChanged: (value) => _toggle(unit.key, unitValue, true),
                )
              else
                Checkbox(
                  activeColor: theme.primaryColor,
                  value: selected,
                  onChanged: (value) => _toggle(unit.key, unitValue, value),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Dimens.spacingSmall),
                    Text(unit.label, style: LelloTextStyles.bodyBold(theme)),
                    if (unit.residents.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: Dimens.spacingSmall),
                        child: Text(unit.residentsText,
                            style: LelloTextStyles.body(theme)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _emptyOr(int count, Widget Function(int index) builder) {
    if (count == 0) {
      return Center(
        child: Text("Nada encontrado",
            style: LelloTextStyles.body(Theme.of(context))),
      );
    }
    return ListView.builder(
        itemCount: count, itemBuilder: (_, i) => builder(i));
  }

  bool _matches(String value) =>
      _query.isEmpty || value.toLowerCase().contains(_query.toLowerCase());

  void _toggle(String key, String label, bool? value) {
    setState(() {
      if (value == true) {
        // Seleção única: substitui o destinatário anterior.
        if (widget.singleSelection) widget.recipientListMap.clear();
        widget.recipientListMap[key] = label;
      } else {
        widget.recipientListMap.remove(key);
      }
    });
  }

  String? get _selectedKey => widget.recipientListMap.keys.isEmpty
      ? null
      : widget.recipientListMap.keys.first;
}
