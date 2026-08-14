import 'dart:io';

import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_bloc.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_state.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as Image;

class LoginTabletListOfflinePoints extends StatefulWidget {
  final Function(LoginTabletSteps newStep) changeStep;
  final String condoRef;
  const LoginTabletListOfflinePoints({
    super.key,
    required this.changeStep,
    required this.condoRef,
  });

  @override
  State<LoginTabletListOfflinePoints> createState() =>
      _LoginTabletListOfflinePointsState();
}

class _LoginTabletListOfflinePointsState
    extends State<LoginTabletListOfflinePoints> {
  AuthenticationTabletBloc bloc =
      ApplicationContainer.instance().resolve<AuthenticationTabletBloc>();

  @override
  void initState() {
    super.initState();
    bloc.getNoAuthPoints(widget.condoRef);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        widget.changeStep(LoginTabletSteps.condominiumName);
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    widget.changeStep(LoginTabletSteps.condominiumName);
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
                SizedBox(width: Dimens.spacingSmall),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Pontos pendentes de sincronização",
                    style: LelloTextStyles.subtitleBold(theme),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimens.spacingMedium),
            OutlinedButton.icon(
              icon: const Icon(Icons.sync),
              label: const Text("Enviar pontos"),
              onPressed: () {
                bloc.sendNoAuthPoints(widget.condoRef);
              },
            ),
            BlocBuilder<AuthenticationTabletBloc, AuthenticationTabletState>(
              bloc: bloc,
              builder: (context, state) {
                if (state is AuthenticationTabletLoadingState ||
                    state is AuthenticationTabletInitialState) {
                  return _builLoading(context, theme);
                }
                if (state is AuthenticationTabletFailedState) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top: Dimens.spacingSmall),
                            child: Column(
                              children: [
                                Text(
                                  "Falha ao buscar/enviar pontos.",
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                      color:
                                          LelloTheme.palleteOf(theme).error()),
                                ),
                                OutlinedButton(
                                    onPressed: () =>
                                        bloc.getNoAuthPoints(widget.condoRef),
                                    child: const Text("Tentar novamente"))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (state is AuthenticationNoAuthPointsLoadedState) {
                  if (state.points.isNotEmpty == true) {
                    return Expanded(
                      child: _buildList(state, theme),
                    );
                  } else {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              padding:
                                  EdgeInsets.only(top: Dimens.spacingSmall),
                              child: Text(
                                "Não encontramos nenhum ponto pendente para envio.",
                                style: LelloTextStyles.body(theme)?.copyWith(
                                    color: LelloTheme.palleteOf(theme).error()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  ListView _buildList(
      AuthenticationNoAuthPointsLoadedState state, ThemeData theme) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: state.points.length,
        itemBuilder: (context, index) {
          var item = state.points[index];
          return Card(
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.spacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          child: Image.Image.file(File(item.photoPath)),
                        ),
                      ),
                      noAuthPointData(
                        theme,
                        "Data",
                        "${item.dateFormatted} às ${item.timeFormatted}",
                      ),
                      noAuthPointData(
                        theme,
                        "Status",
                        enumToString(item.status) ?? "",
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      noAuthPointData(
                        theme,
                        "Tipo de ponto",
                        enumToString(item.typePoint) ?? "",
                      ),
                      noAuthPointData(
                        theme,
                        "Latitude",
                        item.latitude.isEmpty ? "-" : item.latitude,
                      ),
                      noAuthPointData(
                        theme,
                        "Longitude",
                        item.longitude.isEmpty ? "-" : item.longitude,
                      ),
                    ],
                  ),
                  noAuthPointData(
                    theme,
                    "Referência*",
                    item.reference ?? "-",
                  ),
                  noAuthPointData(
                    theme,
                    "Número de cadastro*",
                    item.numCad ?? "-",
                  ),
                  noAuthPointData(
                    theme,
                    "Número crachá*",
                    item.numCra ?? "-",
                  ),
                  noAuthPointDataWidget(
                    theme,
                    "Logs",
                    LoginTabletListOfflinePointsLogs(item: item),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _builLoading(BuildContext context, ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: Dimens.spacingMedium),
          const Center(child: CircularProgressIndicator()),
          SizedBox(height: Dimens.spacing),
          Text(
            getString(context, "please_wait",
                defaultText: "Por favor, aguarde"),
            style: LelloTextStyles.body(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
        ],
      ),
    );
  }

  Widget noAuthPointData(ThemeData theme, String title, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).hubText(),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          info,
          style: LelloTextStyles.body(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).hubText(),
          ),
          softWrap: true,
        ),
        SizedBox(height: Dimens.spacingSmall),
      ],
    );
  }

  Widget noAuthPointDataWidget(ThemeData theme, String title, Widget info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).hubText(),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        info,
        SizedBox(height: Dimens.spacingSmall),
      ],
    );
  }
}

class LoginTabletListOfflinePointsLogs extends StatefulWidget {
  const LoginTabletListOfflinePointsLogs({
    super.key,
    required this.item,
  });

  final DigitalPointEntity item;

  @override
  State<LoginTabletListOfflinePointsLogs> createState() =>
      _LoginTabletListOfflinePointsLogsState();
}

class _LoginTabletListOfflinePointsLogsState
    extends State<LoginTabletListOfflinePointsLogs> {
  @override
  Widget build(BuildContext context) {
    widget.item.logs?.sort((a, b) => (a.date.compareTo(b.date)));
    var lastLog = widget.item.logs?.lastOrNull();

    if (lastLog == null) return const Text("-");

    return ExpansionTile(
      title: Text(
          "${DateFormat("dd/MM/yyyy HH:mm").format(lastLog.date)} - ${lastLog.description}",
          style: const TextStyle(fontSize: 14)),
      tilePadding: const EdgeInsets.all(2),
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildLogs(widget.item.logs))
      ],
    );
  }

  List<Widget> _buildLogs(List<DigitalPointLogData>? logs) {
    return logs?.isNotEmpty == true
        ? logs!
            .map((e) => Text(
                "${DateFormat("dd/MM/yyyy HH:mm").format(e.date)} - ${e.description}"))
            .toList()
        : [const Text("-")];
  }
}
