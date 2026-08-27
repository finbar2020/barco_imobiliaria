import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/my_preferences/presentation/pages/in_care/bloc/in_cara_state.dart';
import 'package:morar/feature/my_preferences/presentation/pages/in_care/bloc/in_care_bloc.dart';

import '../../../../../../core/dependency/application_container.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../core/widgets/loading_widget.dart';

class InCarePage extends StatefulWidget {
  const InCarePage({Key? key}) : super(key: key);

  @override
  State<InCarePage> createState() => _InCarePageState();
}

class _InCarePageState extends State<InCarePage> {
  late final InCareBloc _bloc;
  bool _isDialogShowing = false;
  final _validator = ApplicationContainer.instance().resolve<Validator>();

  @override
  void initState() {
    super.initState();
    _bloc = ApplicationContainer.instance().resolve<InCareBloc>();
    _bloc.getUnitPersonalData();
    _bloc.focusNodeName.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    final Environment env =
        ApplicationContainer.instance().resolve<Environment>();
    return PopScope(
      canPop: !_bloc.hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          // A rota já saiu: nada a fazer (evita um segundo pop).
          _isDialogShowing = false;
          return;
        }
        if (_bloc.hasUnsavedChanges && !_isDialogShowing) {
          _isDialogShowing = true;
          final shouldPop = await showDialog(
            context: context,
            builder: (ctx) => Center(
              child: Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        getString(
                            context, 'paper_zero_unsaved_changes_dialog_title'),
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.subtitleBold(theme),
                      ),
                      SizedBox(height: Dimens.spacingMedium),
                      PrimaryButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        text: getString(context,
                            'paper_zero_unsaved_changes_dialog_confirm'),
                      ),
                      SizedBox(height: Dimens.spacing),
                      SecondaryButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                          _isDialogShowing = false;
                        },
                        text: getString(context,
                            'paper_zero_unsaved_changes_dialog_cancel'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          _isDialogShowing = false;
          if (shouldPop == true && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: CustomAppBar(
            title: "in_care",
          ),
          body: BlocProvider<InCareBloc>.value(
            value: _bloc,
            child: BlocConsumer<InCareBloc, InCareState>(
              listener: (context, state) {
                if (state is InCareUpdateSuccessState) {
                  _showSuccessDialog(context);
                }
              },
              builder: (context, state) {
                switch (state.runtimeType) {
                  case InCareLoadingState:
                  case InCareInitialState:
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: LoadingWidget(),
                    );
                  case InCareLoadedState:
                  case InCareUpdateSuccessState:
                    return _buildContent(theme, context);
                  case InCareFailureState:
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ErrorHandlingWidget(
                          reTryFunction: () => _bloc.getUnitPersonalData(),
                          backFunction: () => Navigator.pop(context, true),
                          isProduction: env.isProduction,
                          error: (state as InCareFailureState).error,
                          errorCode: "",
                        ),
                        // child: Container(
                      ),
                    );
                  default:
                    return Container(
                      height: 0,
                      width: 0,
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            color: LelloTheme.palleteOf(theme).backgroundDark(),
            width: double.infinity,
            height: Dimens.spacingLarge,
            child: Center(
              child: Text(
                '${_bloc.session?.condominium?.name ?? ''} - ${_bloc.session?.unity?.title ?? ''}',
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.body(theme),
              ),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _bloc.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: getString(context, 'in_care_message'),
                            style: LelloTextStyles.body(theme),
                          ),
                          TextSpan(
                            text: ' "${getString(context, 'in_care')}"',
                            style: LelloTextStyles.bodyBold(theme),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(getString(context, "full_name"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    TextFormField(
                      validator: (value) {
                        if (value?.isNotEmpty == true) {
                          return _validator.validateRequired(value);
                        } else if (_bloc
                            .emailTextEditingController.text.isNotEmpty) {
                          return _validateNameAndEmail(context, value);
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _bloc.onChangeName();
                        setState(() {});
                      },
                      keyboardType: TextInputType.text,
                      controller: _bloc.nameTextEditingController,
                      focusNode: _bloc.focusNodeName,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      maxLength: 35,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: getString(context, "type_name")),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Text(getString(context, "profile_update_email"),
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    TextFormField(
                      controller: _bloc.emailTextEditingController,
                      focusNode: _bloc.focusNodeEmail,
                      onChanged: (value) {
                        _bloc.onChangeEmail();
                        setState(() {});
                      },
                      validator: (value) {
                        if (value?.isNotEmpty == true) {
                          return _validator.validateEmail(value);
                        } else if (_bloc
                            .nameTextEditingController.text.isNotEmpty) {
                          return _validateNameAndEmail(context, value);
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: getString(
                            context, 'preferences_zero_paper_digital'),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    PrimaryButton(
                      onPressed: _bloc.hasUnsavedChanges == true
                          ? () async {
                              await _bloc.updateUnitPersonalData();
                            }
                          : null,
                      text: getString(context, 'save'),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      );

  Future _showSuccessDialog(BuildContext context) => showDialog(
        context: context,
        builder: (ctx) => Center(
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getString(context, 'profile_update_success'),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitleBold(Theme.of(context)),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  PrimaryButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    text: getString(context, 'ok'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  String? _validateNameAndEmail(BuildContext context, String? value) {
    if ((_bloc.nameTextEditingController.text.isNotEmpty &&
            _bloc.emailTextEditingController.text.isEmpty) ||
        (_bloc.nameTextEditingController.text.isEmpty &&
            _bloc.emailTextEditingController.text.isNotEmpty)) {
      return getString(context, 'validation_required');
    }
    return null;
  }
}
