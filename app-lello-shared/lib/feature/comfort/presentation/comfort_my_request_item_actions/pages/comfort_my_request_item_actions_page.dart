import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/loading_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/bloc/comfort_my_request_item_actions_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/controller/comfort_my_request_item_actions_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/pages/comfort_my_request_item_actions_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/widgets/confort_request_item_details.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/coupon_request_result_page.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/rating_bar_widget.dart';
import 'package:shared_features/shared_features.dart';

class ComfortMyRequestItemActionsBottomSheet extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  final ComfortCompletedRequest request;
  final Function(ComfortCompletedRequest updatedItem) updatedItemResponse;
  final Function() updateAllItems;
  const ComfortMyRequestItemActionsBottomSheet({
    Key? key,
    required this.appContainer,
    required this.request,
    required this.updatedItemResponse,
    required this.updateAllItems,
  }) : super(key: key);

  @override
  _ComfortMyRequestItemActionsPage createState() =>
      _ComfortMyRequestItemActionsPage();
}

class _ComfortMyRequestItemActionsPage
    extends State<ComfortMyRequestItemActionsBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late ComfortMyRequestItemActionsController controller;

  bool _isDisableRating = false;
  bool _isMessageVisible = false;

  double? userRating;
  ComfortRequestMessageType? newMessageType;
  String? newComment;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller =
        widget.appContainer.resolve<ComfortMyRequestItemActionsController>();
    controller.setRequest(request: widget.request);
    userRating = widget.request.rating;
    if (widget.request.rating != null) {
      _isDisableRating = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (widget.request.rating == null && userRating != null) {
          controller.rateRequest(request: widget.request, rating: userRating!);
          return false;
        }
        Navigator.pop(context);
        return true;
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: IconButton(
            icon: Icon(Icons.keyboard_arrow_down_sharp,
                size: Dimens.spacingLarge),
            color: LelloTheme.palleteOf(theme).grey(),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 3 / 4,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  Dimens.spacingLarge,
                  Dimens.spacingSmall,
                  Dimens.spacingLarge,
                  MediaQuery.of(context).viewInsets.bottom +
                      Dimens.spacingLarge),
              child: BlocConsumer<ComfortMyRequestItemActionsBloc,
                  ComfortMyRequestItemActionsState>(
                bloc: controller.bloc,
                listener: (context, state) {
                  if (state is ComfortMyRequestItemActionsSuccessState) {
                    if (state.action == ComfortMyRequestItemActions.resend) {
                      widget.updateAllItems();
                    } else {
                      widget.updatedItemResponse(state.request);
                    }
                    var successPage = ComfortMyRequestItemActionsSuccessPage(
                      action: state.action,
                      conoName: controller.getCondoName,
                    );
                    if (state.action == ComfortMyRequestItemActions.rate) {
                      Fluttertoast.showToast(
                          msg:
                              getString(context, "comfort_rate_success_title"));
                      Navigator.pop(context);
                      return;
                    }
                    if (state.action == ComfortMyRequestItemActions.cancel) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return successPage;
                      }));
                    } else if (state.action ==
                        ComfortMyRequestItemActions.resend) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return successPage;
                      }));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return successPage;
                      }));
                    }
                  }
                  if (state is ComfortMyRequestItemActionsErrorState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComfortCupomRequesResultPage(
                          isSucces: false,
                          title:
                              getString(context, "comfort_request_error_title"),
                          subtitle: getString(
                              context, "comfort_request_error_subtitle"),
                          okAction: () => Navigator.pop(context),
                          retryAction: () {
                            switch (state.action) {
                              case ComfortMyRequestItemActions.resend:
                                controller.resendRequest(
                                    requestId: state.request.idRequest);
                                break;
                              case ComfortMyRequestItemActions.cancel:
                                controller
                                    .cancelRequest(state.request.idRequest);
                                break;
                              case ComfortMyRequestItemActions.rate:
                                break;
                              case ComfortMyRequestItemActions.message:
                                controller.sendMessage(
                                  request: state.request,
                                  subject: newMessageType!,
                                  message: newComment!,
                                );
                                break;
                            }
                          },
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _buildStateContent(state, context, theme));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateContent(ComfortMyRequestItemActionsState state,
      BuildContext context, ThemeData theme) {
    if (state is ComfortMyRequestItemActionsInitialState) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 2,
        ),
        child: Center(child: LoadingWidget()),
      );
    } else if (state is ComfortMyRequestItemActionsLoadingState) {
      var loadingMessage = getString(context, "loading");
      switch (state.action) {
        case ComfortMyRequestItemActions.resend:
          loadingMessage = getString(context, "comfort_request_resend_loading");
          break;
        case ComfortMyRequestItemActions.cancel:
          loadingMessage = getString(context, "comfort_request_cancel_loading");
          break;
        case ComfortMyRequestItemActions.rate:
          loadingMessage = getString(context, "comfort_request_rate_loading");
          break;
        case ComfortMyRequestItemActions.message:
          loadingMessage =
              getString(context, "comfort_request_message_loading");
          break;
      }
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 2,
        ),
        child: Center(child: LoadingMessageWidget(message: loadingMessage)),
      );
    }

    if (state is ComfortMyRequestItemActionsLoadedState) {
      return _buildBody(context, theme, state.request);
    }
    return Container();
  }

  SingleChildScrollView _buildBody(
      BuildContext context, ThemeData theme, ComfortCompletedRequest request) {
    return SingleChildScrollView(
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
            "${controller.getCondoName} - ${controller.getCondoReference}",
            style: LelloTextStyles.body(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).text(),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          ConfortRequestItemDetails(
            appContainer: widget.appContainer,
            item: request,
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
                          request.messageDate == null
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
                ? _buildMessageFieldd(theme, request)
                : _buildButtons(theme, request),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageFieldd(ThemeData theme, ComfortCompletedRequest request) {
    if (request.messageDate == null) {
      return Form(
        key: _formKey,
        child: Column(
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
              validator: (value) {
                if (value == null) {
                  return getString(context, "validation_required");
                }
                return null;
              },
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
                        child: Text(
                            ComfortCompletedRequest.getMessageTypeString(
                                context, e)),
                      ))
                  .toList(),
              onChanged: (ComfortRequestMessageType? value) {
                newMessageType = value;
              },
              value: newMessageType,
            ),
            SizedBox(height: Dimens.spacingMedium),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().isEmpty) {
                  return getString(context, "validation_required");
                }
                return null;
              },
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
              initialValue: newComment,
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              onPressed: () {
                final form = _formKey.currentState;
                if (form!.validate()) {
                  form.save();
                  controller.sendMessage(
                    request: request,
                    subject: newMessageType!,
                    message: newComment!,
                  );
                }
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
        ),
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
                    context, request.messageType),
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
                request.comment ?? "",
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
                    "1", DateFormat("HH:mm").format(request.messageDate!))
                .replaceAll(
                    "2", DateFormat("dd/MM/yyyy").format(request.messageDate!)),
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).error(),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacingLarge),
        _buildButtons(theme, request),
      ],
    );
  }

  Widget _buildButtons(ThemeData theme, ComfortCompletedRequest request) {
    return Column(
      children: [
        Visibility(
          visible: request.isCanCancel,
          child: PrimaryButton(
            onPressed: request.isCanResend
                ? () {
                    controller.resendRequest(requestId: request.idRequest);
                  }
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.14),
                  child: Icon(
                    Icons.reply,
                    color: request.isCanResend
                        ? null
                        : LelloTheme.palleteOf(theme).grey(),
                  ),
                ),
                SizedBox(width: Dimens.spacingSmall),
                Text(
                    getString(
                        context,
                        request.resendDate == null
                            ? "comfort_request_resend_button"
                            : "comfort_request_resent_button"),
                    style: LelloTextStyles.button(theme)!.copyWith(
                      color: request.isCanResend
                          ? null
                          : LelloTheme.palleteOf(theme).grey(),
                    ))
              ],
            ),
          ),
        ),
        SizedBox(height: Dimens.spacing),
        Visibility(
          visible: request.isCanCancel,
          child: SecondaryButton(
            buttonBorderColor: LelloTheme.palleteOf(theme).primary(),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        Dimens.spacingMedium,
                        Dimens.spacingMedium,
                        Dimens.spacingMedium,
                        Dimens.spacingXSmall,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child:
                                SvgPicture.asset("assets/ic_billet_alert.svg"),
                          ),
                          SizedBox(height: Dimens.spacing),
                          Text(
                            "${getString(context, "attention")}!",
                            textAlign: TextAlign.center,
                            style:
                                LelloTextStyles.titleSmallBold(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight(),
                            ),
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          Text(
                            getString(context,
                                "comfort_request_actions_cancel_warning_1"),
                            style: LelloTextStyles.subtitle(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).grey(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          Text(
                            getString(context,
                                "comfort_request_actions_cancel_warning_2"),
                            style:
                                LelloTextStyles.subtitleBold(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).grey(),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: Dimens.spacingMedium),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  padding: EdgeInsets.all(Dimens.spacing),
                                  child: Text(
                                    getString(context, "back"),
                                    style:
                                        LelloTextStyles.button(theme)?.copyWith(
                                      color:
                                          LelloTheme.palleteOf(theme).primary(),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  controller.cancelRequest(request.idRequest);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(Dimens.spacing),
                                  child: Text(
                                    getString(context,
                                        "comfort_request_cancel_button_confirm"),
                                    style:
                                        LelloTextStyles.button(theme)?.copyWith(
                                      color: LelloTheme.palleteOf(theme)
                                          .textLight(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
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
          disableRating: _isDisableRating,
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
