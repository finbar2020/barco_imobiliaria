import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:flutter_test/flutter_test.dart';

import 'evento_caso.dart';

void main() {
  final casos = <Caso>[
    Caso(AnalyticsEventsManager.despesasAcessar(), 'despesas_acessar', '2gbbeo', 'read'),
    Caso(AnalyticsEventsManager.enviarPagamentoFinalizado(), 'enviar_pagamento_finalizado', 'fa2j8d', 'write'),
    Caso(AnalyticsEventsManager.historicoPagamentoAcessar(), 'historico_pagamento_acessar', '4pt30w', 'read'),
    Caso(AnalyticsEventsManager.consultarPagamentoAcessar(), 'consultar_pagamento_acessar', 'jcq0sz', 'read'),
    Caso(AnalyticsEventsManager.aprovacaoPendenteAcessar(), 'aprovacao_pendente_acessar', 'mo342w', 'read'),
    Caso(AnalyticsEventsManager.aprovacaoPendenteRecusar(), 'aprovacao_pendente_recusar', 'a9axoo', 'write'),
    Caso(AnalyticsEventsManager.aprovacaoPendenteAprovar(), 'aprovacao_pendente_aprovar', 'hbjbto', 'write'),
    Caso(AnalyticsEventsManager.aprovacaoPendenteSuspender(), 'aprovacao_pendente_suspender', 'og7fp5', 'write'),
    Caso(AnalyticsEventsManager.aprovacaoPendenteSucessoAprovar(), 'aprovacao_pendente_sucesso_aprovar', 'odfted', 'write'),
    Caso(AnalyticsEventsManager.aprovacaoPendenteSucessoRecusar(), 'aprovacao_pendente_sucesso_recusar', 'byxqwv', 'write'),
    Caso(AnalyticsEventsManager.aprovacaoPendenteSucessoSuspender(), 'aprovacao_pendente_sucesso_suspender', '8hs6bw', 'write'),
    Caso(AnalyticsEventsManager.aprovacaoPendenteErro(), 'aprovacao_pendente_erro', '97wzq7', 'write'),
    Caso(AnalyticsEventsManager.aprovarPagamentoAcessar(), 'aprovar_pagamento_acessar', 'a3au40', 'read'),
    Caso(AnalyticsEventsManager.aprovarPagamentoFinalizado(), 'aprovar_pagamento_finalizado', 'ymct83', 'write'),
    Caso(AnalyticsEventsManager.despEnviarClick(), 'desp_enviar_click', 'p3sz4w', 'read'),
    Caso(AnalyticsEventsManager.receitasAcessar(), 'receitas_acessar', 'ml04bg', 'read'),
    Caso(AnalyticsEventsManager.detalhesReceitasAcessar(), 'detalhes_receitas_acessar', 'o9q4p3', 'read'),
    Caso(AnalyticsEventsManager.receitasControleAcessar(), 'receitas_controle_acessar', 'gj4b9y', 'read'),
    Caso(AnalyticsEventsManager.gdpAcessar(), 'gdp_acessar', 'tbn0ca', 'read'),
    Caso(AnalyticsEventsManager.resolvaRapidoAcessar(), 'resolva_rapido_acessar', 's0hwed', 'read'),
    Caso(AnalyticsEventsManager.resolvaRapidoFinalizado('custom'), 'resolva_rapido_finalizado', 'a6qrm5', 'custom'),
    Caso(AnalyticsEventsManager.agendarFeriasAcessar(), 'agendar_ferias_acessar', 'uurswn', 'read'),
    Caso(AnalyticsEventsManager.agendarFeriasFinalizado(), 'agendar_ferias_finalizado', 'f4fadl', 'write'),
    Caso(AnalyticsEventsManager.folhaPgtoAcessar(), 'folha_pgto_acessar', 'f1mnr7', 'read'),
    Caso(AnalyticsEventsManager.holeriteAcessar(), 'holerite_acessar', '1kznz4', 'read'),
    Caso(AnalyticsEventsManager.pontoDigitalAcessar(), 'ponto_digital_acessar', 'yd3nip', 'read'),
    Caso(AnalyticsEventsManager.pontoAcaoOcorrenciaAcessar(), 'ponto_acao_ocorrencia_acessar', 'givr2p', 'read'),
    Caso(AnalyticsEventsManager.pontoAcaoOcorrenciaFinalizado('custom'), 'ponto_acao_ocorrencia_finalizado', 'l68d59', 'custom'),
    Caso(AnalyticsEventsManager.pontoAssinaFolhaAcessar(), 'ponto_assinafolha_acessar', 'x2fhga', 'read'),
    Caso(AnalyticsEventsManager.pontoAssinaFolhaFinalizado(), 'ponto_assinafolha_finalizado', 'w6og64', 'write'),
    Caso(AnalyticsEventsManager.pontoInserirEventoFinalizado(), 'ponto_inserir_evento_finalizado', 'w6og64', 'write'),
    Caso(AnalyticsEventsManager.inadimplenciaAcessar(), 'inadimplencia_acessar', 'okzbwx', 'read'),
    Caso(AnalyticsEventsManager.ppcAcessar(), 'ppc_acessar', 'btppz1', 'read'),
    Caso(AnalyticsEventsManager.aprovarPpcAcessar(), 'aprovar_ppc_acessar', 'ddcr6q', 'read'),
    Caso(AnalyticsEventsManager.aprovarPpcFinalizado(), 'aprovar_ppc_finalizado', 'hml09t', 'write'),
    Caso(AnalyticsEventsManager.falelelloAcessar(), 'falelello_acessar', 'a256c2', 'read'),
    Caso(AnalyticsEventsManager.falelelloFinalizado(), 'falelello_finalizado', 'lmu3qy', 'write'),
    Caso(AnalyticsEventsManager.duvidaAcessar(), 'duvida_acessar', 'nj9pk9', 'read'),
    Caso(AnalyticsEventsManager.duvidaFinalizado(), 'duvida_finalizado', 'amzw94', 'write'),
    Caso(AnalyticsEventsManager.caixaLocalAcessar(), 'caixa_local_acessar', 'yn23ru', 'read'),
    Caso(AnalyticsEventsManager.historicoReembolsoAcessar(), 'historico_reembolso_acessar', '7m98uw', 'read'),
    Caso(AnalyticsEventsManager.solicitarReembolsoAcessar(), 'solicitar_reembolso_acessar', 'oqpd7b', 'read'),
    Caso(AnalyticsEventsManager.solicitarReembolsoFinalizado(), 'solicitar_reembolso_finalizado', 'xxyv6q', 'write'),
    Caso(AnalyticsEventsManager.historicoAdiantamentoAcessar(), 'historico_adiantamento_acessar', '2q13c4', 'read'),
    Caso(AnalyticsEventsManager.solicitarAdiantamentoAcessar(), 'solicitar_adiantamento_acessar', 'xzdkdb', 'read'),
    Caso(AnalyticsEventsManager.solicitarAdiantamentoFinalizado(), 'solicitar_adiantamento_finalizado', 'ozbcji', 'write'),
    Caso(AnalyticsEventsManager.envioComprovanteAcessar(), 'envio_comprovante_acessar', '1lqmd8', 'read'),
    Caso(AnalyticsEventsManager.envioComprovanteFinalizado(), 'envio_comprovante_finalizado', '5rcjuv', 'write'),
    Caso(AnalyticsEventsManager.condBoletosAcessar(), 'cond_boletos_acessar', '5pt2wu', 'read'),
    Caso(AnalyticsEventsManager.dadosEquipeAcessar(), 'dados_equipe_acessar', 'qnbypi', 'read'),
    Caso(AnalyticsEventsManager.condAreasAgendaAcessar(), 'cond_areas_agenda_acessar', 'q2ukmr', 'read'),
    Caso(AnalyticsEventsManager.condAreasReservarAcessar(), 'cond_areas_reservar_acessar', 'dda6nb', 'read'),
    Caso(AnalyticsEventsManager.condAreasReservarFinalizado(), 'cond_areas_reservar_finalizado', 'hc3pia', 'write'),
    Caso(AnalyticsEventsManager.condAreasRegrasAcessar(), 'cond_areas_regras_acessar', '1bwume', 'read'),
    Caso(AnalyticsEventsManager.condAreasRegrasFinalizado(), 'cond_areas_regras_finalizado', 'klf90w', 'write'),
    Caso(AnalyticsEventsManager.unidadesAcessar(), 'unidades_acessar', 'mmv0ya', 'read'),
    Caso(AnalyticsEventsManager.comunicadosAcessar(), 'comunicados_acessar', 'xizx3r', 'read'),
    Caso(AnalyticsEventsManager.historicoComunicadosAcessar(), 'historico_comunicados_acessar', 'bteeei', 'read'),
    Caso(AnalyticsEventsManager.criarComunicadosAcessar(), 'criar_solicitar_comunicados_acessar', 'uwurrc', 'read_create'),
    Caso(AnalyticsEventsManager.criarComunicadosFinalizado(), 'criar_solicitar_comunicados_finalizado', 'jd0i4v', 'write_create'),
    Caso(AnalyticsEventsManager.solicitarComunicadosAcessar(), 'criar_solicitar_comunicados_acessar', 'uwurrc', 'read_request'),
    Caso(AnalyticsEventsManager.solicitarComunicadosFinalizado(), 'criar_solicitar_comunicados_finalizado', 'jd0i4v', 'write_request'),
    Caso(AnalyticsEventsManager.advertenciaMultasAcessar(), 'advertencia_multas_acessar', '4sz0vs', 'read'),
    Caso(AnalyticsEventsManager.historicoAdvertenciaAcessar(), 'historico_advertencia_acessar', 'ylifvg', 'read'),
    Caso(AnalyticsEventsManager.criarSolicitarAdvertAcessar('custom'), 'criar_solicitar_advert_acessar', 'kar08g', 'custom'),
    Caso(AnalyticsEventsManager.criarSolicitarAdvertFinalizado('custom'), 'criar_solicitar_advert_finalizado', '47e1rp', 'custom'),
    Caso(AnalyticsEventsManager.historicoMultaAcessar(), 'historico_multa_acessar', 'fq5hqx', 'read'),
    Caso(AnalyticsEventsManager.solicitarMultaAcessar(), 'solicitar_multa_acessar', 'wdq8qk', 'read'),
    Caso(AnalyticsEventsManager.solicitarMultaFinalizado('custom'), 'solicitar_multa_finalizado', 'bzvr43', 'custom'),
    Caso(AnalyticsEventsManager.docsCondominioAcessar(), 'docs_condominio_acessar', 'b3vcds', 'read'),
    Caso(AnalyticsEventsManager.ocorrenciasAcessar(), 'ocorrencias_acessar', 'vmcb0p', 'read'),
    Caso(AnalyticsEventsManager.ocorrenciasResponderFinalizado(), 'ocorrencias_responder_finalizado', '5nrdis', 'write'),
    Caso(AnalyticsEventsManager.homePerfilAcessar(), 'home_perfil_acessar', 'aaebwd', 'read'),
    Caso(AnalyticsEventsManager.homePerfilEditarFinalizado(), 'home_perfil_editar_finalizado', '4hegxq', 'write'),
    Caso(AnalyticsEventsManager.sindicoSessaoExpiradaAcessar(), 'sindico_sessao_expirada_acessar', 'es9wqh', 'read'),
    Caso(AnalyticsEventsManager.sindicoAtualizacaoAdiadaAcessar(), 'sindico_atualizacao_adiada_acessar', 'x9zkd3', 'read'),
    Caso(AnalyticsEventsManager.homeTemporizador(), 'sindico_home_temporizador', 'y8298v', 'read'),
    Caso(AnalyticsEventsManager.homeSaldoAcessar(), 'home_saldo_acessar', 'mlv4hw', 'read'),
    Caso(AnalyticsEventsManager.esqueciSenhaAcessar(), 'esqueci_senha_acessar', 'ph7w4s', 'read'),
    Caso(AnalyticsEventsManager.esqueciSenhaFinalizado(), 'esqueci_senha_finalizado', '35zyin', 'write'),
    Caso(AnalyticsEventsManager.geralLoginFinalizado(), 'geral_login_finalizado', '22otig', 'write'),
    Caso(AnalyticsEventsManager.acordosAcessar(), 'acordos_acessar', '2elli2', 'read'),
    Caso(AnalyticsEventsManager.acordosRelatorioAcessar(), 'acordos_relatorio_acessar', 'bcp7i3', 'read'),
    Caso(AnalyticsEventsManager.acordosHistoricoAcessar(), 'acordos_historico_acessar', '3ld7x6', 'read'),
    Caso(AnalyticsEventsManager.acordosHistoricoDetalheAcessar(), 'acordos_historico_detalhe_acessar', '2ts2wb', 'read'),
    Caso(AnalyticsEventsManager.acordosPendentesAcessar(), 'acordos_pendentes_acessar', 'a7eu10', 'read'),
    Caso(AnalyticsEventsManager.acordosPendentesDetalheAcessar(), 'acordos_pendentes_detalhe_acessar', 'm0tig9', 'read'),
    Caso(AnalyticsEventsManager.acordosAprovarFinalizado(), 'acordos_aprovar_finalizado', '4wfqts', 'write'),
    Caso(AnalyticsEventsManager.acordosReprovarFinalizado(), 'acordos_reprovar_finalizado', 'ptpks9', 'write'),
    Caso(AnalyticsEventsManager.acordosEmProgressoAcessar(), 'acordos_em_progresso_acessar', 'yxhdig', 'read'),
    Caso(AnalyticsEventsManager.acordosEmProgressoDetalheAcessar(), 'acordos_em_progresso_detalhe_acessar', 'axvvug', 'read'),
    Caso(AnalyticsEventsManager.acordosRegrasAcessar(), 'acordos_regras_acessar', 'p3vb77', 'read'),
    Caso(AnalyticsEventsManager.acordosRegrasFinalizado(), 'acordos_regras_finalizado', 'uf31df', 'write'),
    Caso(AnalyticsEventsManager.sessaoIniciar(), 'sessao_iniciar', '9qqmym', 'read'),
    Caso(AnalyticsEventsManager.notificacoeCTA(), 'notificacao_cta', 'lnu9u2', 'read'),
    Caso(AnalyticsEventsManager.comodidadesRecusarAcessoDialog(), 'comodidades_recusar_acesso_dialog', 'huphb9', 'read'),
    Caso(AnalyticsEventsManager.comodidadesVamosLaDialog(), 'comodidades_vamos_la_dialog', '17ekvf', 'read'),
    Caso(AnalyticsEventsManager.comodidadesCtaOptIn(), 'comodidades_cta_opt_in', 'o601fv', 'write'),
    Caso(AnalyticsEventsManager.comodidadesMinhasSolicitacoesAcessar(), 'comodidades_minhas_solicitacoes_acessar', 'wpccd4', 'read'),
    Caso(AnalyticsEventsManager.comodidadesCtaRedirecionamento(), 'comodidades_cta_redirect', '1ivz7p', 'read'),
    Caso(AnalyticsEventsManager.comodidadesCtaCardFechar(), 'comodidades_cta_fechar_card', 'rz4mhk', 'read'),
    Caso(AnalyticsEventsManager.comodidadesLgpdAcessar(), 'comodidades_lgpd_acessar', 'y46k5r', 'read'),
    Caso(AnalyticsEventsManager.comodidadesCtaAcessar(), 'comodidades_cta_acessar', '1pm7bd', 'read'),
    Caso(AnalyticsEventsManager.comodidadesParceiroAcessar(), 'comodidades_parceiro_acessar', 'isy6fm', 'read'),
    Caso(AnalyticsEventsManager.comodidadesParceiroVoltar(), 'comodidades_parceiro_voltar', 'l4blxa', 'read'),
    Caso(AnalyticsEventsManager.comodidadesAcessar(), 'comodidades_acessar', 'q390br', 'read'),
    Caso(AnalyticsEventsManager.comodidadesVoltar(), 'comodidades_voltar', 'b830gr', 'read'),
    Caso(AnalyticsEventsManager.comodidadesAvaliar(), 'comodidades_avaliar', '5o5xi3', 'write'),
    Caso(AnalyticsEventsManager.comodidadesAvaliarDepois(), 'comodidades_avaliar_depois', '1dr7sk', 'write'),
    Caso(AnalyticsEventsManager.comodidadesCompraRealizada(), 'comodidades_compra_realizada', 'rmbv36', 'write'),
    Caso(AnalyticsEventsManager.comodidadesCupomAtivar(), 'comodidades_cupom_ativar', 'umx129', 'write'),
    Caso(AnalyticsEventsManager.comodidadesFavoritosAcessar(), 'comodidades_favoritos_acessar', '19cmux', 'read'),
    Caso(AnalyticsEventsManager.comodidadesMudarFavorito(), 'comodidades_mudar_favorito', '6ptj3i', 'write'),
    Caso(AnalyticsEventsManager.comodidadesParceiroAvaliacoesAcessar(), 'comodidades_parceiro_avaliacoes_acessar', 'u1qhzn', 'read'),
    Caso(AnalyticsEventsManager.comodidadesSolicitacoesAcessar(), 'comodidades_solicitacoes_acessar', 'wqptte', 'read'),
    Caso(AnalyticsEventsManager.comodidadesAcessarViaDialog(), 'comodidades_acessar_via_dialog', 'f6vcex', 'read'),
    Caso(AnalyticsEventsManager.comodidadesRecusarAcessoViaDialog(), 'comodidades_recusar_acesso_via_dialog', 'whkywf', 'read'),
    Caso(AnalyticsEventsManager.comodidadesCategoriaAcessar(), 'comodidades_categoria_acessar', 'xp8beq', 'read'),
    Caso(AnalyticsEventsManager.comodidadesCategoriaVoltar(), 'comodidades_categoria_voltar', 'usv2pn', 'read'),
    Caso(AnalyticsEventsManager.comodidadesSubCategoriaAcessar(), 'comodidades_subcategoria_acessar', 'uq7elt', 'read'),
    Caso(AnalyticsEventsManager.comodidadesHomeTemporizador(), 'comodidades_home_temporizador', 'rse7gf', 'read'),
    Caso(AnalyticsEventsManager.comodidadesCategoriaTemporizador(), 'comodidades_categoria_temporizador', 'la32k7', 'read'),
    Caso(AnalyticsEventsManager.comodidadesCardComodidadeTemporizador(), 'comodidades_card_temporizador', 've7efv', 'read'),
    Caso(AnalyticsEventsManager.comodidadesModalRedirecionamentoTemporizador(), 'comodidades_modal_redirect_temporizador', '72bby8', 'read'),
    Caso(AnalyticsEventsManager.comodidadesPaginaParceiroTemporizador(), 'comodidades_page_parceiro_temporizador', 'r53ly0', 'read'),
    Caso(AnalyticsEventsManager.comodidadesMinhasSolicitacoesTemporizador(), 'comodidades_solicitacoes_temporizador', 'mw6toi', 'read'),
    Caso(AnalyticsEventsManager.comodidadesBottomSheetMinhasSolicitacoesTemporizador(), 'comodidades_bs_solicitacao_temporizador', '2oi95b', 'read'),
    Caso(AnalyticsEventsManager.documentoCnpjDiferenteErroSetorFinanceiro(), 'doc_cnpj_diferente_erro_financeiro', 'eplkk3', 'read'),
    Caso(AnalyticsEventsManager.documentoCnpjDiferenteErroVoltarPagamento(), 'doc_cnpj_diferente_erro_voltar_pagamento', 'abtqzw', 'read'),
    Caso(AnalyticsEventsManager.documentoCondominioErroVoltarPagamento(), 'doc_condominio_erro_voltar_pagamento', 'v60kvt', 'read'),
    Caso(AnalyticsEventsManager.documentoCondominioErroSetorFinanceiro(), 'doc_condominio_erro_financeiro', 's7fq00', 'read'),
    Caso(AnalyticsEventsManager.documentoDataVencidaErro(), 'doc_data_vencida_erro', 'edd0un', 'read'),
    Caso(AnalyticsEventsManager.documentoCondominioErro(), 'doc_condominio_erro', '43fbfy', 'read'),
    Caso(AnalyticsEventsManager.documentoCnpjDiferenteErro(), 'doc_cnpj_diferente_erro', 'p4atwm', 'read'),
    Caso(AnalyticsEventsManager.enviarPagamentoErro(), 'enviar_pagamento_erro', 'w2a1gj', 'read'),
    Caso(AnalyticsEventsManager.enviarPagamentoSucesso(), 'enviar_pagamento_sucesso', 'wlmpd8', 'read'),
    Caso(AnalyticsEventsManager.financeiroCancelarBotao(), 'financeiro_cancelar_botao', '40jg7h', 'read'),
    Caso(AnalyticsEventsManager.enviarParaFinanceiroBotao(), 'enviar_para_financeiro_botao', 'wqax9i', 'read'),
    Caso(AnalyticsEventsManager.etapaFinalEnviarPagamento(), 'etapa_final_enviar_pagamento', 'fkrwwg', 'read'),
    Caso(AnalyticsEventsManager.modalSugestaoEnviarPagamento(), 'modal_sugestao_enviar_pagamento', 'u81w2d', 'read'),
    Caso(AnalyticsEventsManager.modalSugestaoSemContaContabil(), 'modal_sugestao_sem_conta_contabil', 'coib71', 'read'),
    Caso(AnalyticsEventsManager.modalUsarOutraClassificacao(), 'modal_usar_outra_classificacao', '2seyi4', 'read'),
    Caso(AnalyticsEventsManager.modalEscolherContaContabil(), 'modal_escolher_conta_contabil', 'lmuzfe', 'read'),
    Caso(AnalyticsEventsManager.modalSemContaContabil(), 'modal_sem_conta_contabil', '37emnd', 'read'),
    Caso(AnalyticsEventsManager.formularioBotaoVoltar(), 'formulario_botao_voltar', 'w8cznm', 'read'),
    Caso(AnalyticsEventsManager.formularioBotaoAvancar(), 'formulario_botao_avancar', 'itm6l1', 'read'),
    Caso(AnalyticsEventsManager.enviarPagamentoAcessar(), 'enviar_pagamento_acessar', 'sp85pt', 'read'),
    Caso(AnalyticsEventsManager.documentoIlegivelBotaoManual(), 'documento_ilegivel_botao_manual', 'hojgf2', 'read'),
    Caso(AnalyticsEventsManager.documentoIlegivelBotaoSetorFinanceiro(), 'documento_ilegivel_botao_financeiro', '4tsgc1', 'read'),
    Caso(AnalyticsEventsManager.listarDocumentoBotaoVoltar(), 'listar_documento_botao_voltar', 'j2es23', 'read'),
    Caso(AnalyticsEventsManager.listarDocumentoBotaoContinuar(), 'listar_documento_botao_continuar', 'gqi5vd', 'read'),
    Caso(AnalyticsEventsManager.listarDocumentoBotaoAdicionar(), 'listar_documento_botao_adicionar', 'kllqtk', 'read'),
    Caso(AnalyticsEventsManager.pagamentoCancelarFluxo(), 'pagamento_cancelar_fluxo', 'jayujq', 'read'),
    Caso(AnalyticsEventsManager.pagamentoBotaoAdicionarDocumento(), 'pagamento_botao_adicionar_documento', '44fiqm', 'read'),
    Caso(AnalyticsEventsManager.popUpPagamentoVoltar(), 'pop_up_pagamento_voltar', '51jfg5', 'read'),
    Caso(AnalyticsEventsManager.popUpPagamentoContinuar(), 'pop_up_pagamento_continuar', '5xuwbl', 'read'),
    Caso(AnalyticsEventsManager.pagamentosTemporizador(), 'pagamentos_timer', '3ydufr', 'read'),
    Caso(AnalyticsEventsManager.bannerDinamicoAcessar(), 'banner_dinamico_acessar', 'oyra8k', 'read'),
    Caso(AnalyticsEventsManager.clickNotificacao(), 'test_abc_click_notificacao', '804e1f', 'read'),
    Caso(AnalyticsEventsManager.clickSaldo(), 'test_abc_click_saldo', 'fc2vi0', 'read'),
    Caso(AnalyticsEventsManager.clickMaisAcessados(), 'test_abc_click_mais_acessados', 'wqvhgy', 'read'),
    Caso(AnalyticsEventsManager.clickMascaraSaldo(), 'test_abc_click_mascara_saldo', 'p5hfan', 'read'),
  ];

  test('todos os eventos têm nome, token e tipo esperados', () {
    verificaCatalogo(casos);
  });

  test('cada chamada cria uma instância nova (não compartilha estado)', () {
    final a = AnalyticsEventsManager.bannerDinamicoAcessar();
    final b = AnalyticsEventsManager.bannerDinamicoAcessar();
    expect(identical(a, b), isFalse);
    a.name = 'alterado';
    expect(b.name, 'banner_dinamico_acessar');
  });

  test('fábricas com parâmetro repassam o tipo informado', () {
    expect(AnalyticsEventsManager.resolvaRapidoFinalizado('write').type, 'write');
    expect(AnalyticsEventsManager.pontoAcaoOcorrenciaFinalizado('delete').type,
        'delete');
    expect(AnalyticsEventsManager.criarSolicitarAdvertAcessar('read').type,
        'read');
    expect(AnalyticsEventsManager.criarSolicitarAdvertFinalizado('write').type,
        'write');
    expect(AnalyticsEventsManager.solicitarMultaFinalizado('write').type,
        'write');
  });

  test('comunicados: criar e solicitar compartilham nome/token e diferem no tipo',
      () {
    final criar = AnalyticsEventsManager.criarComunicadosAcessar();
    final solicitar = AnalyticsEventsManager.solicitarComunicadosAcessar();
    expect(criar.name, solicitar.name);
    expect(criar.token, solicitar.token);
    expect(criar.type, 'read_create');
    expect(solicitar.type, 'read_request');

    final criarFim = AnalyticsEventsManager.criarComunicadosFinalizado();
    final solicitarFim = AnalyticsEventsManager.solicitarComunicadosFinalizado();
    expect(criarFim.name, solicitarFim.name);
    expect(criarFim.token, solicitarFim.token);
    expect(criarFim.type, 'write_create');
    expect(solicitarFim.type, 'write_request');
  });

  /// Pendente (negócio): `pontoAssinaFolhaFinalizado` e
  /// `pontoInserirEventoFinalizado` usam o mesmo token do Adjust ("w6og64")
  /// com nomes diferentes, então os dois eventos se misturam no painel do
  /// Adjust. Depende de um token novo criado no painel; comportamento atual
  /// documentado aqui.
  test('pendente: ponto_assinafolha_finalizado e ponto_inserir_evento_finalizado '
      'compartilham o token w6og64', () {
    expect(AnalyticsEventsManager.pontoAssinaFolhaFinalizado().token, 'w6og64');
    expect(
        AnalyticsEventsManager.pontoInserirEventoFinalizado().token, 'w6og64');
    expect(AnalyticsEventsManager.pontoAssinaFolhaFinalizado().name,
        isNot(AnalyticsEventsManager.pontoInserirEventoFinalizado().name));
  });

  /// Corrigido: `comodidadesMinhasSolicitacoesAcessar` (wpccd4) agora loga
  /// "comodidades_minhas_solicitacoes_acessar" no Firebase, distinto de
  /// `comodidadesSolicitacoesAcessar` (wqptte, "comodidades_solicitacoes_acessar").
  test('nenhum nome de evento tem dois tokens', () {
    final duplicados = tokensPorNomeTipo(casos)
        .entries
        .where((e) => e.value.length > 1)
        .map((e) => e.key)
        .toList();
    expect(duplicados, isEmpty);
    expect(AnalyticsEventsManager.comodidadesMinhasSolicitacoesAcessar().name,
        'comodidades_minhas_solicitacoes_acessar');
    expect(AnalyticsEventsManager.comodidadesSolicitacoesAcessar().name,
        'comodidades_solicitacoes_acessar');
  });

  test('tokens repetidos entre nomes diferentes são apenas os documentados',
      () {
    final porToken = <String, Set<String>>{};
    for (final caso in casos) {
      porToken.putIfAbsent(caso.token, () => {}).add(caso.nome);
    }
    final repetidos = porToken.entries
        .where((e) => e.value.length > 1)
        .map((e) => e.key)
        .toList();
    expect(repetidos, ['w6og64']);
  });
}
