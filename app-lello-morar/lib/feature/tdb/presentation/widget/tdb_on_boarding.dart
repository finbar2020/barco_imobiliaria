import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/tdb/presentation/widget/tdb_on_boarding_page.dart';

class TdbOnBoardingWidget extends StatefulWidget {
  final VoidCallback onTapRegisterButton;
  final bool initLastPage;

  TdbOnBoardingWidget({
    Key? key,
    required this.onTapRegisterButton,
    this.initLastPage = false,
  }) : super(key: key);

  @override
  State<TdbOnBoardingWidget> createState() => _TdbOnBoardingWidgetState();
}

class _TdbOnBoardingWidgetState extends State<TdbOnBoardingWidget> {
  final int _numPages = 4;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.initLastPage ? _numPages - 1 : 0);
    _currentPage = _pageController.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(Dimens.spacingMedium, Dimens.spacingXLarge,
          Dimens.spacingMedium, Dimens.spacingMedium),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _skipButton(context),
                    SizedBox(height: Dimens.spacingLarge),
                    Container(
                      height: 500.0,
                      child: PageView(
                        controller: _pageController,
                        physics: ClampingScrollPhysics(),
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: <Widget>[
                          TdbOnBoardingPage(
                              assetPath: "assets/tdb_on_boarding_1.svg",
                              description: "tdb_on_boarding_1_description"),
                          TdbOnBoardingPage(
                              assetPath: "assets/tdb_on_boarding_2.svg",
                              description: "tdb_on_boarding_2_description"),
                          TdbOnBoardingPage(
                              assetPath: "assets/tdb_on_boarding_3.svg",
                              description: "tdb_on_boarding_3_description"),
                          TdbOnBoardingPage(
                              assetPath: "assets/tdb_on_boarding_4.svg",
                              description: "tdb_on_boarding_4_description"),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(theme),
                    ),
                  ],
                ),
              )
            ]),
          ),
          SizedBox(height: Dimens.spacingMedium),
          _buildButton(theme),
        ],
      ),
    );
  }

  Container _skipButton(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          _pageController.jumpToPage(_numPages - 1);
        },
        child: Text(
          (_currentPage != _numPages - 1) ? getString(context, "tdb_skip") : "",
          style: LelloTextStyles.subtitleBold(theme)
              ?.copyWith(color: LelloTheme.palleteOf(theme).grey()),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator(ThemeData theme) {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage
          ? _indicator(theme, true)
          : _indicator(theme, false));
    }
    return list;
  }

  Widget _indicator(ThemeData theme, bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: Dimens.spacingSmall),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive
            ? theme.primaryColor
            : LelloTheme.palleteOf(theme).separator(),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }

  Widget _buildButton(ThemeData theme) {
    return _currentPage != _numPages - 1
        ? SecondaryButton(
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
            text: getString(context, "tdb_next"),
          )
        : _buildButtons(theme);
  }

  Widget _buildButtons(ThemeData theme) {
    return Column(
      children: [
        PrimaryButton(
          onPressed: () {
            widget.onTapRegisterButton();
          },
          buttonColor: Colors.purple,
          text: getString(context, "tdb_sign_up"),
        ),
        SizedBox(height: Dimens.spacing),
        TertiaryButton(
          onPressed: () {
            Navigator.pop(context);
          },
          text: getString(context, "tdb_not_now"),
          style: LelloTextStyles.button(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).hubText()),
        )
      ],
    );
  } //
  //
}
