import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morar/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';

class SubUserContactsCardWidget extends StatelessWidget {
  final SubUser model;
  final bool isEdit;
  final VoidCallback? onPressed;
  final SessionBloc sessionBloc;
  const SubUserContactsCardWidget({
    Key? key,
    required this.model,
    required this.sessionBloc,
    this.onPressed,
    this.isEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      width: double.infinity,
      height: Dimens.homeBalanceHeightCollapsed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: _buildResidentPicture(),
          ),
          Expanded(
            flex: 2,
            child: Container(child: _buildResidentsList(theme, context)),
          ),
          Expanded(
            flex: 1,
            child: _buildEditButton(context, theme),
          )
        ],
      ),
    );
  }

  Widget _buildResidentsList(ThemeData theme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            model.name ?? "",
            overflow: TextOverflow.ellipsis,
            style: LelloTextStyles.subtitle(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).hubText(),
            ),
          ),
          Text(
            model.phone ?? "",
            overflow: TextOverflow.ellipsis,
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).textOpaque(),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildResidentPicture() {
    return model.mainUser
        ? Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10000.0),
                child: CustomCachedNetworkImage(
                  link: sessionBloc.state.session?.me?.pictureLink,
                  errorImageAssetsPath: "assets/user_placeholder.svg",
                ),
              ),
            ),
          )
        : Container(
            width: 56.0,
            height: 56.0,
            child: SvgPicture.asset("assets/user_placeholder.svg", width: 32),
          );
  }

  Widget _buildEditButton(BuildContext context, ThemeData theme) {
    return model.mainUser && isEdit
        ? Container()
        : InkWell(
            onTap: onPressed,
            child: Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: Dimens.spacingMedium),
                    Icon(Icons.arrow_forward_ios, size: 15),
                    SizedBox(width: Dimens.spacingMedium),
                  ],
                ),
              ),
            ),
          );
  }
}
