import 'dart:convert';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/core/widgets/custom_app_bar.dart';
import 'package:colaborador/core/widgets/loading_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:colaborador/feature/sick_note/presentation/bloc/sick_note_bloc.dart';
import 'package:colaborador/feature/sick_note/presentation/bloc/sick_note_state.dart';
import 'package:colaborador/feature/sick_note/presentation/widgets/sick_note_document_form.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SickNotePage extends StatefulWidget {
  const SickNotePage({
    Key? key,
  }) : super(key: key);

  @override
  State<SickNotePage> createState() => _SickNotePageState();
}

class _SickNotePageState extends State<SickNotePage> {
  late SickNoteBloc bloc;

  SickNoteEntity sickNote = SickNoteEntity();

  @override
  void initState() {
    super.initState();
    bloc = ApplicationContainer.instance().resolve();
  }

  @override
  Widget build(BuildContext context) {
    var fileMaxSizePermitted = _getFileMaxSizePermitted(context);
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<SickNoteBloc, SickNoteState>(
        listener: (context, state) {
          if (state is SickNoteRegisterFailedState) {
            Navigator.pushNamed(
              context,
              ApplicationRoute.sickNoteRegisterError,
            );
          } else if (state is SickNoteRegisterLoadedState) {
            Navigator.pushReplacementNamed(
              context,
              ApplicationRoute.sickNoteRegisterSuccess,
            );
          }
        },
        builder: (context, state) {
          if (state is SickNoteLoadingState) {
            return const Scaffold(
              body: Center(
                child: LoadingWidget(),
              ),
            );
          }
          return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              return true;
            },
            child: Theme(
              data: theme,
              child: Scaffold(
                appBar: const CustomAppBar(title: "sick_note_title"),
                body: _sickNotePageBody(
                    fileMaxSizePermitted: fileMaxSizePermitted),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sickNotePageBody({required int fileMaxSizePermitted}) {
    return SickNoteDocumentForm(
      sickNote: sickNote,
      sendSickNoteFunction: () {
        bloc.sendSickNote(
            date: sickNote.date!,
            file: sickNote.file!,
            sickNoteDays: sickNote.sickNoteDays);
      },
      maxFileSizePermitted: fileMaxSizePermitted,
    );
  }

  static _getFileMaxSizePermitted(BuildContext context) {
    SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();
    FirebaseRemoteConfig? remoteConfig = sessionBloc.remoteConfig;
    int defaultValue = 10485760;
    try {
      if (remoteConfig != null) {
        var fileMaxSizePermitted = jsonDecode(remoteConfig
            .getString(CustomFirebaseRemoteConfig.fileMaxSizePermitted));
        return fileMaxSizePermitted ?? defaultValue;
      }
    } catch (err) {
      return defaultValue;
    }
  }
}
