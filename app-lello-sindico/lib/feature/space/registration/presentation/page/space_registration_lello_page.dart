import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/presentation/failure_message.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/lello/space_registration_lello_state.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_features/shared_features.dart' as shared;

class SpaceRegistrationLelloPage extends StatefulWidget {
  @override
  _SpaceRegistrationLelloPageState createState() =>
      _SpaceRegistrationLelloPageState();
}

class _SpaceRegistrationLelloPageState
    extends State<SpaceRegistrationLelloPage> {
  final _formKey = GlobalKey<FormState>();
  final Validator _validator = ApplicationContainer.instance().resolve();
  final SpaceRegistrationLelloBloc bloc =
      ApplicationContainer.instance().resolve();
  PackageInfo? packageInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    return Theme(
        data: theme,
        child: Scaffold(
            appBar: PrimaryAppBar(
              title: changeLelloForCompanyName(
                  context, "space_list_request_lello"),
              theme: theme,
            ),
            body: BlocConsumer(
                bloc: bloc,
                listener: (context, state) {
                  if (state is SpaceRegistrationLelloRegisteredState) {
                    pushNamedAndPopUntil(
                        context,
                        ApplicationRoute.spaceRegistrationLelloSuccess,
                        ModalRoute.withName(ApplicationRoute.spaceList));
                  }
                },
                builder: (context, state) =>
                    _buildForm(theme, state as SpaceRegistrationLelloState))));
  }

  Widget _buildForm(ThemeData theme, SpaceRegistrationLelloState state) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        children: [
          _buildFormItem(theme,
              title: getString(context, "space_registration_lello_what_space"),
              field: PrimaryTextFormField(
                initialValue: state.data.space ?? "",
                onSaved: (value) {
                  setState(() {
                    state.data.space = value;
                  });
                },
                validator: (value) => _validator.validateRequired(value),
                textInputType: TextInputType.text,
              )),
          SizedBox(height: Dimens.spacingSmall),
          state is SpaceRegistrationLelloRegisterFailedState
              ? Text(FailureMessage.get(context, state.error),
                  style: LelloTextStyles.error(theme),
                  textAlign: TextAlign.center)
              : Container(),
          SizedBox(height: Dimens.spacing),
          Visibility(
            visible: state is! SpaceRegistrationLelloRegisteringState,
            replacement: const Center(child: CircularProgressIndicator()),
            child: PrimaryButton(
              onPressed: () {
                _save();
              },
              text: getString(context, "send"),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFormItem(ThemeData theme, {String? title, Widget? field}) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        title ?? "",
        style: LelloTextStyles.bodyBold(theme),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: Dimens.spacingSmall),
        child: field ?? Container(),
      ),
    );
  }

  void _save() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      bloc.beginRegister(bloc.state.data);
    }
  }

  bool _isGeneric() {
    String packageName = _getPackageName();
    return packageName == shared.SharedPreferencesKeys.genericSindico ||
        packageName == shared.SharedPreferencesKeys.iosGenericSindico;
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
