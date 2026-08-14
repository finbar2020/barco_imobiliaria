part of shared_features;

/// Controller responsible for monitoring and managing network connectivity
class ConnectionController with WidgetsBindingObserver implements Disposable {
  // Constants
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 5);
  static const Duration _checkInterval = Duration(seconds: 30);

  // Dependencies
  final ConnectionUseCase connectionUseCase;
  final dio.Dio _dioClient = dio.Dio();

  // State
  bool _isAppActive = true;
  bool _lastToastShown = false;
  bool _isCheckingConnection = false;
  Timer? _timer;

  /// Creates a new instance of [ConnectionController]
  ConnectionController({
    required this.connectionUseCase,
  }) {
    WidgetsBinding.instance.addObserver(this);
    _initConnection();
  }

  // Lifecycle methods
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isAppActive = state == AppLifecycleState.resumed;
    if (_isAppActive) {
      verifyConnections();
    }
  }

  @override
  FutureOr onDispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    return Future.value();
  }

  // Public methods
  /// Starts periodic connection checks
  Future<void> starCheckConnection() async {
    if (!_isAppActive) return;

    _timer = Timer.periodic(
      _checkInterval,
      (Timer timer) async {
        if (!_isAppActive) {
          timer.cancel();
          return;
        }
        await verifyConnections();
      },
    );
  }

  /// Verifies all connections in sequence:
  /// 1. Basic connectivity
  /// 2. Internet access (via Google)
  /// 3. Lello API connection
  Future<void> verifyConnections() async {
    if (!_isAppActive || _isCheckingConnection) return;

    _isCheckingConnection = true;
    try {
      // First check Connectivity
      if (!await _hasBasicConnectivity()) {
        _isCheckingConnection = false;
        return;
      }

      // Then check Internet connection, e.g., via Google
      // This is a simple check to see if the device can reach the internet
      // if this succeeds, we assume the device has internet access, ending the check
      if (await _hasInternetAccess()) {
        _isCheckingConnection = false;
        return;
      }

      // Finally check Lello connection if the previous checks failed
      // This is a double-check to ensure the Lello API is reachable
      var hasConnectionLello = await _checkConnectionLello();
      _handleLelloConnectionResult(hasConnectionLello);
    } finally {
      _isCheckingConnection = false;
    }
  }

  // Private methods
  void _initConnection() async {
    starCheckConnection();
  }

  Future<bool> _hasBasicConnectivity() async {
    List<ConnectivityResult> conn = await Connectivity().checkConnectivity();
    return !conn.every((x) => x == ConnectivityResult.none);
  }

  Future<bool> _hasInternetAccess() async {
    try {
      var result = await _dioClient
          .get("https://www.google.com")
          .timeout(const Duration(seconds: 10));
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _checkConnectionLello() async {
    for (int retry = 0; retry < _maxRetries; retry++) {
      try {
        var response = await connectionUseCase.call(ConnectionParams());
        return response.fold((l) => throw Exception(), (r) => true);
      } catch (e) {
        if (retry < _maxRetries - 1) {
          await Future.delayed(_retryDelay);
          continue;
        }
      }
    }
    return false;
  }

  void _handleLelloConnectionResult(bool hasConnection) {
    if (!hasConnection && !_lastToastShown) {
      _showToast(
          "Não foi possível fazer conexão com o Sistema Lello. Verifique sua conexão com a internet.");
      _lastToastShown = true;
    } else if (hasConnection) {
      _lastToastShown = false;
    }
  }

  void _showToast(String title) {
    if (!_isAppActive) return;
    Fluttertoast.showToast(msg: title, toastLength: Toast.LENGTH_LONG);
  }
}
