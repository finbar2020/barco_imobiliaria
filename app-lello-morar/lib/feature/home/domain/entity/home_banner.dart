class HomeBanner {
  bool? insideApp;
  String? url;
  String? image;

  HomeBanner({
    this.insideApp = false,
    this.url,
    this.image,
  }) : assert(insideApp != null);
}
