class AnalyticsEvent {
  String name;
  String token;
  String type;
  AnalyticsEvent(this.name, this.token, this.type);
}

class Type {
  static final read = "read";
  static final write = "write";
  static final delete = "delete";
}
