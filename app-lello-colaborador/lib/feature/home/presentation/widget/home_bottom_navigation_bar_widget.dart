import 'package:colaborador/feature/home/domain/entity/home_navigation_item.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class HomeBottomNavigationBarWidget extends StatelessWidget {
  final Function(int index) changePage;
  final List<HomeNavigationItem> navigationItems;
  final int currentPage;
  const HomeBottomNavigationBarWidget({
    Key? key,
    required this.changePage,
    required this.navigationItems,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (navigationItems.length < 2) return Container();
    return SnakeNavigationBar.color(
      height: 70,
      behaviour: SnakeBarBehaviour.pinned,
      snakeShape: SnakeShape.rectangle,
      snakeViewColor: Colors.transparent,
      selectedItemColor: Colors.white,
      backgroundColor: LelloTheme.palleteOf(theme).backgroundDark(),
      unselectedItemColor: LelloTheme.palleteOf(theme).hubText(),
      showUnselectedLabels: true,
      showSelectedLabels: true,
      currentIndex: getCurrentPage,
      elevation: 0,
      onTap: (index) {
        if (navigationItems[index].activated) {
          changePage(index);
        }
      },
      items: navigationItems
          .map((e) => BottomNavigationBarItem(
                icon: Container(
                  width: 100.0,
                  padding: const EdgeInsets.only(top: 10.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        e.icon,
                        height: 22.0,
                        width: 22.0,
                        color: LelloTheme.palleteOf(theme).hubText(),
                      ),
                      SizedBox(height: Dimens.spacingXSmall),
                      Text(
                        getString(context, e.titleKey),
                        style: TextStyle(
                            color: LelloTheme.palleteOf(theme).hubText()),
                      )
                    ],
                  ),
                ),
                activeIcon: Container(
                  width: 100.0,
                  padding: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                      color: LelloTheme.palleteOf(theme).primary(),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        e.icon,
                        height: 22.0,
                        width: 22.0,
                        color: Colors.white,
                      ),
                      SizedBox(height: Dimens.spacingXSmall),
                      Text(
                        getString(context, e.titleKey),
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ))
          .toList(),
      selectedLabelStyle: const TextStyle(fontSize: 14),
      unselectedLabelStyle: const TextStyle(fontSize: 10),
    );
  }

  int get getCurrentPage => currentPage >= navigationItems.length
      ? navigationItems.length - 1
      : currentPage;
}
