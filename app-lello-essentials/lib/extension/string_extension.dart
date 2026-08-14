extension StringExtension on String {
  String formatCpfCnpj() {
    var digits = this.replaceAll(RegExp(r'[\.\-\/]'), '');

    if (digits.length == 11) {
      return "${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9, 11)}";
    } else if (digits.length == 14) {
      return "${digits.substring(0, 2)}.${digits.substring(2, 5)}.${digits.substring(5, 8)}/${digits.substring(8, 12)}-${digits.substring(12, 14)}";
    } else {
      return digits;
    }
  }
}
