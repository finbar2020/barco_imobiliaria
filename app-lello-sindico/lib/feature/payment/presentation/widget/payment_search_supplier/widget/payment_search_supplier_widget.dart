import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/payment/domain/entity/supplier_data_entity.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/bloc/payment_search_supplier_bloc.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/bloc/payment_search_supplier_state.dart';
import 'package:lello/feature/payment/presentation/widget/payment_search_supplier/controllers/payment_search_supplier_controller.dart';
import 'package:shared_features/feature/attach_files/widgets/attach_files_error_toasts.dart';

class PaymentSearchSupplierWidget extends StatefulWidget {
  /// [showDocumentInput]: Indica se o campo de entrada manual de documento deve ser exibido.
  final bool showDocumentInput;

  /// [initialSuplierId]: Fornecedor pré-selecionado ao iniciar o widget.
  final int? initialSuplierId;

  /// [initialDocument]: Documento pré-preenchido no campo de entrada ao iniciar o widget.
  final String? initialDocument;

  /// Callback acionado sempre que o documento ou fornecedor for alterado.
  final Function(String? document, SupplierDataEntity? supplier) onChange;

  /// Widget para buscar e selecionar fornecedores.
  ///
  /// Este widget permite ao usuário selecionar um fornecedor por meio de um dropdown
  /// ou informar manualmente um documento (CPF/CNPJ).
  ///
  /// Parâmetros:
  /// - [showDocumentInput]: Indica se o campo de entrada manual de documento deve ser exibido.
  /// - [initialSuplierId]: Fornecedor pré-selecionado ao iniciar o widget.
  /// - [initialDocument]: Documento pré-preenchido no campo de entrada ao iniciar o widget.
  /// - [onChange]: Callback acionado sempre que o documento ou fornecedor for alterado.
  const PaymentSearchSupplierWidget({
    super.key,
    required this.onChange,
    this.showDocumentInput = true,
    this.initialSuplierId,
    this.initialDocument,
  });

  @override
  State<PaymentSearchSupplierWidget> createState() =>
      _PaymentSearchSupplierWidgetState();
}

/// Estado do [PaymentSearchSupplierWidget].
///
/// Gerencia o estado interno do widget, incluindo a validação e busca de fornecedores.
class _PaymentSearchSupplierWidgetState
    extends State<PaymentSearchSupplierWidget> {
  /// Controlador do campo de texto para entrada manual de documento.
  late final TextEditingController _textFieldController;

  /// Controlador responsável pela lógica de busca e filtro de fornecedores.
  final PaymentSearchSupplierController controller =
      ApplicationContainer.instance().resolve();

  /// Validador para CPF/CNPJ, configurado com o contexto atual.
  final Validator validator = ApplicationContainer.instance().resolve();

  /// Indica se a mensagem "Nenhum fornecedor encontrado" deve ser exibida.
  bool _showNoSupplierMessage = false;

  @override
  void initState() {
    super.initState();
    validator.context = context;

    // Inicializa o controlador do campo de texto.
    _textFieldController = TextEditingController();

    // Pré-configura o campo de texto e o fornecedor selecionado se valores iniciais foram passados.
    if (widget.initialDocument != null && widget.initialDocument!.isNotEmpty) {
      _textFieldController.text = widget.initialDocument ?? "";
      _onTextChanged(widget.initialDocument!);
    }

    if (widget.initialSuplierId != null) {
      setSupplier(null, SupplierDataEntity(id: widget.initialSuplierId));
    }
  }

  @override
  void dispose() {
    // Libera os recursos do controlador do campo de texto.
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(theme),
        SizedBox(height: Dimens.spacing),
        _buildDropdownSearch(context, theme),
        if (widget.showDocumentInput) _buildDocumentInput(context, theme),
      ],
    );
  }

  /// Exibe o rótulo principal do widget.
  Widget _buildLabel(ThemeData theme) {
    return Text(
      getString(context, "payments_widget_supplier_label"),
      style: LelloTextStyles.subtitleBold(theme)!.copyWith(
        color: LelloTheme.palleteOf(theme).text(),
      ),
    );
  }

  /// Constrói o dropdown para seleção de fornecedores.
  ///
  /// O dropdown permite ao usuário buscar fornecedores por nome ou documento.
  Widget _buildDropdownSearch(BuildContext context, ThemeData theme) {
    return BlocConsumer<PaymentSearchSupplierListBloc,
        PaymentSearchSupplierState>(
      bloc: controller.bloc,
      listener: (context, state) {
        if (state is PaymentSearchSupplierFailureState) {
          _showError();
          _resetSelection();
          _updateSelection(null, null);
        } else if (state is PaymentSearchSupplierSuccessState) {
          setState(() {
            controller.selectedSupplier = state.value;
            _textFieldController.text =
                state.value.document?.formatCpfCnpj() ?? "";
          });
          _updateSelection(state.value.document, state.value);
        }
      },
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment
              .center, // Certifica alinhamento vertical correto
          children: [
            Expanded(
              // Garante que o DropdownSearch ocupe o espaço necessário
              child: DropdownSearch<SupplierDataEntity>(
                enabled: state is! PaymentSearchSupplierLoadingState,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  itemBuilder: (context, item, isDisabled, isSelected) {
                    return ListTile(
                      title: Text(item.name ?? ""),
                      subtitle: Text(item.document?.formatCpfCnpj() ?? ""),
                    );
                  },
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      label: Text(getString(context, "find")),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  emptyBuilder: (context, searchEntry) {
                    if (controller.nameEmpty && controller.docEmpty) {
                      return ListTile(
                        title: Text(getString(
                            context, "payments_widget_supplier_empty_tip")),
                      );
                    }
                    return ListTile(
                      title: Text(getString(
                          context, "payments_widget_supplier_no_results")),
                      subtitle: _buildFilterText(context),
                    );
                  },
                ),
                suffixProps: const DropdownSuffixProps(
                  clearButtonProps: ClearButtonProps(isVisible: true),
                ),
                items: (filter, loadProps) {
                  controller.nameFilter = filter;
                  return controller.fetchValues();
                },
                compareFn: (i, s) => i.id == s.id,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: getString(context, "select"),
                    hintStyle:
                        TextStyle(color: LelloTheme.palleteOf(theme).text()),
                  ),
                ),
                itemAsString: (item) => "${item.document} - ${item.name}",
                dropdownBuilder: (context, selectedItem) {
                  return Text(
                    selectedItem?.name ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  );
                },
                onChanged: _onDropdownChanged,
                selectedItem: controller.selectedSupplier,
              ),
            ),
            if (state is PaymentSearchSupplierLoadingState)
              const Padding(
                padding: EdgeInsets.only(
                    left:
                        8.0), // Adiciona espaçamento entre o dropdown e o indicador
                child: CircularProgressIndicator(),
              ),
          ],
        );
      },
    );
  }

  /// Constrói o campo de entrada manual de documento.
  ///
  /// Permite que o usuário insira manualmente um CPF/CNPJ caso o fornecedor
  /// desejado não seja encontrado no dropdown.
  Widget _buildDocumentInput(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimens.spacing),
        if (_showNoSupplierMessage)
          Padding(
            padding: EdgeInsets.only(left: Dimens.spacingSmall),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.orange),
                SizedBox(width: Dimens.spacingSmall),
                Text(getString(context, "payments_widget_supplier_not_found")),
              ],
            ),
          ),
        SizedBox(height: Dimens.spacing),
        Text(
          "${getString(context, "payments_widget_supplier_document")}*",
          style: LelloTextStyles.subtitleBold(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).text(),
          ),
        ),
        SizedBox(height: Dimens.spacing),
        TextFormField(
          controller: _textFieldController,
          inputFormatters: [cpfOrCnpjFormatter()],
          readOnly: controller.selectedSupplier != null,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: validator.validateCPForCNPJ,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: _onTextChanged,
        ),
      ],
    );
  }

  /// Constrói a mensagem com os filtros aplicados.
  ///
  /// Exibe os filtros de nome ou documento atualmente aplicados ao dropdown.
  Widget _buildFilterText(BuildContext context) {
    final nameFilter = controller.nameFilter;
    final documentFilter = controller.documentFilter;

    if (nameFilter != null && documentFilter != null) {
      return Text(
          "${getString(context, "payments_widget_supplier_name")}: $nameFilter - ${getString(context, "payments_widget_supplier_document")}: $documentFilter");
    } else if (nameFilter != null) {
      return Text(
          "${getString(context, "payments_widget_supplier_name")}: $nameFilter");
    } else if (documentFilter != null) {
      return Text(
          "${getString(context, "payments_widget_supplier_document")}: $documentFilter");
    }
    return const SizedBox.shrink();
  }

  /// Lógica ao alterar o valor do dropdown.
  ///
  /// Atualiza o fornecedor selecionado e o campo de entrada manual.
  void _onDropdownChanged(SupplierDataEntity? supplier) {
    setState(() {
      setSupplier(supplier?.document, supplier);
      _textFieldController.text = supplier?.document?.formatCpfCnpj() ?? "";
      controller.selectedSupplier = supplier;
      if (supplier == null) {
        controller.documentFilter = null;
        controller.nameFilter = null;
      }
    });
  }

  /// Lógica ao alterar o valor do campo de documento.
  ///
  /// Valida o documento e busca os fornecedores correspondentes.
  void _onTextChanged(String value) {
    if (value.isEmpty) {
      controller.documentFilter = value;
      _updateNoSupplierMessage([], null);
    } else if (validator.validateCPForCNPJ(value) == null) {
      controller.documentFilter = value.replaceAll(RegExp(r'[^\d ]'), "");
      controller.fetchValues().then((fetchedValues) {
        _updateNoSupplierMessage(
            fetchedValues, value.replaceAll(RegExp(r'[^\d ]'), ""));
      });
    }
  }

  /// Atualiza a mensagem de "Nenhum fornecedor encontrado".
  ///
  /// Define o estado da mensagem e o fornecedor selecionado com base nos resultados da busca.
  void _updateNoSupplierMessage(
      List<SupplierDataEntity> fetchedValues, String? document) {
    setState(() {
      if (fetchedValues.isEmpty && document == null) {
        setSupplier(document, null);
        _showNoSupplierMessage = false;
        return;
      }
      _showNoSupplierMessage = fetchedValues.isEmpty;
      if (_showNoSupplierMessage) {
        setSupplier(document, null);
      } else if (fetchedValues.length == 1) {
        controller.selectedSupplier = fetchedValues.first;
      }
    });
  }

  /// Define o fornecedor selecionado ou exibe um erro caso não seja possível selecionar.
  ///
  /// Este método realiza as seguintes ações:
  /// 1. Se ambos [document] e [supplier] forem `null`, a seleção é limpa.
  /// 2. Caso apenas [supplier] seja fornecido, tenta buscar os dados atualizados do fornecedor pelo ID.
  ///    - Se o fornecedor for encontrado, a seleção é atualizada.
  ///    - Caso contrário, exibe uma mensagem de erro e limpa a seleção.
  /// 3. Se apenas [document] for fornecido, a seleção é atualizada com o documento e sem fornecedor.
  ///
  /// Parâmetros:
  /// - [document]: O documento (CPF/CNPJ) do fornecedor. Pode ser `null` para limpar o campo de documento.
  /// - [supplier]: O fornecedor selecionado. Pode ser `null` para limpar a seleção.
  void setSupplier(String? document, SupplierDataEntity? supplier) {
    if (document == null && supplier == null) {
      _updateSelection(null, null);
      return;
    }
    if (supplier != null) {
      // Tenta buscar o fornecedor pelo ID.
      controller.getSupplier(supplier.id);
    } else {
      // Atualiza a seleção apenas com o documento.
      _updateSelection(document, null);
    }
  }

  /// Exibe uma mensagem de erro ao usuário.
  ///
  /// Utiliza o contexto do widget para exibir um alerta de erro genérico.
  void _showError() {
    if (mounted) {
      AttachFilesErrorToasts.showGenericError(
        context: context,
        errorTitle:
            getString(context, "payments_widget_supplier_select_error_title"),
        errorMessage: getString(
            context, "payments_widget_supplier_select_error_sub_title"),
        autoCloseDuration: const Duration(seconds: 5),
      );
    }
  }

  /// Reseta a seleção do fornecedor.
  ///
  /// Limpa o texto do campo de documento e remove o fornecedor selecionado atual.
  void _resetSelection() {
    if (mounted) {
      setState(() {
        _textFieldController.text = "";
        controller.selectedSupplier = null;
      });
    }
  }

  /// Atualiza a seleção do documento e fornecedor.
  ///
  /// Este método aciona o callback [onChange] para informar a nova seleção ao componente pai.
  ///
  /// Parâmetros:
  /// - [document]: O documento (CPF/CNPJ) do fornecedor selecionado.
  /// - [supplier]: O fornecedor selecionado. Pode ser `null` para limpar a seleção.
  void _updateSelection(String? document, SupplierDataEntity? supplier) {
    widget.onChange(document, supplier);
  }
}
