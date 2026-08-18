import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart' hide TextDirection;
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/domain/entity/installment.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/presentation/register_form/controllers/register_form_page_controller.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/bloc/register_installments_page_state.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/controllers/register_installments_page_controller.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/page/register_installments_edit_bottom_sheet.dart';

class RegisterInstallments extends StatefulWidget {
  final int step;
  final RegisterFormPageController controller;
  final Function(PaymentDataEntity paymentdata) onChange;
  const RegisterInstallments({
    required this.onChange,
    super.key,
    required this.step,
    required this.controller,
  });

  @override
  State<RegisterInstallments> createState() => _RegisterInstallmentsState();
}

class _RegisterInstallmentsState extends State<RegisterInstallments> {
  final RegisterInstallmentsController controller =
      ApplicationContainer.instance().resolve();
  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  String realCurrency = CommonCurrencies().brl.isoCode;
  final dateFormat = DateFormat("dd/MM/yyyy");

  final TextEditingController valueController = TextEditingController();

  late PaymentDataEntity paymentdata;
  late SupplierDataEntity? supplier;
  late int parcelas;
  late Money valorTotal;
  late List<InstallmentEntity> valoresParcelas;
  DateTime initialDueDate = DateTime.now();
  bool _isSumError = false;

  @override
  void initState() {
    super.initState();
    controller.getBanks();
    paymentdata = widget.controller.paymentData;
    supplier = widget.controller.supplier;

    paymentdata.installmentQuantity ??= 1;
    paymentdata.totalValue ??= 0;
    paymentdata.dueDate ??= DateTime.now();

    parcelas = paymentdata.installmentQuantity!;
    valorTotal = moneyParse(paymentdata.totalValue!);
    initialDueDate = paymentdata.dueDate!;
    valueController.text = valorTotal.toString();

    valueController.addListener(() {
      _onValueControllerChanged();
    });

    _onValueControllerChanged();
  }

  Money moneyParse(double value) {
    return Money.fromInt(int.parse((value * 100).toStringAsFixed(0)),
        isoCode: realCurrency);
  }

  void _checkAndNotifyOnChange() {
    Money sum = Money.fromInt(0, isoCode: realCurrency);
    for (var item in valoresParcelas) {
      sum += moneyParse(item.value);
    }
    setState(() {
      _isSumError = (sum != valorTotal);
    });

    onChange(paymentdata);
  }

  void _onValueControllerChanged() {
    setState(() {
      Money value = Money.parse(valueController.text, isoCode: realCurrency);
      paymentdata.totalValue = value.toDouble();
      valorTotal = value;
      _atualizarParcelas();
      _checkAndNotifyOnChange();
    });
  }

  void _onInstallmentsChanged(int newParcelas) {
    if (newParcelas > 100) {
      newParcelas = 100;
    }
    setState(() {
      parcelas = newParcelas;
      paymentdata.installmentQuantity = parcelas;
      _atualizarParcelas();
      _checkAndNotifyOnChange();
    });
  }

  // @override
  // void didUpdateWidget(RegisterInstallmentsWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldpaymentdata != paymentdata) {
  //     setState(() {
  //       parcelas = paymentdata.installmentQuantity!;
  //       valorTotal = paymentdata.totalValue!;
  //       valueController.text = currencyFormat.format(valorTotal);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return BlocConsumer(
      bloc: controller.bloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is RegisterInstallmentsSuccessState) {
          return _buildSuccessWidget(state);
        } else if (state is RegisterInstallmentsFailureState) {
          return _buildFailureWidget(state);
        } else if (state is RegisterInstallmentsLoadingState) {
          return _buildLoadingWidget();
        }
        return _buildContent(theme);
      },
    );
  }

  Widget _buildContent(ThemeData theme) {
    final pallete = LelloTheme.palleteOf(theme);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          SizedBox(height: Dimens.spacing),
          _buildValueField(theme, pallete),
          SizedBox(height: Dimens.spacing),
          _buildParcelasField(theme, pallete),
          SizedBox(height: Dimens.spacing),
          _buildInstallmentsList(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
            getString(
                context, "register_payment_installments_page_installment_qtd"),
            style: LelloTextStyles.titleSmall(theme)),
        SizedBox(height: Dimens.spacingSmall),
        Text(
            getString(
                context, "register_payment_installments_page_check_fields"),
            style: LelloTextStyles.subtitleBold(theme)),
      ],
    );
  }

  Widget _buildError(ThemeData theme) {
    if (_isSumError == false) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(height: Dimens.spacing),
        Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Colors.orange,
            ),
            SizedBox(width: Dimens.spacing),
            Expanded(
              child: Text(
                getString(
                    context, "register_payment_installments_page_sum_error"),
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: Colors.orange),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildValueField(ThemeData theme, ColorPallete pallete) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: pallete.grey().withAlpha(150), width: 1.5),
      ),
      height: 50,
      child: Row(
        children: [
          Text(
            getString(
                context, "register_payment_installments_page_total_value"),
            style:
                LelloTextStyles.body(theme)?.copyWith(fontSize: Dimens.spacing),
          ),
          SizedBox(width: Dimens.spacingSmall),
          Flexible(
            child: PrimaryAmountFormField(
              textAlign: TextAlign.end,
              fontSize: Dimens.spacing,
              textInputType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  paymentdata.totalValue =
                      currencyFormat.parse(value) as double;
                  onChange(paymentdata);
                });
              },
              controller: valueController,
              action: TextInputAction.done,
              formatter: currencyFormatter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParcelasField(ThemeData theme, ColorPallete pallete) {
    var boxShadow = [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        offset: const Offset(0, 5),
        blurRadius: 10,
        spreadRadius: 3,
      ),
    ];
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getString(
                    context, "register_payment_installments_page_installments"),
                style: LelloTextStyles.titleSmall(theme),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: boxShadow,
                    ),
                    child: IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (parcelas > 1) {
                          _onInstallmentsChanged(parcelas - 1);
                        }
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white, // Ícone branco
                      ),
                    ),
                  ),
                  SizedBox(width: Dimens.spacingSmall),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: TextEditingController(text: '$parcelas'),
                      onSubmitted: (value) {
                        final newParcelas = int.tryParse(value) ?? 1;
                        _onInstallmentsChanged(newParcelas);
                      },
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: LelloTextStyles.body(theme)?.copyWith(
                          color: pallete.grey(), fontSize: Dimens.spacing),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: pallete.grey())),
                      ),
                    ),
                  ),
                  SizedBox(width: Dimens.spacingSmall),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue, // Fundo azul
                      shape: BoxShape.circle, // Botão circular
                      boxShadow: boxShadow,
                    ),
                    child: IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _onInstallmentsChanged(parcelas + 1);
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white, // Ícone branco
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildError(theme),
      ],
    );
  }

  Widget _buildInstallmentsList(ThemeData theme) {
    final pallete = LelloTheme.palleteOf(theme);
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: Dimens.spacingMedium,
        ),
        itemCount: valoresParcelas.length,
        itemBuilder: (context, index) {
          var item = valoresParcelas[index];
          var paymentType = supplier?.supplierPaymentTypes
              .firstWhereOrNull((element) => element?.id == item.paymentTypeId);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "${getString(context, "register_payment_installments_page_installment")} ${index + 1}/$parcelas",
                        style: LelloTextStyles.bodyBold(theme)),
                    SizedBox(height: Dimens.spacingSmall),
                    _labelValue(
                        getString(context,
                            "register_payment_installments_page_due_date"),
                        dateFormat.format(item.dueDate),
                        theme),
                    _labelValue(
                        getString(context,
                            "register_payment_installments_page_payment_type"),
                        paymentType?.name ?? "Padrão",
                        theme),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(currencyFormat.format(item.value),
                      style: LelloTextStyles.body(theme)?.copyWith(
                          color: pallete.grey(), fontSize: Dimens.spacing)),
                  SizedBox(height: Dimens.spacingSmall),
                  PrimaryButton(
                      onPressed: () {
                        Modal.showBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) =>
                                RegisterInstallmentsEditBottomSheet(
                                  controller: controller,
                                  supplier: supplier,
                                  paymentData: paymentdata,
                                  installments: valoresParcelas,
                                  index: index,
                                )).then((value) {
                          if (value != null && value is InstallmentEntity) {
                            valoresParcelas[index] = value;
                            _checkAndNotifyOnChange();
                          }
                        });
                      },
                      text: getString(
                          context, "register_payment_installments_page_edit"),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimens.spacingLarge)),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  void _atualizarParcelas() {
    Decimal valorBase = (valorTotal.toDecimal() / Decimal.fromInt(parcelas))
        .toDecimal(scaleOnInfinitePrecision: 2)
        .truncate(scale: 2);
    Decimal sobra =
        valorTotal.toDecimal() - (valorBase * Decimal.fromInt(parcelas));

    print("Valor base: $valorBase");
    print("Sobra: $sobra");

    final updatedParcelas = List.generate(parcelas, (index) {
      Decimal value = valorBase;
      DateTime dueDate = index == 0
          ? initialDueDate
          : _addMonthsSkippingWeekends(initialDueDate, index);
      if (index == parcelas - 1) value += sobra;
      return InstallmentEntity(dueDate: dueDate, value: value.toDouble());
    });

    setState(() {
      valoresParcelas = updatedParcelas;
    });
  }

  DateTime _addMonthsSkippingWeekends(DateTime startDate, int monthsToAdd) {
    int newYear = startDate.year + (startDate.month + monthsToAdd - 1) ~/ 12;
    int newMonth = (startDate.month + monthsToAdd - 1) % 12 + 1;

    DateTime adjustedDate = DateTime(newYear, newMonth, startDate.day);
    if (adjustedDate.weekday == DateTime.saturday) {
      adjustedDate = adjustedDate.add(const Duration(days: 2));
    } else if (adjustedDate.weekday == DateTime.sunday) {
      adjustedDate = adjustedDate.add(const Duration(days: 1));
    }
    return adjustedDate;
  }

  Widget _labelValue(String s, String format, ThemeData theme) {
    final pallete = LelloTheme.palleteOf(theme);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s,
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: pallete.grey(),
            fontSize: Dimens.spacing,
          ),
        ),
        SizedBox(width: Dimens.spacingSmall),
        Expanded(
          child: Text(
            format,
            style: LelloTextStyles.body(theme)?.copyWith(
              color: pallete.grey(),
              fontSize: Dimens.spacing,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingWidget() =>
      const Center(child: CircularProgressIndicator());

  Widget _buildSuccessWidget(RegisterInstallmentsSuccessState state) =>
      Container();

  Widget _buildFailureWidget(RegisterInstallmentsFailureState state) =>
      Container();

  void onChange(PaymentDataEntity paymentdata) {
    paymentdata.installments = valoresParcelas;
    paymentdata.totalValue = valorTotal.toDouble();
    widget.onChange(paymentdata);
  }
}
