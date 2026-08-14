import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';

import '../../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../preferences/presentation/widget/preferences_checkbox.dart';
import '../../../../../domain/entities/access_data_entity.dart';
import '../../../../../model/zero_paper_preference_item_model.dart';
import '../bloc/receiving_documents_bloc.dart';
import '../bloc/receiving_documents_state.dart';
import '../widgets/change_address_forms_widget.dart';
import '../widgets/change_email_widget.dart';

class ReceivingDocumentsPage extends StatefulWidget {
  const ReceivingDocumentsPage({Key? key}) : super(key: key);

  @override
  State<ReceivingDocumentsPage> createState() => _ReceivingDocumentsPageState();
}

class _ReceivingDocumentsPageState extends State<ReceivingDocumentsPage> {
  late final ReceivingDocumentsBloc bloc;
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    bloc = ApplicationContainer.instance().resolve<ReceivingDocumentsBloc>();
    bloc.init();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Environment env =
        ApplicationContainer.instance().resolve<Environment>();
    return BlocProvider<ReceivingDocumentsBloc>.value(
      value: bloc,
      child: BlocConsumer<ReceivingDocumentsBloc, ReceivingDocumentsState>(
        listener: (_, state) {},
        builder: (ctx, state) => PopScope(
          canPop: !(state is ReceivingDocumentsLoadedState && state.hasChanges),
          onPopInvokedWithResult: (didPop, _) async {
            if (state is ReceivingDocumentsLoadedState &&
                state.hasChanges &&
                !_isDialogShowing) {
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
                            getString(context,
                                'paper_zero_unsaved_changes_dialog_title'),
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
              if (shouldPop == true) {
                Navigator.pop(context);
              } else {
                _isDialogShowing = false;
              }
            }
          },
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'receipt_of_documents',
            ),
            body: BlocBuilder<ReceivingDocumentsBloc, ReceivingDocumentsState>(
                builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state is ReceivingDocumentsLoadedState)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        color: LelloTheme.palleteOf(theme).backgroundDark(),
                        width: double.infinity,
                        height: Dimens.spacingLarge,
                        child: Center(
                          child: Text(
                            '${bloc.sessionBloc.state.session?.condominium?.name ?? ''} - ${bloc.sessionBloc.state.session?.unity?.title ?? ''}',
                            overflow: TextOverflow.ellipsis,
                            style: LelloTextStyles.body(theme),
                          ),
                        ),
                      ),
                    SizedBox(height: Dimens.spacing),
                    if (state is ReceivingDocumentsLoadedState)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          getString(context, 'documents_receiving_msg'),
                          maxLines: 3,
                          style: LelloTextStyles.body(theme),
                        ),
                      ),
                    SizedBox(height: Dimens.spacing),
                    BlocBuilder<ReceivingDocumentsBloc,
                        ReceivingDocumentsState>(
                      builder: (ctx, state) {
                        switch (state.runtimeType) {
                          case ReceivingDocumentsLoadingState:
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: LoadingWidget(),
                            );
                          case ReceivingDocumentsLoadedState:
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: _buildBody(
                                  context,
                                  (state as ReceivingDocumentsLoadedState)
                                      .preferences,
                                  (state).accessData,
                                  theme),
                            );
                          case ReceivingDocumentsFailureState:
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: ErrorHandlingWidget(
                                  reTryFunction: () => bloc.getUnitData(),
                                  backFunction: () =>
                                      Navigator.pop(context, true),
                                  isProduction: env.isProduction,
                                  error: (state as ReceivingDocumentsFailureState)
                                      .error,
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
                  ],
                ),
              );
            }),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: BlocBuilder<ReceivingDocumentsBloc,
                    ReceivingDocumentsState>(builder: (context, state) {
                  ReceivingDocumentsLoadedState? currentState;

                  if (state is ReceivingDocumentsLoadingState ||
                      state is ReceivingDocumentsFailureState) {
                    return SizedBox(
                      height: 1,
                    );
                  }

                  if (state is ReceivingDocumentsLoadedState) {
                    currentState = state;
                  }

                  return Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: getString(context, 'discard_changes'),
                          onPressed: currentState?.hasChanges == true
                              ? () async {
                                  if (state is ReceivingDocumentsLoadedState &&
                                      state.hasChanges &&
                                      !_isDialogShowing) {
                                    _isDialogShowing = true;
                                    final shouldPop =
                                        await _showDiscardChangesConfirmationDialog(
                                      context,
                                      theme,
                                    );
                                    if (shouldPop == true) {
                                      Navigator.pop(context);
                                    } else {
                                      _isDialogShowing = false;
                                    }
                                  }
                                }
                              : null,
                          buttonBorderColor: currentState?.hasChanges == true
                              ? theme.primaryColor
                              : theme.disabledColor,
                        ),
                      ),
                      SizedBox(width: Dimens.spacing),
                      Expanded(
                        child: PrimaryButton(
                          onPressed: currentState?.hasChanges == true
                              ? () async {
                                  final success = await bloc.saveChanges();
                                  if (success) {
                                    await _showSuccessDialog(context);
                                  }
                                }
                              : null,
                          text: getString(context, 'save'),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

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

  Widget _buildBody(
    BuildContext context,
    List<ZeroPaperItemModel> items,
    AccessData data,
    ThemeData theme,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Container()),
              Text(
                getString(context, 'preferences_zero_paper_digital'),
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).textLight(),
                ),
              ),
              SizedBox(width: Dimens.spacing),
              Text(
                getString(context, 'preferences_zero_paper_printed'),
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).textLight(),
                ),
              ),
            ],
          ),
          ...List.generate(items.length, (index) {
            final item = items[index];
            return Column(
              children: [
                _buildZeroPaperPreferenceItem(context, item, theme),
                if (index != items.length - 1) const Divider(),
              ],
            );
          }),
          SizedBox(
            height: Dimens.spacingMedium,
          ),
          _buildChangeInfoComponent(
            getString(context, 'preferences_correspondece_email'),
            getString(context, 'use_another_email'),
            data.unitContactData.correspondenceEmail,
            theme,
            () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => ChangeEmailWidget(
                  email: bloc.personalEmail,
                  onChanged: (value) async {
                    final success = await bloc.saveChanges(email: value);
                    if (success) {
                      await _showSuccessDialog(context);
                    }
                  },
                ),
              );
            },
          ),
          SizedBox(
            height: Dimens.spacingMedium,
          ),
          _buildChangeInfoComponent(
            getString(context, 'correspondence_address'),
            getString(context, 'use_another_address'),
            data.useUnitAddress ?? false
                ? data.condoAddressData.toString()
                : data.unitAddressData.toString(),
            theme,
            () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => ChangeAddressFormsWidget(
                    bloc: bloc,
                    condoAddress: data.condoAddressData!,
                    useUnitAddress: !(data.useUnitAddress ?? false),
                    unitAddress: data.unitAddressData,
                    onChanged: (value) async {
                      final success = await bloc.saveChanges(address: value);
                      if (success) {
                        await _showSuccessDialog(context);
                      }
                    }),
              );
            },
          ),
          SizedBox(
            height: Dimens.spacingMedium,
          ),
          SwitchListTile(
            title: Text(
              getString(context, 'propagate_other_units'),
              style: LelloTextStyles.body(theme),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            value: data.propagateOtherUnits ?? false,
            onChanged: (value) {
              bloc.changePropagateOtherUnits(value);
            },
          )
        ],
      );

  Widget _buildChangeInfoComponent(
    String title,
    String buttonTitle,
    String value,
    ThemeData theme,
    VoidCallback onTap,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: LelloTextStyles.bodyBold(theme),
          ),
          Text(
            value,
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: LelloTheme.palleteOf(theme).textLight(),
            ),
          ),
          SizedBox(
            height: Dimens.spacing,
          ),
          SecondaryButton(
            text: buttonTitle,
            onPressed: onTap,
          )
        ],
      );

  Future _showDiscardChangesConfirmationDialog(
    BuildContext context,
    ThemeData theme,
  ) =>
      showDialog(
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
                      Navigator.of(ctx).pop(true);
                    },
                    text: getString(
                        context, 'paper_zero_unsaved_changes_dialog_confirm'),
                  ),
                  SizedBox(height: Dimens.spacing),
                  SecondaryButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                      _isDialogShowing = false;
                    },
                    text: getString(
                        context, 'paper_zero_unsaved_changes_dialog_cancel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildZeroPaperPreferenceItem(
    BuildContext context,
    ZeroPaperItemModel item,
    ThemeData theme,
  ) =>
      ListTile(
        contentPadding: EdgeInsets.only(right: 20),
        title: Text(
          item.type.getLabel(context),
          style: LelloTextStyles.bodyBold(theme),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PreferencesCheckBox(
              onTap: () {
                bloc.updatePreferences(
                  item.copyWith(
                    choice: ZeroPaperPreferenceChoiceEnum.email,
                  ),
                );
                setState(() {});
              },
              checked: item.choice == ZeroPaperPreferenceChoiceEnum.both ||
                  item.choice == ZeroPaperPreferenceChoiceEnum.email,
            ),
            const SizedBox(width: 40),
            PreferencesCheckBox(
              onTap: () {
                bloc.updatePreferences(
                  item.copyWith(
                    choice: ZeroPaperPreferenceChoiceEnum.printed,
                  ),
                );
                setState(() {});
              },
              checked: item.choice == ZeroPaperPreferenceChoiceEnum.both ||
                  item.choice == ZeroPaperPreferenceChoiceEnum.printed,
            ),
          ],
        ),
      );
}
