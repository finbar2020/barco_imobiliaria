import 'package:essentials/analytics/events/analytics_event.dart';

class AnalyticsEventsOwner {
  //Agreement
  static acordosAcessarAcordosEmAndamento() => AnalyticsEvent(
      "acordos_acessar_acordos_em_andamento", "x2w07f", Type.read);
  static acordosAcessarCotasDisponiveis() =>
      AnalyticsEvent("acordos_acessar_cotas_disponiveis", "ccwpyj", Type.read);
  static acordosAcessarAcordosRealizados() =>
      AnalyticsEvent("acordos_acessar_acordos_realizados", "sqvi1c", Type.read);
  static acordosAcessarSiteParceiroVamosParcelar() => AnalyticsEvent(
      "acordos_acessar_site_parceiro_vamos_parcelar", "qi273v", Type.read);
  static acordosEscolherPagarBoleto() =>
      AnalyticsEvent("acordos_escolher_pagar_boleto", "zffe0p", Type.read);
  static acordosEscolherPagarCartaoDeCredito() => AnalyticsEvent(
      "acordos_escolher_pagar_cartao_de_credito", "4o1an8", Type.read);
  static acordosEscolherOpcoesDePagamentoMaisIndicada() => AnalyticsEvent(
      "acordos_escolher_opcoes_de_pagamento_mais_indicada",
      "x4enqs",
      Type.read);
  static acordosEscolherOutrasOpcoesDePagamento() => AnalyticsEvent(
      "acordos_escolher_outras_opcoes_de_pagamento", "38q70l", Type.read);
  static acordosEscolherPersonalizarAcordo() => AnalyticsEvent(
      "acordos_escolher_personalizar_acordo", "tdqz07", Type.read);
  static acordosRecusarAcordo() =>
      AnalyticsEvent("acordos_recusar_acordo", "u3mowp", Type.read);
  static acordosFinalizarAcordoSucesso() =>
      AnalyticsEvent("acordos_finalizar_acordo_sucesso", "8klwff", Type.write);
  static acordosVisualizarBoleto() =>
      AnalyticsEvent("acordos_visualizar_boleto", "ezsadb", Type.read);
  static acordosCopiarCodigoDeBarras() =>
      AnalyticsEvent("acordos_copiar_codigo_de_barras", "vu6inl", Type.read);
  static acordosCompartilharBoleto() =>
      AnalyticsEvent("acordos_compartilhar_boleto", "lpzzlh", Type.read);

  //Acess Control
  static autorizacaoEntradasAcessar() =>
      AnalyticsEvent("autorizacao_entradas_acessar", "39e0pa", Type.read);
  static autorizacaoEntradasAcessarAgendamentos() => AnalyticsEvent(
      "autorizacao_entradas_acessar_agendamentos", "du0ogy", Type.read);
  static autorizacaoEntradasAcessarAgendamentosApagar() => AnalyticsEvent(
      "autorizacao_entradas_acessar_agendamentos_apagar",
      "es7gs3",
      Type.delete);
  static autorizacaoEntradasAcessarApagarVisitante() => AnalyticsEvent(
      "autorizacao_entradas_acessar_apagar_visitante", "kz57fn", Type.delete);
  static autorizacaoEntradasAgendamentosSucesso() => AnalyticsEvent(
      "autorizacao_entradas_agendamentos_sucesso", "4qp1yw", Type.write);
  static autorizacaoEntradasCadastrarNovoVisitanteSucesso() => AnalyticsEvent(
      "autorizacao_entradas_cadastrar_novo_visitante_sucesso",
      "ljxjd7",
      Type.write);

  //Billets
  static boletosAcessar() =>
      AnalyticsEvent("boletos_acessar", "lkjuxc", Type.read);
  static boletosAcessarVencido() =>
      AnalyticsEvent("boletos_acessar_vencido", "ta05t4", Type.read);
  static boletosAcessarVencidoCopiarEmail() => AnalyticsEvent(
      "boletos_acessar_vencido_copiar_email", "q23ehb", Type.read);
  static boletosAcessarVencidoIrParaWhats() => AnalyticsEvent(
      "boletos_acessar_vencido_ir_para_whats", "uv0g1b", Type.read);
  static boletosCopiarCodigoDeBarras() =>
      AnalyticsEvent("boletos_copiar_codigo_de_barras", "kvgo0a", Type.read);
  static boletosCompartilhar() =>
      AnalyticsEvent("boletos_compartilhar", "rcno08", Type.read);

  //Mailing
  static correspondenciaAcessar() =>
      AnalyticsEvent("correspondencia_acessar", "gepx95", Type.read);

  //Documents
  static documentosAcessar() =>
      AnalyticsEvent("documentos_acessar", "k1gjqd", Type.read);
  static documentosAcessarCompartilhar() =>
      AnalyticsEvent("documentos_acessar_compartilhar", "lsr1wk", Type.read);
  static documentosAtasAcessar() =>
      AnalyticsEvent("documentos_atas_acessar", "nscp3c", Type.read);
  static documentosEditaisAcessar() =>
      AnalyticsEvent("documentos_editais_acessar", "2r3ft9", Type.read);
  static documentosCircularesAcessar() =>
      AnalyticsEvent("documentos_circulares_acessar", "etzz1h", Type.read);
  static documentosDiversosAcessar() =>
      AnalyticsEvent("documentos_diversos_acessar", "6qsk86", Type.read);

  //Me
  static edicaoCadastroAcessar() =>
      AnalyticsEvent("edicao_cadastro_acessar", "emhaa3", Type.read);
  static edicaoCadastroTelaDeSucesso() =>
      AnalyticsEvent("edicao_cadastro_tela_de_sucesso", "d5zeyw", Type.write);
  static esqueciSenhaAcessar() =>
      AnalyticsEvent("esqueci_senha_acessar", "z2gatk", Type.read);
  static esqueciSenhaFinalizado() =>
      AnalyticsEvent("esqueci_senha_finalizado", "p6hu3j", Type.write);
  static loginFinalizado() =>
      AnalyticsEvent("login_finalizado", "jw7o8k", Type.write);

  //Sub User
  static moradoresAcessar() =>
      AnalyticsEvent("moradores_acessar", "4599xc", Type.read);
  static moradoresAcessarEditar() =>
      AnalyticsEvent("moradores_acessar_editar", "nxikf4", Type.read);
  static moradoresAcessarEditarBloquear() =>
      AnalyticsEvent("moradores_acessar_editar_bloquear", "bw955o", Type.write);
  static moradoresAdicionarNovoUsuario() =>
      AnalyticsEvent("moradores_adicionar_novo_usuario", "46bvsa", Type.read);
  static moradoresAdicionarNovoUsuarioSucesso() => AnalyticsEvent(
      "moradores_adicionar_novo_usuario_sucesso", "tbka17", Type.write);

  //home
  static notificacoesAcessar() =>
      AnalyticsEvent("notificacoes_acessar", "71d0wi", Type.read);
  static notificacoeCTA() =>
      AnalyticsEvent("notificacao_cta", "xpaf7r", Type.read);
  static morarHomeTemporizador() =>
      AnalyticsEvent("morar_home_temporizador", "eq060p", Type.read);

  //Reports Book
  static ocorrenciasMinhasAbertas() =>
      AnalyticsEvent("ocorrencias_minhas_abertas", "ub5erm", Type.read);
  static ocorrenciasMinhasEncerradas() =>
      AnalyticsEvent("ocorrencias_minhas_encerradas", "pnyu2p", Type.read);
  static ocorrenciasMinhasOcorrencias() =>
      AnalyticsEvent("ocorrencias_minhas_ocorrencias", "951xtp", Type.read);
  static ocorrenciasRegistrarNovaOcorrencia() => AnalyticsEvent(
      "ocorrencias_registrar_nova_ocorrencia", "aknead", Type.read);
  static ocorrenciasMinhasResponder() =>
      AnalyticsEvent("ocorrencias_minhas_responder", "8yitw2", Type.read);
  static ocorrenciasRegistrarNovaOcorrenciaSucesso() => AnalyticsEvent(
      "ocorrencias_registrar_nova_ocorrencia_sucesso", "96tdjp", Type.write);

  //Accountability
  static ppcAcessar() => AnalyticsEvent("ppc_acessar", "p41ap3", Type.read);
  static ppcAcessarMesConsultar() =>
      AnalyticsEvent("ppc_acessar_mes_consultar", "vxwo6v", Type.read);
  static redefinirSenha() =>
      AnalyticsEvent("redefinir_senha", "qdkro2", Type.write);

  //Reservation
  static reservasAcessar() =>
      AnalyticsEvent("reservas_acessar", "qx9eya", Type.read);
  static reservasAcessarAgendamentos() =>
      AnalyticsEvent("reservas_acessar_agendamentos", "h81e6d", Type.read);
  static reservasCancelar() =>
      AnalyticsEvent("reservas_cancelar", "m4zsfd", Type.delete);
  static reservasReservar() =>
      AnalyticsEvent("reservas_reservar", "oxlr22", Type.write);

  //Digital Meeting
  static resolvaFacilAssembleiaAcessar() =>
      AnalyticsEvent("resolva_facil_assembleia_acessar", "9l3l7u", Type.read);
  static resolvaFacilAssembleiaParticiparzoom() => AnalyticsEvent(
      "resolva_facil_assembleia_participarzoom", "ixvgyh", Type.read);

  //Vehicles
  static veiculoAcessar() =>
      AnalyticsEvent("veiculo_acessar", "sil59z", Type.read);
  static veiculoAcessarAdicionarNovoVeiculo() => AnalyticsEvent(
      "veiculo_acessar_adicionar_novo_veiculo", "28zh6q", Type.write);
  static veiculoAcessarAdicionarNovoVeiculoSucesso() => AnalyticsEvent(
      "veiculo_acessar_adicionar_novo_veiculo_sucesso", "eblev4", Type.write);
  static veiculoAcessarExcluirVeiculo() =>
      AnalyticsEvent("veiculo_acessar_excluir_veiculo", "5pmpmo", Type.delete);

//Comfort
  static comodidadesCtaOptIn() =>
      AnalyticsEvent("comodidades_cta_opt_in", "mbm4hb", Type.write);
  static comodidadesCtaRedirecionamento() =>
      AnalyticsEvent("comodidades_cta_redirect", "tar6ji", Type.read);
  static comodidadesCtaCardFechar() =>
      AnalyticsEvent("comodidades_cta_fechar_card", "iudnje", Type.read);
  static comodidadesLgpdAcessar() =>
      AnalyticsEvent("comodidades_lgpd_acessar", "ikzjmc", Type.read);
  static comodidadesCtaAcessar() =>
      AnalyticsEvent("comodidades_cta_acessar", "3t6adh", Type.read);
  static comodidadesParceiroAcessar() =>
      AnalyticsEvent("comodidades_parceiro_acessar", "uxxv42", Type.read);
  static comodidadesParceiroVoltar() =>
      AnalyticsEvent("comodidades_parceiro_voltar", "o8xu1n", Type.read);
  static comodidadesAcessar() =>
      AnalyticsEvent("comodidades_acessar", "eykqhn", Type.read);
  static comodidadesVoltar() =>
      AnalyticsEvent("comodidades_voltar", "ua2w0v", Type.read);
  static comodidadesAvaliar() =>
      AnalyticsEvent("comodidades_avaliar", "qsto8u", Type.write);
  static comodidadesAvaliarDepois() =>
      AnalyticsEvent("comodidades_avaliar_depois", "vsvxyw", Type.write);
  static comodidadesCompraRealizada() =>
      AnalyticsEvent("comodidades_compra_realizada", "m938b6", Type.write);
  static comodidadesCupomAtivar() =>
      AnalyticsEvent("comodidades_cupom_ativar", "2fbqgg", Type.write);
  static comodidadesFavoritosAcessar() =>
      AnalyticsEvent("comodidades_favoritos_acessar", "g63fbu", Type.read);
  static comodidadesMudarFavorito() =>
      AnalyticsEvent("comodidades_mudar_favorito", "20z2kw", Type.write);
  static comodidadesParceiroAvaliacoesAcessar() => AnalyticsEvent(
      "comodidades_parceiro_avaliacoes_acessar", "bh38fv", Type.read);
  static comodidadesSolicitacoesAcessar() =>
      AnalyticsEvent("comodidades_solicitacoes_acessar", "gq0m2e", Type.read);
  static comodidadesAcessarViaDialog() =>
      AnalyticsEvent("comodidades_acessar_via_dialog", "al344l", Type.read);
  static comodidadesRecusarAcessoViaDialog() => AnalyticsEvent(
      "comodidades_recusar_acesso_via_dialog", "kbinwp", Type.read);
  static comodidadesCategoriaAcessar() =>
      AnalyticsEvent("comodidades_categoria_acessar", "c6fcfe", Type.read);
  static comodidadesCategoriaVoltar() =>
      AnalyticsEvent("comodidades_categoria_voltar", "isq4nc", Type.read);
  static comodidadesSubCategoriaAcessar() =>
      AnalyticsEvent("comodidades_subcategoria_acessar", "yhbbvj", Type.read);
  static comodidadesHomeTemporizador() =>
      AnalyticsEvent("comodidades_home_temporizador", "c8mrdw", Type.read);
  static comodidadesCategoriaTemporizador() =>
      AnalyticsEvent("comodidades_categoria_temporizador", "au8tj8", Type.read);
  static comodidadesCardComodidadeTemporizador() =>
      AnalyticsEvent("comodidades_card_temporizador", "a2v650", Type.read);
  static comodidadesModalRedirecionamentoTemporizador() => AnalyticsEvent(
      "comodidades_modal_redirect_temporizador", "z0x6r7", Type.read);
  static comodidadesPaginaParceiroTemporizador() => AnalyticsEvent(
      "comodidades_page_parceiro_temporizador", "k6qln4", Type.read);

  //TDB - Tesouros do Bairro
  static tdbAcessar() => AnalyticsEvent("tdb_acessar", "5mwycx", Type.read);
  static tdbCadastrar() =>
      AnalyticsEvent("tdb_cadastrar", "e792ky", Type.write);

  //Dynamic Banner
  static bannerDinamicoAcessar() =>
      AnalyticsEvent("banner_dinamico_acessar", "oyra8k", Type.read);

  //Insurance
  static comodidadesParceiroSegurosAcessar() => AnalyticsEvent(
      "comodidades_parceiro_seguros_acessar", "ghk8t1", Type.read);
  static comodidadesParceiroSegurosCancelar() => AnalyticsEvent(
      "comodidades_parceiro_seguros_cancelar", "w38073", Type.read);
  static comodidadesParceiroSegurosContratar() => AnalyticsEvent(
      "comodidades_parceiro_seguros_contratar", "cm0lpc", Type.write);
  static comodidadesParceiroSegurosDesistir() => AnalyticsEvent(
      "comodidades_parceiro_seguros_desistir", "djnzm6", Type.read);

  //Session
  static sessaoIniciar() =>
      AnalyticsEvent("sessao_iniciar", "7q4vnd", Type.read);

  //Fale com a Lello
  static falelelloAcessar() =>
      AnalyticsEvent("falelello_acessar", "smtjqk", Type.read);

  //Rent or sell
  static lelloImoveisAcessar() =>
      AnalyticsEvent("lello_imoveis_acessar", "b3w1uq", Type.read);
  static lelloImoveisRecusarAcesso() =>
      AnalyticsEvent("lello_imoveis_recusar_acesso", "vsfgjf", Type.read);
}
