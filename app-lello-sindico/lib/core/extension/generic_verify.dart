import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class GenericChanges {
  static String changeLelloForCompanyName(BuildContext context, String getText,
      bool isGeneric, SessionBloc sessionBloc) {
    if (isGeneric) {
      var textFormatted = getString(context, getText);
      if (textFormatted.isNotEmpty) {
        return textFormatted.replaceAll("Lello",
            sessionBloc.state.session?.selectedCondominium?.layout?.name ?? "");
      } else {
        return getString(context, getText);
      }
    } else {
      return getString(context, getText);
    }
  }
}
