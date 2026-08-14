import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'cpf_and_cnpj_input_formatter.dart';
import 'currency_input_formatter.dart';

MaskTextInputFormatter cpfFormatter() => MaskTextInputFormatter(
    mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
MaskTextInputFormatter cnpjFormatter() => MaskTextInputFormatter(
    mask: '##.###.###/####-##', filter: {"#": RegExp(r'[0-9]')});
TextInputFormatter landlinePhoneFormatter() =>
    MaskTextInputFormatter(mask: '####-####', filter: {"#": RegExp(r'[0-9]')});
TextInputFormatter landlinePhoneWithDDDFormatter() => MaskTextInputFormatter(
    mask: '(##) ####-####', filter: {"#": RegExp(r'[0-9]')});
TextInputFormatter dateFormatter() =>
    MaskTextInputFormatter(mask: '##/####', filter: {"#": RegExp(r'[0-9]')});
TextInputFormatter fullDateFormatter() =>
    MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
TextInputFormatter timeFormatter() =>
    MaskTextInputFormatter(mask: '##:##', filter: {"#": RegExp(r'[0-9]')});
TextInputFormatter currencyFormatter({showSymbol = true}) =>
    CurrencyInputFormatter(showSymbol: showSymbol);
TextInputFormatter cpfOrCnpjFormatter() => CpfOrCnpjInputFormatter();
TextInputFormatter rgFormatter() => MaskTextInputFormatter(
    mask: '##.###.###-#', filter: {"#": RegExp(r'[0-9]')});
MaskTextInputFormatter rneFormatter() => MaskTextInputFormatter(
    mask: '#######-#', filter: {"#": RegExp(r'[a-zA-Z0-9]')});
MaskTextInputFormatter passportFormatter() => MaskTextInputFormatter(
    mask: '##########', filter: {"#": RegExp(r'[a-zA-Z0-9]')});
TextInputFormatter cellphoneFormatter() =>
    MaskTextInputFormatter(mask: '#####-####', filter: {"#": RegExp(r'[0-9]')});
TextInputFormatter cellphoneWithDDDFormatter() => MaskTextInputFormatter(
    mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
TextInputFormatter cepFormatter() =>
    MaskTextInputFormatter(mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});
