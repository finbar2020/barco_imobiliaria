import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/request_partners_entity.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_result_page.dart';
import 'package:shared_features/shared_features.dart';

class ComfortToYourCondoContactPage extends StatefulWidget {
  final ComfortPartnersController comfortPartnersController;
  final List<String> partners;
  final SharedApplicationContainer appContainer;
  const ComfortToYourCondoContactPage({
    super.key,
    required this.comfortPartnersController,
    required this.partners,
    required this.appContainer,
  });

  @override
  State<ComfortToYourCondoContactPage> createState() =>
      _ComfortToYourCondoContactPageState();
}

class _ComfortToYourCondoContactPageState
    extends State<ComfortToYourCondoContactPage> {
  List<bool> contactsChoices = [false, false, false];
  List<String> contacts = ["E-mail", "Whatsapp", "Telefone"];
  late Validator _validator;
  int emailSelected = 0;
  int whatsSelected = 0;
  int phoneSelected = 0;
  String selectedEmailContact = "";
  String selectedWhatsContact = "";
  String selectedPhoneContact = "";
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _validator = widget.appContainer.resolve();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var sessionBloc = widget.comfortPartnersController.getSessionBloc();
    _validator.context = context;
    return Scaffold(
      appBar: CustomAppBar(title: "comfort"),
      body: DismissKeyboard(
        child: BlocConsumer(
          bloc: widget.comfortPartnersController.comfortPartnersBloc,
          listener: (context, state) {
            if (state is LoadedComfortPartnersState &&
                state.isSuccessYourCondoPartners) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ComfortToYourCondoResultPage(isSucces: true),
                ),
              );
            } else if (state is LoadedComfortPartnersState &&
                state.isFailedCondoPartners) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ComfortToYourCondoResultPage(
                      isSucces: false, tryAgain: postRequest),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is LoadingComfortPartnersState) {
              return Column(
                children: [
                  Expanded(child: LoadingWidget()),
                ],
              );
            }
            return Form(
              key: _formKey,
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Como deseja ser contatado?",
                                  style: LelloTextStyles.titleSmallBold(theme),
                                ),
                                SizedBox(height: Dimens.spacing),
                                Text(
                                  "Selecione o meio de comunicação de sua preferência para que nosso concierge entre em contato:",
                                  style: LelloTextStyles.body(theme),
                                ),
                                SizedBox(height: Dimens.spacingMedium),
                                ...List.generate(contactsChoices.length,
                                    (index) {
                                  bool hasEmail = sessionBloc.state.session?.me
                                          ?.email?.isNotEmpty ==
                                      true;
                                  bool hasPhone = sessionBloc.state.session?.me
                                          ?.phone?.isNotEmpty ==
                                      true;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _contacChoiceFunction(
                                              index, hasEmail, hasPhone);
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 20.0,
                                              width: 20.0,
                                              decoration: BoxDecoration(
                                                  color: contactsChoices[index]
                                                      ? theme.primaryColor
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(3.0)),
                                                  border: Border.all(
                                                      color: contactsChoices[
                                                              index]
                                                          ? theme.primaryColor
                                                          : Colors.black45)),
                                              child: Center(
                                                child: Icon(Icons.check,
                                                    size: 15.0,
                                                    color:
                                                        contactsChoices[index]
                                                            ? Colors.white
                                                            : Colors
                                                                .transparent),
                                              ),
                                            ),
                                            SizedBox(width: Dimens.spacing),
                                            Text(contacts[index],
                                                style: LelloTextStyles.body(
                                                    theme)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: Dimens.spacing),
                                      if (contactsChoices[index])
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: expandedChoices(
                                                index, sessionBloc, theme),
                                          ),
                                        ),
                                    ],
                                  );
                                }),
                                SizedBox(height: Dimens.spacing),
                              ],
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: "Atenção: ",
                                    style: LelloTextStyles.bodyBold(theme)),
                                TextSpan(
                                    text:
                                        "alguns serviços têm limitação geográfica e podem não estar disponíveis para a localização do seu condomínio. Se for este o caso, lhe avisaremos dentro do prazo de resposta.",
                                    style: LelloTextStyles.body(theme)
                                        ?.copyWith(height: 1.5))
                              ],
                            ),
                          ),
                          SizedBox(height: Dimens.spacingLarge),
                          PrimaryButton(
                            onPressed: (selectedEmailContact.isNotEmpty &&
                                        emailSelected != 0) ||
                                    (selectedWhatsContact.isNotEmpty &&
                                        whatsSelected != 0) ||
                                    (selectedPhoneContact.isNotEmpty &&
                                        phoneSelected != 0)
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      postRequest();
                                    }
                                  }
                                : null,
                            text: "Enviar solicitação",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _contacChoiceFunction(int index, bool hasEmail, bool hasPhone) {
    setState(() {
      ///Apaga escolhas quando remove a seleção do contato
      if (contactsChoices[index]) {
        if (index == 0) {
          emailSelected = 0;
          selectedEmailContact = "";
        } else if (index == 1) {
          whatsSelected = 0;
          selectedWhatsContact = "";
        } else {
          phoneSelected = 0;
          selectedPhoneContact = "";
        }

        ///Caso não exista telefone ou email, já seleciona a opção de enviar um novo contato com o campo de texto para digitar
      } else {
        if (index == 0 && !hasEmail) {
          emailSelected = 2;
        } else if (index == 1 && !hasPhone) {
          whatsSelected = 2;
        } else if (index == 2 && !hasPhone) {
          phoneSelected = 2;
        }
      }
      contactsChoices[index] = !contactsChoices[index];
    });
  }

  List<Widget> expandedChoices(
      int index, dynamic sessionBloc, ThemeData theme) {
    bool hasEmail = sessionBloc.state.session?.me?.email?.isNotEmpty == true;
    bool hasPhone = sessionBloc.state.session?.me?.phone?.isNotEmpty == true;
    if (index == 0) {
      return [
        if (sessionBloc != null)
          if (hasEmail)
            selectedContactWidget(
              theme,
              sessionBloc,
              () {
                setState(() {
                  emailSelected = 1;
                  selectedEmailContact = sessionBloc.state.session!.me!.email!;
                });
              },
              emailSelected == 1,
              sessionBloc.state.session!.me!.email!,
            ),
        if (hasEmail) SizedBox(height: Dimens.spacing),
        selectedContactWidget(
          theme,
          sessionBloc,
          () {
            setState(() {
              emailSelected = 2;
              selectedEmailContact = "";
            });
          },
          emailSelected == 2,
          hasEmail ? "Informar outro e-mail" : "Informe um e-mail",
        ),
        SizedBox(height: Dimens.spacing),
        if (emailSelected == 2)
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (value) => _validator.validateEmail(value),
            onChanged: (val) {
              setState(() {
                selectedEmailContact = val;
              });
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        SizedBox(height: Dimens.spacing),
      ];
    } else if (index == 1) {
      return [
        if (sessionBloc != null)
          if (hasPhone)
            selectedContactWidget(
              theme,
              sessionBloc,
              () {
                setState(() {
                  whatsSelected = 1;
                  selectedWhatsContact = sessionBloc.state.session!.me!.phone!;
                });
              },
              whatsSelected == 1,
              sessionBloc.state.session!.me!.phone!,
            ),
        if (hasPhone) SizedBox(height: Dimens.spacing),
        selectedContactWidget(
          theme,
          sessionBloc,
          () {
            setState(() {
              whatsSelected = 2;
              selectedWhatsContact = "";
            });
          },
          whatsSelected == 2,
          hasPhone ? "Informar outro número" : "Informe um número",
        ),
        SizedBox(height: Dimens.spacing),
        if (whatsSelected == 2)
          TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateCellPhone(value),
            onChanged: (val) {
              setState(() {
                selectedWhatsContact = val;
              });
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        SizedBox(height: Dimens.spacing),
      ];
    } else {
      return [
        if (sessionBloc != null)
          if (hasPhone)
            selectedContactWidget(
              theme,
              sessionBloc,
              () {
                setState(() {
                  phoneSelected = 1;
                  selectedPhoneContact = sessionBloc.state.session!.me!.phone!;
                });
              },
              phoneSelected == 1,
              sessionBloc.state.session!.me!.phone!,
            ),
        if (hasPhone) SizedBox(height: Dimens.spacing),
        selectedContactWidget(
          theme,
          sessionBloc,
          () {
            setState(() {
              phoneSelected = 2;
              selectedPhoneContact = "";
            });
          },
          phoneSelected == 2,
          hasPhone ? "Informar outro número" : "Informe um número",
        ),
        SizedBox(height: Dimens.spacing),
        if (phoneSelected == 2)
          TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) => _validator.validateCellPhone(value),
            onChanged: (val) {
              setState(() {
                selectedPhoneContact = val;
              });
            },
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        SizedBox(height: Dimens.spacing),
      ];
    }
  }

  Widget selectedContactWidget(
    ThemeData theme,
    dynamic sessionBloc,
    VoidCallback onTap,
    bool selected,
    String title,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          ClipOval(
            child: Container(
                height: 15.0,
                width: 15.0,
                decoration: BoxDecoration(
                    color: selected ? theme.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    border: Border.all(
                        color:
                            selected ? theme.primaryColor : Colors.black45))),
          ),
          SizedBox(width: Dimens.spacingSmall),
          Text(title, style: LelloTextStyles.body(theme)),
        ],
      ),
    );
  }

  postRequest() {
    RequestPartnersEntity entity = RequestPartnersEntity(
      email: selectedEmailContact,
      whatsapp: selectedWhatsContact,
      phone: selectedPhoneContact,
      partners: widget.partners,
    );
    widget.comfortPartnersController.requestPartners(entity);
  }
}
