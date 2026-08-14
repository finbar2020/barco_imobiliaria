import 'package:essentials/analytics/events/analytics_event.dart';

class AnalyticsEventsManager {
  //Despesas
  static despesasAcessar() =>
      AnalyticsEvent("despesas_acessar", "2gbbeo", Type.read);
  static enviarPagamentoFinalizado() =>
      AnalyticsEvent("enviar_pagamento_finalizado", "fa2j8d", Type.write);
  static historicoPagamentoAcessar() =>
      AnalyticsEvent("historico_pagamento_acessar", "4pt30w", Type.read);
  static consultarPagamentoAcessar() =>
      AnalyticsEvent("consultar_pagamento_acessar", "jcq0sz", Type.read);
  static aprovacaoPendenteAcessar() =>
      AnalyticsEvent("aprovacao_pendente_acessar", "mo342w", Type.read);
  static aprovacaoPendenteRecusar() =>
      AnalyticsEvent("aprovacao_pendente_recusar", "a9axoo", Type.write);
  static aprovacaoPendenteAprovar() =>
      AnalyticsEvent("aprovacao_pendente_aprovar", "hbjbto", Type.write);
  static aprovacaoPendenteSuspender() =>
      AnalyticsEvent("aprovacao_pendente_suspender", "og7fp5", Type.write);
  static aprovacaoPendenteSucessoAprovar() => AnalyticsEvent(
      "aprovacao_pendente_sucesso_aprovar", "odfted", Type.write);
  static aprovacaoPendenteSucessoRecusar() => AnalyticsEvent(
      "aprovacao_pendente_sucesso_recusar", "byxqwv", Type.write);
  static aprovacaoPendenteSucessoSuspender() => AnalyticsEvent(
      "aprovacao_pendente_sucesso_suspender", "8hs6bw", Type.write);
  static aprovacaoPendenteErro() =>
      AnalyticsEvent("aprovacao_pendente_erro", "97wzq7", Type.write);
  static aprovarPagamentoAcessar() =>
      AnalyticsEvent("aprovar_pagamento_acessar", "a3au40", Type.read);
  static aprovarPagamentoFinalizado() =>
      AnalyticsEvent("aprovar_pagamento_finalizado", "ymct83", Type.write);
  static despEnviarClick() =>
      AnalyticsEvent("desp_enviar_click", "p3sz4w", Type.read);

  //Receitas
  static receitasAcessar() =>
      AnalyticsEvent("receitas_acessar", "ml04bg", Type.read);
  static detalhesReceitasAcessar() =>
      AnalyticsEvent("detalhes_receitas_acessar", "o9q4p3", Type.read);
  static receitasControleAcessar() =>
      AnalyticsEvent("receitas_controle_acessar", "gj4b9y", Type.read);

  //Gestão de Pessoas
  static gdpAcessar() => AnalyticsEvent("gdp_acessar", "tbn0ca", Type.read);
  static resolvaRapidoAcessar() =>
      AnalyticsEvent("resolva_rapido_acessar", "s0hwed", Type.read);
  static resolvaRapidoFinalizado(String type) =>
      AnalyticsEvent("resolva_rapido_finalizado", "a6qrm5", type);
  static agendarFeriasAcessar() =>
      AnalyticsEvent("agendar_ferias_acessar", "uurswn", Type.read);
  static agendarFeriasFinalizado() =>
      AnalyticsEvent("agendar_ferias_finalizado", "f4fadl", Type.write);
  static folhaPgtoAcessar() =>
      AnalyticsEvent("folha_pgto_acessar", "f1mnr7", Type.read);
  static holeriteAcessar() =>
      AnalyticsEvent("holerite_acessar", "1kznz4", Type.read);
  static pontoDigitalAcessar() =>
      AnalyticsEvent("ponto_digital_acessar", "yd3nip", Type.read);
  static pontoAcaoOcorrenciaAcessar() =>
      AnalyticsEvent("ponto_acao_ocorrencia_acessar", "givr2p", Type.read);
  static pontoAcaoOcorrenciaFinalizado(String type) =>
      AnalyticsEvent("ponto_acao_ocorrencia_finalizado", "l68d59", type);
  static pontoAssinaFolhaAcessar() =>
      AnalyticsEvent("ponto_assinafolha_acessar", "x2fhga", Type.read);
  static pontoAssinaFolhaFinalizado() =>
      AnalyticsEvent("ponto_assinafolha_finalizado", "w6og64", Type.write);
  static pontoInserirEventoFinalizado() =>
      AnalyticsEvent("ponto_inserir_evento_finalizado", "w6og64", Type.write);

  //Inadimplência
  static inadimplenciaAcessar() =>
      AnalyticsEvent("inadimplencia_acessar", "okzbwx", Type.read);

  //Prestação de Contas
  static ppcAcessar() => AnalyticsEvent("ppc_acessar", "btppz1", Type.read);
  static aprovarPpcAcessar() =>
      AnalyticsEvent("aprovar_ppc_acessar", "ddcr6q", Type.read);
  static aprovarPpcFinalizado() =>
      AnalyticsEvent("aprovar_ppc_finalizado", "hml09t", Type.write);

  //Fale com a Lello
  static falelelloAcessar() =>
      AnalyticsEvent("falelello_acessar", "a256c2", Type.read);
  static falelelloFinalizado() =>
      AnalyticsEvent("falelello_finalizado", "lmu3qy", Type.write);
  static duvidaAcessar() =>
      AnalyticsEvent("duvida_acessar", "nj9pk9", Type.read);
  static duvidaFinalizado() =>
      AnalyticsEvent("duvida_finalizado", "amzw94", Type.write);

  //Caixa local
  static caixaLocalAcessar() =>
      AnalyticsEvent("caixa_local_acessar", "yn23ru", Type.read);
  static historicoReembolsoAcessar() =>
      AnalyticsEvent("historico_reembolso_acessar", "7m98uw", Type.read);
  static solicitarReembolsoAcessar() =>
      AnalyticsEvent("solicitar_reembolso_acessar", "oqpd7b", Type.read);
  static solicitarReembolsoFinalizado() =>
      AnalyticsEvent("solicitar_reembolso_finalizado", "xxyv6q", Type.write);
  static historicoAdiantamentoAcessar() =>
      AnalyticsEvent("historico_adiantamento_acessar", "2q13c4", Type.read);
  static solicitarAdiantamentoAcessar() =>
      AnalyticsEvent("solicitar_adiantamento_acessar", "xzdkdb", Type.read);
  static solicitarAdiantamentoFinalizado() =>
      AnalyticsEvent("solicitar_adiantamento_finalizado", "ozbcji", Type.write);
  static envioComprovanteAcessar() =>
      AnalyticsEvent("envio_comprovante_acessar", "1lqmd8", Type.read);
  static envioComprovanteFinalizado() =>
      AnalyticsEvent("envio_comprovante_finalizado", "5rcjuv", Type.write);

  //Boleto do mês
  static condBoletosAcessar() =>
      AnalyticsEvent("cond_boletos_acessar", "5pt2wu", Type.read);

  //Equipe
  static dadosEquipeAcessar() =>
      AnalyticsEvent("dados_equipe_acessar", "qnbypi", Type.read);

  //Reserva de Áreas
  static condAreasAgendaAcessar() =>
      AnalyticsEvent("cond_areas_agenda_acessar", "q2ukmr", Type.read);
  static condAreasReservarAcessar() =>
      AnalyticsEvent("cond_areas_reservar_acessar", "dda6nb", Type.read);
  static condAreasReservarFinalizado() =>
      AnalyticsEvent("cond_areas_reservar_finalizado", "hc3pia", Type.write);
  static condAreasRegrasAcessar() =>
      AnalyticsEvent("cond_areas_regras_acessar", "1bwume", Type.read);
  static condAreasRegrasFinalizado() =>
      AnalyticsEvent("cond_areas_regras_finalizado", "klf90w", Type.write);

  //Unidades
  static unidadesAcessar() =>
      AnalyticsEvent("unidades_acessar", "mmv0ya", Type.read);

  //Comunicados
  static comunicadosAcessar() =>
      AnalyticsEvent("comunicados_acessar", "xizx3r", Type.read);
  static historicoComunicadosAcessar() =>
      AnalyticsEvent("historico_comunicados_acessar", "bteeei", Type.read);
  static criarComunicadosAcessar() => AnalyticsEvent(
      "criar_solicitar_comunicados_acessar", "uwurrc", "read_create");
  static criarComunicadosFinalizado() => AnalyticsEvent(
      "criar_solicitar_comunicados_finalizado", "jd0i4v", "write_create");
  static solicitarComunicadosAcessar() => AnalyticsEvent(
      "criar_solicitar_comunicados_acessar", "uwurrc", "read_request");
  static solicitarComunicadosFinalizado() => AnalyticsEvent(
      "criar_solicitar_comunicados_finalizado", "jd0i4v", "write_request");

  //Advertências e Multas
  static advertenciaMultasAcessar() =>
      AnalyticsEvent("advertencia_multas_acessar", "4sz0vs", Type.read);
  static historicoAdvertenciaAcessar() =>
      AnalyticsEvent("historico_advertencia_acessar", "ylifvg", Type.read);
  static criarSolicitarAdvertAcessar(String type) =>
      AnalyticsEvent("criar_solicitar_advert_acessar", "kar08g", type);
  static criarSolicitarAdvertFinalizado(String type) =>
      AnalyticsEvent("criar_solicitar_advert_finalizado", "47e1rp", type);
  static historicoMultaAcessar() =>
      AnalyticsEvent("historico_multa_acessar", "fq5hqx", Type.read);
  static solicitarMultaAcessar() =>
      AnalyticsEvent("solicitar_multa_acessar", "wdq8qk", Type.read);
  static solicitarMultaFinalizado(String type) =>
      AnalyticsEvent("solicitar_multa_finalizado", "bzvr43", type);

  //Documentos
  static docsCondominioAcessar() =>
      AnalyticsEvent("docs_condominio_acessar", "b3vcds", Type.read);

  //Livro de Ocorrências
  static ocorrenciasAcessar() =>
      AnalyticsEvent("ocorrencias_acessar", "vmcb0p", Type.read);
  static ocorrenciasResponderFinalizado() =>
      AnalyticsEvent("ocorrencias_responder_finalizado", "5nrdis", Type.write);

  //Perfil
  static homePerfilAcessar() =>
      AnalyticsEvent("home_perfil_acessar", "aaebwd", Type.read);
  static homePerfilEditarFinalizado() =>
      AnalyticsEvent("home_perfil_editar_finalizado", "4hegxq", Type.write);
  static sindicoSessaoExpiradaAcessar() =>
      AnalyticsEvent("sindico_sessao_expirada_acessar", "es9wqh", Type.read);
  static sindicoAtualizacaoAdiadaAcessar() =>
      AnalyticsEvent("sindico_atualizacao_adiada_acessar", "x9zkd3", Type.read);

  //Home
  static homeTemporizador() =>
      AnalyticsEvent("sindico_home_temporizador", "y8298v", Type.read);

  //Saldo Condominio
  static homeSaldoAcessar() =>
      AnalyticsEvent("home_saldo_acessar", "mlv4hw", Type.read);

  //Esquecer senha
  static esqueciSenhaAcessar() =>
      AnalyticsEvent("esqueci_senha_acessar", "ph7w4s", Type.read);
  static esqueciSenhaFinalizado() =>
      AnalyticsEvent("esqueci_senha_finalizado", "35zyin", Type.write);

  //Fazer Login
  static geralLoginFinalizado() =>
      AnalyticsEvent("geral_login_finalizado", "22otig", Type.write);

  //Acordos
  static acordosAcessar() =>
      AnalyticsEvent("acordos_acessar", "2elli2", Type.read);
  static acordosRelatorioAcessar() =>
      AnalyticsEvent("acordos_relatorio_acessar", "bcp7i3", Type.read);
  static acordosHistoricoAcessar() =>
      AnalyticsEvent("acordos_historico_acessar", "3ld7x6", Type.read);
  static acordosHistoricoDetalheAcessar() =>
      AnalyticsEvent("acordos_historico_detalhe_acessar", "2ts2wb", Type.read);
  static acordosPendentesAcessar() =>
      AnalyticsEvent("acordos_pendentes_acessar", "a7eu10", Type.read);
  static acordosPendentesDetalheAcessar() =>
      AnalyticsEvent("acordos_pendentes_detalhe_acessar", "m0tig9", Type.read);
  static acordosAprovarFinalizado() =>
      AnalyticsEvent("acordos_aprovar_finalizado", "4wfqts", Type.write);
  static acordosReprovarFinalizado() =>
      AnalyticsEvent("acordos_reprovar_finalizado", "ptpks9", Type.write);
  static acordosEmProgressoAcessar() =>
      AnalyticsEvent("acordos_em_progresso_acessar", "yxhdig", Type.read);
  static acordosEmProgressoDetalheAcessar() => AnalyticsEvent(
      "acordos_em_progresso_detalhe_acessar", "axvvug", Type.read);
  static acordosRegrasAcessar() =>
      AnalyticsEvent("acordos_regras_acessar", "p3vb77", Type.read);
  static acordosRegrasFinalizado() =>
      AnalyticsEvent("acordos_regras_finalizado", "uf31df", Type.write);

  //Session
  static sessaoIniciar() =>
      AnalyticsEvent("sessao_iniciar", "9qqmym", Type.read);

  static notificacoeCTA() =>
      AnalyticsEvent("notificacao_cta", "lnu9u2", Type.read);

  //Comfort
  static comodidadesRecusarAcessoDialog() =>
      AnalyticsEvent("comodidades_recusar_acesso_dialog", "huphb9", Type.read);
  static comodidadesVamosLaDialog() =>
      AnalyticsEvent("comodidades_vamos_la_dialog", "17ekvf", Type.read);
  static comodidadesCtaOptIn() =>
      AnalyticsEvent("comodidades_cta_opt_in", "o601fv", Type.write);
  static comodidadesMinhasSolicitacoesAcessar() =>
      AnalyticsEvent("comodidades_solicitacoes_acessar", "wpccd4", Type.read);
  static comodidadesCtaRedirecionamento() =>
      AnalyticsEvent("comodidades_cta_redirect", "1ivz7p", Type.read);
  static comodidadesCtaCardFechar() =>
      AnalyticsEvent("comodidades_cta_fechar_card", "rz4mhk", Type.read);
  static comodidadesLgpdAcessar() =>
      AnalyticsEvent("comodidades_lgpd_acessar", "y46k5r", Type.read);
  static comodidadesCtaAcessar() =>
      AnalyticsEvent("comodidades_cta_acessar", "1pm7bd", Type.read);
  static comodidadesParceiroAcessar() =>
      AnalyticsEvent("comodidades_parceiro_acessar", "isy6fm", Type.read);
  static comodidadesParceiroVoltar() =>
      AnalyticsEvent("comodidades_parceiro_voltar", "l4blxa", Type.read);
  static comodidadesAcessar() =>
      AnalyticsEvent("comodidades_acessar", "q390br", Type.read);
  static comodidadesVoltar() =>
      AnalyticsEvent("comodidades_voltar", "b830gr", Type.read);
  static comodidadesAvaliar() =>
      AnalyticsEvent("comodidades_avaliar", "5o5xi3", Type.write);
  static comodidadesAvaliarDepois() =>
      AnalyticsEvent("comodidades_avaliar_depois", "1dr7sk", Type.write);
  static comodidadesCompraRealizada() =>
      AnalyticsEvent("comodidades_compra_realizada", "rmbv36", Type.write);
  static comodidadesCupomAtivar() =>
      AnalyticsEvent("comodidades_cupom_ativar", "umx129", Type.write);
  static comodidadesFavoritosAcessar() =>
      AnalyticsEvent("comodidades_favoritos_acessar", "19cmux", Type.read);
  static comodidadesMudarFavorito() =>
      AnalyticsEvent("comodidades_mudar_favorito", "6ptj3i", Type.write);
  static comodidadesParceiroAvaliacoesAcessar() => AnalyticsEvent(
      "comodidades_parceiro_avaliacoes_acessar", "u1qhzn", Type.read);
  static comodidadesSolicitacoesAcessar() =>
      AnalyticsEvent("comodidades_solicitacoes_acessar", "wqptte", Type.read);
  static comodidadesAcessarViaDialog() =>
      AnalyticsEvent("comodidades_acessar_via_dialog", "f6vcex", Type.read);
  static comodidadesRecusarAcessoViaDialog() => AnalyticsEvent(
      "comodidades_recusar_acesso_via_dialog", "whkywf", Type.read);
  static comodidadesCategoriaAcessar() =>
      AnalyticsEvent("comodidades_categoria_acessar", "xp8beq", Type.read);
  static comodidadesCategoriaVoltar() =>
      AnalyticsEvent("comodidades_categoria_voltar", "usv2pn", Type.read);
  static comodidadesSubCategoriaAcessar() =>
      AnalyticsEvent("comodidades_subcategoria_acessar", "uq7elt", Type.read);
  static comodidadesHomeTemporizador() =>
      AnalyticsEvent("comodidades_home_temporizador", "rse7gf", Type.read);
  static comodidadesCategoriaTemporizador() =>
      AnalyticsEvent("comodidades_categoria_temporizador", "la32k7", Type.read);
  static comodidadesCardComodidadeTemporizador() =>
      AnalyticsEvent("comodidades_card_temporizador", "ve7efv", Type.read);
  static comodidadesModalRedirecionamentoTemporizador() => AnalyticsEvent(
      "comodidades_modal_redirect_temporizador", "72bby8", Type.read);
  static comodidadesPaginaParceiroTemporizador() => AnalyticsEvent(
      "comodidades_page_parceiro_temporizador", "r53ly0", Type.read);
  static comodidadesMinhasSolicitacoesTemporizador() => AnalyticsEvent(
      "comodidades_solicitacoes_temporizador", "mw6toi", Type.read);
  static comodidadesBottomSheetMinhasSolicitacoesTemporizador() =>
      AnalyticsEvent(
          "comodidades_bs_solicitacao_temporizador", "2oi95b", Type.read);

  //Pagamento
  static documentoCnpjDiferenteErroSetorFinanceiro() =>
      AnalyticsEvent("doc_cnpj_diferente_erro_financeiro", "eplkk3", Type.read);
  static documentoCnpjDiferenteErroVoltarPagamento() => AnalyticsEvent(
      "doc_cnpj_diferente_erro_voltar_pagamento", "abtqzw", Type.read);
  static documentoCondominioErroVoltarPagamento() => AnalyticsEvent(
      "doc_condominio_erro_voltar_pagamento", "v60kvt", Type.read);
  static documentoCondominioErroSetorFinanceiro() =>
      AnalyticsEvent("doc_condominio_erro_financeiro", "s7fq00", Type.read);
  static documentoDataVencidaErro() =>
      AnalyticsEvent("doc_data_vencida_erro", "edd0un", Type.read);
  static documentoCondominioErro() =>
      AnalyticsEvent("doc_condominio_erro", "43fbfy", Type.read);
  static documentoCnpjDiferenteErro() =>
      AnalyticsEvent("doc_cnpj_diferente_erro", "p4atwm", Type.read);
  static enviarPagamentoErro() =>
      AnalyticsEvent("enviar_pagamento_erro", "w2a1gj", Type.read);
  static enviarPagamentoSucesso() =>
      AnalyticsEvent("enviar_pagamento_sucesso", "wlmpd8", Type.read);
  static financeiroCancelarBotao() =>
      AnalyticsEvent("financeiro_cancelar_botao", "40jg7h", Type.read);
  static enviarParaFinanceiroBotao() =>
      AnalyticsEvent("enviar_para_financeiro_botao", "wqax9i", Type.read);
  static etapaFinalEnviarPagamento() =>
      AnalyticsEvent("etapa_final_enviar_pagamento", "fkrwwg", Type.read);
  static modalSugestaoEnviarPagamento() =>
      AnalyticsEvent("modal_sugestao_enviar_pagamento", "u81w2d", Type.read);
  static modalSugestaoSemContaContabil() =>
      AnalyticsEvent("modal_sugestao_sem_conta_contabil", "coib71", Type.read);
  static modalUsarOutraClassificacao() =>
      AnalyticsEvent("modal_usar_outra_classificacao", "2seyi4", Type.read);
  static modalEscolherContaContabil() =>
      AnalyticsEvent("modal_escolher_conta_contabil", "lmuzfe", Type.read);
  static modalSemContaContabil() =>
      AnalyticsEvent("modal_sem_conta_contabil", "37emnd", Type.read);
  static formularioBotaoVoltar() =>
      AnalyticsEvent("formulario_botao_voltar", "w8cznm", Type.read);
  static formularioBotaoAvancar() =>
      AnalyticsEvent("formulario_botao_avancar", "itm6l1", Type.read);
  static enviarPagamentoAcessar() =>
      AnalyticsEvent("enviar_pagamento_acessar", "sp85pt", Type.read);
  static documentoIlegivelBotaoManual() =>
      AnalyticsEvent("documento_ilegivel_botao_manual", "hojgf2", Type.read);
  static documentoIlegivelBotaoSetorFinanceiro() => AnalyticsEvent(
      "documento_ilegivel_botao_financeiro", "4tsgc1", Type.read);
  static listarDocumentoBotaoVoltar() =>
      AnalyticsEvent("listar_documento_botao_voltar", "j2es23", Type.read);
  static listarDocumentoBotaoContinuar() =>
      AnalyticsEvent("listar_documento_botao_continuar", "gqi5vd", Type.read);
  static listarDocumentoBotaoAdicionar() =>
      AnalyticsEvent("listar_documento_botao_adicionar", "kllqtk", Type.read);
  static pagamentoCancelarFluxo() =>
      AnalyticsEvent("pagamento_cancelar_fluxo", "jayujq", Type.read);
  static pagamentoBotaoAdicionarDocumento() => AnalyticsEvent(
      "pagamento_botao_adicionar_documento", "44fiqm", Type.read);
  static popUpPagamentoVoltar() =>
      AnalyticsEvent("pop_up_pagamento_voltar", "51jfg5", Type.read);
  static popUpPagamentoContinuar() =>
      AnalyticsEvent("pop_up_pagamento_continuar", "5xuwbl", Type.read);
  static pagamentosTemporizador() =>
      AnalyticsEvent("pagamentos_timer", "3ydufr", Type.read);

  //Dynamic Banner
  static bannerDinamicoAcessar() =>
      AnalyticsEvent("banner_dinamico_acessar", "oyra8k", Type.read);

  //testABC
  static clickNotificacao() =>
      AnalyticsEvent("test_abc_click_notificacao", "804e1f", Type.read);
  static clickSaldo() =>
      AnalyticsEvent("test_abc_click_saldo", "fc2vi0", Type.read);
  static clickMaisAcessados() =>
      AnalyticsEvent("test_abc_click_mais_acessados", "wqvhgy", Type.read);
  static clickMascaraSaldo() =>
      AnalyticsEvent("test_abc_click_mascara_saldo", "p5hfan", Type.read);
}
