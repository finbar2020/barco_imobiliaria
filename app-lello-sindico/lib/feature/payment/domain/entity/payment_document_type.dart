enum PaymentDocumentType {
  receipt,
  invoice,
  bill,
  billAndInvoice,
  billSeparetedInvoice,
  paySlip
}

String paymentDocumentTypeToString(PaymentDocumentType documentType) {
  switch (documentType) {
    case PaymentDocumentType.receipt:
      return "RECIBO";
    case PaymentDocumentType.invoice:
      return "NOTA FISCAL";
    case PaymentDocumentType.bill:
      return "BOLETO";
    case PaymentDocumentType.billAndInvoice:
      return "NOTA + BOLETO NO MESMO ARQUIVO";
    case PaymentDocumentType.billSeparetedInvoice:
      return "NOTA + BOLETO SEPARADOS";
    case PaymentDocumentType.paySlip:
      return "GUIA";
  }
}

PaymentDocumentType paymentDocumentTypeFromString(String documentType) {
  switch (documentType) {
    case "RECIBO":
      return PaymentDocumentType.receipt;
    case "NOTA FISCAL":
      return PaymentDocumentType.invoice;
    case "BOLETO":
      return PaymentDocumentType.bill;
    case "NOTA + BOLETO NO MESMO ARQUIVO":
      return PaymentDocumentType.billAndInvoice;
    case "NOTA + BOLETO SEPARADOS":
      return PaymentDocumentType.billSeparetedInvoice;
    case "GUIA":
      return PaymentDocumentType.paySlip;
    default:
      return PaymentDocumentType.receipt;
  }
}

List<PaymentDocumentType> getPaymentDocumentTypes() {
  return [
    PaymentDocumentType.receipt,
    PaymentDocumentType.invoice,
    PaymentDocumentType.bill,
    PaymentDocumentType.billAndInvoice,
    PaymentDocumentType.billSeparetedInvoice,
    PaymentDocumentType.paySlip
  ];
}
