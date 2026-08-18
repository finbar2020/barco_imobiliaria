import 'dart:io';

import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/space/domain/entity/space_type.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc_impl.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_state.dart';

class SpaceRegistrationDataWidget extends StatefulWidget {
  final bool shrinkList;

  const SpaceRegistrationDataWidget({Key? key, this.shrinkList = false})
      : super(key: key);

  @override
  _SpaceRegistrationDataWidgetState createState() =>
      _SpaceRegistrationDataWidgetState();
}

class _SpaceRegistrationDataWidgetState
    extends State<SpaceRegistrationDataWidget> {
  final _formKey = GlobalKey<FormState>();
  final Validator _validator = ApplicationContainer.instance().resolve();
  late SpaceRegistrationBloc bloc;

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
      subtitle: Text(getString(context, "space_registration_data_title"),
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
          physics: widget.shrinkList ? NeverScrollableScrollPhysics() : null,
          padding: EdgeInsets.all(Dimens.spacingMedium).copyWith(top: 0),
          children: [
            _buildHeader(theme, state),
            _buildFormItem(
              theme,
              title: getString(context, "space_registration_data_type"),
              field: DropdownButtonFormField(
                validator: _validator.validateExisting,
                onSaved: (value) {
                  state.data.type = value as SpaceType?;
                },
                value: state.data.type,
                items: state.spaceTypes
                    .map((e) =>
                        DropdownMenuItem(child: Text(e.description!), value: e))
                    .toList(),
                onChanged: (value) {
                  state.data.type = value as SpaceType?;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: Dimens.spacing),
            _buildFormItem(theme,
                title: getString(context, "space_registration_data_name"),
                field: PrimaryTextFormField(
                  initialValue: state.data.name,
                  onSaved: (value) => state.data.name = value,
                  onFieldSubmitted: (value) {
                    _nextFocus();
                  },
                  validator: (value) => _validator.validateRequired(value),
                  textInputType: TextInputType.text,
                  hint: getString(context, "fill_in"),
                )),
            SizedBox(height: Dimens.spacing),
            _buildFormItem(theme,
                title: getString(context, "space_registration_description"),
                field: PrimaryTextFormField(
                  initialValue: state.data.description,
                  textInputType: TextInputType.multiline,
                  onFieldSubmitted: (value) {
                    _nextFocus();
                  },
                  hint: getString(context, "fill_in"),
                  onSaved: (value) {
                    state.data.description = value;
                  },
                )),
            SizedBox(height: Dimens.spacing),
            _buildFormItem(theme,
                title: getString(context, "space_registration_capacity"),
                field: PrimaryTextFormField(
                  initialValue: state.data.capacity?.toString() ?? "",
                  hint: getString(context, "fill_in"),
                  onFieldSubmitted: (value) {
                    _nextFocus();
                  },
                  onSaved: (value) {
                    state.data.capacity = int.parse(value ?? "0");
                  },
                  validator: (value) => _validator.validateRequired(value),
                  textInputType: TextInputType.number,
                )),
            SizedBox(height: Dimens.spacing),
            _buildFormItem(
              theme,
              title: getString(context, "space_registration_shared_space"),
              field: DropdownButtonFormField(
                  value: state.data.sharedSpace?.id,
                  items: (state.spaces)
                      .map((e) =>
                          DropdownMenuItem(child: Text(e.name!), value: e.id))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      state.data.sharedSpace = state.spaces.firstWhere(
                          (element) => element.id == value,
                          orElse: null);
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  )),
            ),
            SizedBox(height: Dimens.spacingMedium),
            _buildUpload(theme, state),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              onPressed: () {
                _save();
              },
              text: getString(context, "next"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUpload(ThemeData theme, SpaceRegistrationState state) {
    ImagePicker imagePicker = new ImagePicker();
    if (state.data.pendingPicture != null)
      return _showPreviewImage(theme, state);
    return Wrap(children: [
      Container(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButtons(
                  theme, getString(context, "camera"), "assets/ic_camera.svg",
                  () async {
                var image =
                    await imagePicker.pickImage(source: ImageSource.camera);
                setState(() {
                  state.data.pendingPicture = image as File?;
                });
              }),
              SizedBox(width: Dimens.spacingLarge),
              _buildButtons(
                  theme, getString(context, "gallery"), "assets/ic_gallery.svg",
                  () async {
                var image =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  state.data.pendingPicture = image as File?;
                });
              })
            ],
          )),
    ]);
  }

  Widget _buildButtons(
      ThemeData theme, String title, String image, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Column(
        children: [
          SvgPicture.asset(image, width: 45, height: 45),
          SizedBox(height: Dimens.spacingLarge),
          Text(title, style: LelloTextStyles.bodyBold(theme))
        ],
      ),
    );
  }

  Widget _buildFormItem(ThemeData theme, {String? title, Widget? field}) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
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

  Widget _showPreviewImage(ThemeData theme, SpaceRegistrationState state) {
    return Row(children: [
      Stack(children: [
        Container(
          width: 100,
          height: 100,
          child: Image.file(state.data.pendingPicture!),
        ),
        Positioned(
          right: -4,
          top: -8,
          child: InkWell(
            onTap: () {
              setState(() {
                state.data.pendingPicture = null;
              });
            },
            child: SvgPicture.asset("assets/ic_cancel.svg"),
          ),
        )
      ]),
    ]);
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
