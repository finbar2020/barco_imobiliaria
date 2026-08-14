part of shared_features;

class NotificationListPage extends StatefulWidget {
  final VoidCallback closeOverlay;
  final NotificationController notificationController;
  final dynamic dialogBloc;
  final dynamic homeBloc;
  final StatefulWidget HomeNavigationPage;
  final dynamic sessionBloc;
  final Function(SingleNotification notification) onTap;
  final AppOriginEnum appOriginEnum;
  final String? configurationPage;
  final VoidCallback? onConfigurationTap;
  final bool? checkRbac;
  final SharedApplicationContainer applicationContainer;
  final NotificationScopeLabelBuilder? scopeLabelBuilder;
  NotificationListPage({
    required this.closeOverlay,
    required this.dialogBloc,
    required this.notificationController,
    required this.homeBloc,
    required this.HomeNavigationPage,
    required this.sessionBloc,
    required this.onTap,
    required this.appOriginEnum,
    required this.applicationContainer,
    this.checkRbac,
    this.configurationPage,
    this.onConfigurationTap,
    this.scopeLabelBuilder,
  });

  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  var didSetup = false;

  @override
  void initState() {
    super.initState();
    // Carregar notificações apenas uma vez na inicialização
    if (!didSetup && 
        widget.notificationController.bloc.state is! NotificationListPageState) {
      didSetup = true;
      widget.notificationController.getNotificationList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme,
      child: BlocConsumer(
        bloc: widget.notificationController.bloc,
        listener: (context, state) {},
        builder: (context, state) {
          return _buildScaffold(state as NotificationListState);
        },
      ),
    );
  }

  Widget _buildScaffold(NotificationListState state) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: widget.appOriginEnum == AppOriginEnum.employee
            ? CustomAppBar(title: "notification")
            : null,
        body: GestureDetector(
            onTap: () {
              widget.closeOverlay();
            },
            child: _buildBody(state, theme)));
  }

  Widget _buildBody(NotificationListState state, ThemeData theme) {
    if (state is NotificationListLoadingState)
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    if (state is NotificationListLoadedFailedState) {
      return _buildError(theme);
    }
    if (state is NotificationListPageState) {
      return _buildForm(state);
    }
    return Container();
  }

  Widget _buildForm(state) {
    final List<SingleNotification> notificationList =
        state.notificationList.toList();
    return NotificationListWidget(
      closeOverlay: widget.closeOverlay,
      controller: widget.notificationController,
      sessionBloc: widget.sessionBloc,
      onTap: widget.onTap,
      notificationList: notificationList,
      appOriginEnum: widget.appOriginEnum,
      configurationPage: widget.configurationPage,
      onConfigurationTap: widget.onConfigurationTap,
      checkRbac: widget.checkRbac,
      applicationContainer: widget.applicationContainer,
      scopeLabelBuilder: widget.scopeLabelBuilder,
    );
  }

  Widget _buildError(ThemeData theme) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.notificationController.getNotificationList();
      },
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            getString(context, "warning_failed_message"),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: SecondaryButton(
                                buttonBorderColor: Colors.black,
                                text: getString(context, "try_again"),
                                onPressed: () {
                                  widget.notificationController
                                      .getNotificationList();
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
