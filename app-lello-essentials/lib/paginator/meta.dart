class Meta {
  int? currentPage;
  int? totalPages;
  int? itemCount;
  int? itemPerPage;
  int? totalItems;

  Meta({
    this.currentPage,
    this.totalPages,
    this.itemCount,
    this.itemPerPage,
    this.totalItems,
  });

  @override
  String toString() {
    return 'Meta(currentPage: $currentPage, totalPages: $totalPages, itemCount: $itemCount, itemPerPage: $itemPerPage, totalItems: $totalItems)';
  }
}
