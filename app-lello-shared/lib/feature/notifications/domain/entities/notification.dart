part of shared_features;

class SingleNotification {
  String? id;
  DateTime? date;
  String? title;
  String? message;
  DateTime? visualizedAt;
  String? status;
  String? reference;
  String? identifier;
  String? module;
  String? type;
  bool? markRead;
  bool? inApp;
  String? typeRedirect;
  String? redirectPath;
  String? redirectId;
  String? callback;
  String? hash;
  String? bigMessage;
  int page;
  int index;
  String? senderId;
  String? uuidGroup;

  SingleNotification({
    this.id,
    this.date,
    this.title,
    this.message,
    this.visualizedAt,
    this.status,
    this.reference,
    this.identifier,
    this.module,
    this.type,
    this.markRead,
    this.inApp,
    this.typeRedirect,
    this.redirectPath,
    this.redirectId,
    this.callback,
    this.hash,
    this.bigMessage,
    this.page = 0,
    this.index = 0,
    this.senderId,
    this.uuidGroup,
  });

  String? get dateFormatted {
    if (date == null) return null;
    DateTime now = DateTime.now();
    DateFormat hours = DateFormat("HH:mm");
    String hoursFormat = hours.format(date!);
    if (date!.year == now.year &&
        date!.month == now.month &&
        date!.day == now.day) {
      return "Hoje, às $hoursFormat";
    } else if (date!.year == now.year &&
        date!.month == now.month &&
        ((date!.day - now.day) == -1)) {
      return "Ontem, às $hoursFormat";
    }
    DateFormat dateExtended = DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR');
    String dateFormat = dateExtended.format(date!);
    return "$dateFormat, às $hoursFormat";
  }

  /// Returns a grouping key for period headers.
  /// "Esta semana", "Este mês", or "Mês de Ano" for older.
  String get datePeriodKey {
    if (date == null) return '';
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);

    if (!date!.isBefore(startOfWeekDate)) {
      return 'Esta semana';
    }
    if (date!.year == now.year && date!.month == now.month) {
      return 'Este mês';
    }
    final monthName = DateFormat("MMMM 'de' yyyy", 'pt_BR').format(date!);
    return monthName[0].toUpperCase() + monthName.substring(1);
  }

  Widget iconFromModule(Color primaryColor) {
    final _default = _assetForModule(null);
    var assetName = _assetForModule(module);
    if (assetName == _default) {
      assetName = _assetForModule(title);
    }
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(8),
      child: Image.asset(assetName, color: Colors.white),
    );
  }

  static String _assetForModule(String? key) {
    switch (key) {
      case "OCORRENCIA":
        return "assets/ic_notifications_ocorrencia.png";
      case "PRESTACAO_CONTAS":
        return "assets/ic_notifications_prestacao_conta.png";
      case "RESERVA_AREA":
      case "RESERVA_MUDANCA":
        return "assets/ic_notifications_reservas.png";
      case "DESPESAS":
        return "assets/ic_notifications_despesas.png";
      case "MKT":
        return "assets/ic_notifications_marketing.png";
      case "GDP":
        return "assets/ic_notifications_gdp.png";
      case "BOLETOS":
        return "assets/ic_notifications_boletos.png";
      case "COMUNICADOS":
        return "assets/ic_notifications_comunicados.png";
      case "CORRESPONDENCIA":
        return "assets/ic_notifications_correspondencias.png";
      case "APROVACOES":
        return "assets/ic_notifications_aprovacoes.png";
      case "SISTEMA":
        return "assets/ic_notifications_outras.png";
      case "ACORDOS":
        return "assets/ic_notifications_outras.png";
      default:
        return "assets/ic_notifications_outras.png";
    }
  }

  String getModuleTitle(BuildContext context) {
    switch (module) {
      case "ACORDOS":
        return getString(context, "agreements");
      case "OCORRENCIA":
        return getString(context, "reports_report");
      case "PRESTACAO_CONTAS":
        return getString(context, "accountability_title");
      case "RESERVA_AREA":
        return getString(context, "condominium_hub_manage_space");
      case "RESERVA_MUDANCA":
        return getString(context, "condominium_hub_manage_space");
      case "BOLETOS":
        return getString(context, "income_control_billets");
      case "GDP":
        return getString(context, "lello_hub_employee");
      case "COMUNICADOS":
        return getString(context, "notification_module_announcements");
      case "MKT":
        return getString(context, "notification_module_mkt");
      case "CORRESPONDENCIA":
        return getString(context, "mailing_title");
      case "DESPESAS":
        return getString(context, "lello_hub_outcome");
      default:
        return getString(context, "notification_module_others");
    }
  }

  Color get getBackgroundColor => page % 2 == 0 ? Colors.grey : Colors.white;

  String? get imageLink => hash?.isNotEmpty == true
      ? "/dashboard/pendencies/notificationImage/$hash"
      : null;

  String get getInAppMessage =>
      bigMessage?.isNotEmpty == true ? bigMessage! : message ?? "";

  bool get canRedirect =>
      reference?.isNotEmpty == true && redirectPath?.isNotEmpty == true;

  bool get isHtml {
    final RegExp htmlRegExp =
        RegExp(r"<[^>]+>", multiLine: true, caseSensitive: false);
    return htmlRegExp.hasMatch(getInAppMessage);
  }
}
