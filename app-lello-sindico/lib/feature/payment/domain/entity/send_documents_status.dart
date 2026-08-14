enum SendDocumentsStatus {
  success,
  documentoIlegivel,
  validacaoCampos,
  timeout,
  erroGenerico,
  semRetornoExtracao,
  erroExtracaoCnpjFornecedorCondominio,
  erroExtracaoCnpjCondominio,
  arquivoDesconhecido,
  validacaoCnpjCondominio,
  validacaoCnpjFornecedor,
  validacaoReferenciaCnpjCondoDiferente,
  documentoEnvioEmMenos24Horas,
  dadosDuplicados,
}

SendDocumentsStatus parseSendDocumentsStatus(String status) {
  switch (status) {
    case 'SUCCESS':
      return SendDocumentsStatus.success;
    case 'DOCUMENTO_ILEGIVEL':
      return SendDocumentsStatus.documentoIlegivel;
    case 'VALIDACAO_CAMPOS':
      return SendDocumentsStatus.validacaoCampos;
    case 'TIMEOUT':
      return SendDocumentsStatus.timeout;
    case 'ERRO_GENERICO':
      return SendDocumentsStatus.erroGenerico;
    case 'SEM_RETORNO_EXTRACAO':
      return SendDocumentsStatus.semRetornoExtracao;
    case 'ERRO_EXTRACAO_CNPJ_FORNECEDOR_CONDOMINIO':
      return SendDocumentsStatus.erroExtracaoCnpjFornecedorCondominio;
    case 'ERRO_EXTRACAO_CNPJ_CONDOMINIO':
      return SendDocumentsStatus.erroExtracaoCnpjCondominio;
    case 'ARQUIVO_DESCONHECIDO':
      return SendDocumentsStatus.arquivoDesconhecido;
    case 'VALIDACAO_CNPJ_CONDOMINIO':
      return SendDocumentsStatus.validacaoCnpjCondominio;
    case 'VALIDACAO_CNPJ_FORNECEDOR':
      return SendDocumentsStatus.validacaoCnpjFornecedor;
    case 'VALIDACAO_REFERENCIA_CNPJ_CONDO_DIFERENTE':
      return SendDocumentsStatus.validacaoReferenciaCnpjCondoDiferente;
    case 'DOCUMENTO_ENVIO_EM_MENOS_24_HORAS':
      return SendDocumentsStatus.documentoEnvioEmMenos24Horas;
    case 'DADOS_DUPLICADOS':
      return SendDocumentsStatus.dadosDuplicados;
    default:
      return SendDocumentsStatus.erroGenerico;
  }
}

String sendDocumentsStatusToString(SendDocumentsStatus status) {
  switch (status) {
    case SendDocumentsStatus.success:
      return 'SUCCESS';
    case SendDocumentsStatus.documentoIlegivel:
      return 'DOCUMENTO_ILEGIVEL';
    case SendDocumentsStatus.validacaoCampos:
      return 'VALIDACAO_CAMPOS';
    case SendDocumentsStatus.timeout:
      return 'TIMEOUT';
    case SendDocumentsStatus.erroGenerico:
      return 'ERRO_GENERICO';
    case SendDocumentsStatus.semRetornoExtracao:
      return 'SEM_RETORNO_EXTRACAO';
    case SendDocumentsStatus.erroExtracaoCnpjFornecedorCondominio:
      return 'ERRO_EXTRACAO_CNPJ_FORNECEDOR_CONDOMINIO';
    case SendDocumentsStatus.erroExtracaoCnpjCondominio:
      return 'ERRO_EXTRACAO_CNPJ_CONDOMINIO';
    case SendDocumentsStatus.arquivoDesconhecido:
      return 'ARQUIVO_DESCONHECIDO';
    case SendDocumentsStatus.validacaoCnpjCondominio:
      return 'VALIDACAO_CNPJ_CONDOMINIO';
    case SendDocumentsStatus.validacaoCnpjFornecedor:
      return 'VALIDACAO_CNPJ_FORNECEDOR';
    case SendDocumentsStatus.validacaoReferenciaCnpjCondoDiferente:
      return 'VALIDACAO_REFERENCIA_CNPJ_CONDO_DIFERENTE';
    case SendDocumentsStatus.documentoEnvioEmMenos24Horas:
      return 'DOCUMENTO_ENVIO_EM_MENOS_24_HORAS';
    case SendDocumentsStatus.dadosDuplicados:
      return 'DADOS_DUPLICADOS';
    default:
      return 'ERRO_GENERICO';
  }
}

String handleSendDocumentsStatus(SendDocumentsStatus status) {
  switch (status) {
    case SendDocumentsStatus.success:
      return 'Documentos enviados com sucesso.';
    case SendDocumentsStatus.documentoIlegivel:
      return 'Documento ilegível.';
    case SendDocumentsStatus.validacaoCampos:
      return 'Erro de validação de campos.';
    case SendDocumentsStatus.timeout:
      return 'Timeout ao enviar documentos.';
    case SendDocumentsStatus.erroGenerico:
      return 'Erro genérico.';
    case SendDocumentsStatus.semRetornoExtracao:
      return 'Sem retorno de extração.';
    case SendDocumentsStatus.erroExtracaoCnpjFornecedorCondominio:
      return 'Erro na extração do CNPJ do fornecedor ou condomínio.';
    case SendDocumentsStatus.erroExtracaoCnpjCondominio:
      return 'Erro na extração do CNPJ do condomínio.';
    case SendDocumentsStatus.arquivoDesconhecido:
      return 'Arquivo desconhecido.';
    case SendDocumentsStatus.validacaoCnpjCondominio:
      return 'Erro de validação do CNPJ do condomínio.';
    case SendDocumentsStatus.validacaoCnpjFornecedor:
      return 'Erro de validação do CNPJ do fornecedor.';
    case SendDocumentsStatus.validacaoReferenciaCnpjCondoDiferente:
      return 'Erro de validação de referência de CNPJ diferente do condomínio.';
    default:
      return 'Status desconhecido.';
  }
}
