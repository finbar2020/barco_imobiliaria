import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/confort_request_item_details.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/rating_bar_widget.dart';
import 'package:shared_features/shared_features.dart';

class ComfortCompletedRequestBottomSheet extends StatefulWidget {
  final ComfortCompletedRequest comfortCompletedRequest;
  final ComfortMyRequestsController myRequestsController;
  final SharedApplicationContainer appContainer;

  const ComfortCompletedRequestBottomSheet({
    Key? key,
    required this.comfortCompletedRequest,
    required this.myRequestsController,
    required this.appContainer,
  }) : super(key: key);

  @override
  ComfortCompletedRequestBottomSheetState createState() =>
      ComfortCompletedRequestBottomSheetState();
}

class ComfortCompletedRequestBottomSheetState
    extends State<ComfortCompletedRequestBottomSheet> {
  double? userRating;
  bool disableRaring = false;
  bool _isMessageVisible = false;

  ComfortRequestMessageType? newMessageType;
  String? newComment;

  @override
  void initState() {
    super.initState();
    if (widget.comfortCompletedRequest.rating != null) {
      disableRaring = true;
      userRating = widget.comfortCompletedRequest.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
            child: IconButton(
          icon:
              Icon(Icons.keyboard_arrow_down_sharp, size: Dimens.spacingLarge),
          color: LelloTheme.palleteOf(theme).grey(),
          onPressed: () {
            Navigator.pop(context);
          },
        )),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 8 / 10,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                Dimens.spacingLarge,
                Dimens.spacingSmall,
                Dimens.spacingLarge,
                MediaQuery.of(context).viewInsets.bottom + Dimens.spacingLarge),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getString(context, "condominium") + ":",
                    style: LelloTextStyles.bodyBold(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingXSmall),
                  Text(
                    widget.myRequestsController.getCondoName,
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  ConfortRequestItemDetails(
                    appContainer: widget.appContainer,
                    item: widget.comfortCompletedRequest,
                    hideStatus: true,
                  ),
                  if (_isMessageVisible == false) _buildRateBar(theme),
                  SizedBox(height: Dimens.spacingLarge),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.easeInOut,
                    height: !_isMessageVisible ? null : 0.0,
                    child: !_isMessageVisible
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                _isMessageVisible = true;
                              });
                            },
                            child: Text(
                              getString(
                                  context,
                                  widget.comfortCompletedRequest.messageDate ==
                                          null
                                      ? "comfort_message_need_help"
                                      : "comfort_message_view"),
                              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                                color: Color(0xFF2F80ED),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF2F80ED)
                              ),
                            ))
                        : Container(),
                  ),
                  if (_isMessageVisible == false)
                    SizedBox(height: Dimens.spacingMedium),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 2000),
                    curve: Curves.easeInOut,
                    child: _isMessageVisible
                        ? _buildMessageFieldd(theme)
                        : _buildButtons(theme),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageFieldd(ThemeData theme) {
    if (widget.comfortCompletedRequest.messageDate == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getString(context, "comfort_message_need_help"),
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
          SizedBox(height: Dimens.spacingXSmall),
          Text(
            getString(context, "comfort_message_need_help_subtitle"),
            style: LelloTextStyles.body(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: getString(context, "comfort_message_subject"),
              labelStyle: LelloTextStyles.body(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.spacingSmall),
              ),
            ),
            items: ComfortRequestMessageType.values
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(ComfortCompletedRequest.getMessageTypeString(
                          context, e)),
                    ))
                .toList(),
            onChanged: (ComfortRequestMessageType? value) {
              newMessageType = value;
            },
          ),
          SizedBox(height: Dimens.spacingMedium),
          TextFormField(
            minLines: 5,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: getString(context, "comfort_message_text"),
              alignLabelWithHint: true,
              labelStyle: LelloTextStyles.body(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.spacingSmall),
              ),
            ),
            onChanged: (value) {
              newComment = value;
            },
          ),
          SizedBox(height: Dimens.spacingMedium),
          PrimaryButton(
            onPressed: () {
              if (newMessageType == null ||
                  newComment == null ||
                  newComment!.isEmpty) {
                return;
              }
              widget.myRequestsController.sendMessage(
                widget.comfortCompletedRequest.idRequest,
                newMessageType!,
                newComment!,
              );
              Navigator.pop(context);
            },
            child: Text(getString(context, "send"),
                style: LelloTextStyles.button(theme)),
          ),
          SizedBox(height: Dimens.spacingMedium),
          SecondaryButton(
            buttonBorderColor: LelloTheme.palleteOf(theme).primary(),
            onPressed: () {
              setState(() {
                _isMessageVisible = false;
              });
            },
            child: Text(getString(context, "cancel"),
                style: LelloTextStyles.button(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).primary(),
                )),
          )
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
            onPressed: () {
              setState(() {
                _isMessageVisible = false;
              });
            },
            child: Text(
              getString(context, "comfort_message_hide"),
              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                color: Color(0xFF2F80ED),
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF2F80ED)
              ),
            )),
        SizedBox(height: Dimens.spacingSmall),
        Padding(
          padding: EdgeInsets.only(left: Dimens.spacingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getString(context, "comfort_message_subject"),
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
              Text(
                ComfortCompletedRequest.getMessageTypeString(
                    context, widget.comfortCompletedRequest.messageType),
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Text(
                getString(context, "comfort_message_text"),
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
              Text(
                widget.comfortCompletedRequest.comment ?? "",
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimens.spacingLarge),
        Center(
          child: Text(
            getString(context, "comfort_message_sended_at")
                .replaceAll(
                    "1",
                    DateFormat("HH:mm")
                        .format(widget.comfortCompletedRequest.messageDate!))
                .replaceAll(
                    "2",
                    DateFormat("dd/MM/yyyy")
                        .format(widget.comfortCompletedRequest.messageDate!)),
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).error(),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacingLarge),
        _buildButtons(theme),
      ],
    );
  }

  Widget _buildButtons(ThemeData theme) {
    return Column(
      children: [
        PrimaryButton(
          onPressed: widget.comfortCompletedRequest.isCanResend
              ? () {
                  Navigator.pop(context);
                  widget.myRequestsController
                      .resendRequest(widget.comfortCompletedRequest.idRequest);
                }
              : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.14),
                child: Icon(Icons.reply),
              ),
              SizedBox(width: Dimens.spacingSmall),
              Text(
                  getString(
                      context,
                      widget.comfortCompletedRequest.isCanResend
                          ? "comfort_request_resend_button"
                          : "comfort_request_resent_button"),
                  style: LelloTextStyles.button(theme)),
            ],
          ),
        ),
        SizedBox(height: Dimens.spacing),
        SecondaryButton(
          buttonBorderColor: LelloTheme.palleteOf(theme).primary(),
          onPressed: () {},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel_outlined,
                  color: LelloTheme.palleteOf(theme).primary()),
              SizedBox(width: Dimens.spacingSmall),
              Text(getString(context, "comfort_request_cancel_button"),
                  style: LelloTextStyles.button(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).primary(),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRateBar(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.spacingMedium),
        Text(
          getString(context, "comfort_rate_rating"),
          style: LelloTextStyles.subtitleBold(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
        SizedBox(height: Dimens.spacing),
        RatingBarWidget(
          allowHalfRating: false,
          initValue: userRating ?? 0,
          size: 40,
          disableRating: disableRaring,
          color: LelloTheme.palleteOf(theme).success(),
          setRating: (value) {
            setState(() {
              userRating = value;
            });
          },
        ),
      ],
    );
  }
}
