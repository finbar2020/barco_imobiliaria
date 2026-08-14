part of shared_features;

class CodeValidationPage extends StatefulWidget {
  final CodeRequest codeRequest;
  final Function(CodeValidation?) onSuccess;
  final Function() onRestart;
  final SharedApplicationContainer appContainer;
  final bool isGeneric;
  final int digits;
  final AppOriginEnum? appOriginEnum;

  CodeValidationPage({
    Key? key,
    required this.appContainer,
    required this.codeRequest,
    required this.onSuccess,
    required this.onRestart,
    required this.digits,
    this.isGeneric = false,
    this.appOriginEnum,
  }) : super(key: key);

  @override
  _CodeValidationPageState createState() => _CodeValidationPageState();
}

class _CodeValidationPageState extends State<CodeValidationPage> {
  final _inputKey = GlobalKey<CodeValidationInputState>();
  late CodeValidationStore store;

  @override
  void initState() {
    super.initState();
    store = widget.appContainer.resolve<CodeValidationStore>();
    store.request = widget.codeRequest;
    store.listenSMSTokenCode();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    if (widget.isGeneric) {
      theme = LelloTheme.viverDefaultTheme;
    } else if (widget.appOriginEnum == AppOriginEnum.employee) {
      theme = LelloTheme.carimbeira;
    } else {
      theme = LelloTheme.lelloDefaultTheme;
    }

    return BlocConsumer<CodeValidationBloc, CodeValidationState>(
      bloc: store.bloc,
      listener: (context, state) {
        if (state is CodeValidationSucceededState) {
          widget.onSuccess(state.validation);
        }
        if (state is CodeValidationResendState) {
          widget.onSuccess(state.validation);
        }
      },
      builder: (context, state) {
        var value = store.request != null ? store.request!.value : "";
        if (store.request?.source == CodeValidationSource.phone &&
            value.contains("**") == false) {
          value = LgpdFormatter.formatPhone(value);
        } else if (store.request?.source == CodeValidationSource.email &&
            value.contains("**") == false) {
          value = LgpdFormatter.formatEmail(value);
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(getString(context, "code_validation_title"),
                  style: LelloTextStyles.title(theme)),
              SizedBox(height: Dimens.spacingSmall),
              Text(value, style: LelloTextStyles.subBody(theme)),
              SizedBox(height: Dimens.spacingLarge),
              SizedBox(
                height: 85,
                child: CodeValidationInput(
                  store: store,
                  key: _inputKey,
                  digits: widget.digits,
                ),
              ),
              Visibility(
                visible: state is CodeValidationFailedState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: Dimens.spacingLarge),
                    Center(
                        child: Text(getString(context, "error_invalid_code"),
                            style: LelloTextStyles.error(theme))),
                  ],
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Visibility(
                child: PrimaryButton(
                  buttonColor: theme.primaryColor,
                  text: getString(context, "next"),
                  onPressed: () => _inputKey.currentState!.next(),
                ),
                replacement: Center(child: CircularProgressIndicator()),
                visible: !(state is CodeValidationValidatingState),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Visibility(
                  visible: store.request != null,
                  child: Text(
                    store.request?.getWarningMessage(context) ?? "",
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subBody(theme),
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              TimerWidget(onRestart: widget.onRestart),
            ],
          ),
        );
      },
    );
  }
}

class TimerWidget extends StatefulWidget {
  final Function() onRestart;
  const TimerWidget({Key? key, required this.onRestart}) : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(getString(context, "did_not_receive"),
            style: LelloTextStyles.body(theme)),
        TertiaryButton(
            text:
                ("${getString(context, "resend_sms")}" + " (00:${getTimer()})"),
            style: _start >= 1
                ? LelloTextStyles.inverseButton(theme)!
                    .copyWith(color: Colors.grey)
                : TextStyle(color: theme.primaryColor),
            onPressed: _start >= 1 ? () {} : () => widget.onRestart())
      ],
    );
  }

  String getTimer() {
    return _start.toString().padLeft(2, '0');
  }

  Timer? _timer;
  int _start = 59;
  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _start = 59;
    }
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start <= 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start = _start - 1;
          });
        }
      },
    );
  }
}
