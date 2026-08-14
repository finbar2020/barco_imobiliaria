import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class PageViewIndicator extends StatefulWidget {
  final int itemCount;
  final ValueNotifier<int> pageNotifier;
  final bool isGeneric;

  PageViewIndicator({
    Key? key,
    required this.itemCount,
    required this.pageNotifier,
    this.isGeneric = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _PageViewIndicatorState(itemCount, pageNotifier);
}

class _PageViewIndicatorState extends State<PageViewIndicator>
    with SingleTickerProviderStateMixin {
  final int itemCount;
  final double _itemSize = 8;
  final double _horizontalMargin = Dimens.spacingSmall;
  final ValueNotifier<int> pageNotifier;

  int _selectedPage = 0;

  void _selectPage(int page) {
    setState(() {
      _selectedPage = page;
    });
  }

  _PageViewIndicatorState(this.itemCount, this.pageNotifier) {
    this.pageNotifier.addListener(() {
      _selectPage(this.pageNotifier.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: Iterable.generate(itemCount)
            .map((index) => _buildBullet(index))
            .toList());
  }

  Widget _buildBullet(int index) {
    final theme = Theme.of(context);
    return Container(
        width: _itemSize,
        height: _itemSize,
        margin: EdgeInsets.fromLTRB(_horizontalMargin, 0, _horizontalMargin, 0),
        decoration: BoxDecoration(
            color: index == _selectedPage
                ? widget.isGeneric
                    ? theme.colorScheme.shadow
                    : theme.scaffoldBackgroundColor
                : widget.isGeneric
                    ? theme.colorScheme.outline
                    : theme.scaffoldBackgroundColor.withAlpha(120),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(_itemSize / 2.0))));
  }
}
