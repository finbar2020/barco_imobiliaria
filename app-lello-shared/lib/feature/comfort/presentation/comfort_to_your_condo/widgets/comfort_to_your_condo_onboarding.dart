import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/widgets/comfort_to_your_condo_onboarding_widget.dart';
import 'package:shared_features/shared_features.dart';

class ComfortToYourCondoOnboarding extends StatefulWidget {
  final ComfortPartnersController comfortPartnersController;
  final bool fromIcon;
  final SharedApplicationContainer appContainer;
  final AppOriginEnum appOriginEnum;
  final String reference;
  final String? unit;
  ComfortToYourCondoOnboarding({
    Key? key,
    this.fromIcon = false,
    required this.comfortPartnersController,
    required this.appContainer,
    required this.appOriginEnum,
    required this.reference,
    this.unit,
  }) : super(key: key);

  @override
  State<ComfortToYourCondoOnboarding> createState() =>
      _ComfortToYourCondoOnboardingState();
}

class _ComfortToYourCondoOnboardingState
    extends State<ComfortToYourCondoOnboarding> {
  final int _numPages = 2;
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

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            0, Dimens.spacingXLarge, 0, Dimens.spacingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: PageView(
                controller: _pageController,
                physics: ClampingScrollPhysics(),
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: <Widget>[
                  ComfortToYourCondoOnboardingWidet(
                    numPages: _numPages,
                    appContainer: widget.appContainer,
                    fromIcon: widget.fromIcon,
                    comfortPartnersController: widget.comfortPartnersController,
                    assetPath: "assets/img_comfort_to_you_onboarding1.svg",
                    title: "Produtos e serviços para o seu condomínio",
                    subtitle: RichText(
                      text: TextSpan(
                        style: LelloTextStyles.subtitle(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).text()),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                'Aqui você encontra produtos e serviços para ',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: 'facilitar o dia a dia da sua gestão',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text:
                                ' e melhorar a experiência do viver em seu condomínio.',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    currentPage: 0,
                    appOriginEnum: widget.appOriginEnum,
                    reference: widget.reference,
                    unit: widget.unit,
                  ),
                  ComfortToYourCondoOnboardingWidet(
                    numPages: _numPages,
                    appContainer: widget.appContainer,
                    fromIcon: widget.fromIcon,
                    comfortPartnersController: widget.comfortPartnersController,
                    assetPath: "assets/img_comfort_to_you_onboarding2.svg",
                    title: "O que precisar, te ajudamos a encontrar",
                    subtitle: RichText(
                      text: new TextSpan(
                        style: LelloTextStyles.subtitle(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).text()),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                'Minimercado, adega, lavanderia, prestadores de serviço e especialistas em reforma, decoração e práticas sustentáveis. Conheça essas e outras soluções com ',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: 'condições exclusivas!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    currentPage: 1,
                    appOriginEnum: widget.appOriginEnum,
                    reference: widget.reference,
                    unit: widget.unit,
                  ),
                ],
              ),
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
        ? SecondaryButton(
            buttonBorderColor: theme.primaryColor,
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
            text: getString(context, "announcements_request_action_title"),
          )
        : PrimaryButton(
            onPressed: () {
              widget.fromIcon
                  ? Navigator.pop(context)
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ToYourCondoPage(
                          comfortPartnersController:
                              widget.comfortPartnersController,
                          appContainer: widget.appContainer,
                          appOriginEnum: widget.appOriginEnum,
                          reference: widget.reference,
                          unit: widget.unit,
                        ),
                      ),
                    );
            },
            text: getString(context, "comfort_want_know"),
          );
  }
}
