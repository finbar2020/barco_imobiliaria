import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:flutter_test/flutter_test.dart';

import 'evento_caso.dart';

void main() {
  final casos = <Caso>[
    Caso(AnalyticsEventsEmployee.esqueciSenhaAcessar(), 'esqueci_senha_acessar', 'bmemjq', 'read'),
    Caso(AnalyticsEventsEmployee.esqueciSenhaFinalizado(), 'esqueci_senha_finalizado', 'lthniw', 'write'),
    Caso(AnalyticsEventsEmployee.redefinirSenha(), 'redefinir_senha', '1o19zn', 'write'),
    Caso(AnalyticsEventsEmployee.sessaoIniciar(), 'sessao_iniciar', '7zsp7g', 'read'),
    Caso(AnalyticsEventsEmployee.edicaoCadastradoAcessar(), 'edicao_cadastro_acessar', '55z19b', 'read'),
    Caso(AnalyticsEventsEmployee.edicaoCadastradoSucesso(), 'edicao_cadastro_tela_de_sucesso', 'y1dqrv', 'write'),
    Caso(AnalyticsEventsEmployee.comodidadesCtaOptIn(), 'comodidades_cta_opt_in', 'kis0oy', 'write'),
    Caso(AnalyticsEventsEmployee.comodidadesCtaRedirecionamento(), 'comodidades_cta_redirect', '32cj6i', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesCtaCardFechar(), 'comodidades_cta_fechar_card', 'sn654c', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesLgpdAcessar(), 'comodidades_lgpd_acessar', 'yo2xmp', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesCtaAcessar(), 'comodidades_cta_acessar', '63g7xo', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesParceiroAcessar(), 'comodidades_parceiro_acessar', 'nsv0hf', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesParceiroVoltar(), 'comodidades_parceiro_voltar', 'b7qi0a', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesAcessar(), 'comodidades_acessar', 'l17hgc', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesVoltar(), 'comodidades_voltar', 'uw9mu0', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesAvaliar(), 'comodidades_avaliar', 'suxb4w', 'write'),
    Caso(AnalyticsEventsEmployee.comodidadesAvaliarDepois(), 'comodidades_avaliar_depois', 'mfwywy', 'write'),
    Caso(AnalyticsEventsEmployee.comodidadesCompraRealizada(), 'comodidades_compra_realizada', 'ykr7ah', 'write'),
    Caso(AnalyticsEventsEmployee.comodidadesCupomAtivar(), 'comodidades_cupom_ativar', 'ij690l', 'write'),
    Caso(AnalyticsEventsEmployee.comodidadesFavoritosAcessar(), 'comodidades_favoritos_acessar', 'c1vinj', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesMudarFavorito(), 'comodidades_mudar_favorito', '6y6y1b', 'write'),
    Caso(AnalyticsEventsEmployee.comodidadesParceiroAvaliacoesAcessar(), 'comodidades_parceiro_avaliacoes_acessar', '5atq2i', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesSolicitacoesAcessar(), 'comodidades_solicitacoes_acessar', 'nde8c9', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesCategoriaAcessar(), 'comodidades_categoria_acessar', 'ujgfk8', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesCategoriaVoltar(), 'comodidades_categoria_voltar', 'ad7hsj', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesSubCategoriaAcessar(), 'comodidades_subcategoria_acessar', 'y49nwc', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesHomeTemporizador(), 'comodidades_home_temporizador', '5gca5q', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesCategoriaTemporizador(), 'comodidades_categoria_temporizador', 'ppj2r7', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesCardComodidadeTemporizador(), 'comodidades_card_temporizador', 'peue82', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesModalRedirecionamentoTemporizador(), 'comodidades_modal_redirect_temporizador', 'de6h0n', 'read'),
    Caso(AnalyticsEventsEmployee.comodidadesPaginaParceiroTemporizador(), 'comodidades_page_parceiro_temporizador', 'ocuiek', 'read'),
    Caso(AnalyticsEventsEmployee.bannerDinamicoAcessar(), 'banner_dinamico_acessar', 'oyra8k', 'read'),
    Caso(AnalyticsEventsEmployee.documentosHoleriteAcessar(), 'documentos_holerite_acessar', 'kzlez2', 'read'),
    Caso(AnalyticsEventsEmployee.documentosFeriasAcessar(), 'documentos_ferias_acessar', 'ducmvu', 'read'),
    Caso(AnalyticsEventsEmployee.documentosBeneficiosAcessar(), 'documentos_beneficios_acessar', 'fk0kkg', 'read'),
    Caso(AnalyticsEventsEmployee.documentosInfoRendimentosAcessar(), 'documentos_info_redimentos_acessar', '2lsrcj', 'read'),
    Caso(AnalyticsEventsEmployee.vantagensIndiqueGanheAcessar(), 'vantagens_indique_ganhe_acessar', '78raph', 'read'),
    Caso(AnalyticsEventsEmployee.vantagensCondolivreAcessar(), 'vantagens_condolivre_acessar', 'khtcu6', 'read'),
    Caso(AnalyticsEventsEmployee.vantagensCursosAcessar(), 'vantagens_cursos_acessar', '6mczkp', 'read'),
    Caso(AnalyticsEventsEmployee.notificacoeCTA(), 'notificacao_cta', 'pjmjdc', 'read'),
    Caso(AnalyticsEventsEmployee.pontoDigitalEspelhoPontoAcessar(), 'ponto_digital_espelho_ponto_acessar', 'ifr3hb', 'read'),
    Caso(AnalyticsEventsEmployee.pontoDigitalEspelhoPontoAssinar(), 'ponto_digital_espelho_ponto_assinar', 'dsq0vl', 'write'),
    Caso(AnalyticsEventsEmployee.pontoDigitalDetalhesTratativasAcessar(), 'ponto_digital_detalhes_tratativas_acessar', 'a9k6e1', 'read'),
    Caso(AnalyticsEventsEmployee.pontoDigitalInformacoesAcessar(), 'ponto_digital_informacoes_acessar', 'qoh9k5', 'read'),
    Caso(AnalyticsEventsEmployee.pontoDigitalComprovanteAcessar(), 'ponto_digital_comprovante_acessar', 'wzytl2', 'read'),
    Caso(AnalyticsEventsEmployee.pontoDigitalRelorioAcessar(), 'ponto_digital_relatorio_acessar', '9t6q98', 'read'),
    Caso(AnalyticsEventsEmployee.pontoDigitalAtestadoMedicoAcessar(), 'ponto_digital_atestado_medico_acessar', 'yp4mc9', 'read'),
    Caso(AnalyticsEventsEmployee.pontoDigitalAtestadoMedicoSucesso(), 'ponto_digital_atestado_medico_envio_sucesso', 'o8gxwp', 'write'),
    Caso(AnalyticsEventsEmployee.homeEnvioFolhaPontoAcessar(), 'home_envio_folha_ponto_acessar', '43q72k', 'read'),
    Caso(AnalyticsEventsEmployee.homeEnvioFolhaPontoSucesso(), 'home_envio_folha_ponto_sucesso', '2o8oml', 'write'),
    Caso(AnalyticsEventsEmployee.homeLiberarPontoDigitalAcessar(), 'home_liberar_ponto_digital_acessar', 'c3qb1i', 'read'),
    Caso(AnalyticsEventsEmployee.homeConhecerPontoDigitalAcessar(), 'home_conhecer_ponto_digital_acessar', 'bah91s', 'read'),
    Caso(AnalyticsEventsEmployee.homeRegistrarPontoDigitalAcessar(), 'home_registrar_ponto_digital_acessar', '9bun7x', 'read'),
    Caso(AnalyticsEventsEmployee.homeRegistrarPontoDigitalSucesso(), 'home_registrar_ponto_digital_sucesso', 'coq4cm', 'write'),
    Caso(AnalyticsEventsEmployee.homeRegistrarPontoDigitalFalhaIdentificacao(), 'home_registrar_ponto_digital_falha_identificacao', 'pfxuf9', 'write'),
    Caso(AnalyticsEventsEmployee.homeRegistrarPontoDigitalFalhaEnvio(), 'home_registrar_ponto_digital_falha_envio', '4ss3yo', 'write'),
    Caso(AnalyticsEventsEmployee.homeRegistrarPontoDigitalSucessoOffline(), 'home_registrar_ponto_digital_sucesso_offline', 'srxs28', 'write'),
    Caso(AnalyticsEventsEmployee.homeWhatsAppAcessar(), 'home_whatsapp_acessar', 'i7e3vk', 'read'),
    Caso(AnalyticsEventsEmployee.colaboradorHomeTemporizador(), 'colaborador_home_temporizador', 'z6880i', 'read'),
    Caso(AnalyticsEventsEmployee.gdpAcessar(), 'gdp_acessar', '9yla91', 'read'),
    Caso(AnalyticsEventsEmployee.resolvaRapidoAcessar(), 'resolva_rapido_acessar', '3k1yc6', 'read'),
    Caso(AnalyticsEventsEmployee.resolvaRapidoFinalizado('custom'), 'resolva_rapido_finalizado', 'n1c1q5', 'custom'),
    Caso(AnalyticsEventsEmployee.agendarFeriasAcessar(), 'agendar_ferias_acessar', 'crtmb6', 'read'),
    Caso(AnalyticsEventsEmployee.agendarFeriasFinalizado(), 'agendar_ferias_finalizado', 'ix1hsy', 'write'),
    Caso(AnalyticsEventsEmployee.folhaPgtoAcessar(), 'folha_pgto_acessar', 'ug61ax', 'read'),
    Caso(AnalyticsEventsEmployee.holeriteAcessar(), 'holerite_acessar', 'tcfg12', 'read'),
    Caso(AnalyticsEventsEmployee.pontoDigitalAcessar(), 'ponto_digital_acessar', 'qz90ry', 'read'),
    Caso(AnalyticsEventsEmployee.pontoAcaoOcorrenciaAcessar(), 'ponto_acao_ocorrencia_acessar', '29mqat', 'read'),
    Caso(AnalyticsEventsEmployee.pontoAcaoOcorrenciaFinalizado('custom'), 'ponto_acao_ocorrencia_finalizado', 'wkka47', 'custom'),
    Caso(AnalyticsEventsEmployee.pontoAssinaFolhaAcessar(), 'ponto_assinafolha_acessar', '3j82ro', 'read'),
    Caso(AnalyticsEventsEmployee.pontoAssinaFolhaFinalizado(), 'ponto_assinafolha_finalizado', 'wuzqst', 'write'),
    Caso(AnalyticsEventsEmployee.pontoInserirEventoFinalizado(), 'ponto_inserir_evento_finalizado', 'ds0t52', 'write'),
    Caso(AnalyticsEventsEmployee.dadosEquipeAcessar(), 'dados_equipe_acessar', '18un06', 'read'),
    Caso(AnalyticsEventsEmployee.indicaVagaAcessar(), 'indica_vaga_acessar', 'ybzfox', 'read'),
    Caso(AnalyticsEventsEmployee.indicaVagaEventoFinalizado(), 'indica_vaga_envio_sucesso', '3bel3i', 'write'),
  ];

  test('todos os eventos têm nome, token e tipo esperados', () {
    verificaCatalogo(casos);
  });

  test('cada chamada cria uma instância nova (não compartilha estado)', () {
    final a = AnalyticsEventsEmployee.bannerDinamicoAcessar();
    final b = AnalyticsEventsEmployee.bannerDinamicoAcessar();
    expect(identical(a, b), isFalse);
    a.name = 'alterado';
    expect(b.name, 'banner_dinamico_acessar');
  });

  test('fábricas com parâmetro repassam o tipo informado', () {
    expect(AnalyticsEventsEmployee.resolvaRapidoFinalizado('write').type,
        'write');
    expect(AnalyticsEventsEmployee.pontoAcaoOcorrenciaFinalizado('read').type,
        'read');
  });

  test('nomes de evento são únicos por tipo', () {
    final duplicados = tokensPorNomeTipo(casos)
        .entries
        .where((e) => e.value.length > 1)
        .map((e) => e.key)
        .toList();
    expect(duplicados, isEmpty);
  });

  test('tokens são únicos dentro do catálogo do colaborador', () {
    final tokens = casos.map((c) => c.token).toList();
    expect(tokens.toSet().length, tokens.length);
  });

  /// Corrigido: eventos de conclusão do colaborador (`edicaoCadastradoSucesso`,
  /// `redefinirSenha`, `indicaVagaEventoFinalizado`) usam o tipo `write`, como
  /// os equivalentes do morador (`AnalyticsEventsOwner`).
  test('eventos de sucesso do colaborador são tipados como write', () {
    expect(AnalyticsEventsEmployee.edicaoCadastradoSucesso().type, 'write');
    expect(AnalyticsEventsEmployee.redefinirSenha().type, 'write');
    expect(AnalyticsEventsEmployee.indicaVagaEventoFinalizado().type, 'write');
  });

  /// Pendente (negócio): o nome `documentos_info_redimentos_acessar` tem erro
  /// de digitação ("redimentos"), mas é contrato com o dashboard e não existe
  /// o nome correto em nenhum outro app; mantido até alinhamento.
  test('pendente: documentos_info_redimentos_acessar mantém o nome com typo',
      () {
    expect(AnalyticsEventsEmployee.documentosInfoRendimentosAcessar().name,
        'documentos_info_redimentos_acessar');
  });
}
