import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_on_boarding_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AccessControlOnBoardingWidget extends StatefulWidget {
  final bool isGeneric;
  final AccessControlStore store;
  AccessControlOnBoardingWidget({
    Key? key,
    required this.store,
    required this.isGeneric,
  }) : super(key: key);

  @override
  State<AccessControlOnBoardingWidget> createState() =>
      _AccessControlOnBoardingWidgetState();
}

class _AccessControlOnBoardingWidgetState
    extends State<AccessControlOnBoardingWidget> {
  final int _numPages = 3;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _currentPage = _pageController.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    SessionBloc sessionBloc = BlocProvider.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            0, Dimens.spacingXLarge, 0, Dimens.spacingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: CustomScrollView(slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimens.spacingMedium),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: widget.isGeneric
                              ? CachedNetworkImage(
                                  height: 50.0,
                                  width: 50.0,
                                  imageUrl: sessionBloc.state.session
                                          ?.condominium?.layout?.logoPath ??
                                      "",
                                  placeholder: (context, url) => Center(
                                      child: Padding(
                                    padding:
                                        EdgeInsets.all(Dimens.spacingSmall),
                                    child: const CircularProgressIndicator(),
                                  )),
                                  errorWidget: (context, url, error) =>
                                      SvgPicture.asset(
                                    "assets/custom_image_network_placeholder.svg",
                                  ),
                                )
                              : Image.asset(
                                  "assets/img_logo_lello.png",
                                  height: 35.0,
                                ),
                        ),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
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
                            AccessControlOnBoardingPage(
                              assetPath: "assets/access_onboarding_1.svg",
                              title: "access_control_onboarding_title_1",
                              subtitle: "access_control_onboarding_subtitle_1",
                              currentPage: 0,
                            ),
                            AccessControlOnBoardingPage(
                              assetPath: "assets/access_onboarding_2.svg",
                              title: "access_control_onboarding_title_2",
                              subtitle: "access_control_onboarding_subtitle_2",
                              currentPage: 1,
                            ),
                            AccessControlOnBoardingPage(
                              assetPath: "assets/access_onboarding_3.svg",
                              title: "access_control_onboarding_title_3",
                              subtitle: "access_control_onboarding_subtitle_3",
                              currentPage: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
              child: _buildButton(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(ThemeData theme) {
    return _currentPage != _numPages - 1
        ? Column(
            children: [
              SecondaryButton(
                buttonBorderColor: theme.primaryColor,
                onPressed: () {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                text: getString(context, "next"),
              ),
              SizedBox(height: Dimens.spacing),
              TertiaryButton(
                onPressed: () {
                  widget.store.getLists(closeOnboarding: true);
                },
                text: getString(context, "access_control_exit_onboarding"),
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: theme.primaryColor),
              )
            ],
          )
        : _buildButtons(theme);
  }

  Widget _buildButtons(ThemeData theme) {
    return Column(
      children: [
        PrimaryButton(
          onPressed: () {
            widget.store.getLists(closeOnboarding: true);
          },
          text: getString(context, "login"),
        ),
        SizedBox(height: Dimens.spacing),
        TertiaryButton(
          onPressed: () {
            widget.store.getLists(closeOnboarding: true);
          },
          text: getString(context, "access_control_close_onboarding"),
          style: LelloTextStyles.button(theme)!
              .copyWith(color: theme.primaryColor),
        )
      ],
    );
  }
}
