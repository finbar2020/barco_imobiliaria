import 'dart:io';

import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_attachments.dart';
import 'package:lello/feature/accountability/presentation/question_list/controller/question_list_controller.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

import 'package:shared_features/shared_features.dart';

class QuestionListDetailPageArgs {
  final AccountabilityDoubt accountabilityDoubt;

  QuestionListDetailPageArgs({
    required this.accountabilityDoubt,
  });
}

class QuestionListDetailPage extends StatefulWidget {
  @override
  State<QuestionListDetailPage> createState() => _QuestionListDetailPageState();
}

class _QuestionListDetailPageState extends State<QuestionListDetailPage> {
  final QuestionListController controller =
      ApplicationContainer.instance().resolve<QuestionListController>();
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  final dateFormat = DateFormat("MMMM yyyy");

  final formattedDate = DateFormat("dd MMMM yyyy");
  final formattedDateTime = DateFormat("dd MMMM yyyy HH:mm");
  PackageInfo? packageInfo;

  late Map<String, String>? customHeader;

  @override
  void initState() {
    super.initState();
    customHeader = authenticationStore.getCustomHeader();
  }

  File? file;
  int loadingPdf = 0;
  // 0 = erro 1= loading 2= sucesso
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    QuestionListDetailPageArgs arguments = ModalRoute.of(context)!
        .settings
        .arguments as QuestionListDetailPageArgs;

    return Scaffold(
      appBar: PrimaryAppBar(
        theme: theme,
        title: getString(context, "accountability_list_question"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: BlocBuilder(
          bloc: controller.bloc,
          builder: ((context, state) {
            if (loadingPdf == 1) {
              return Column(
                children: [
                  Expanded(
                    child: LoadingWidget(
                      message: getString(context,
                          "accountability_list_question_item_loading_file"),
                    ),
                  ),
                ],
              );
            }
            return Padding(
              padding: EdgeInsets.all(Dimens.spacingMedium),
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Text(
                                arguments.accountabilityDoubt.doubtType!.name,
                                style: LelloTextStyles.subtitleBold(theme),
                              ),
                              SizedBox(height: Dimens.spacingSmall),
                              Text(
                                "${getString(context, "accountability_send_question_sumary_period")}: ${dateFormat.format(arguments.accountabilityDoubt.period)}",
                              ),
                              Text(
                                "${getString(context, "accountability_send_question_sumary_date")}: ${formattedDate.format(DateTime.now())}",
                              ),
                              SizedBox(height: Dimens.spacingSmall),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  arguments.accountabilityDoubt.message,
                                  style: LelloTextStyles.body(theme),
                                ),
                              ),
                              SizedBox(height: Dimens.spacingMedium),
                              if (arguments.accountabilityDoubt.attachments
                                      .isNotEmpty ==
                                  true)
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      getString(context,
                                          "accountability_send_question_sumary_files"),
                                      style: LelloTextStyles.titleSmall(theme)
                                          ?.copyWith(
                                        color:
                                            LelloTheme.palleteOf(theme).grey(),
                                      ),
                                    ),
                                    SizedBox(height: Dimens.spacingSmall),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: List.generate(
                                        arguments.accountabilityDoubt
                                            .attachments.length,
                                        (index) {
                                          var item = arguments
                                              .accountabilityDoubt
                                              .attachments[index];
                                          return GestureDetector(
                                            onTap: () async {
                                              final String condominiumId =
                                                  controller.codominiumId;
                                              await searchBilletPdf(
                                                item,
                                                arguments.accountabilityDoubt,
                                                condominiumId,
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(children: <Widget>[
                                                SvgPicture.asset(
                                                    "assets/ic_clips.svg"),
                                                SizedBox(
                                                    width:
                                                        Dimens.spacingXSmall),
                                                Expanded(
                                                  child: Text(
                                                    "${index + 1} - ${item.name}",
                                                    style: LelloTextStyles
                                                        .bodyBold(theme),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ]),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              if (arguments
                                      .accountabilityDoubt.answers.isNotEmpty ==
                                  true)
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: List.generate(
                                    arguments
                                        .accountabilityDoubt.answers.length,
                                    (index) {
                                      var item = arguments
                                          .accountabilityDoubt.answers[index];
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Divider(
                                            height: Dimens.spacingLarge,
                                          ),
                                          Text(
                                            changeLelloForCompanyName(context,
                                                "accountability_send_question_sumary_answer_lello"),
                                            style: LelloTextStyles.titleSmall(
                                              theme,
                                            )?.copyWith(
                                              color: LelloTheme.palleteOf(theme)
                                                  .accent(),
                                            ),
                                          ),
                                          SizedBox(
                                              height: Dimens.spacingXSmall),
                                          Text(
                                            "${getString(context, "accountability_send_question_sumary_answer_date")}: ${formattedDate.format(item.date)}",
                                            style:
                                                LelloTextStyles.subBody(theme),
                                          ),
                                          SizedBox(
                                              height: Dimens.spacingMedium),
                                          Text(item.commentary),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              SizedBox(height: Dimens.spacing),
                              PrimaryButton(
                                text: getString(context, "back"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> searchBilletPdf(
    Attachments item,
    AccountabilityDoubt doubt,
    String condominiumId,
  ) async {
    setState(
      () {
        loadingPdf = 1;
      },
    );
    if (item.id != "") {
      file = await DefaultCacheManager()
          .getSingleFile(
              "${doubt.baseUrl}/condominiums/$condominiumId/questions/file/${item.id}/download",
              headers: customHeader)
          .whenComplete(
            () => setState(
              () {
                loadingPdf = 2;
              },
            ),
          );
    } else {
      setState(
        () {
          loadingPdf = 0;
        },
      );
    }
    if (loadingPdf == 2 && file != null) {
      if (basename(item.name).split(".").last.toLowerCase() == "pdf") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(pdfFile: file, title: 'PDF'),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Image.file(
                file!,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }
    } else {
      Flushbar(
        duration: Duration(seconds: 1),
        message: getString(context, "request_fine_error_message"),
      )..show(context);
    }
  }

  bool _isGeneric() {
    String packageName = _getPackageName();
    return packageName == SharedPreferencesKeys.genericSindico ||
        packageName == SharedPreferencesKeys.iosGenericSindico;
  }

  String _getPackageName() {
    if (packageInfo != null) {
      return packageInfo!.packageName;
    } else {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
      return "";
    }
  }

  String changeLelloForCompanyName(BuildContext context, String getText) {
    if (_isGeneric()) {
      var textFormatted = getString(context, getText);
      if (textFormatted.isNotEmpty) {
        return textFormatted.replaceAll("Lello", packageInfo!.appName);
      } else {
        return getString(context, getText);
      }
    } else {
      return getString(context, getText);
    }
  }
}
