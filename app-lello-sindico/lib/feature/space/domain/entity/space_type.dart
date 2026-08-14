class SpaceType {
  String? id;
  String? description;

  @override
  bool operator ==(other) {
    return other is SpaceType && this.id != null && other.id == this.id;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}
