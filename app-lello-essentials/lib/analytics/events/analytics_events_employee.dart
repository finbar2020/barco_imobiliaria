import 'package:essentials/analytics/events/analytics_event.dart';

class AnalyticsEventsEmployee {
  //Login Page
  static esqueciSenhaAcessar() =>
      AnalyticsEvent("esqueci_senha_acessar", "bmemjq", Type.read);
  static esqueciSenhaFinalizado() =>
      AnalyticsEvent("esqueci_senha_finalizado", "lthniw", Type.write);
  static redefinirSenha() =>
      AnalyticsEvent("redefinir_senha", "1o19zn", Type.write);

  static sessaoIniciar() =>
      AnalyticsEvent("sessao_iniciar", "7zsp7g", Type.read);

  //uptade Profile
  static edicaoCadastradoAcessar() =>
      AnalyticsEvent("edicao_cadastro_acessar", "55z19b", Type.read);
  static edicaoCadastradoSucesso() =>
      AnalyticsEvent("edicao_cadastro_tela_de_sucesso", "y1dqrv", Type.write);

  //Comfort
  static comodidadesCtaOptIn() =>
      AnalyticsEvent("comodidades_cta_opt_in", "kis0oy", Type.write);
  static comodidadesCtaRedirecionamento() =>
      AnalyticsEvent("comodidades_cta_redirect", "32cj6i", Type.read);
  static comodidadesCtaCardFechar() =>
      AnalyticsEvent("comodidades_cta_fechar_card", "sn654c", Type.read);
  static comodidadesLgpdAcessar() =>
      AnalyticsEvent("comodidades_lgpd_acessar", "yo2xmp", Type.read);
  static comodidadesCtaAcessar() =>
      AnalyticsEvent("comodidades_cta_acessar", "63g7xo", Type.read);
  static comodidadesParceiroAcessar() =>
      AnalyticsEvent("comodidades_parceiro_acessar", "nsv0hf", Type.read);
  static comodidadesParceiroVoltar() =>
      AnalyticsEvent("comodidades_parceiro_voltar", "b7qi0a", Type.read);
  static comodidadesAcessar() =>
      AnalyticsEvent("comodidades_acessar", "l17hgc", Type.read);
  static comodidadesVoltar() =>
      AnalyticsEvent("comodidades_voltar", "uw9mu0", Type.read);
  static comodidadesAvaliar() =>
      AnalyticsEvent("comodidades_avaliar", "suxb4w", Type.write);
  static comodidadesAvaliarDepois() =>
      AnalyticsEvent("comodidades_avaliar_depois", "mfwywy", Type.write);
  static comodidadesCompraRealizada() =>
      AnalyticsEvent("comodidades_compra_realizada", "ykr7ah", Type.write);
  static comodidadesCupomAtivar() =>
      AnalyticsEvent("comodidades_cupom_ativar", "ij690l", Type.write);
  static comodidadesFavoritosAcessar() =>
      AnalyticsEvent("comodidades_favoritos_acessar", "c1vinj", Type.read);
  static comodidadesMudarFavorito() =>
      AnalyticsEvent("comodidades_mudar_favorito", "6y6y1b", Type.write);
  static comodidadesParceiroAvaliacoesAcessar() => AnalyticsEvent(
      "comodidades_parceiro_avaliacoes_acessar", "5atq2i", Type.read);
  static comodidadesSolicitacoesAcessar() =>
      AnalyticsEvent("comodidades_solicitacoes_acessar", "nde8c9", Type.read);
  static comodidadesCategoriaAcessar() =>
      AnalyticsEvent("comodidades_categoria_acessar", "ujgfk8", Type.read);
  static comodidadesCategoriaVoltar() =>
      AnalyticsEvent("comodidades_categoria_voltar", "ad7hsj", Type.read);
  static comodidadesSubCategoriaAcessar() =>
      AnalyticsEvent("comodidades_subcategoria_acessar", "y49nwc", Type.read);
  static comodidadesHomeTemporizador() =>
      AnalyticsEvent("comodidades_home_temporizador", "5gca5q", Type.read);
  static comodidadesCategoriaTemporizador() =>
      AnalyticsEvent("comodidades_categoria_temporizador", "ppj2r7", Type.read);
  static comodidadesCardComodidadeTemporizador() =>
      AnalyticsEvent("comodidades_card_temporizador", "peue82", Type.read);
  static comodidadesModalRedirecionamentoTemporizador() => AnalyticsEvent(
      "comodidades_modal_redirect_temporizador", "de6h0n", Type.read);
  static comodidadesPaginaParceiroTemporizador() => AnalyticsEvent(
      "comodidades_page_parceiro_temporizador", "ocuiek", Type.read);

  //Dynamic Banner
  static bannerDinamicoAcessar() =>
      AnalyticsEvent("banner_dinamico_acessar", "oyra8k", Type.read);

  //Documents
  static documentosHoleriteAcessar() =>
      AnalyticsEvent("documentos_holerite_acessar", "kzlez2", Type.read);
  static documentosFeriasAcessar() =>
      AnalyticsEvent("documentos_ferias_acessar", "ducmvu", Type.read);
  static documentosBeneficiosAcessar() =>
      AnalyticsEvent("documentos_beneficios_acessar", "fk0kkg", Type.read);
  // TODO(negócio): nome com typo ("redimentos"); manter até alinhar com o
  // dashboard, pois o nome é contrato com o Firebase.
  static documentosInfoRendimentosAcessar() =>
      AnalyticsEvent("documentos_info_redimentos_acessar", "2lsrcj", Type.read);

  //Benefits
  static vantagensIndiqueGanheAcessar() =>
      AnalyticsEvent("vantagens_indique_ganhe_acessar", "78raph", Type.read);
  static vantagensCondolivreAcessar() =>
      AnalyticsEvent("vantagens_condolivre_acessar", "khtcu6", Type.read);
  static vantagensCursosAcessar() =>
      AnalyticsEvent("vantagens_cursos_acessar", "6mczkp", Type.read);

  static notificacoeCTA() =>
      AnalyticsEvent("notificacao_cta", "pjmjdc", Type.read);

  //Digital Point
  static pontoDigitalEspelhoPontoAcessar() => AnalyticsEvent(
      "ponto_digital_espelho_ponto_acessar", "ifr3hb", Type.read);
  static pontoDigitalEspelhoPontoAssinar() => AnalyticsEvent(
      "ponto_digital_espelho_ponto_assinar", "dsq0vl", Type.write);
  static pontoDigitalDetalhesTratativasAcessar() => AnalyticsEvent(
      "ponto_digital_detalhes_tratativas_acessar", "a9k6e1", Type.read);
  static pontoDigitalInformacoesAcessar() =>
      AnalyticsEvent("ponto_digital_informacoes_acessar", "qoh9k5", Type.read);
  static pontoDigitalComprovanteAcessar() =>
      AnalyticsEvent("ponto_digital_comprovante_acessar", "wzytl2", Type.read);
  static pontoDigitalRelorioAcessar() =>
      AnalyticsEvent("ponto_digital_relatorio_acessar", "9t6q98", Type.read);
  static pontoDigitalAtestadoMedicoAcessar() => AnalyticsEvent(
      "ponto_digital_atestado_medico_acessar", "yp4mc9", Type.read);
  static pontoDigitalAtestadoMedicoSucesso() => AnalyticsEvent(
      "ponto_digital_atestado_medico_envio_sucesso", "o8gxwp", Type.write);

  //Home
  static homeEnvioFolhaPontoAcessar() =>
      AnalyticsEvent("home_envio_folha_ponto_acessar", "43q72k", Type.read);
  static homeEnvioFolhaPontoSucesso() =>
      AnalyticsEvent("home_envio_folha_ponto_sucesso", "2o8oml", Type.write);
  static homeLiberarPontoDigitalAcessar() =>
      AnalyticsEvent("home_liberar_ponto_digital_acessar", "c3qb1i", Type.read);
  static homeConhecerPontoDigitalAcessar() => AnalyticsEvent(
      "home_conhecer_ponto_digital_acessar", "bah91s", Type.read);
  static homeRegistrarPontoDigitalAcessar() => AnalyticsEvent(
      "home_registrar_ponto_digital_acessar", "9bun7x", Type.read);
  static homeRegistrarPontoDigitalSucesso() => AnalyticsEvent(
      "home_registrar_ponto_digital_sucesso", "coq4cm", Type.write);
  static homeRegistrarPontoDigitalFalhaIdentificacao() => AnalyticsEvent(
      "home_registrar_ponto_digital_falha_identificacao", "pfxuf9", Type.write);
  static homeRegistrarPontoDigitalFalhaEnvio() => AnalyticsEvent(
      "home_registrar_ponto_digital_falha_envio", "4ss3yo", Type.write);
  static homeRegistrarPontoDigitalSucessoOffline() => AnalyticsEvent(
      "home_registrar_ponto_digital_sucesso_offline", "srxs28", Type.write);
  static homeWhatsAppAcessar() =>
      AnalyticsEvent("home_whatsapp_acessar", "i7e3vk", Type.read);
  static colaboradorHomeTemporizador() =>
      AnalyticsEvent("colaborador_home_temporizador", "z6880i", Type.read);

  //Gestão de Pessoas
  static gdpAcessar() => AnalyticsEvent("gdp_acessar", "9yla91", Type.read);
  static resolvaRapidoAcessar() =>
      AnalyticsEvent("resolva_rapido_acessar", "3k1yc6", Type.read);
  static resolvaRapidoFinalizado(String type) =>
      AnalyticsEvent("resolva_rapido_finalizado", "n1c1q5", type);
  static agendarFeriasAcessar() =>
      AnalyticsEvent("agendar_ferias_acessar", "crtmb6", Type.read);
  static agendarFeriasFinalizado() =>
      AnalyticsEvent("agendar_ferias_finalizado", "ix1hsy", Type.write);
  static folhaPgtoAcessar() =>
      AnalyticsEvent("folha_pgto_acessar", "ug61ax", Type.read);
  static holeriteAcessar() =>
      AnalyticsEvent("holerite_acessar", "tcfg12", Type.read);
  static pontoDigitalAcessar() =>
      AnalyticsEvent("ponto_digital_acessar", "qz90ry", Type.read);
  static pontoAcaoOcorrenciaAcessar() =>
      AnalyticsEvent("ponto_acao_ocorrencia_acessar", "29mqat", Type.read);
  static pontoAcaoOcorrenciaFinalizado(String type) =>
      AnalyticsEvent("ponto_acao_ocorrencia_finalizado", "wkka47", type);
  static pontoAssinaFolhaAcessar() =>
      AnalyticsEvent("ponto_assinafolha_acessar", "3j82ro", Type.read);
  static pontoAssinaFolhaFinalizado() =>
      AnalyticsEvent("ponto_assinafolha_finalizado", "wuzqst", Type.write);
  static pontoInserirEventoFinalizado() =>
      AnalyticsEvent("ponto_inserir_evento_finalizado", "ds0t52", Type.write);

  //Equipe
  static dadosEquipeAcessar() =>
      AnalyticsEvent("dados_equipe_acessar", "18un06", Type.read);

  //Indica Vada
  static indicaVagaAcessar() =>
      AnalyticsEvent("indica_vaga_acessar", "ybzfox", Type.read);
  static indicaVagaEventoFinalizado() =>
      AnalyticsEvent("indica_vaga_envio_sucesso", "3bel3i", Type.write);
}
