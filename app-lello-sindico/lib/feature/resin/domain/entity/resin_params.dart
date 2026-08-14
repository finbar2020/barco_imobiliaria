class ResinParams {
  double avaliableValue;
  double requestMaxValue;
  double refundMaxValue;
  double refundTotalValue;
  int? requestOnPeriod;
  int? pendingRequests;

  double? maxFileSizeAllowed;

  DateTime? filterStartDate;
  DateTime? filterEndDate;

  ResinParams({
    this.avaliableValue = 0.0,
    this.requestMaxValue = 0.0,
    this.refundMaxValue = 0.0,
    this.refundTotalValue = 0.0,
    this.requestOnPeriod,
    this.pendingRequests,
    this.maxFileSizeAllowed,
    this.filterStartDate,
    this.filterEndDate,
  });

  double get usedValue {
    return requestMaxValue - avaliableValue;
  }
}
