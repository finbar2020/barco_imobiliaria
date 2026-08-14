import 'package:essentials/essentials.dart' hide BlendMode;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/payment_data.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lello/feature/payment/domain/entity/process_files_response.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/bloc/payment_send_financial_department_bloc.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/bloc/payment_send_financial_department_state.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/controller/payment_send_financial_department_controller.dart';
import 'package:lello/feature/payment/presentation/widget/payment_exit_proccess_dialog.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/widget/payment_search_supplier_widget.dart';

class PaymentSendFinancialDepartmentPageArgs {
  ProcessFilesResponseEntity data;
  PaymentSendFinancialDepartmentPageArgs(this.data);
}

class PaymentSendFinancialDepartmentPage extends StatefulWidget {
  const PaymentSendFinancialDepartmentPage({super.key});

  @override
  PaymentSendFinancialDepartmentPageState createState() =>
      PaymentSendFinancialDepartmentPageState();
}

class PaymentSendFinancialDepartmentPageState
    extends State<PaymentSendFinancialDepartmentPage>
    with SingleTickerProviderStateMixin {
  final scaffoldState = GlobalKey<ScaffoldState>();

  Environment env = ApplicationContainer.instance().resolve<Environment>();
  var controller = ApplicationContainer.instance()
      .resolve<PaymentSendFinancialDepartmentController>();

  var dueDateController = TextEditingController();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  PaymentSendFinancialDepartmentPageArgs? arguments;
  late ProcessFilesResponseEntity data;
  late PaymentDataEntity paymentData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    arguments = ModalRoute.of(context)!.settings.arguments
        as PaymentSendFinancialDepartmentPageArgs?;
    data = arguments!.data;
    paymentData = (data.paymentData != null)
        ? data.paymentData!
        : PaymentDataEntity(
            idSupplier: null,
            documentSupplier: null,
            idContract: null,
            documentNumber: null,
            documentType: null,
            dueDate: null,
            installmentQuantity: null,
            totalValue: null,
            observation: null,
            filePathLaunch: data.filePathLaunch,
            totalPages: null,
            ledgerAccount: null,
            isUtilityAccount: null,
            installments: null,
            isSendFinancial: true,
          );

    var labelStyle = LelloTextStyles.subtitleBold(theme)!.copyWith(
      color: LelloTheme.palleteOf(theme).text(),
    );

    dueDateController.text = paymentData.dueDate != null
        ? dateFormat.format(paymentData.dueDate!)
        : "";

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          confirmPop(context);
        }
      },
      canPop: false,
      child: Theme(
        data: theme,
        child: Scaffold(
          key: scaffoldState,
          appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            theme: theme,
            title: getString(context, "register_payment_title"),
            onBackArrowPressed: () {
              confirmPop(context);
            },
          ),
          body: Padding(
            padding: EdgeInsets.all(Dimens.spacing),
            child: BlocConsumer<PaymentSendFinancialDepartmentListBloc,
                PaymentSendFinancialDepartmentState>(
              bloc: controller.bloc,
              listener: (context, state) {
                if (state is PaymentSendFinancialDepartmentSuccessState) {
                  controller.sendPaymentSuccessAnalyticsLog(
                      PaymentScreens.paymentFinancialSuccess);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      ApplicationRoute
                          .paymentSendFinancialDepartmentSuccessPage,
                      ModalRoute.withName(ApplicationRoute.payment));
                } else if (state
                    is PaymentSendFinancialDepartmentFailureState) {
                  controller.sendPaymentErrorAnalyticsLog(
                      PaymentScreens.paymentFinancialError);
                  Navigator.of(context).pushNamed(
                    ApplicationRoute.paymentSendFinancialDepartmentFaliurePage,
                  );
                }
              },
              builder: (context, state) {
                if (state is PaymentSendFinancialDepartmentSuccessState) {
                  return const SizedBox.shrink();
                }
                if (state is PaymentSendFinancialDepartmentFailureState) {
                  return const SizedBox.shrink();
                } else if (state
                    is PaymentSendFinancialDepartmentLoadingState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200, // Define diretamente a altura.
                          child: Lottie.asset(
                            "assets/processing_documents_animation.json",
                            fit: BoxFit.scaleDown,
                            delegates: LottieDelegates(values: [
                              ValueDelegate.colorFilter(
                                ['casa', '**'],
                                value: ColorFilter.mode(
                                    theme.primaryColor, BlendMode.src),
                              ),
                              ValueDelegate.colorFilter(
                                ['telhado', '**'],
                                value: ColorFilter.mode(
                                    theme.colorScheme.secondary, BlendMode.src),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          getString(context, "please_wait"),
                          style: theme.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getString(
                                  context, "payments_send_financial_sub_title"),
                              style: const TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: Dimens.spacing),
                            // Campo de Referência do Condomínio
                            Text(
                              getString(context,
                                  "payments_send_financial_label_condo"),
                              style: labelStyle,
                            ),
                            SizedBox(height: Dimens.spacingSmall),
                            TextField(
                              readOnly: true,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                hintText:
                                    controller.condominiumNameAndReference,
                              ),
                            ),
                            SizedBox(height: Dimens.spacing),
                            // Dropdown Fornecedor
                            PaymentSearchSupplierWidget(
                              showDocumentInput: false,
                              initialSuplierId: paymentData.idSupplier,
                              onChange: (document, supplier) {
                                setState(() {
                                  paymentData.idSupplier = supplier?.id;
                                  paymentData.documentSupplier =
                                      supplier?.document;
                                });
                              },
                            ),
                            SizedBox(height: Dimens.spacing),
                            // Campo de Data de Vencimento
                            Text(
                              "${getString(context, "payments_send_financial_label_due")} *",
                              style: labelStyle,
                            ),
                            SizedBox(height: Dimens.spacingSmall),
                            PrimaryTextFormField(
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  final date = await datePicker(
                                    context,
                                    firstDate: DateTime.now(),
                                    selectedDate: data.paymentData?.dueDate,
                                  );
                                  setState(() {
                                    paymentData.dueDate = (date);
                                    dueDateController.text =
                                        dateFormat.format(date);
                                  });
                                },
                                controller: dueDateController,
                                textInputType: TextInputType.number,
                                formatter: fullDateFormatter(),
                                hint: "00/00/0000"),
                            SizedBox(height: Dimens.spacing),
                            // Pergunta "É uma conta de concessionária?"
                            Text(
                              getString(context,
                                  "payments_send_financial_label_acc_check"),
                              style: labelStyle,
                            ),
                            SizedBox(height: Dimens.spacingSmall),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: RadioListTile<bool>(
                                    title: Text(getString(context, "yes")),
                                    value: true,
                                    contentPadding: const EdgeInsets.all(0),
                                    groupValue: paymentData.isUtilityAccount,
                                    onChanged: (value) {
                                      setState(() {
                                        paymentData.isUtilityAccount = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: RadioListTile<bool>(
                                    title: Text(getString(context, "no")),
                                    value: false,
                                    contentPadding: const EdgeInsets.all(0),
                                    groupValue: paymentData.isUtilityAccount,
                                    onChanged: (value) {
                                      setState(() {
                                        paymentData.isUtilityAccount = value;
                                      });
                                    },
                                  ),
                                ),
                                const Spacer(flex: 1),
                              ],
                            ),
                            SizedBox(height: Dimens.spacing),
                            // Status dos anexos
                            Row(
                              children: [
                                const Icon(Icons.check_circle,
                                    color: Colors.green),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        getString(context,
                                            "payments_send_financial_label_attachment"),
                                        style: labelStyle),
                                    SizedBox(height: Dimens.spacingSmall),
                                    Text(
                                        "${paymentData.totalPages ?? 0} ${getString(context, "payments_send_financial_label_attachment_count")}"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: SecondaryButton(
                            text: getString(context, "cancel"),
                            onPressed: () {
                              controller.cancelSendToFinancialAnalyticsLog();
                              confirmPop(context);
                            },
                          ),
                        ),
                        const Spacer(flex: 1),
                        Flexible(
                          flex: 1,
                          child: PrimaryButton(
                            buttonColor: theme.colorScheme.secondary,
                            text: getString(context, "send"),
                            onPressed: controller.isDataOk(paymentData)
                                ? () {
                                    controller.send(paymentData);
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void confirmPop(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return PaymentExitProccessDialog(
            onConfirm: () {
              //controller.dispose();
              controller.backArrowAnalyticsLog(
                  PaymentScreens.paymentSendToFinancialPage);
              navigateToPaymentMainAndClearStack(context);
            },
            onCancel: () {
              Navigator.pop(context);
            },
          );
        });
  }

  void navigateToPaymentMainAndClearStack(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(ApplicationRoute.payment, (route) => false);
  }
}
