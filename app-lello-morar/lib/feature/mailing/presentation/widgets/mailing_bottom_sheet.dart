import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/mailing/domain/entity/mailing.dart';
import 'package:morar/feature/mailing/presentation/controllers/mailing_controller.dart';

class MailingBottomSheet extends StatefulWidget {
  final Mailing mailing;
  const MailingBottomSheet({super.key, required this.mailing});

  @override
  State<MailingBottomSheet> createState() => _MailingBottomSheetState();
}

class _MailingBottomSheetState extends State<MailingBottomSheet> {
  final controller =
      ApplicationContainer.instance().resolve<MailingController>();

  bool loadingPicture = false;

  @override
  void dispose() {
    controller.picture = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      maxChildSize: 1,
      initialChildSize: 1,
      minChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.spacingLarge,
            vertical: Dimens.spacing,
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: Transform.scale(
                  scaleY: 0.9,
                  scaleX: 2.2,
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    size: 35,
                    weight: 0.6,
                    color: LightPallete().grey(),
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getString(context, "mailing_received"),
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                          SizedBox(height: Dimens.spacingXSmall),
                          Text(
                            "${widget.mailing.arrivalFullDate} ${getString(context, "mailing_received_at")} ${widget.mailing.arrivalHourMinute}h",
                            style: LelloTextStyles.body(theme),
                          ),
                        ],
                      )),
                      SizedBox(width: Dimens.spacingSmall),
                      Flexible(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 10.0,
                            width: 10.0,
                            decoration: BoxDecoration(
                              color: color(widget.mailing.status ?? "", theme),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: Dimens.spacingSmall),
                          Flexible(
                            child: Text(
                              "${getString(context, widget.mailing.statusMailing)}",
                              style: LelloTextStyles.subBody(theme)!.copyWith(
                                color:
                                    color(widget.mailing.status ?? "", theme),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(
                    "${getString(context, "mailing_receiver")}",
                    style: LelloTextStyles.bodyBold(theme),
                  ),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(
                    "${widget.mailing.addressee ?? getString(context, "not_informed")}",
                    style: LelloTextStyles.body(theme),
                  ),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(
                    "${widget.mailing.category} - ${widget.mailing.size}",
                    style: LelloTextStyles.subBody(theme),
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                    "${getString(context, "attachment")}",
                    style: LelloTextStyles.body(theme),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  widget.mailing.photo != null
                      ? FutureBuilder(
                          future: controller.getPicture(
                              hash: widget.mailing.photo!),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(),
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierColor: theme.disabledColor,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 24,
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Spacer(),
                                                  Expanded(
                                                    child: Text(
                                                      getString(context,
                                                          'attachment'),
                                                      style: LelloTextStyles
                                                          .titleSmallBold(
                                                              theme),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: Navigator.of(context)
                                                        .pop,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 24,
                                                      ),
                                                      child: CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor: Colors
                                                            .grey.shade200,
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Image.memory(
                                              controller.picture!,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Image.memory(
                                controller.picture!,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.photo_outlined,
                                    color: LightPallete().grey(),
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : Text(
                          getString(context, "mailing_without_attachment"),
                          style: LelloTextStyles.caption(theme)?.copyWith(
                            color: theme.disabledColor,
                          ),
                        ),
                  SizedBox(height: Dimens.spacing),
                  Text(
                    "${getString(context, "mailing_tracking_code")}",
                    style: LelloTextStyles.bodyBold(theme),
                  ),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(
                    "${widget.mailing.trackingCode ?? getString(context, "not_informed")}",
                    style: LelloTextStyles.body(theme),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(
                    "${getString(context, "description")}",
                    style: LelloTextStyles.bodyBold(theme),
                  ),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(
                    "${widget.mailing.description ?? getString(context, "not_informed")}",
                    style: LelloTextStyles.body(theme),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(
                    "${getString(context, "observations")}",
                    style: LelloTextStyles.bodyBold(theme),
                  ),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(
                    "${widget.mailing.observation ?? getString(context, "not_informed")}",
                    style: LelloTextStyles.body(theme),
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  if (widget.mailing.retirado)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getString(context, "mailing_withdraw_by")}",
                          style: LelloTextStyles.bodyBold(theme)?.copyWith(
                            color: LightPallete().success(),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingSmall),
                        Text(
                          "${widget.mailing.pickUpResident ?? getString(context, "not_informed")}",
                          style: LelloTextStyles.body(theme)?.copyWith(
                            color: LightPallete().success(),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingXSmall),
                        Text(
                          "${widget.mailing.pickUpFullDate} ${getString(context, "mailing_received_at")} ${widget.mailing.pickUpHourMinute}h",
                          style: LelloTextStyles.body(theme)?.copyWith(
                            color: LightPallete().success(),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

Color color(String status, ThemeData theme) {
  switch (status) {
    case "PENDENTE":
      return LelloTheme.palleteOf(theme).warning();
    case "RETIRADA":
      return LelloTheme.palleteOf(theme).success();
    default:
      return LelloTheme.palleteOf(theme).customColor();
  }
}
