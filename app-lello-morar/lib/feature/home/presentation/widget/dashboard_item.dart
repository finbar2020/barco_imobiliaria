import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/dialogs/redirection_whatsapp_dialog.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/utils/remote_config/horta_remote_config_entity.dart';
import 'package:morar/core/widgets/hex_color.dart';
import 'package:morar/feature/access_control/presentation/page/access_control_page.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_access_not_allowed_dialog.dart';
import 'package:morar/feature/agreements/presentation/widgets/agreement_not_avaliable_dialog.dart';
import 'package:morar/feature/home/domain/entity/external_link_redirect_enum.dart';
import 'package:morar/feature/home/presentation/widget/badge_icon.dart';
import 'package:morar/feature/home/presentation/widget/error_dialog.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/widgets/rent_sell_dialog.dart/rent_sell_dialog.dart';
import 'package:morar/feature/home/presentation/widget/horta_dialog.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';

import 'feature_moved_full_screen_dialog.dart';

class DashboardItem extends StatefulWidget {
  final String imagePath;
  final String text;
  final String route;
  final VoidCallback closeOverlay;
  final SessionBloc sessionBloc;
  final bool isCardWideScreen;
  final String badgeText;
  final ExternalLinkRedirectEnum? externalLinkRedirectEnum;
  final bool isGeneric;
  final HortaRemoteConfigEntity? horta;
  final Function()? startAnalyticsTimer, stopAnalyticsTimer;
  final bool? isHighlighted;
  final bool? canHyphenateText;
  final String? whatsAppNumber;
  final VoidCallback? onComfortTap;

  const DashboardItem(
      {Key? key,
      required this.imagePath,
      required this.text,
      required this.route,
      required this.closeOverlay,
      required this.sessionBloc,
      required this.isCardWideScreen,
      this.isGeneric = false,
      this.badgeText = "",
      this.horta,
      this.externalLinkRedirectEnum,
      this.startAnalyticsTimer,
      this.stopAnalyticsTimer,
      this.isHighlighted = false,
      this.canHyphenateText = false,
      this.whatsAppNumber,
      this.onComfortTap})
      : super(key: key);

  @override
  State<DashboardItem> createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
  late bool activeManager;
  late SessionBloc sessionBloc;

  void startAnalyticsTimer() {
    if (widget.startAnalyticsTimer != null) {
      return widget.startAnalyticsTimer!();
    }
  }

  void stopAnalyticsTimer() {
    if (widget.stopAnalyticsTimer != null) {
      return widget.stopAnalyticsTimer!();
    }
  }

  @override
  void initState() {
    super.initState();
    activeManager =
        widget.sessionBloc.state.session?.condominium?.active_manager ?? false;
    sessionBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //TODO: Verificar quebra de linha em cards da home
    final text = widget.text == "ia_bella"
        ? getStringWithParams(
            context,
            widget.text,
            [FlavorConfig.config.iaName],
          )
        : getString(context, widget.text);
    final isHyphenateEnabled = widget.canHyphenateText == true;
    final shouldUseSingleLine =
        isHyphenateEnabled && !text.trim().contains(' ');
    final displayText = isHyphenateEnabled ? hyphenateText(text) : text;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: InkWell(
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          if (widget.externalLinkRedirectEnum != null) {
            _redirectExternalLink(
                externalLinkRedirectEnum: widget.externalLinkRedirectEnum);
          } else {
            _onTap(widget.text, widget.route, theme);
          }
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 100.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            width: widget.isCardWideScreen
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width / 2 - 25,
            decoration: BoxDecoration(
                color: widget.isHighlighted!
                    ? LelloTheme.palleteOf(theme).primary()
                    : LelloTheme.palleteOf(theme).background(),
                border: Border.all(
                  width: 0.5,
                  color: LelloTheme.palleteOf(theme).grey(),
                ),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.imagePath == "assets/ic_whats.svg"
                          ? SvgPicture.asset(widget.imagePath,
                              height: 30, color: HexColor("#828282"))
                          : SvgPicture.asset(
                              widget.imagePath,
                            ),
                      SizedBox(
                        height: 8,
                      ),
                      AutoSizeText(
                        displayText,
                        maxLines: shouldUseSingleLine ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: widget.isHighlighted!
                              ? LelloTheme.palleteOf(theme).background()
                              : LelloTheme.palleteOf(theme).text(),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                BadgeIcon(text: widget.badgeText),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onTap(
    String text,
    String route,
    ThemeData theme,
  ) async {
    widget.closeOverlay();
    if (text == "reports_title") {
      if (!activeManager) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                  isGeneric: widget.isGeneric,
                  theme: theme,
                  title: "manager_inactive_message");
            });
      } else {
        stopAnalyticsTimer();
        Navigator.pushNamed(context, route).then((_) => startAnalyticsTimer());
      }
    } else if (text == "comfort") {
      if (sessionBloc.checkRback(ApplicationRbac.morarComodidades)) {
        stopAnalyticsTimer();
        if (widget.onComfortTap != null) {
          widget.onComfortTap!();
          startAnalyticsTimer();
        } else {
          Navigator.pushNamed(
            context,
            route,
            arguments: ComfortPageArgs(
              appOriginEnum: AppOriginEnum.owner,
              unit: (sessionBloc.state as SessionLoadedState)
                      .session
                      ?.unity
                      ?.title ??
                  "",
              reference: (sessionBloc.state as SessionLoadedState)
                      .session
                      ?.condominium
                      ?.reference ??
                  "",
              accessRouteOrigin: ComfortPageOriginEnum.dashboard,
            ),
          ).then((_) => startAnalyticsTimer());
        }
      }
    } else if (text == "authorize_entry") {
      if (!widget.sessionBloc
          .checkRback(ApplicationRbac.morarAutorizarEntrada)) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                  isGeneric: widget.isGeneric,
                  theme: theme,
                  title: "manager_no_concierge");
            });
      } else {
        stopAnalyticsTimer();
        Navigator.pushNamed(context, route,
                arguments: AcessControlPageArgs(isGeneric: widget.isGeneric))
            .then((_) => startAnalyticsTimer());
      }
    } else if (text == "mailing_title") {
      if (!widget.sessionBloc
          .checkRback(ApplicationRbac.morarCorrespondencias)) {
        showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                  isGeneric: widget.isGeneric,
                  theme: theme,
                  title: "manager_no_concierge");
            });
      } else {
        stopAnalyticsTimer();
        Navigator.pushNamed(context, route).then((_) => startAnalyticsTimer());
      }
    } else if (text == "agreements") {
      if (!widget.sessionBloc.checkRback(ApplicationRbac.morarAcordos)) {
        showDialog(
            context: context,
            builder: (context) {
              return AgreementAccessNotAllowedDialog();
            });
      } else {
        var result = await Navigator.pushNamed(context, route);
        if (result != null &&
            result is Exception &&
            result.toString().contains("agreement_not_avaliable_failure")) {
          showDialog(
              context: context,
              builder: (context) {
                return AgreementNotAvaliableDialog();
              });
        }
      }
    } else if (text == "lello_hub_billing") {
      OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.ppcAcessar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
      stopAnalyticsTimer();
      Navigator.pushNamed(context, route).then((_) => startAnalyticsTimer());
    } else if (text == 'me_vehicles_title') {
      OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.veiculoAcessar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue:
            sessionBloc.state.session!.unity?.namedTitle.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
      stopAnalyticsTimer();
      Navigator.pushNamed(context, route).then((_) => startAnalyticsTimer());
    } else if (text == 'documents') {
      OwnerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsOwner.documentosAcessar(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue: sessionBloc.state.session!.unity?.title?.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
      stopAnalyticsTimer();
      Navigator.pushNamed(context, route).then((_) => startAnalyticsTimer());
    } else if (text == 'horta_title') {
      if (widget.horta != null) {
        showDialog(
          context: context,
          builder: (context) => HortaDialog(
            horta: widget.horta!,
          ),
        );
      }
    } else if (text == 'preferences_zero_paper') {
      _showFeatureMovedFullscreenDialog(
        'preferences_zero_paper',
        'access_paper_zero_instructions',
        ApplicationRoute.receivingDocuments,
      );
    } else if (text == 'change_address') {
      _showFeatureMovedFullscreenDialog(
        'change_address',
        'access_change_address_instructions',
        ApplicationRoute.receivingDocuments,
      );
    } else {
      stopAnalyticsTimer();
      Navigator.pushNamed(context, route).then((_) => startAnalyticsTimer());
    }
  }

  void _redirectExternalLink({required externalLinkRedirectEnum}) {
    switch (externalLinkRedirectEnum) {
      case ExternalLinkRedirectEnum.talkToLello:
        // Try to get WhatsApp number from widget parameter first,
        // then fallback to default
        String phoneNumber = widget.whatsAppNumber ??
            FlavorConfig.config.supportMoradorWhatsAppNumber;
        WhatsAppDialog.redirect(
          context: context,
          phoneNumber: phoneNumber,
          title: "online_service",
          text: "talk_to_lello_text_description",
          message: "would_speack_lello",
          isGeneric: widget.isGeneric,
          companyName: widget.sessionBloc.state.session?.condominium?.layout
                  ?.companyName ??
              "",
        );
        OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.falelelloAcessar(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title?.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
        );
        break;
      case ExternalLinkRedirectEnum.rentOrSellYourProperty:
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => RentSellDialogWidget(),
        );
        break;
      default:
    }
  }

  void _showFeatureMovedFullscreenDialog(
    String appBarTitle,
    String message,
    String route,
  ) =>
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isDismissible: false,
        isScrollControlled: true,
        enableDrag: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        builder: (context) => FractionallySizedBox(
          heightFactor: 1,
          child: FeatureMovedFullscreenDialog(
            message: message,
            appBarTitle: appBarTitle,
            route: route,
          ),
        ),
      );
}

String hyphenateText(String text) {
  if (text.trim().contains(' ')) return text;
  return text;
}
