import 'package:essentials/essentials.dart' hide Image, BlendMode;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/feature/ia_bella/domain/entity/bella_message_entity.dart';
import 'package:morar/feature/ia_bella/presentation/bloc/ia_bella_state.dart';
import 'package:morar/feature/ia_bella/presentation/controllers/bella_feature_redirect_handler.dart';
import 'package:morar/feature/ia_bella/presentation/controllers/ia_bella_controller.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_document_message.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_info_bottomsheet.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/bella_not_available_widget.dart';
import 'package:morar/feature/ia_bella/presentation/controllers/bella_feature_redirect_handler.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/feedback_row.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/final_evaluation_dialog.dart';
import 'package:morar/feature/ia_bella/presentation/widgets/negative_feedback_dialog.dart';

class IABellaPage extends StatefulWidget {
  @override
  State<IABellaPage> createState() => _IABellaPageState();
}

class _IABellaPageState extends State<IABellaPage> {
  final _controller =
      ApplicationContainer.instance().resolve<IaBellaController>();
  ScrollController scrollController = ScrollController();

  BellaMessageEntity? _pendingMessage;
  bool _sessionReady = false;
  bool _handledInitialMessage = false;
  bool _showChips = true;

  List<String> get _chips => [
        getString(context, 'second_bill_copy'),
        getString(context, 'last_assembly_chip'),
        getString(context, 'condominium_rules'),
      ];

  List<String> get _chipPrompts => [
        getString(context, 'second_bill_copy'),
        getString(context, 'last_assembly_prompt'),
        getString(context, 'condominium_rules'),
      ];

  List<String?> get _chipDisplayTexts => [
        null,
        getString(context, 'last_assembly'),
        null,
      ];

  @override
  initState() {
    super.initState();
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    await _controller.startSession();
    setState(() {
      _sessionReady = true;
    });

    _handlePendingMessage();
  }

  void _handlePendingMessage() {
    if (!_handledInitialMessage && _pendingMessage != null && _sessionReady) {
      _handledInitialMessage = true;
      setState(() {
        _showChips = false;
      });
      _controller.sendMessage(context, _pendingMessage!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_handledInitialMessage) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is BellaMessageEntity && arg.text.isNotEmpty) {
        _pendingMessage = arg;
        if (_sessionReady) {
          _handlePendingMessage();
        }
      }
    }
  }

  @override
  dispose() {
    _controller.messages = [];
    _controller.checkSendMessage = false;
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_controller.messageController.text.trim().isEmpty) return;
    setState(() {
      _showChips = false;
    });
    _controller.sendMessage(
      context,
      BellaMessageEntity(
        text: _controller.messageController.text,
        isUser: true,
      ),
    );

    Future.delayed(Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder(
      bloc: _controller.bloc,
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              if (_controller.checkSendMessage) {
                await showDialog(
                  context: context,
                  builder: (context) => FinalEvaluationDialog(
                    textController: _controller.finalEvaluationController,
                    onRatingSelected: (value) {
                      _controller.setSelectedFeedbackRating(value);
                    },
                    onRequestResolvedSelected: (value) {
                      _controller.selectedRequestResolved = value;
                    },
                    onConfirm: () async {
                      bool success = await _controller.finalEvaluation(
                        _controller.selectedFeedbackRating,
                        _controller.finalEvaluationController.text,
                        _controller.selectedRequestResolved!,
                      );
                      _controller.onFinalEvaluationSuccess(
                        context,
                        success,
                        _controller.selectedRequestResolved!,
                        () {
                          setState(() {
                            _handledInitialMessage = true;
                            _sessionReady = false;
                            _pendingMessage = null;
                            _showChips = true;
                          });
                          _controller.resetChat();
                          _initializeSession();
                        },
                      );
                      if (success) _controller.clearFinalEvaluationFields();
                    },
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  ),
                );
                return;
              }
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(
              title: getStringWithParams(
                context,
                'ia_bella_title',
                [FlavorConfig.config.iaName, FlavorConfig.config.brandName],
              ),
              useGetString: false,
              autoSizeTitle: true,
              onPressed: () async {
                if (_controller.checkSendMessage) {
                  await showDialog(
                    context: context,
                    builder: (context) => FinalEvaluationDialog(
                      textController: _controller.finalEvaluationController,
                      onRatingSelected: (value) {
                        _controller.setSelectedFeedbackRating(value);
                      },
                      onRequestResolvedSelected: (value) {
                        _controller.selectedRequestResolved = value;
                      },
                      onConfirm: () async {
                        bool success = await _controller.finalEvaluation(
                          _controller.selectedFeedbackRating,
                          _controller.finalEvaluationController.text,
                          _controller.selectedRequestResolved!,
                        );
                        _controller.onFinalEvaluationSuccess(
                          context,
                          success,
                          _controller.selectedRequestResolved!,
                          () {
                            setState(() {
                              _handledInitialMessage = true;
                              _sessionReady = false;
                              _pendingMessage = null;
                              _showChips = true;
                            });
                            _controller.resetChat();
                            _initializeSession();
                          },
                        );
                        if (success) _controller.clearFinalEvaluationFields();
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
              },
              actions: [
                IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => BellaInfoBottomSheet(),
                    );
                  },
                ),
              ],
            ),
            body: state is IaBellaStartSessionState
                ? Center(child: CircularProgressIndicator())
                : state is IaBellaStartSessionErrorState
                    ? BellaNotAvailableWidget(
                        onReturnToMainPage: () {
                          Navigator.of(context).pop();
                        },
                      )
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${_controller.isSessionStartedToday() ? 'Hoje,' : ''} ${_controller.getSessionStartDate()}',
                                style: LelloTextStyles.bodyBold(theme)!
                                    .copyWith(
                                        color:
                                            LelloTheme.palleteOf(theme).grey()),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.65 +
                                      (_showChips ? 0 : 40),
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: _controller.messages.length,
                                itemBuilder: (context, index) {
                                  final message = _controller.messages[index];
                                  final isUserMessage = message.isUser;
                                  return Align(
                                    alignment: isUserMessage!
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment: isUserMessage
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          children: [
                                            if (!isUserMessage)
                                              Container(
                                                  padding: EdgeInsets.all(8),
                                                  child: SvgPicture.asset(
                                                    'assets/ic_bella_profile.svg',
                                                    width: 40,
                                                    height: 40,
                                                    theme: SvgTheme(
                                                      currentColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                                  )),
                                            SizedBox(width: 8),
                                            Container(
                                              constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                minWidth: 50,
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 10),
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: isUserMessage
                                                    ? theme.primaryColor
                                                    : LelloTheme.palleteOf(
                                                            theme)
                                                        .greyCard(),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  topRight: Radius.circular(12),
                                                  bottomLeft: isUserMessage
                                                      ? Radius.circular(12)
                                                      : Radius.circular(0),
                                                  bottomRight: isUserMessage
                                                      ? Radius.circular(0)
                                                      : Radius.circular(12),
                                                ),
                                              ),
                                              child: LayoutBuilder(
                                                builder:
                                                    (context, constraints) {
                                                  return MarkdownBody(
                                                    data: message.text,
                                                    styleSheet:
                                                        MarkdownStyleSheet(
                                                      p: TextStyle(
                                                        fontSize: 16,
                                                        color: isUserMessage
                                                            ? Colors.white
                                                            : LelloTheme
                                                                    .palleteOf(
                                                                        theme)
                                                                .text(),
                                                      ),
                                                    ),
                                                    onTapLink: (text, href,
                                                        title) async {
                                                      if (href == null) return;
                                                      final handled =
                                                          BellaFeatureRedirectHandler
                                                              .redirect(
                                                        context: context,
                                                        href: href,
                                                        sessionBloc: _controller
                                                            .sessionBloc,
                                                      );
                                                      if (handled) return;
                                                      final uri =
                                                          Uri.tryParse(href);
                                                      if (uri == null ||
                                                          !uri.hasScheme) {
                                                        return;
                                                      }
                                                      if (await canLaunchUrl(
                                                          uri)) {
                                                        await launchUrl(uri,
                                                            mode: LaunchMode
                                                                .externalApplication);
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (!isUserMessage &&
                                            message.text != "..." &&
                                            index != 0 &&
                                            message.responseId != "" &&
                                            message.responseId != null)
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 70),
                                            child: FeedbackRow(
                                              onFeedbackSelected:
                                                  (isPositive) async {
                                                return await _controller
                                                    .rateResponse(
                                                        message.responseId!,
                                                        "",
                                                        isPositive);
                                              },
                                              onSendFeedback: () async {
                                                return showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        NegativeFeedbackDialog(
                                                            textController:
                                                                _controller
                                                                    .negativeFeedbackController,
                                                            onConfirm:
                                                                () async {
                                                              bool success = await _controller
                                                                  .rateResponse(
                                                                      message
                                                                          .responseId!,
                                                                      _controller
                                                                          .negativeFeedbackController
                                                                          .text,
                                                                      false);
                                                              if (success) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true);
                                                              }
                                                            },
                                                            onCancel: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }));
                                              },
                                            ),
                                          ),
                                        if (message.documents != null)
                                          for (var document
                                              in message.documents!)
                                            BellaDocumentMessage(
                                                documentName:
                                                    document?.description ??
                                                        'Nome não fornecido',
                                                isDownloading:
                                                    state is IaBellaDownloadingState &&
                                                            document?.id ==
                                                                state.documentId
                                                        ? true
                                                        : false,
                                                isRendering:
                                                    state is IaBellaRenderingPdfState &&
                                                            document?.id ==
                                                                state.documentId
                                                        ? true
                                                        : false,
                                                onVisualizePressed: () {
                                                  if (document?.id != null) {
                                                    _controller.renderPdf(
                                                        context,
                                                        document!.id!,
                                                        document.serviceType ??
                                                            "");
                                                  }
                                                },
                                                onDownloadPressed: () {
                                                  if (document?.id != null) {
                                                    _controller.downloadPdf(
                                                        document!.id!,
                                                        document.serviceType ??
                                                            "");
                                                  }
                                                }),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (_showChips)
                              SizedBox(
                                height: 40,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: _chips.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    return ActionChip(
                                      backgroundColor: Colors.grey.shade100,
                                      label: Row(
                                        children: [
                                          Text(_chips[index],
                                              style: TextStyle(
                                                  color: LelloTheme.palleteOf(
                                                          theme)
                                                      .primary())),
                                          const SizedBox(width: 4),
                                          Icon(Icons.search,
                                              size: 18,
                                              color: LelloTheme.palleteOf(theme)
                                                  .primary()),
                                        ],
                                      ),
                                      onPressed: () {
                                        if (state is! IaBellaLoadingState &&
                                            _controller.isSessionStarted) {
                                          setState(() {
                                            _showChips = false;
                                          });
                                          _controller.sendMessage(
                                            context,
                                            BellaMessageEntity(
                                              text: _chipPrompts[index],
                                              displayText:
                                                  _chipDisplayTexts[index],
                                              isUser: true,
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _controller.messageController,
                                      decoration: InputDecoration(
                                        hintText: getStringWithParams(
                                          context,
                                          'bella_message_hint',
                                          [FlavorConfig.config.iaName],
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                      ),
                                      enabled: state is! IaBellaLoadingState &&
                                          _controller.isSessionStarted,
                                    ),
                                  ),
                                  SizedBox(width: Dimens.spacingSmall),
                                  GestureDetector(
                                    onTap: () {
                                      _sendMessage();
                                    },
                                    child: SvgPicture.asset(
                                      'assets/ic_send_message.svg',
                                      width: 36,
                                      height: 39,
                                      colorFilter: ColorFilter.mode(
                                          theme.primaryColor, BlendMode.srcIn),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      getStringWithParams(
                                        context,
                                        'bella_error_warning_title',
                                        [FlavorConfig.config.iaName],
                                      ),
                                      textAlign: TextAlign.center,
                                      style: LelloTextStyles.bodyBold(theme)!
                                          .copyWith(color: theme.primaryColor),
                                    ),
                                    // const SizedBox(height: 8),
                                    // Text(
                                    //   getString(context,
                                    //       'bella_error_warning_subtitle'),
                                    //   textAlign: TextAlign.center,
                                    //   style: LelloTextStyles.body(theme)!
                                    //       .copyWith(color: theme.primaryColor),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ),
        );
      },
    );
  }
}
