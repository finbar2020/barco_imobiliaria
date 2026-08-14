import 'package:essentials/essentials.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageViewIndicator extends StatefulWidget {
  final int itemCount;
  final ValueNotifier<int> pageNotifier;

  PageViewIndicator(
      {Key? key, required this.itemCount, required this.pageNotifier})
      : super(key: key);

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
  final theme = LelloTheme.light;

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
    return Container(
        width: _itemSize,
        height: _itemSize,
        margin: EdgeInsets.fromLTRB(_horizontalMargin, 0, _horizontalMargin, 0),
        decoration: BoxDecoration(
            color: index == _selectedPage
                ? LelloTheme.palleteOf(theme).customColor()
                : LelloTheme.palleteOf(theme).customColor().withAlpha(120),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(_itemSize / 2.0))));
  }
}
