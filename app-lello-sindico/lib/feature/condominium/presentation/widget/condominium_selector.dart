import 'package:essentials/essentials.dart' hide BlendMode;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';

class CondominiumSelector extends StatefulWidget {
  final List<Condominium> condominiums;
  final Condominium? selected;
  final List<int> referencesFilter;
  final Function(Condominium)? onSelect;
  final bool showSearch;
  final bool lightStyle;

  const CondominiumSelector({
    super.key,
    required this.condominiums,
    required this.selected,
    this.onSelect,
    this.referencesFilter = const [],
    this.showSearch = true,
    this.lightStyle = false,
  });

  @override
  _CondominiumSelectorState createState() => _CondominiumSelectorState();
}

class _CondominiumSelectorState extends State<CondominiumSelector> {
  String filter = '';

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      children: [
        if (widget.showSearch) _buildSearch(theme),
        Expanded(
          child: buildListView(theme),
        ),
      ],
    );
  }

  Widget _buildSearch(ThemeData theme) {
    ColorPallete pallete = LelloTheme.palleteOf(theme);
    return Container(
      color: pallete.appBarHome(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacing,
          vertical: Dimens.spacing,
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  filter = value;
                });
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Busque pelo nome do condomínio',
                hintStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.white54, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.white54, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: SvgPicture.asset(
                  "assets/ic_search.svg",
                  height: 16,
                  fit: BoxFit.scaleDown,
                  colorFilter: ColorFilter.mode(
                    pallete.primary(),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildListView(ThemeData theme) {
    final pallete = LelloTheme.palleteOf(theme);
    List<Condominium> list = widget.condominiums;
    List<Condominium> subList = list.toSet().toList();

    List<Condominium> filteredList = filter.isEmpty
        ? subList
        : subList
            .where((condo) =>
                condo.name!.toLowerCase().contains(filter.toLowerCase()))
            .toList();

    if (widget.referencesFilter.isNotEmpty) {
      filteredList = filteredList
          .where(
            (condo) => widget.referencesFilter.contains(
              int.parse(condo.reference),
            ),
          )
          .toList();
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: filteredList.isEmpty ? 1 : filteredList.length,
      itemBuilder: (context, index) {
        if (filteredList.isEmpty) {
          return Container(
            color: widget.lightStyle ? Colors.white : pallete.appBarHome(),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Center(
              child: Text(
                'Você não possui nenhum prédio com esse nome',
                style: TextStyle(
                  color: widget.lightStyle ? pallete.text() : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return _buildItem(filteredList[index], theme);
      },
    );
  }

  Widget _buildItem(Condominium condo, ThemeData theme) {
    ColorPallete pallete = LelloTheme.palleteOf(theme);
    final titleColor = widget.lightStyle ? pallete.text() : pallete.buttonText();
    final subtitleColor = widget.lightStyle
        ? pallete.text().withAlpha(170)
        : pallete.buttonText();
    final titleText = widget.lightStyle
        ? '${condo.reference} ${(condo.name ?? '').toUpperCase()}'
        : '${condo.name}';
    final subtitleText = widget.lightStyle
        ? (condo.address ?? '').toUpperCase()
        : '${condo.address ?? ""}${condo.number == null ? "" : "-"}${condo.number ?? ""}';

    return Container(
      color: widget.lightStyle ? Colors.white : pallete.appBarHome(),
      child: ListTile(
        tileColor: widget.lightStyle ? Colors.white : pallete.appBarHome(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        minVerticalPadding: 4,
        onTap: () {
          if (widget.onSelect != null) {
            widget.onSelect!(condo);
          }
        },
        title: Text(
          titleText,
          style: LelloTextStyles.subtitleBold(theme)!.copyWith(
            color: titleColor,
            fontSize: widget.lightStyle ? 16 : null,
          ),
        ),
        subtitle: Text(
          subtitleText,
          style: LelloTextStyles.caption(theme)!.copyWith(
            color: subtitleColor,
            fontSize: widget.lightStyle ? 13 : null,
          ),
        ),
        trailing: _buildBullet(condo, theme),
      ),
    );
  }

  Widget _buildBullet(Condominium condo, ThemeData theme) {
    ColorPallete pallete = LelloTheme.palleteOf(theme);
    if (condo.id == widget.selected?.id) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: widget.lightStyle ? pallete.primary() : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.lightStyle ? pallete.primary() : Colors.white,
          ),
        ),
        child: Center(
            child: Icon(
          Icons.check,
          size: 20.0,
          color: widget.lightStyle ? Colors.white : pallete.primary(),
        )),
      );
    } else {
      return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.lightStyle ? pallete.primary() : Colors.white,
              width: widget.lightStyle ? 2 : 1,
            ),
          ));
    }
  }
}
