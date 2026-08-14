import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/presentation/failure_message.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_state.dart';

class SpaceRegistrationRegisteringWidget extends StatefulWidget {
  @override
  _SpaceRegistrationRegisteringWidgetState createState() =>
      _SpaceRegistrationRegisteringWidgetState();
}

class _SpaceRegistrationRegisteringWidgetState
    extends State<SpaceRegistrationRegisteringWidget> {
  bool calledRegister = false;
  double fileProgress = 0.0;
  double pictureProgress = 0.0;
  late SpaceRegistrationBloc bloc;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bloc = BlocProvider.of(context);
    final SpaceRegistrationState state = bloc.state;

    if (!calledRegister &&
        state is! SpaceRegistrationRegisterFailedState &&
        state is! SpaceRegistrationRegisteringState &&
        state is! SpaceRegistrationRegisteredState) {
      bloc.beginRegister(bloc.state.data);
      calledRegister = true;
    }

    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            visible: state is! SpaceRegistrationRegisterFailedState,
            replacement: Text(
                state is SpaceRegistrationRegisterFailedState
                    ? FailureMessage.get(context, state.error)
                    : "",
                style: LelloTextStyles.error(theme),
                textAlign: TextAlign.center),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Aguarde.. Cadastrando seu espaço",
                  style: LelloTextStyles.title(theme)),
            ),
          ),
          SizedBox(height: Dimens.spacing),
          _buildUploadingFile(theme, state, state.data.pendingPicture!,
              "Upload da imagem", state.data.pictureUrl != null ? 100 : 0),
          _buildUploadingFile(theme, state, state.data.pendingFile!,
              "Upload do anexo", state.data.fileUrl != null ? 100 : 0),
          _buildRetry(theme, state),
          SizedBox(height: Dimens.spacing),
        ],
      ),
    );
  }

  Widget _buildRetry(ThemeData theme, SpaceRegistrationState state) {
    if (state is SpaceRegistrationUploadFailedState) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
            "Ocorreu um erro ao fazer upload dos arquivos. Por favor tente novamente",
            style: LelloTextStyles.error(theme)),
        subtitle: Padding(
          padding: EdgeInsets.only(top: Dimens.spacing),
          child: PrimaryButton(
            text: "Tentar novamente",
            onPressed: () {
              if (state.data.pendingFile != null) {
                state.data.fileUrl = null;
              }
              if (state.data.pendingPicture != null) {
                state.data.pictureUrl = null;
              }
              bloc.beginRegister(state.data);
            },
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildUploadingFile(ThemeData theme, SpaceRegistrationState state,
      File? file, String title, double defaultProgress) {
    if (file == null) return Container();
    if (state is SpaceRegistrationUploadingState && state.file == file) {
      return StreamBuilder<double>(
          stream: state.progress,
          builder: (context, progress) =>
              _buildUploadProgress(theme, progress.data ?? 0, title));
    }
    return _buildUploadProgress(theme, defaultProgress, title);
  }

  Widget _buildUploadProgress(ThemeData theme, double? progress, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: LinearProgressIndicator(
          value: (progress ?? 0) / 100,
          backgroundColor: LelloTheme.palleteOf(theme).separator()),
    );
  }
}
