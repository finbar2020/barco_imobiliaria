import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app_localization.dart';
import '../../app_theme.dart';
import '../../dimens.dart';
import '../text/lello_text_styles.dart';

class ErrorHandlingWidget extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final bool isProduction;
  final String? errorCode;
  final String? error;
  final String? textReturnButton;
  final Function() reTryFunction;
  final Function() backFunction;
  final String? message;
  final bool showBackButton;

  const ErrorHandlingWidget({Key? key,
    this.title,
    this.subTitle,
    this.errorCode,
    this.error,
    this.textReturnButton,
    this.message,
    this.showBackButton = true,
    required this.isProduction,
    required this.reTryFunction,
    required this.backFunction})
      : super(key: key);

  @override
  State<ErrorHandlingWidget> createState() => _ErrorHandlingWidgetState();
}

class _ErrorHandlingWidgetState extends State<ErrorHandlingWidget> {
  PackageInfo? packageInfo;
  final expandableController = ExpandableController();

  @override
  void initState() {
    expandableController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: <Widget>[
                  SizedBox(height: Dimens.spacingLarge),
                  SvgPicture.asset("assets/ic_error_request_widget.svg",
                      width: 150, height: 150),
                  SizedBox(height: Dimens.spacing),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          getString(
                              context,
                              widget.title != null
                                  ? widget.title!
                                  : 'error_handling_widget_title'),
                          textAlign: TextAlign.center,
                          style: LelloTextStyles.headline(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).text(),
                          ),
                        ),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          widget.message ?? getString(
                              context,
                              widget.subTitle != null
                                  ? widget.subTitle!
                                  : 'error_handling_widget_subtitle'),
                          textAlign: TextAlign.center,
                          style: LelloTextStyles.subtitle(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).text(),
                          ),
                        ),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          DateFormat("dd/MM/yyyy HH:mm").format(DateTime.now()),
                          textAlign: TextAlign.center,
                          style: LelloTextStyles.subtitle(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).text(),
                          ),
                        ),
                        Offstage(
                          offstage: widget.isProduction,
                          child: ExpandableNotifier(
                            controller: expandableController,
                            child: ExpandablePanel(
                              theme: const ExpandableThemeData(
                                  hasIcon: false,
                                  headerAlignment:
                                  ExpandablePanelHeaderAlignment.center),
                              header: Icon(
                                expandableController.expanded
                                    ? Icons.expand_less
                                    : Icons.more_horiz,
                                color: LelloTheme.palleteOf(theme).grey(),
                              ),
                              collapsed: const SizedBox.shrink(),
                              expanded: Column(
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      SizedBox(height: Dimens.spacingXSmall),
                                      Row(
                                        children: [
                                          Text(
                                            (getString(context,
                                                "error_handling_widget_date")),
                                            textAlign: TextAlign.left,
                                            style:
                                            LelloTextStyles.captionBold(theme)!
                                                .copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .hubText(),
                                            ),
                                          ),
                                          SizedBox(width: Dimens.spacingSmall),
                                          Text(
                                            DateFormat.yMd("pt_BR").format(
                                              DateTime.now(),
                                            ),
                                            style: LelloTextStyles.caption(
                                                theme)!
                                                .copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .hubText(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Dimens.spacingXSmall),
                                      Row(
                                        children: [
                                          Text(
                                            (getString(context,
                                                "error_handling_widget_hour")),
                                            textAlign: TextAlign.left,
                                            style: LelloTextStyles.captionBold(
                                                theme)!
                                                .copyWith(
                                                color:
                                                LelloTheme.palleteOf(theme)
                                                    .hubText()),
                                          ),
                                          SizedBox(width: Dimens.spacingSmall),
                                          Text(
                                            DateFormat.Hm("pt_BR").format(
                                              DateTime.now(),
                                            ),
                                            style: LelloTextStyles.caption(
                                                theme)!
                                                .copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .hubText(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Dimens.spacingXSmall),
                                      Row(
                                        children: [
                                          Text(
                                            (getString(context,
                                                "error_handling_widget_app_version")),
                                            textAlign: TextAlign.left,
                                            style:
                                            LelloTextStyles.captionBold(theme)!
                                                .copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .hubText(),
                                            ),
                                          ),
                                          SizedBox(width: Dimens.spacingSmall),
                                          Text(
                                            (_getVersion()),
                                            textAlign: TextAlign.left,
                                            style: LelloTextStyles.caption(
                                                theme)!
                                                .copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .hubText(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Dimens.spacingXSmall),
                                      Row(
                                        children: [
                                          Text(
                                            (getString(context,
                                                "error_handling_widget_code_error")),
                                            textAlign: TextAlign.left,
                                            style:
                                            LelloTextStyles.captionBold(theme)!
                                                .copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .hubText(),
                                            ),
                                          ),
                                          SizedBox(width: Dimens.spacingSmall),
                                          Text(
                                            (widget.errorCode != null
                                                ? widget.errorCode!
                                                : ""),
                                            textAlign: TextAlign.left,
                                            style: LelloTextStyles.caption(
                                                theme)!
                                                .copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .hubText(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: Dimens.spacingXSmall),
                                      Row(
                                        children: [
                                          Text(
                                            (getString(context,
                                                "error_handling_widget_error")),
                                            textAlign: TextAlign.left,
                                            style: LelloTextStyles.captionBold(
                                                theme)!
                                                .copyWith(
                                                color:
                                                LelloTheme.palleteOf(theme)
                                                    .hubText()),
                                          ),
                                          SizedBox(width: Dimens.spacingSmall),
                                          Flexible(
                                            child: Text(
                                              (widget.error != null
                                                  ? widget.error!
                                                  : ""),
                                              textAlign: TextAlign.left,
                                              style: LelloTextStyles.caption(
                                                  theme)!
                                                  .copyWith(
                                                color: LelloTheme.palleteOf(
                                                    theme)
                                                    .hubText(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: LelloTheme
                            .palleteOf(theme)
                            .customColor(),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: LelloTheme.palleteOf(theme).textOpaque(),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Dimens.spacing),
                        child: Text(
                          getString(
                              context, "error_handling_widget_button_reTry"),
                          style: LelloTextStyles.button(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).text(),
                          ),
                        ),
                      ),
                      onPressed: () {
                        widget.reTryFunction();
                      },
                    ),
                  ),
                  if (widget.showBackButton) ...[  
                    SizedBox(height: Dimens.spacing),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          backgroundColor: LelloTheme
                              .palleteOf(theme)
                              .customColor(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.spacing),
                          child: Text(
                            getString(
                                context,
                                widget.textReturnButton == null
                                    ? "error_handling_widget_button_back"
                                    : widget.textReturnButton ?? ""),
                            style: LelloTextStyles.button(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).text(),
                            ),
                          ),
                        ),
                        onPressed: () {
                          widget.backFunction();
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ));
  }

  String _getVersion() {
    if (packageInfo != null) {
      return packageInfo!.version;
    } else {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
      return "";
    }
  }
}
