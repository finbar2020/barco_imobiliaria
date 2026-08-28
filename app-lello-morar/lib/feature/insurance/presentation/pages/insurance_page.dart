import 'dart:io';

import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_bloc.dart';
import 'package:morar/feature/insurance/presentation/bloc/insurance_state.dart';
import 'package:morar/feature/insurance/presentation/controller/insurance_controller.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_cancel_page.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_success_page.dart';
import 'package:morar/feature/insurance/presentation/widget/insurance_contract_dialog.dart';
import 'package:morar/feature/insurance/presentation/widget/insurance_table.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';

class InsurancePageArgs {
  InsurancePageArgs();
}

class InsurancePage extends StatefulWidget {
  const InsurancePage({Key? key}) : super(key: key);

  @override
  _InsurancePageState createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  List<String> images = [
    "assets/ic_chaveiro.png",
    "assets/ic_eletricista.png",
    "assets/ic_encanador.png",
    "assets/ic_vidraceiro.png",
  ];

  bool checkedBox = false;

  final formatCurrency = new NumberFormat.currency(symbol: "R\$");

  late InsuranceController controller;
  late SessionBloc sessionBloc;

  @override
  void initState() {
    super.initState();
    controller = ApplicationContainer.instance().resolve<InsuranceController>();
    controller.getInsurance();
    sessionBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Platform.isIOS
        ? GestureDetector(
            onPanUpdate: (details) {
              if (details.delta.dx > 0) {
                Navigator.of(context).pop();
              }
            },
            child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: _buildScaffold(theme),
            ))
        : WillPopScope(
            child: _buildScaffold(theme),
            onWillPop: () async {
              Navigator.of(context).pop();
              return true;
            });
  }

  Scaffold _buildScaffold(ThemeData theme) {
    return Scaffold(
      body: BlocConsumer(
        bloc: controller.bloc,
        listener: (context, state) {
          if (state is LoadedInsuranceState) {
            if (state.isPost) {
              state.isCancel
                  ? Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsuranceCancelPage(),
                      ),
                    )
                  : Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InsuranceSuccessPage()),
                    );
            }
          }
        },
        builder: (context, state) {
          if (state is LoadingInsuranceState) {
            return Center(
              child: LoadingWidget(),
            );
          }
          if (state is FailedInsuranceState) {
            return _buildFailed(context);
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: theme.primaryColor,
                  width: double.infinity,
                  child: SafeArea(
                    left: false,
                    right: false,
                    bottom: false,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Image.asset(
                            "assets/ic_seguro_banner.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                            left: 20.0,
                            top: 5,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      BlocBuilder(
                        bloc: controller.bloc,
                        builder: (context, state) {
                          if (state is LoadedInsuranceState) {
                            if (state.model?.contratado == true) {
                              return Column(
                                children: [
                                  PrimaryButton(
                                    onPressed: () {
                                      Launch.tel(
                                          context,
                                          state.insuranceData.telefone
                                              .replaceAll(
                                                  RegExp(r'[^a-zA-Z0-9 ]'),
                                                  ""));
                                    },
                                    text: "Acionar Assistência 24h",
                                  ),
                                  SizedBox(height: Dimens.spacingMedium),
                                ],
                              );
                            }
                            if (state.model?.contratar == true) {
                              return Column(
                                children: [
                                  IgnorePointer(
                                    ignoring: !checkedBox,
                                    child: Opacity(
                                      opacity: checkedBox ? 1.0 : 0.5,
                                      child: Container(
                                        width: double.infinity,
                                        child: PrimaryButton(
                                          text: getString(context,
                                              "insurance_contract_insurance_house"),
                                          onPressed: () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) =>
                                                  InsuranceContractDialog(
                                                      controller: controller),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Dimens.spacingMedium),
                                ],
                              );
                            }
                            // Os textos informativos do plano (custo maximo ou nao) sao
                            // renderizados pelo BlocBuilder seguinte; os Columns que
                            // existiam aqui eram construidos e descartados (sem return).
                          }
                          return Container();
                        },
                      ),
                      BlocBuilder(
                        bloc: controller.bloc,
                        builder: (context, state) {
                          if (state is LoadedInsuranceState) {
                            if (state.model?.insuranceData?.cost ==
                                controller.maxCost) {
                              return Column(
                                children: [
                                  Text(
                                    "Agora você conta com a nossa ajuda para aqueles momentos em que um cano estourar, a máquina de lavar pifar, ou ainda algum outro acidente acontecer!",
                                    textAlign: TextAlign.center,
                                    style: LelloTextStyles.bodyBold(theme)!
                                        .copyWith(color: Color(0xFF484848)),
                                  ),
                                  SizedBox(height: Dimens.spacingMedium),
                                  Text(
                                    "Oferecer a melhor cobertura do mercado contra possíveis acidentes do dia a dia faz parte do nosso propósito em garantir a sua comodidade.",
                                    textAlign: TextAlign.center,
                                    style: LelloTextStyles.body(theme)!
                                        .copyWith(color: Color(0xFF484848)),
                                  ),
                                  SizedBox(height: Dimens.spacingMedium),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: new TextSpan(
                                      style: LelloTextStyles.body(theme)!
                                          .copyWith(color: Color(0xFF484848)),
                                      children: <TextSpan>[
                                        TextSpan(text: "Com o seguro "),
                                        TextSpan(
                                            text: "Casa Protegida Lello",
                                            style: LelloTextStyles.bodyBold(
                                                    theme)!
                                                .copyWith(
                                                    color: theme.primaryColor)),
                                        TextSpan(text: ", você garante "),
                                        TextSpan(
                                            text: "proteção",
                                            style:
                                                LelloTextStyles.bodyBold(theme)!
                                                    .copyWith(
                                                        color:
                                                            Color(0xFF5C0521))),
                                        TextSpan(text: " e "),
                                        TextSpan(
                                            text: "cuidado",
                                            style:
                                                LelloTextStyles.bodyBold(theme)!
                                                    .copyWith(
                                                        color:
                                                            Color(0xFF5C0521))),
                                        TextSpan(text: " para o seu lar"),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            if (!(state.model?.insuranceData?.cost ==
                                controller.maxCost)) {
                              return Column(
                                children: [
                                  Text(
                                    "Proporcionar tranquilidade, segurança para você e sua família é o nosso objetivo.",
                                    textAlign: TextAlign.center,
                                    style: LelloTextStyles.bodyBold(theme)!
                                        .copyWith(color: Color(0xFF484848)),
                                  ),
                                  SizedBox(height: Dimens.spacingMedium),
                                  Text(
                                    "Por isso, oferecer a melhor cobertura do mercado contra possíveis acidentes do dia a dia faz parte do nosso propósito em garantir a sua comodidade.",
                                    textAlign: TextAlign.center,
                                    style: LelloTextStyles.body(theme)!
                                        .copyWith(color: Color(0xFF484848)),
                                  ),
                                ],
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                      BlocBuilder(
                        bloc: controller.bloc,
                        builder: (context, state) {
                          if (state is LoadedInsuranceState) {
                            if (state.model?.indisponivel == true) {
                              return _buildNoInsuranceInformative(theme);
                            }
                          }
                          return Container();
                        },
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      Text(
                        "Coberturas Especiais",
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.bodyBold(theme)!
                            .copyWith(color: theme.primaryColor),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      BlocBuilder(
                        bloc: controller.bloc,
                        builder: (context, state) {
                          if (state is LoadedInsuranceState) {
                            if (state.model?.insuranceData?.cost ==
                                controller.minCost) {
                              return SvgPicture.asset(
                                "assets/ic_seguro_coberturas_especiais.svg",
                                fit: BoxFit.cover,
                              );
                            }
                            if (state.model?.insuranceData?.cost ==
                                controller.maxCost) {
                              return SvgPicture.asset(
                                "assets/ic_seguro_coberturas_especiais_max_cost.svg",
                                height: 300,
                                fit: BoxFit.fill,
                              );
                            }
                            return SvgPicture.asset(
                              "assets/ic_seguro_coberturas_especiais_completa.svg",
                              fit: BoxFit.cover,
                            );
                          }
                          return Container();
                        },
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      BlocBuilder(
                        bloc: controller.bloc,
                        builder: (context, state) {
                          if (state is LoadedInsuranceState &&
                              !(state.model?.insuranceData?.cost ==
                                  controller.maxCost)) {
                            return Column(
                              children: [
                                Text(
                                  "Serviços de Assistência 24h\n quando você mais precisar:",
                                  textAlign: TextAlign.center,
                                  style: LelloTextStyles.bodyBold(theme)!
                                      .copyWith(color: theme.primaryColor),
                                ),
                                SizedBox(height: Dimens.spacingMedium),
                                SvgPicture.asset(
                                  "assets/ic_seguro_assistencia.svg",
                                  fit: BoxFit.cover,
                                ),
                              ],
                            );
                          }
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "E com assistência 24hs, além de cobertura completa nas linhas branca e marrom!",
                                textAlign: TextAlign.center,
                                style: LelloTextStyles.bodyBold(theme)!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      BlocBuilder(
                        bloc: controller.bloc,
                        builder: (context, state) {
                          if (state is LoadingInsuranceState) {
                            return Center(
                              child: LoadingWidget(),
                            );
                          }

                          if (state is LoadedInsuranceState) {
                            if (state.model?.contratado == true) {
                              return _buildCancelInsurance(state, context,
                                  controller.bloc, theme, sessionBloc);
                            }
                            if (state.model?.contratar == true) {
                              return _buildBuyInsurance(
                                  state, controller.bloc, sessionBloc, theme);
                            }
                            if (state.model?.cancelamentoPendente == true) {
                              return _buildCancelPendingInsurance(
                                  state, context, controller.bloc, theme);
                            }
                            if (state.model?.contratacaoPendente == true) {
                              return _buildBuyPendingInsurance(
                                  state, context, controller.bloc, theme);
                            }
                            if (state.model?.indisponivel == true) {
                              return _buildNoInsurance(
                                  state, context, controller.bloc, theme);
                            }
                          }
                          return Container();
                        },
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      BlocBuilder(
                        bloc: controller.bloc,
                        builder: (context, state) {
                          if (state is LoadedInsuranceState) {
                            if (state.model?.insuranceData?.cost ==
                                    controller.maxCost) {
                              return Container(
                                width: double.infinity,
                                child: Image.asset(
                                  "assets/descricao_casa_protegida.png",
                                  fit: BoxFit.fill,
                                ),
                              );
                            }
                          }
                          return Container(
                            width: double.infinity,
                            child: Image.asset(
                              "assets/descricao_casa_protegida.png",
                              fit: BoxFit.fill,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Column _buildNoInsuranceInformative(ThemeData theme) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacingMedium),
        RichText(
          textAlign: TextAlign.center,
          text: new TextSpan(
            style:
                LelloTextStyles.body(theme)!.copyWith(color: Color(0xFF484848)),
            children: <TextSpan>[
              TextSpan(text: "Com o seguro "),
              TextSpan(
                  text: "Casa Protegida Lello",
                  style: LelloTextStyles.bodyBold(theme)!
                      .copyWith(color: theme.primaryColor)),
              TextSpan(text: ", você garante "),
              TextSpan(
                  text: "proteção",
                  style: LelloTextStyles.bodyBold(theme)!
                      .copyWith(color: Color(0xFF5C0521))),
              TextSpan(text: " e "),
              TextSpan(
                  text: "cuidado",
                  style: LelloTextStyles.bodyBold(theme)!
                      .copyWith(color: Color(0xFF5C0521))),
              TextSpan(text: " para o seu lar"),
            ],
          ),
        ),
        SizedBox(height: Dimens.spacingMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/ic_seguro_cobertura_dano.png",
              height: 40,
              width: 40,
            ),
            SizedBox(width: Dimens.spacing),
            Expanded(
              child: RichText(
                text: new TextSpan(
                  style: LelloTextStyles.body(theme)!
                      .copyWith(color: Color(0xFF5C0521)),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Cobertura para danos ",
                        style: LelloTextStyles.body(theme)!.copyWith(
                          color: Color(0xFF5C0521),
                          fontWeight: FontWeight.w700,
                        )),
                    TextSpan(
                        text:
                            "na sua unidade, unidades vizinhas e até em áreas comuns do condomínio.",
                        style: LelloTextStyles.body(theme)!
                            .copyWith(color: Color(0xFF5C0521))),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/ic_seguro_sorteio_mensal.png",
              height: 40,
              width: 40,
            ),
            SizedBox(width: Dimens.spacing),
            Text(
              "Sorteios mensais de R\$ 10.000,00*",
              style: LelloTextStyles.bodyBold(theme)!
                  .copyWith(color: Color(0xFF5C0521)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              "assets/ic_seguro_contratacao.png",
              height: 40,
              width: 40,
            ),
            SizedBox(width: Dimens.spacing),
            Expanded(
              child: RichText(
                text: new TextSpan(
                  style: LelloTextStyles.body(theme)!
                      .copyWith(color: Color(0xFF5C0521)),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Contratação por menos de ",
                        style: LelloTextStyles.body(theme)!.copyWith(
                          color: Color(0xFF5C0521),
                        )),
                    TextSpan(
                        text: " R\$ 1,70 por dia",
                        style: LelloTextStyles.bodyBold(theme)!.copyWith(
                          color: Color(0xFF5C0521),
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimens.spacing),
      ],
    );
  }

  Column _buildFailed(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: UnexpectedErrorWidget(),
          ),
        ),
      ],
    );
  }

  Column _buildNoInsurance(LoadedInsuranceState state, BuildContext context,
      InsuranceBloc bloc, ThemeData theme) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacing),
        Container(
          decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Em breve, o Seguro Casa Protegida Lello estará disponível no seu condomínio",
              textAlign: TextAlign.center,
              style: LelloTextStyles.bodyBold(theme)!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacingMedium),
        _buildCentralButton(state, theme, context),
        SizedBox(height: Dimens.spacingXSmall),
        _buildAssistenciaButton(state, theme, context)
      ],
    );
  }

  Column _buildCancelPendingInsurance(LoadedInsuranceState state,
      BuildContext context, InsuranceBloc bloc, ThemeData theme) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacing),
        Divider(),
        SizedBox(height: Dimens.spacing),
        Text(
          getString(context, "insurance_in_progress_cancellation"),
          style: LelloTextStyles.body(theme)!.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        SizedBox(height: Dimens.spacing),
        Divider(),
        SizedBox(height: Dimens.spacing),
      ],
    );
  }

  Column _buildBuyPendingInsurance(LoadedInsuranceState state,
      BuildContext context, InsuranceBloc bloc, ThemeData theme) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacing),
        Divider(),
        SizedBox(height: Dimens.spacing),
        Text(
          getString(context, "insurance_in_progress_contracting"),
          style: LelloTextStyles.body(theme)!.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.primaryColor,
          ),
        ),
        SizedBox(height: Dimens.spacing),
        Divider(),
        SizedBox(height: Dimens.spacing),
      ],
    );
  }

  Column _buildCancelInsurance(LoadedInsuranceState state, BuildContext context,
      InsuranceBloc bloc, ThemeData theme, SessionBloc sessionBloc) {
    return Column(
      children: [
        InsuranceTable(
            model: state.insuranceData, selectedPremium: state.selectedPremium),
        SizedBox(height: Dimens.spacing),
        RichText(
          text: TextSpan(
            text: "* Consultar os ",
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
            children: <TextSpan>[
              TextSpan(
                text: "termos de uso e condições gerais",
                style: LelloTextStyles.caption(theme)!.copyWith(
                    color: Colors.black,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                    fontWeight: FontWeight.w700),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () async {
                    UrlLauncherNative.openUrl(controller.linkTermos);
                  },
              ),
              TextSpan(
                text: " do plano ",
                style: LelloTextStyles.caption(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).hubText(),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimens.spacing),
        Container(
          width: double.infinity,
          child: PrimaryButton(
            text: "Acionar Assistência 24h",
            onPressed: () {
              Launch.tel(
                  context,
                  state.insuranceData.telefone
                      .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ""));
            },
          ),
        ),
        SizedBox(height: Dimens.spacing),
        TextButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Color(0xFFDDDDDD)),
          ),
          child: Text(
            getString(context, "insurance_cancel_hiring"),
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: Color(0xFF5C0521),
            ),
          ),
          onPressed: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) =>
                  _buildDeleteDialog(context, bloc, theme, sessionBloc),
            );
          },
        ),
        SizedBox(height: Dimens.spacing),
        _buildCentralButton(state, theme, context),
        SizedBox(height: Dimens.spacing),
        _buildAssistenciaButton(state, theme, context),
      ],
    );
  }

  Column _buildBuyInsurance(LoadedInsuranceState state, InsuranceBloc bloc,
      SessionBloc sessionBloc, ThemeData theme) {
    return Column(
      children: [
        SizedBox(height: Dimens.spacing),
        InsuranceTable(
          model: state.insuranceData,
          selectedPremium: state.selectedPremium,
        ),
        SizedBox(height: Dimens.spacing),
        Text("* Consultar os termos de uso e condições gerais do plano",
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            )),
        SizedBox(height: Dimens.spacing),
        PrimaryButton(
            height: 90.0,
            buttonColor: Color(0xFF64001F),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Apenas",
                    style: LelloTextStyles.body(theme)!
                        .copyWith(color: Colors.white),
                  ),
                  Text(
                    "${formatCurrency.format(state.model?.insuranceData!.cost)}/mês",
                    style: LelloTextStyles.title(theme)!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {}),
        SizedBox(height: Dimens.spacing),
        Row(
          children: [
            Checkbox(
              onChanged: (value) {
                setState(() {
                  checkedBox = !checkedBox;
                });
              },
              value: checkedBox,
            ),
            Expanded(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: getString(context, "insurance_terms_title"),
                  style: LelloTextStyles.caption(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "termos de uso e condições gerais.",
                      style: LelloTextStyles.caption(theme)!.copyWith(
                          color: Color(0xFF484848),
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF484848)),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () async {
                          if (state.model?.insuranceData?.cost ==
                              controller.minCost) {
                            UrlLauncherNative.openUrl(controller.linkTermos);
                            return;
                          }
                          UrlLauncherNative.openUrl(
                              controller.linkTermosCompleto);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimens.spacing),
        IgnorePointer(
          ignoring: !checkedBox,
          child: Opacity(
            opacity: checkedBox ? 1.0 : 0.5,
            child: Container(
              width: double.infinity,
              child: PrimaryButton(
                text: getString(context, "insurance_contract_insurance_house"),
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) =>
                        InsuranceContractDialog(controller: controller),
                  );
                },
              ),
            ),
          ),
        ),
        SizedBox(height: Dimens.spacing),
        _buildCentralButton(state, theme, context),
        SizedBox(height: Dimens.spacing),
        _buildAssistenciaButton(state, theme, context),
      ],
    );
  }

  Dialog _buildDeleteDialog(BuildContext context, InsuranceBloc bloc,
      ThemeData theme, SessionBloc sessionBloc) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: getString(context, "insurance_want_cancel"),
                style: LelloTextStyles.body(theme),
                children: <TextSpan>[
                  TextSpan(
                    text: "Casa Protegida Lello?",
                    style: LelloTextStyles.body(theme)!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "insurance_home_no_care"),
              style: LelloTextStyles.caption(theme),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      getString(context, "back").toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      controller.postInsurance(true);
                    },
                    child: Text(
                      getString(context, "confirm").toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildAssistenciaButton(
      LoadedInsuranceState state, ThemeData theme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PrimaryButton(
        buttonColor: Color(0xFF5C0521),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/ic_seguro_phone_assistencia.svg"),
            SizedBox(width: Dimens.spacing),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                    "Assistência 24 horas Vila Velha\n ${state.insuranceData.assistencia}",
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.button(theme)),
              ),
            ),
          ],
        ),
        onPressed: () {
          Clipboard.setData(ClipboardData(
                  text: state.insuranceData.assistencia
                      .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), "")))
              .then((value) {
            return Flushbar(
              duration: Duration(seconds: 3),
              message: "Número de telefone copiado",
            )..show(context);
          });
        },
      ),
    );
  }

  Padding _buildCentralButton(
      LoadedInsuranceState state, ThemeData theme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: PrimaryButton(
        buttonColor: Color(0xFF1A69A9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/ic_seguro_phone_central.svg"),
            SizedBox(width: Dimens.spacing),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                    "Central de Atendimento Vila Velha\n ${state.insuranceData.telefone}",
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.button(theme)),
              ),
            ),
          ],
        ),
        onPressed: () {
          Clipboard.setData(ClipboardData(
                  text: state.insuranceData.telefone
                      .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), "")))
              .then((value) {
            return Flushbar(
              duration: Duration(seconds: 3),
              message: "Número de telefone copiado",
            )..show(context);
          });
        },
      ),
    );
  }
}
