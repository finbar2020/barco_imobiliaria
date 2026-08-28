class LgpdFormatter {
  static String formatEmail(String? email) {
    if (email == null) return "";
    return email.replaceAllMapped(
        RegExp(r'(?<=[\w]{3})[\w-\._\+%]+(?=[\w]{2}@)'), (match) {
      return '*';
    });
  }

  static String formatPhone(String? phone) {
    if (phone == null) return "";
    if (phone.length < 8) return phone;
    var onlyNum = phone.replaceAll(RegExp(r'[^\d ]'), ""); //only numbers
    return onlyNum.substring(0, 2) +
        "****" +
        onlyNum.substring(onlyNum.length - 4, onlyNum.length);
  }

  static String formatCpf(String? cpf) {
    if (cpf == null) return "";
    var onlyNum = cpf.replaceAll(RegExp(r'[^\d ]'), ""); //only numbers
    if (onlyNum.length < 11) return cpf;
    return onlyNum.substring(0, 3) +
        ".***.***-" +
        onlyNum.substring(onlyNum.length - 2, onlyNum.length);
  }
}
