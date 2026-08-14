import 'package:essentials/essentials.dart' hide BlendMode;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item_status.dart';

import 'package:lello/feature/payment/presentation/history_list/bloc/payment_history_list_state.dart';
import 'package:lello/feature/payment/presentation/history_list/controller/payment_history_list_controller.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class PaymentHistoryDetailsPage extends StatefulWidget {
  const PaymentHistoryDetailsPage({super.key});

  @override
  PaymentHistoryDetailsPageState createState() =>
      PaymentHistoryDetailsPageState();
}

class PaymentHistoryDetailsPageState extends State<PaymentHistoryDetailsPage>
    with SingleTickerProviderStateMixin {
  final scaffoldState = GlobalKey<ScaffoldState>();
  final controller =
      ApplicationContainer.instance().resolve<PaymentHistoryController>();
  final sessionBloc = ApplicationContainer.instance().resolve<SessionBloc>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  late PaymentHistoryItem item;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null &&
        ModalRoute.of(context)?.settings.arguments is PaymentHistoryItem) {
      item = ModalRoute.of(context)!.settings.arguments as PaymentHistoryItem;
    } else {
      Navigator.pop(context);
    }
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: BlocConsumer(
        listener: (context, state) {
          if (state is PaymentHistorySuccessState) {}
        },
        bloc: controller.bloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: LelloTheme.palleteOf(theme).backgroundDark(),
            key: scaffoldState,
            appBar: PrimaryAppBar(
              theme: theme,
              title: getString(context, "payments_history_details_title"),
            ),
            body: Builder(
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildItem(
                              context,
                              "payments_history_details_label_date",
                              item.inclusionDate != null
                                  ? DateFormat("dd/MM/yyyy")
                                      .format(item.inclusionDate!)
                                  : "-"),
                          _buildItem(
                            context,
                            "payments_history_details_label_status",
                            paymentHistoryItemStatusToString(
                                context, item.processingStatus),
                            rigth: true,
                          ),
                        ],
                      ),
                      SizedBox(height: Dimens.spacing),
                      _buildItem(
                        context,
                        "payments_history_details_label_number",
                        item.releaseId,
                      ),
                      SizedBox(height: Dimens.spacing),
                      _buildItem(
                        context,
                        "payments_history_details_label_supplier",
                        item.supplierName,
                      ),
                      SizedBox(height: Dimens.spacing),
                      _buildItem(
                        context,
                        "payments_history_details_label_file",
                        item.fileName,
                      ),
                      SizedBox(height: Dimens.spacing),
                      _buildItem(
                        context,
                        "payments_history_details_label_value",
                        item.totalValue != null
                            ? NumberFormat.currency(
                                    locale: "pt_BR", symbol: "R\$")
                                .format(item.totalValue)
                            : "-",
                      ),
                      SizedBox(height: Dimens.spacingSmall),
                      _buildItem(
                          context,
                          "payments_history_details_label_instalments",
                          item.installments?.toString()),
                      SizedBox(height: Dimens.spacing),
                      _buildItem(
                        context,
                        "payments_history_details_label_origin",
                        item.documentOrigin,
                      ),
                      SizedBox(height: Dimens.spacing),
                      if (item.releaseId != null)
                        PrimaryButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return PDFScreen(
                                  url:
                                      "${env.apiUrl}/condominiums/${sessionBloc.state.session!.selectedCondominium!.id}/payments/${item.releaseId}/download",
                                  fileName: item.fileName,
                                  canDownload: true,
                                  title: "PDF",
                                  headers:
                                      authenticationStore.getCustomHeader(),
                                );
                              },
                            ));
                          },
                          text: getString(
                              context, "payments_history_details_label_btn"),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, String label, String? value,
      {bool rigth = false}) {
    final ThemeData theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:
          rigth ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          "${getString(context, label)}:",
          style: LelloTextStyles.body(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).textLight(),
          ),
        ),
        SizedBox(height: Dimens.spacingXSmall),
        Text(value ?? "-", style: LelloTextStyles.bodyBold(theme)),
      ],
    );
  }
}
