import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';

import '../../../../shared_features.dart';

class AuthenticationStore {
  final AuthenticationBloc bloc;
  final Authenticate authenticateUsecase;
  final Logout logoutUsecase;
  final GetToken getToken;
  final SwitchRoles switchRoles;
  final AppOriginEnum? appOrigin;

  final ConnectionController? connectionController;
  bool isTabletSession = false;

  Credentials credentials = Credentials(username: "", password: "");

  AuthenticationStore({
    required this.bloc,
    required this.authenticateUsecase,
    required this.logoutUsecase,
    required this.getToken,
    required this.switchRoles,
    this.appOrigin,
    this.connectionController,
  }) {
    if (connectionController != null) {
      connectionController?.starCheckConnection();
    }
  }

  Future<void> authenticate() async {
    isTabletSession = appOrigin == null
        ? false
        : await TabletSessionUtils.getIsTabletSession(appOrigin);
    bloc.add(AuthenticatingEvent());

    final result = await authenticateUsecase.call(credentials);

    result.fold(
      (error) => bloc.add(AuthenticationFailedEvent(error: error)),
      (token) {
        if (isTabletSession) {
          TabletSessionUtils.setTabletSessionStartDate(DateTime.now());
        }
        return bloc.add(AuthenticateEvent(accessToken: token!, onLogin: true));
      },
    );
  }

  Future<void> logout() async {
    bloc.add(LogoutEvent());
    final result = await logoutUsecase.call();
    if (result is Success) {
      print("logged Out");
      bloc.add(UnauthenticateEvent());
    }
  }

  Future<void> load() async {
    if (appOrigin != null &&
        (await TabletSessionUtils.getIsTabletSession(appOrigin)) == true) {
      return bloc.add(UnauthenticateEvent());
    }
    final result = await getToken.call(null);
    result.fold(
        (error) => UnauthenticatedState(),
        (token) => token == null
            ? bloc.add(UnauthenticateEvent())
            : bloc.add(AuthenticateEvent(accessToken: token, onLogin: false)));
  }

  Future<void> switchRole(
      {AccessToken? token,
      String? role,
      bool isUpdate = false,
      dynamic me}) async {
    if (token == null) {
      //use cache
      final result = await getToken.call(GetTokenParams(role: role ?? ""));
      result.fold((error) {
        return bloc.add(UnauthorizedEvent(error: error, restartApp: false));
      }, (token) {
        return token == null
            ? bloc.add(UnauthorizedEvent(error: null, restartApp: true))
            : bloc.add(AuthenticateEvent(accessToken: token, me: me));
      });
    } else {
      _setSwitchRolesLastUpdate();
      bloc.add(AuthenticateEvent(accessToken: token, me: me));
    }
  }

  Future<void> _setSwitchRolesLastUpdate() async {
    var preferences = await SharedPreferences.getInstance();
    try {
      preferences.setString(
          SharedPreferencesKeys.lastSwitchRoles, DateTime.now().toString());
    } catch (ex) {}
  }

  Future<void> close() async {
    print("AuthenticationBloc -- Closed");
    bloc.close();
  }

  bool checkRback(String feature) {
    if (bloc.state is AuthenticatedState) {
      return (bloc.state as AuthenticatedState)
          .accessToken
          .checkPermission(feature);
    }
    return false;
  }

  Map<String, String>? getCustomHeader() {
    Map<String, String>? customHeaders;
    String authorization = "";
    if (bloc.state is AuthenticatedState) {
      String tokenJwt =
          (bloc.state as AuthenticatedState).accessToken.accessToken ?? "";
      if (tokenJwt != "") {
        authorization = "Bearer $tokenJwt";
        customHeaders = Map<String, String>();
        customHeaders["Authorization"] = authorization;
      }
    }
    return customHeaders;
  }

  String getRefreshToken() {
    if (bloc.state is AuthenticatedState) {
      var refreshToken =
          (bloc.state as AuthenticatedState).accessToken.refreshToken;
      if (refreshToken?.isNotEmpty == true) return refreshToken!;
    }
    return "-";
  }

  String getExpirationDate() {
    if (bloc.state is AuthenticatedState) {
      var expiresIn = (bloc.state as AuthenticatedState).accessToken.expiresIn;

      if (expiresIn != null) return expiresIn.toDateTimeFormattedString();
    }
    return "";
  }
}
