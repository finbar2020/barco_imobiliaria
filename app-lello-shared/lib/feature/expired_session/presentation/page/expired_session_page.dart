part of shared_features;

class ExpiredSessionArguments {
  String? reason;
  String? cpf;
  String? accessToken;
  String? refreshToken;
  String? failure;
  String? timestamp;
  String? source;
  List<Object>? information;
  ExpiredSessionArguments({
    this.reason,
    this.cpf,
    this.accessToken,
    this.refreshToken,
    this.failure,
    this.timestamp,
    this.source,
    this.information,
  });
}

class ExpiredSessionPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  final AppOriginEnum appOriginEnum;
  ExpiredSessionPage({required this.appContainer, required this.appOriginEnum});
  @override
  _ExpiredSessionPageState createState() => _ExpiredSessionPageState();
}

class _ExpiredSessionPageState extends State<ExpiredSessionPage> {
  final _theme = LelloTheme.light;
  late final ExpiredSessionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.appContainer.resolve();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ExpiredSessionArguments? args =
        ModalRoute.of(context)!.settings.arguments as ExpiredSessionArguments?;
    _bloc.beginLogOut(args);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _theme,
      child: Scaffold(
        body: BlocProvider(
          create: (context) => _bloc,
          child: BlocBuilder<ExpiredSessionBloc, ExpiredSessionState>(
            builder: (context, state) {
              if (state is ExpiredSessionLogOutLoadingState) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                      SizedBox(height: Dimens.spacing),
                      Text(getString(context, "please_wait"),
                          style: LelloTextStyles.subtitleBold(_theme)),
                    ],
                  ),
                );
              }
              if (state is ExpiredSessionLogOutLoadedState) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/ic_attention.svg",
                        color: LelloTheme.palleteOf(_theme).grey(),
                        height: 128.0,
                        width: 128.0,
                      ),
                      SizedBox(height: Dimens.spacingLarge),
                      Text(
                        getString(context, "expired_session_title"),
                        style: LelloTextStyles.title(_theme)?.copyWith(
                          color: LelloTheme.palleteOf(_theme).hubText(),
                        ),
                      ),
                      SizedBox(height: Dimens.spacingLarge),
                      Text(
                        getString(context, "expired_session_subtitle"),
                        style: LelloTextStyles.subtitle(_theme)?.copyWith(
                          color: LelloTheme.palleteOf(_theme).hubText(),
                        ),
                      ),
                      Text(
                        _getVersion(),
                        style: LelloTextStyles.subtitle(_theme)?.copyWith(
                            color: LelloTheme.palleteOf(_theme).hubText()),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Dimens.spacingLarge),
                        child: PrimaryButton(
                          text: getString(context, 'expired_session_ok'),
                          onPressed: () {
                            _bloc.setEmptySessionState();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                SharedApplicationRoute.splash,
                                (Route<dynamic> route) => false);
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  PackageInfo? packageInfo;
  String _getVersion() {
    if (packageInfo != null) {
      return "V${packageInfo!.version}";
    } else {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
      return "";
    }
  }
}
