class FirebaseRemoteConfigLink {
  String link;
  bool webview;
  String name;
  FirebaseRemoteConfigLink(
      {required this.link, required this.webview, required this.name});

  factory FirebaseRemoteConfigLink.fromJson(Map<String, dynamic> json) =>
      FirebaseRemoteConfigLink(
        link: json['link'] as String,
        webview: json['webview'] as bool,
        name: json['name'] as String,
      );
}
