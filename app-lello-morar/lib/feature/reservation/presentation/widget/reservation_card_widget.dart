// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_rule.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class ReservationCardWidget extends StatefulWidget {
  final bool isChangeArea;
  final VoidCallback onTap;
  final Space model;

  const ReservationCardWidget({
    Key? key,
    this.isChangeArea = false,
    required this.model,
    required this.onTap,
  }) : super(key: key);

  @override
  _ReservationCardWidgetState createState() => _ReservationCardWidgetState();
}

class _ReservationCardWidgetState extends State<ReservationCardWidget> {
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  Map<String, String>? customHeader;

  @override
  void initState() {
    super.initState();
    customHeader = authenticationStore.getCustomHeader();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 125),
      child: Card(
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: InkWell(
          onTap: widget.onTap,
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: LelloTheme.palleteOf(theme).separator(),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: widget.isChangeArea
                                ? Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: SvgPicture.asset(
                                        "assets/ic_mudanca.svg",
                                        fit: BoxFit.contain),
                                  )
                                : widget.model.pictureUrl == null
                                    ? Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: SvgPicture.asset(
                                            "assets/ic_space_placeholder.svg",
                                            fit: BoxFit.contain),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: widget.model.pictureUrl!,
                                        httpHeaders: customHeader,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              bottomLeft: Radius.circular(15.0),
                                            ),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(),
                                          ],
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: SvgPicture.asset(
                                              "assets/ic_space_placeholder.svg",
                                              fit: BoxFit.contain),
                                        ),
                                      ),
                          )
                        ]),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _buildBody(theme),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (widget.model.reservationRule.chargeable! ||
        widget.model.reservationRule.isGuarantor) {
      return _buildPaidArea(theme);
    } else if (widget.isChangeArea) {
      return _buildChangeArea(theme);
    } else {
      return _buildFreeArea(theme);
    }
  }

  Widget _buildFreeArea(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.model.name ?? "",
          style: LelloTextStyles.subtitleBold(theme),
          softWrap: true,
        ),
        SizedBox(height: Dimens.spacingXSmall),
        Text(
          getString(context, "free"),
          style: LelloTextStyles.caption(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).primary(),
          ),
        ),
        Expanded(child: SizedBox()),
        Text(
          getString(context, "maximum_capacity")
              .replaceAll("%s", "${widget.model.capacity}"),
          style: LelloTextStyles.caption(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).textLightest(),
          ),
        ),
        SizedBox(height: Dimens.spacingSmall),
      ],
    );
  }

  Column _buildPaidArea(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.model.name ?? "",
          softWrap: true,
          style: LelloTextStyles.subtitleBold(theme),
        ),
        SizedBox(height: Dimens.spacingXSmall),
        PriceBuilder(rule: widget.model.reservationRule),
        Expanded(child: SizedBox()),
        Text(
          getString(context, widget.model.reservationRule.paymentInfo),
          style: LelloTextStyles.caption(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).textLightest(),
          ),
        ),
        SizedBox(height: Dimens.spacingXSmall),
        Text(
          getString(context, "maximum_capacity")
              .replaceAll("%s", "${widget.model.capacity}"),
          style: LelloTextStyles.caption(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).textLightest(),
          ),
        ),
        SizedBox(height: Dimens.spacingSmall),
      ],
    );
  }

  Column _buildChangeArea(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          getString(context, "reserves_moving"),
          softWrap: true,
          style: LelloTextStyles.subtitleBold(theme),
        ),
        SizedBox(height: Dimens.spacingSmall),
      ],
    );
  }
}

class PriceBuilder extends StatelessWidget {
  final ReservationRule rule;

  const PriceBuilder({
    Key? key,
    required this.rule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Builder(builder: (context) {
      if (rule.isBillet) {
        if (rule.price != null) {
          return Text(
            "${NumberFormat.currency(symbol: "R\$").format(rule.price ?? 0.0)}",
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).primary(),
            ),
          );
        }
        return Text(
          "${rule.percentageTax?.toPrecision(2)}% ${getString(context, "of_condominium_quota")}",
          style: LelloTextStyles.caption(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).primary(),
          ),
        );
      }
      if ((rule.price == null || rule.price == 0) &&
          rule.percentageTax != null) {
        return Text(
          "${rule.percentageTax?.toPrecision(2)}% ${getString(context, "of_condominium_quota")}",
          style: LelloTextStyles.caption(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).primary(),
          ),
        );
      }

      return Text(
        "${NumberFormat.currency(symbol: "R\$").format(rule.price ?? 0.0)}",
        style: LelloTextStyles.caption(theme)!.copyWith(
          color: LelloTheme.palleteOf(theme).primary(),
        ),
      );
    });
  }
}
