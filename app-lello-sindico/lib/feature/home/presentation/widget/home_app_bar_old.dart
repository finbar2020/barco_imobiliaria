import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class HomeAppBarOld extends StatelessWidget implements PreferredSizeWidget {
  final Function() onTap;
  final theme = LelloTheme.dark;
  final bool expanded;
  final bool isHome;
  final int? pendencyNumber;
  final bool isGeneric;

  HomeAppBarOld(
      {super.key,
      required this.onTap,
      required this.expanded,
      required this.isHome,
      this.isGeneric = false,
      this.pendencyNumber});

  @override
  Widget build(BuildContext context) {
    var themeContext = Theme.of(context);
    final radius = expanded ? 0.0 : 8.0;
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final AuthenticationStore authenticationStore =
        ApplicationContainer.instance().resolve();
    return BlocBuilder<SessionBloc, SessionState>(
        bloc: sessionBloc,
        builder: (context, state) {
          final session = state.session;
          final selectedCondominium = session?.selectedCondominium;

          return Container(
            decoration: ShapeDecoration(
                color: themeContext.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(radius),
                    bottomLeft: Radius.circular(radius),
                  ),
                )),
            child: _buildContent(
                context,
                selectedCondominium,
                session?.me,
                state is SessionFailedState,
                state,
                authenticationStore,
                themeContext),
          );
        });
  }

  Widget _buildContent(
    BuildContext context,
    Condominium? selectedCondominium,
    Me? me,
    bool failed,
    SessionState state,
    AuthenticationStore authenticationStore,
    ThemeData themeContext,
  ) {
    final opacity = failed ? 0.5 : 1.0;
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(
            top: Dimens.spacingXLarge,
            bottom: Dimens.spacingMedium,
            left: Dimens.spacingSmall,
            right: Dimens.spacingSmall),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: onTap,
              child: isGeneric
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100.0,
                            height: 70.0,
                            child: CachedNetworkImage(
                              imageUrl:
                                  selectedCondominium?.layout?.logoPath ?? "",
                              placeholder: (context, url) => Center(
                                  child: Padding(
                                padding: EdgeInsets.all(Dimens.spacingSmall),
                                child: const CircularProgressIndicator(),
                              )),
                              errorWidget: (context, url, error) =>
                                  SvgPicture.asset(
                                "assets/logo-condominio_placeholder.svg",
                              ),
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Opacity(
                                  opacity: opacity,
                                  child: Text(selectedCondominium?.name ?? "",
                                      style:
                                          LelloTextStyles.subtitleBold(theme))),
                              Row(
                                children: [
                                  Opacity(
                                      opacity: opacity,
                                      child: Text(
                                          '${selectedCondominium?.address ?? ""}${selectedCondominium?.number == null ? "" : "-"}${selectedCondominium?.number ?? ""}',
                                          style:
                                              LelloTextStyles.caption(theme))),
                                  SizedBox(width: Dimens.spacingSmall),
                                  Visibility(
                                    visible: selectedCondominium != null,
                                    child: RotatedBox(
                                      quarterTurns: expanded ? 2 : 0,
                                      child: SvgPicture.asset(
                                          "assets/ic_arrow_down.svg",
                                          width: 10),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : ListTile(
                      dense: true,
                      title: Opacity(
                          opacity: opacity,
                          child: Text(selectedCondominium?.name ?? "",
                              style: LelloTextStyles.subtitleBold(theme))),
                      subtitle: Row(
                        children: [
                          Opacity(
                              opacity: opacity,
                              child: Text(
                                  '${selectedCondominium?.address ?? ""}${selectedCondominium?.number == null ? "" : "-"}${selectedCondominium?.number ?? ""}',
                                  style: LelloTextStyles.caption(theme))),
                          SizedBox(width: Dimens.spacingSmall),
                          Visibility(
                            visible: selectedCondominium != null,
                            child: RotatedBox(
                              quarterTurns: expanded ? 2 : 0,
                              child: SvgPicture.asset(
                                  "assets/ic_arrow_down.svg",
                                  width: 10),
                            ),
                          )
                        ],
                      ),
                      trailing: _buildProfilePicture(
                          context, me, failed, authenticationStore),
                    ),
            ),
            isHome
                ? (state is SessionLoadingState)
                    ? CircularProgressIndicator(
                        backgroundColor:
                            LelloTheme.palleteOf(theme).greyDarker(),
                      )
                    : isGeneric
                        ? Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ListTile(
                              dense: true,
                              title: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Opacity(
                                            opacity: opacity,
                                            child: Text(
                                                _getGreetings(context, me),
                                                style: LelloTextStyles
                                                    .subtitleBold(theme))),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Opacity(
                                                opacity: opacity,
                                                child: Text(
                                                  getString(
                                                      context, "greeting"),
                                                  // overflow: TextOverflow.ellipsis,
                                                  style:
                                                      LelloTextStyles.caption(
                                                          theme),
                                                ),
                                              ),
                                            ),
                                            Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  _buildProfilePicture(
                                      context, me, failed, authenticationStore),
                                ],
                              ),
                            ),
                          )
                        : ListTile(
                            dense: true,
                            title: Opacity(
                                opacity: opacity,
                                child: Text(_getGreetings(context, me),
                                    style:
                                        LelloTextStyles.subtitleBold(theme))),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Text(
                                      getString(context, "greeting"),
                                      overflow: TextOverflow.ellipsis,
                                      style: LelloTextStyles.caption(theme),
                                    ),
                                  ),
                                ),
                                Container(),
                              ],
                            ),
                          )
                : Container(),
          ],
        ),
      ),
    );
  }

//MAKE THIS METHOD ASYNC
  String _getGreetings(BuildContext context, Me? me) {
    var firstName = me != null && me.name?.split(" ")[0] != null
        ? me.name?.split(" ")[0]
        : "...";
    var greeting =
        "${getString(context, "hi")} ${firstName![0].toUpperCase()}${firstName.substring(1).toLowerCase()}";
    return greeting;
  }

  Widget _buildProfilePicture(BuildContext context, Me? me, bool failed,
      AuthenticationStore authenticationStore) {
    Map<String, String>? customHeader = authenticationStore.getCustomHeader();
    return Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: LelloTheme.palleteOf(theme).contrastBackground(),
              width: 2),
        ),
        //padding: EdgeInsets.all(3.0),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(ApplicationRoute.me);
          },
          child: (failed ||
                  (me?.pictureLink.isNotEmpty == true && customHeader != null))
              ? Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10000.0),
                    child: CachedNetworkImage(
                      httpHeaders: customHeader,
                      imageUrl: me!.pictureLink,
                      placeholder: (context, url) => Container(
                        padding: const EdgeInsets.all(16.0),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => SvgPicture.asset(
                          "assets/user_placeholder.svg",
                          width: 32),
                    ),
                  ),
                )
              : SvgPicture.asset("assets/user_placeholder.svg", width: 32),
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(Dimens.homeAppBarHeight);
}
