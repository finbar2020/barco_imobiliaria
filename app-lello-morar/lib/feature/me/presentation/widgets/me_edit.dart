import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:morar/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:shared_features/shared_features.dart';

class MeEdit extends StatefulWidget {
  final MeController controller;

  MeEdit({required this.controller});
  @override
  _MeEditState createState() => _MeEditState();
}

class _MeEditState extends State<MeEdit> {
  final _formKey = GlobalKey<FormState>();
  final Validator _validator = ApplicationContainer.instance().resolve();

  var focused = false;

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        ApplicationContainer.instance().resolve();
    final theme = Theme.of(context);
    _validator.context = context;
    return _buildContent(theme, authenticationBloc);
  }

  Widget _buildContent(ThemeData theme, AuthenticationBloc authenticationBloc) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: _buildForm(theme, authenticationBloc),
        ),
      ),
    );
  }

  Widget _buildForm(ThemeData theme, AuthenticationBloc authenticationBloc) {
    final me = widget.controller.bloc.state.me;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfilePicture(context, me),
          SizedBox(height: Dimens.spacing),
          buildInfoTile(
              me.cpf!.length > 14
                  ? getString(context, "cnpj")
                  : getString(context, "me_cpf_title"),
              "${me.cpf}"),
          SizedBox(height: Dimens.spacing),
          Text(getString(context, "full_name"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacingSmall),
          TextFormField(
            initialValue: me.name,
            validator: _validator.validateRequired,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            onSaved: (value) => me.name = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: getString(context, "type_name")),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(getString(context, "profile_update_email"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacingSmall),
          TextFormField(
            initialValue: me.email,
            validator: _validator.validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSaved: (value) => me.email = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: getString(context, "type_email")),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(getString(context, "registration_lello_user_phone_title"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacingSmall),
          _buildPhoneInput(me),
          SizedBox(height: Dimens.spacingXLarge),
          SecondaryButton(
              text: getString(context, "me_edit_password_title"),
              onPressed: () {
                widget.controller.beginEditPassword();
              }),
          SizedBox(height: Dimens.spacing),
          Container(
            width: double.infinity,
            child: PrimaryButton(
                text: getString(context, "conclude"), onPressed: save),
          ),
          SizedBox(height: Dimens.spacingSmall),
        ],
      ),
    );
  }

  void save() {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      widget.controller.mapSave();
    }
  }

  Widget _buildProfilePicture(BuildContext context, Me me) {
    ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        setState(() {
          Modal.showBottomSheet(
              context: context, builder: (context) => _editImage(theme));
        });
      },
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: new Container(
          width: 60.0,
          height: 60.0,
          //padding: EdgeInsets.all(3.0),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: LelloTheme.palleteOf(theme).backgroundDark(), width: 2),
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10000.0),
              child: CustomCachedNetworkImage(
                link: me.pictureLink,
                errorImageAssetsPath: "assets/user_placeholder.svg",
              ),
            ),
          )),
    );
  }

  Widget _editImage(ThemeData theme) {
    return Wrap(children: [
      Container(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButtons(
                  theme, getString(context, "camera"), "assets/ic_camera.svg",
                  () {
                widget.controller.chooseImageEvent(ImageSource.camera);

                Navigator.of(context).pop();
              }),
              SizedBox(width: Dimens.spacingLarge),
              _buildButtons(
                  theme, getString(context, "gallery"), "assets/ic_upload.svg",
                  () {
                widget.controller.chooseImageEvent(ImageSource.gallery);
                Navigator.of(context).pop();
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

  Widget buildInfoTile(String title, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            '$info',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInput(Me model) {
    var ddd = _initialDDD(model.phone ?? "") ?? "";
    var phone = _initialPhone(model.phone ?? "") ?? "";
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: Dimens.spacingXLarge,
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: ddd,
            onSaved: (value) => ddd = value ?? "",
            textInputAction: TextInputAction.next,
            validator: _validator.validateRequired,
            onChanged: (value) {
              if (value.length == 2) {
                FocusScope.of(context).nextFocus();
              }
              ddd = value;
              model.phone = _getPhone(ddd, phone);
            },
            textAlign: TextAlign.center,
            maxLength: 2,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              counterText: '',
              hintText: "00",
            ),
          ),
        ),
        SizedBox(
          width: Dimens.spacingSmall,
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: phone,
            onChanged: (value) {
              phone = value;
              model.phone = _getPhone(ddd, phone);
              print("PHONE => ${model.phone}");
            },
            onSaved: (value) => phone = value ?? "",
            inputFormatters: [cellphoneFormatter()],
            validator: _validator.validateCellPhone,
            textInputAction: TextInputAction.done,
            maxLength: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "00000.0000",
              counterText: '',
            ),
          ),
        ),
      ],
    );
  }

  String? _initialDDD(String initialValue) {
    var initial = initialValue.trim();
    initial = initial.replaceAll(" ", "").replaceAll("-", "");
    if (initial.isNotEmpty) {
      if (initial.startsWith("+55") && initial.length > 4)
        return initial.substring(3, 5);
      if (initial.startsWith("(") && initial.length > 4)
        return initial.substring(1, 3);
      if (initial.length == 11 || initial.length == 12)
        return initial.substring(0, 2);
      if (initial.length > 9) return initial.substring(0, 2);
    }
    return null;
  }

  String? _initialPhone(String initialValue) {
    var initial = initialValue.trim();
    initial = initial.replaceAll(" ", "").replaceAll("-", "");
    if (initial.isNotEmpty) {
      if (initial.startsWith("+55") && initial.length > 4)
        return initial.substring(5).trim();
      if (initial.startsWith("(")) {
        if (initial.length > 5) {
          return initial.substring(4).trim();
        }
      } else {
        if (initial.length == 11 || initial.length == 12)
          return initial.substring(2, initial.length);
        if (initial.length > 9)
          return initial.substring(2, initial.length);
        else
          return initial;
      }
    }
    return null;
  }

  String _getPhone(String ddd, String phone) {
    String val = "";
    if (ddd.isNotEmpty) {
      val = "($ddd)";
    }
    if (phone.isNotEmpty) {
      val += phone;
    }
    return val;
  }
}
