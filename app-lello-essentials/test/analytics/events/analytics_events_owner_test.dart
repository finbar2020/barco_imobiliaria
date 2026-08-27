import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:flutter_test/flutter_test.dart';

import 'evento_caso.dart';

void main() {
  final casos = <Caso>[
    Caso(AnalyticsEventsOwner.acordosAcessarAcordosEmAndamento(), 'acordos_acessar_acordos_em_andamento', 'x2w07f', 'read'),
    Caso(AnalyticsEventsOwner.acordosAcessarCotasDisponiveis(), 'acordos_acessar_cotas_disponiveis', 'ccwpyj', 'read'),
    Caso(AnalyticsEventsOwner.acordosAcessarAcordosRealizados(), 'acordos_acessar_acordos_realizados', 'sqvi1c', 'read'),
    Caso(AnalyticsEventsOwner.acordosAcessarSiteParceiroVamosParcelar(), 'acordos_acessar_site_parceiro_vamos_parcelar', 'qi273v', 'read'),
    Caso(AnalyticsEventsOwner.acordosEscolherPagarBoleto(), 'acordos_escolher_pagar_boleto', 'zffe0p', 'read'),
    Caso(AnalyticsEventsOwner.acordosEscolherPagarCartaoDeCredito(), 'acordos_escolher_pagar_cartao_de_credito', '4o1an8', 'read'),
    Caso(AnalyticsEventsOwner.acordosEscolherOpcoesDePagamentoMaisIndicada(), 'acordos_escolher_opcoes_de_pagamento_mais_indicada', 'x4enqs', 'read'),
    Caso(AnalyticsEventsOwner.acordosEscolherOutrasOpcoesDePagamento(), 'acordos_escolher_outras_opcoes_de_pagamento', '38q70l', 'read'),
    Caso(AnalyticsEventsOwner.acordosEscolherPersonalizarAcordo(), 'acordos_escolher_personalizar_acordo', 'tdqz07', 'read'),
    Caso(AnalyticsEventsOwner.acordosRecusarAcordo(), 'acordos_recusar_acordo', 'u3mowp', 'read'),
    Caso(AnalyticsEventsOwner.acordosFinalizarAcordoSucesso(), 'acordos_finalizar_acordo_sucesso', '8klwff', 'write'),
    Caso(AnalyticsEventsOwner.acordosVisualizarBoleto(), 'acordos_visualizar_boleto', 'ezsadb', 'read'),
    Caso(AnalyticsEventsOwner.acordosCopiarCodigoDeBarras(), 'acordos_copiar_codigo_de_barras', 'vu6inl', 'read'),
    Caso(AnalyticsEventsOwner.acordosCompartilharBoleto(), 'acordos_compartilhar_boleto', 'lpzzlh', 'read'),
    Caso(AnalyticsEventsOwner.autorizacaoEntradasAcessar(), 'autorizacao_entradas_acessar', '39e0pa', 'read'),
    Caso(AnalyticsEventsOwner.autorizacaoEntradasAcessarAgendamentos(), 'autorizacao_entradas_acessar_agendamentos', 'du0ogy', 'read'),
    Caso(AnalyticsEventsOwner.autorizacaoEntradasAcessarAgendamentosApagar(), 'autorizacao_entradas_acessar_agendamentos_apagar', 'es7gs3', 'delete'),
    Caso(AnalyticsEventsOwner.autorizacaoEntradasAcessarApagarVisitante(), 'autorizacao_entradas_acessar_apagar_visitante', 'kz57fn', 'delete'),
    Caso(AnalyticsEventsOwner.autorizacaoEntradasAgendamentosSucesso(), 'autorizacao_entradas_agendamentos_sucesso', '4qp1yw', 'write'),
    Caso(AnalyticsEventsOwner.autorizacaoEntradasCadastrarNovoVisitanteSucesso(), 'autorizacao_entradas_cadastrar_novo_visitante_sucesso', 'ljxjd7', 'write'),
    Caso(AnalyticsEventsOwner.boletosAcessar(), 'boletos_acessar', 'lkjuxc', 'read'),
    Caso(AnalyticsEventsOwner.boletosAcessarVencido(), 'boletos_acessar_vencido', 'ta05t4', 'read'),
    Caso(AnalyticsEventsOwner.boletosAcessarVencidoCopiarEmail(), 'boletos_acessar_vencido_copiar_email', 'q23ehb', 'read'),
    Caso(AnalyticsEventsOwner.boletosAcessarVencidoIrParaWhats(), 'boletos_acessar_vencido_ir_para_whats', 'uv0g1b', 'read'),
    Caso(AnalyticsEventsOwner.boletosCopiarCodigoDeBarras(), 'boletos_copiar_codigo_de_barras', 'kvgo0a', 'read'),
    Caso(AnalyticsEventsOwner.boletosCompartilhar(), 'boletos_compartilhar', 'rcno08', 'read'),
    Caso(AnalyticsEventsOwner.correspondenciaAcessar(), 'correspondencia_acessar', 'gepx95', 'read'),
    Caso(AnalyticsEventsOwner.documentosAcessar(), 'documentos_acessar', 'k1gjqd', 'read'),
    Caso(AnalyticsEventsOwner.documentosAcessarCompartilhar(), 'documentos_acessar_compartilhar', 'lsr1wk', 'read'),
    Caso(AnalyticsEventsOwner.documentosAtasAcessar(), 'documentos_atas_acessar', 'nscp3c', 'read'),
    Caso(AnalyticsEventsOwner.documentosEditaisAcessar(), 'documentos_editais_acessar', '2r3ft9', 'read'),
    Caso(AnalyticsEventsOwner.documentosCircularesAcessar(), 'documentos_circulares_acessar', 'etzz1h', 'read'),
    Caso(AnalyticsEventsOwner.documentosDiversosAcessar(), 'documentos_diversos_acessar', '6qsk86', 'read'),
    Caso(AnalyticsEventsOwner.edicaoCadastroAcessar(), 'edicao_cadastro_acessar', 'emhaa3', 'read'),
    Caso(AnalyticsEventsOwner.edicaoCadastroTelaDeSucesso(), 'edicao_cadastro_tela_de_sucesso', 'd5zeyw', 'write'),
    Caso(AnalyticsEventsOwner.esqueciSenhaAcessar(), 'esqueci_senha_acessar', 'z2gatk', 'read'),
    Caso(AnalyticsEventsOwner.esqueciSenhaFinalizado(), 'esqueci_senha_finalizado', 'p6hu3j', 'write'),
    Caso(AnalyticsEventsOwner.loginFinalizado(), 'login_finalizado', 'jw7o8k', 'write'),
    Caso(AnalyticsEventsOwner.moradoresAcessar(), 'moradores_acessar', '4599xc', 'read'),
    Caso(AnalyticsEventsOwner.moradoresAcessarEditar(), 'moradores_acessar_editar', 'nxikf4', 'read'),
    Caso(AnalyticsEventsOwner.moradoresAcessarEditarBloquear(), 'moradores_acessar_editar_bloquear', 'bw955o', 'write'),
    Caso(AnalyticsEventsOwner.moradoresAdicionarNovoUsuario(), 'moradores_adicionar_novo_usuario', '46bvsa', 'read'),
    Caso(AnalyticsEventsOwner.moradoresAdicionarNovoUsuarioSucesso(), 'moradores_adicionar_novo_usuario_sucesso', 'tbka17', 'write'),
    Caso(AnalyticsEventsOwner.notificacoesAcessar(), 'notificacoes_acessar', '71d0wi', 'read'),
    Caso(AnalyticsEventsOwner.notificacoeCTA(), 'notificacao_cta', 'xpaf7r', 'read'),
    Caso(AnalyticsEventsOwner.morarHomeTemporizador(), 'morar_home_temporizador', 'eq060p', 'read'),
    Caso(AnalyticsEventsOwner.ocorrenciasMinhasAbertas(), 'ocorrencias_minhas_abertas', 'ub5erm', 'read'),
    Caso(AnalyticsEventsOwner.ocorrenciasMinhasEncerradas(), 'ocorrencias_minhas_encerradas', 'pnyu2p', 'read'),
    Caso(AnalyticsEventsOwner.ocorrenciasMinhasOcorrencias(), 'ocorrencias_minhas_ocorrencias', '951xtp', 'read'),
    Caso(AnalyticsEventsOwner.ocorrenciasRegistrarNovaOcorrencia(), 'ocorrencias_registrar_nova_ocorrencia', 'aknead', 'read'),
    Caso(AnalyticsEventsOwner.ocorrenciasMinhasResponder(), 'ocorrencias_minhas_responder', '8yitw2', 'read'),
    Caso(AnalyticsEventsOwner.ocorrenciasRegistrarNovaOcorrenciaSucesso(), 'ocorrencias_registrar_nova_ocorrencia_sucesso', '96tdjp', 'write'),
    Caso(AnalyticsEventsOwner.ppcAcessar(), 'ppc_acessar', 'p41ap3', 'read'),
    Caso(AnalyticsEventsOwner.ppcAcessarMesConsultar(), 'ppc_acessar_mes_consultar', 'vxwo6v', 'read'),
    Caso(AnalyticsEventsOwner.redefinirSenha(), 'redefinir_senha', 'qdkro2', 'write'),
    Caso(AnalyticsEventsOwner.reservasAcessar(), 'reservas_acessar', 'qx9eya', 'read'),
    Caso(AnalyticsEventsOwner.reservasAcessarAgendamentos(), 'reservas_acessar_agendamentos', 'h81e6d', 'read'),
    Caso(AnalyticsEventsOwner.reservasCancelar(), 'reservas_cancelar', 'm4zsfd', 'delete'),
    Caso(AnalyticsEventsOwner.reservasReservar(), 'reservas_reservar', 'oxlr22', 'write'),
    Caso(AnalyticsEventsOwner.resolvaFacilAssembleiaAcessar(), 'resolva_facil_assembleia_acessar', '9l3l7u', 'read'),
    Caso(AnalyticsEventsOwner.resolvaFacilAssembleiaParticiparzoom(), 'resolva_facil_assembleia_participarzoom', 'ixvgyh', 'read'),
    Caso(AnalyticsEventsOwner.veiculoAcessar(), 'veiculo_acessar', 'sil59z', 'read'),
    Caso(AnalyticsEventsOwner.veiculoAcessarAdicionarNovoVeiculo(), 'veiculo_acessar_adicionar_novo_veiculo', '28zh6q', 'write'),
    Caso(AnalyticsEventsOwner.veiculoAcessarAdicionarNovoVeiculoSucesso(), 'veiculo_acessar_adicionar_novo_veiculo_sucesso', 'eblev4', 'write'),
    Caso(AnalyticsEventsOwner.veiculoAcessarExcluirVeiculo(), 'veiculo_acessar_excluir_veiculo', '5pmpmo', 'delete'),
    Caso(AnalyticsEventsOwner.comodidadesCtaOptIn(), 'comodidades_cta_opt_in', 'mbm4hb', 'write'),
    Caso(AnalyticsEventsOwner.comodidadesCtaRedirecionamento(), 'comodidades_cta_redirect', 'tar6ji', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesCtaCardFechar(), 'comodidades_cta_fechar_card', 'iudnje', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesLgpdAcessar(), 'comodidades_lgpd_acessar', 'ikzjmc', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesCtaAcessar(), 'comodidades_cta_acessar', '3t6adh', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesParceiroAcessar(), 'comodidades_parceiro_acessar', 'uxxv42', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesParceiroVoltar(), 'comodidades_parceiro_voltar', 'o8xu1n', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesAcessar(), 'comodidades_acessar', 'eykqhn', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesVoltar(), 'comodidades_voltar', 'ua2w0v', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesAvaliar(), 'comodidades_avaliar', 'qsto8u', 'write'),
    Caso(AnalyticsEventsOwner.comodidadesAvaliarDepois(), 'comodidades_avaliar_depois', 'vsvxyw', 'write'),
    Caso(AnalyticsEventsOwner.comodidadesCompraRealizada(), 'comodidades_compra_realizada', 'm938b6', 'write'),
    Caso(AnalyticsEventsOwner.comodidadesCupomAtivar(), 'comodidades_cupom_ativar', '2fbqgg', 'write'),
    Caso(AnalyticsEventsOwner.comodidadesFavoritosAcessar(), 'comodidades_favoritos_acessar', 'g63fbu', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesMudarFavorito(), 'comodidades_mudar_favorito', '20z2kw', 'write'),
    Caso(AnalyticsEventsOwner.comodidadesParceiroAvaliacoesAcessar(), 'comodidades_parceiro_avaliacoes_acessar', 'bh38fv', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesSolicitacoesAcessar(), 'comodidades_solicitacoes_acessar', 'gq0m2e', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesAcessarViaDialog(), 'comodidades_acessar_via_dialog', 'al344l', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesRecusarAcessoViaDialog(), 'comodidades_recusar_acesso_via_dialog', 'kbinwp', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesCategoriaAcessar(), 'comodidades_categoria_acessar', 'c6fcfe', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesCategoriaVoltar(), 'comodidades_categoria_voltar', 'isq4nc', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesSubCategoriaAcessar(), 'comodidades_subcategoria_acessar', 'yhbbvj', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesHomeTemporizador(), 'comodidades_home_temporizador', 'c8mrdw', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesCategoriaTemporizador(), 'comodidades_categoria_temporizador', 'au8tj8', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesCardComodidadeTemporizador(), 'comodidades_card_temporizador', 'a2v650', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesModalRedirecionamentoTemporizador(), 'comodidades_modal_redirect_temporizador', 'z0x6r7', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesPaginaParceiroTemporizador(), 'comodidades_page_parceiro_temporizador', 'k6qln4', 'read'),
    Caso(AnalyticsEventsOwner.tdbAcessar(), 'tdb_acessar', '5mwycx', 'read'),
    Caso(AnalyticsEventsOwner.tdbCadastrar(), 'tdb_cadastrar', 'e792ky', 'write'),
    Caso(AnalyticsEventsOwner.bannerDinamicoAcessar(), 'banner_dinamico_acessar', 'oyra8k', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesParceiroSegurosAcessar(), 'comodidades_parceiro_seguros_acessar', 'ghk8t1', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesParceiroSegurosCancelar(), 'comodidades_parceiro_seguros_cancelar', 'w38073', 'read'),
    Caso(AnalyticsEventsOwner.comodidadesParceiroSegurosContratar(), 'comodidades_parceiro_seguros_contratar', 'cm0lpc', 'write'),
    Caso(AnalyticsEventsOwner.comodidadesParceiroSegurosDesistir(), 'comodidades_parceiro_seguros_desistir', 'djnzm6', 'read'),
    Caso(AnalyticsEventsOwner.sessaoIniciar(), 'sessao_iniciar', '7q4vnd', 'read'),
    Caso(AnalyticsEventsOwner.falelelloAcessar(), 'falelello_acessar', 'smtjqk', 'read'),
    Caso(AnalyticsEventsOwner.lelloImoveisAcessar(), 'lello_imoveis_acessar', 'b3w1uq', 'read'),
    Caso(AnalyticsEventsOwner.lelloImoveisRecusarAcesso(), 'lello_imoveis_recusar_acesso', 'vsfgjf', 'read'),
  ];

  test('todos os eventos têm nome, token e tipo esperados', () {
    verificaCatalogo(casos);
  });

  test('cada chamada cria uma instância nova (não compartilha estado)', () {
    final a = AnalyticsEventsOwner.bannerDinamicoAcessar();
    final b = AnalyticsEventsOwner.bannerDinamicoAcessar();
    expect(identical(a, b), isFalse);
    a.name = 'alterado';
    expect(b.name, 'banner_dinamico_acessar');
  });

  test('nomes de evento são únicos por tipo', () {
    final duplicados = tokensPorNomeTipo(casos)
        .entries
        .where((e) => e.value.length > 1)
        .map((e) => e.key)
        .toList();
    expect(duplicados, isEmpty);
  });

  test('tokens são únicos dentro do catálogo do morador', () {
    final tokens = casos.map((c) => c.token).toList();
    expect(tokens.toSet().length, tokens.length);
  });

  test('eventos de exclusão usam o tipo delete', () {
    expect(AnalyticsEventsOwner.reservasCancelar().type, 'delete');
    expect(AnalyticsEventsOwner.veiculoAcessarExcluirVeiculo().type, 'delete');
    expect(AnalyticsEventsOwner.autorizacaoEntradasAcessarApagarVisitante().type,
        'delete');
    expect(
        AnalyticsEventsOwner.autorizacaoEntradasAcessarAgendamentosApagar().type,
        'delete');
  });

  test('banner dinâmico usa o mesmo token nos três apps', () {
    expect(AnalyticsEventsOwner.bannerDinamicoAcessar().token, 'oyra8k');
  });
}
