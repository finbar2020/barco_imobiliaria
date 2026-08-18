import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc_impl.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_state.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class SpaceRegistrationUsageWidget extends StatefulWidget {
  final bool shrinkList;

  const SpaceRegistrationUsageWidget({Key? key, this.shrinkList = false})
      : super(key: key);

  @override
  _SpaceRegistrationUsageWidgetState createState() =>
      _SpaceRegistrationUsageWidgetState();
}

class _SpaceRegistrationUsageWidgetState
    extends State<SpaceRegistrationUsageWidget> {
  final _formKey = GlobalKey<FormState>();
  final Validator _validator = ApplicationContainer.instance().resolve();
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  late Map<String, String>? customHeader;
  late SpaceRegistrationBloc bloc;

  @override
  void initState() {
    super.initState();
    customHeader = authenticationStore.getCustomHeader();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bloc = BlocProvider.of(context);
    _validator.context = context;
    return _buildForm(theme);
  }

  Widget _buildHeader(ThemeData theme, SpaceRegistrationState state) {
    final steps = SpaceRegistrationBlocImpl.stepOrder;
    final currentStep = steps.indexOf(state.step!);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
          sprintf(getString(context, "register_payment_step"),
              [currentStep + 1, steps.length - 1]),
          style: LelloTextStyles.caption(theme)),
      subtitle: Text(getString(context, "space_registration_usage_title"),
          style: LelloTextStyles.subtitleBold(theme)),
      trailing:
          StepIndicator(numberOfSteps: steps.length, currentStep: currentStep),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return BlocBuilder<SpaceRegistrationBloc, SpaceRegistrationState>(
      bloc: bloc,
      builder: (context, state) => Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: widget.shrinkList,
          physics:
              widget.shrinkList ? const NeverScrollableScrollPhysics() : null,
          padding: EdgeInsets.all(Dimens.spacingMedium).copyWith(top: 0),
          children: [
            _buildHeader(theme, state),
            _buildRegulationButton(theme, state),
            _buildUploadButton(theme, state),
            SizedBox(height: Dimens.spacingMedium),
            _buildFormItem(theme,
                title: getString(context, "space_registration_usage_term"),
                field: PrimaryTextFormField(
                  initialValue: bloc.state.data.term,
                  onSaved: (value) {
                    bloc.state.data.term = value;
                  },
                  onFieldSubmitted: (_) => _nextFocus(),
                  textInputType: TextInputType.multiline,
                )),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              onPressed: () {
                _save();
              },
              text: getString(context, "next"),
            ),
            SizedBox(height: Dimens.spacing),
            SecondaryButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              text: getString(context, "back"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(ThemeData theme, SpaceRegistrationState state) {
    if (state.data.pendingFile != null) {
      return ListTile(
        onTap: () {
          setState(() {
            state.data.pendingFile = null;
          });
        },
        contentPadding: EdgeInsets.zero,
        leading: SvgPicture.asset("assets/ic_attachment.svg"),
        title: Text(state.data.pendingFile?.path.split('/').last ?? "-",
            style: LelloTextStyles.body(theme)),
        trailing: SvgPicture.asset("assets/ic_cancel.svg"),
      );
    }
    return DottedBorder(
      strokeWidth: 1,
      dashPattern: const [3.0, 3.0],
      color: LelloTheme.palleteOf(theme).secondary(),
      child: Material(
        child: InkWell(
          onTap: () async {
            var file = await FilePicker.platform.pickFiles(
              type: FileType.any,
              allowMultiple: false,
            );
            if (file != null) {
              setState(() {
                state.data.pendingFile = File(file.files.first.path!);
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(Dimens.spacing),
            alignment: Alignment.center,
            child: Text(
                getString(context, "space_reservation_file_attach_file"),
                style: LelloTextStyles.bodyBold(theme)),
          ),
        ),
      ),
    );
  }

  Widget _buildRegulationButton(ThemeData theme, SpaceRegistrationState state) {
    final savedFile = state.data.fileUrl;
    return Visibility(
      visible: savedFile?.isNotEmpty == true,
      child: ListTile(
        onTap: () {
          Launch.urlString(context, savedFile, headers: customHeader);
        },
        contentPadding: EdgeInsets.zero,
        leading: SvgPicture.asset("assets/ic_regulatio.svg"),
        title: Text(
          getString(context, "space_registration_usage_regulation"),
          style: LelloTextStyles.bodyBold(theme)!
              .copyWith(color: theme.primaryColor),
        ),
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

  void _nextFocus() {
    FocusScope.of(context).nextFocus();
  }

  void _save() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      bloc.nextStep();
    }
  }
}
