extension ListExtension<T> on List<T> {
  T? lastOrNull() => this.length > 0 ? this.last : null;
}
