import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';

enum ApplicationRbacEnum {
  colaborador,
  colaboradorChat,
  colaboradorChatRead,
  colaboradorDocumentos,
  colaboradorDocumentosRead,
  colaboradorGestaoEquipe,
  colaboradorGestaoEquipeRead,
  colaboradorGestaoEquipeWrite,
  colaboradorDocumentosHolerite,
  colaboradorDocumentosHoleriteRead,
  colaboradorDocumentosFerias,
  colaboradorDocumentosFeriasRead,
  colaboradorDocumentosInformeRendimentos,
  colaboradorDocumentosInformeRendimentosRead,
  colaboradorDocumentosBeneficios,
  colaboradorDocumentosBeneficiosRead,
  colaboradorVantagens,
  colaboradorVantagensRead,
  colaboradorVantagensDescontos,
  colaboradorVantagensDescontosRead,
  colaboradorVantagensIndiqueGanhe,
  colaboradorVantagensIndiqueGanheRead,
  colaboradorVantagensIndiqueVagas,
  colaboradorVantagensIndiqueVagasRead,
  colaboradorVantagensCondoLivre,
  colaboradorVantagensCondoLivreRead,
  colaboradorVantagensCursos,
  colaboradorVantagensCursosRead,
  colaboradorPontoManual,
  colaboradorPontoManualWrite,
  colaboradorPontodigital,
  colaboradorPontodigitalMarcarPonto,
  colaboradorPontodigitalMarcarPontoWrite,
  colaboradorPontodigitalEspelhoPonto,
  colaboradorPontodigitalEspelhoPontoRead,
  colaboradorPontodigitalComprovante,
  colaboradorPontodigitalComprovanteRead,
  colaboradorPontodigitalAtestado,
  colaboradorPontodigitalAtestadoWrite
}

extension ExtensionApplicationRbacEnum on ApplicationRbacEnum {
  HomeItemEnum? get homeItem {
    switch (this) {
      case ApplicationRbacEnum.colaborador:
        return null;
      case ApplicationRbacEnum.colaboradorChat:
        return null;
      case ApplicationRbacEnum.colaboradorChatRead:
        return null;
      case ApplicationRbacEnum.colaboradorDocumentos:
        return HomeItemEnum.myDocuments;
      case ApplicationRbacEnum.colaboradorDocumentosRead:
        return HomeItemEnum.myDocuments;
      case ApplicationRbacEnum.colaboradorGestaoEquipe:
        return HomeItemEnum.teamManagement;
      case ApplicationRbacEnum.colaboradorGestaoEquipeRead:
        return HomeItemEnum.teamManagement;
      case ApplicationRbacEnum.colaboradorGestaoEquipeWrite:
        return HomeItemEnum.teamManagement;

      case ApplicationRbacEnum.colaboradorDocumentosHolerite:
        return HomeItemEnum.payStub;
      case ApplicationRbacEnum.colaboradorDocumentosHoleriteRead:
        return HomeItemEnum.payStub;
      case ApplicationRbacEnum.colaboradorDocumentosFerias:
        return HomeItemEnum.vacation;
      case ApplicationRbacEnum.colaboradorDocumentosFeriasRead:
        return HomeItemEnum.vacation;
      case ApplicationRbacEnum.colaboradorDocumentosInformeRendimentos:
        return HomeItemEnum.incomeReport;
      case ApplicationRbacEnum.colaboradorDocumentosInformeRendimentosRead:
        return HomeItemEnum.incomeReport;
      case ApplicationRbacEnum.colaboradorDocumentosBeneficios:
        return HomeItemEnum.benefits;
      case ApplicationRbacEnum.colaboradorDocumentosBeneficiosRead:
        return HomeItemEnum.benefits;
      case ApplicationRbacEnum.colaboradorVantagens:
        return null;
      case ApplicationRbacEnum.colaboradorVantagensRead:
        return null;
      case ApplicationRbacEnum.colaboradorVantagensDescontos:
        return HomeItemEnum.discounts;
      case ApplicationRbacEnum.colaboradorVantagensDescontosRead:
        return HomeItemEnum.discounts;
      case ApplicationRbacEnum.colaboradorVantagensIndiqueGanhe:
        return HomeItemEnum.indicateReceiveBenefits;
      case ApplicationRbacEnum.colaboradorVantagensIndiqueGanheRead:
        return HomeItemEnum.indicateReceiveBenefits;
      case ApplicationRbacEnum.colaboradorVantagensCondoLivre:
        return HomeItemEnum.condolivre;
      case ApplicationRbacEnum.colaboradorVantagensCondoLivreRead:
        return HomeItemEnum.condolivre;
      case ApplicationRbacEnum.colaboradorVantagensCursos:
        return HomeItemEnum.courses;
      case ApplicationRbacEnum.colaboradorVantagensCursosRead:
        return HomeItemEnum.courses;
      case ApplicationRbacEnum.colaboradorPontoManual:
        return HomeItemEnum.sendTimeSheet;
      case ApplicationRbacEnum.colaboradorPontoManualWrite:
        return HomeItemEnum.sendTimeSheet;
      case ApplicationRbacEnum.colaboradorPontodigital:
        return null;
      case ApplicationRbacEnum.colaboradorPontodigitalMarcarPonto:
        return HomeItemEnum.registerDigitalPoint;
      case ApplicationRbacEnum.colaboradorPontodigitalMarcarPontoWrite:
        return HomeItemEnum.registerDigitalPoint;
      case ApplicationRbacEnum.colaboradorPontodigitalEspelhoPonto:
        return HomeItemEnum.timeSheet;
      case ApplicationRbacEnum.colaboradorPontodigitalEspelhoPontoRead:
        return HomeItemEnum.timeSheet;
      case ApplicationRbacEnum.colaboradorPontodigitalComprovante:
        return HomeItemEnum.proof;
      case ApplicationRbacEnum.colaboradorPontodigitalComprovanteRead:
        return HomeItemEnum.proof;
      case ApplicationRbacEnum.colaboradorPontodigitalAtestado:
        return HomeItemEnum.sickNote;
      case ApplicationRbacEnum.colaboradorPontodigitalAtestadoWrite:
        return HomeItemEnum.sickNote;
      case ApplicationRbacEnum.colaboradorVantagensIndiqueVagas:
        return HomeItemEnum.employeeReferral;
      case ApplicationRbacEnum.colaboradorVantagensIndiqueVagasRead:
        return HomeItemEnum.employeeReferral;
    }
  }

  String toFormattedString() {
    switch (this) {
      case ApplicationRbacEnum.colaborador:
        return "colaborador";
      case ApplicationRbacEnum.colaboradorChat:
        return "colaborador.chat";
      case ApplicationRbacEnum.colaboradorChatRead:
        return "colaborador.chat.read";
      case ApplicationRbacEnum.colaboradorDocumentos:
        return "colaborador.documentos";
      case ApplicationRbacEnum.colaboradorDocumentosRead:
        return "colaborador.documentos";
      case ApplicationRbacEnum.colaboradorGestaoEquipe:
        return "colaborador.gestaoEquipe";
      case ApplicationRbacEnum.colaboradorGestaoEquipeRead:
        return "colaborador.gestaoEquipe.read";
      case ApplicationRbacEnum.colaboradorGestaoEquipeWrite:
        return "colaborador.gestaoEquipe.write";

      case ApplicationRbacEnum.colaboradorDocumentosHolerite:
        return "colaborador.documentos.holerite";
      case ApplicationRbacEnum.colaboradorDocumentosHoleriteRead:
        return "colaborador.documentos.holerite.read";
      case ApplicationRbacEnum.colaboradorDocumentosFerias:
        return "colaborador.documentos.ferias";
      case ApplicationRbacEnum.colaboradorDocumentosFeriasRead:
        return "colaborador.documentos.ferias.read";
      case ApplicationRbacEnum.colaboradorDocumentosInformeRendimentos:
        return "colaborador.documentos.informeRendimentos";
      case ApplicationRbacEnum.colaboradorDocumentosInformeRendimentosRead:
        return "colaborador.documentos.informeRendimentos.read";
      case ApplicationRbacEnum.colaboradorDocumentosBeneficios:
        return "colaborador.documentos.beneficios";
      case ApplicationRbacEnum.colaboradorDocumentosBeneficiosRead:
        return "colaborador.documentos.beneficios.read";
      case ApplicationRbacEnum.colaboradorVantagens:
        return "colaborador.vantagens";
      case ApplicationRbacEnum.colaboradorVantagensRead:
        return "colaborador.vantagens.read";
      case ApplicationRbacEnum.colaboradorVantagensDescontos:
        return "colaborador.vantagens.descontos";
      case ApplicationRbacEnum.colaboradorVantagensDescontosRead:
        return "colaborador.vantagens.descontos.read";
      case ApplicationRbacEnum.colaboradorVantagensIndiqueGanhe:
        return "colaborador.vantagens.indiqueGanhe";
      case ApplicationRbacEnum.colaboradorVantagensIndiqueGanheRead:
        return "colaborador.vantagens.indiqueGanhe.read";
      case ApplicationRbacEnum.colaboradorVantagensIndiqueVagas:
        return "colaborador.vantagens.indiqueVagas";
      case ApplicationRbacEnum.colaboradorVantagensIndiqueVagasRead:
        return "colaborador.vantagens.indiqueVagas.read";
      case ApplicationRbacEnum.colaboradorVantagensCondoLivre:
        return "colaborador.vantagens.condoLivre";
      case ApplicationRbacEnum.colaboradorVantagensCondoLivreRead:
        return "colaborador.vantagens.condoLivre.read";
      case ApplicationRbacEnum.colaboradorVantagensCursos:
        return "colaborador.vantagens.cursos";
      case ApplicationRbacEnum.colaboradorVantagensCursosRead:
        return "colaborador.vantagens.cursos.read";
      case ApplicationRbacEnum.colaboradorPontoManual:
        return "colaborador.pontoManual";
      case ApplicationRbacEnum.colaboradorPontoManualWrite:
        return "colaborador.pontoManual.write";
      case ApplicationRbacEnum.colaboradorPontodigital:
        return "colaborador.pontodigital";
      case ApplicationRbacEnum.colaboradorPontodigitalMarcarPonto:
        return "colaborador.pontodigital.marcarPonto";
      case ApplicationRbacEnum.colaboradorPontodigitalMarcarPontoWrite:
        return "colaborador.pontodigital.marcarPonto.write";
      case ApplicationRbacEnum.colaboradorPontodigitalEspelhoPonto:
        return "colaborador.pontodigital.espelhoPonto";
      case ApplicationRbacEnum.colaboradorPontodigitalEspelhoPontoRead:
        return "colaborador.pontodigital.espelhoPonto.read";
      case ApplicationRbacEnum.colaboradorPontodigitalComprovante:
        return "colaborador.pontodigital.comprovante";
      case ApplicationRbacEnum.colaboradorPontodigitalComprovanteRead:
        return "colaborador.pontodigital.comprovante.read";
      case ApplicationRbacEnum.colaboradorPontodigitalAtestado:
        return "colaborador.pontodigital.atestado";
      case ApplicationRbacEnum.colaboradorPontodigitalAtestadoWrite:
        return "colaborador.pontodigital.atestado.write";
    }
  }
}

class UtilsAplicationRbac {
  static ApplicationRbacEnum? fromString(String rbac) {
    switch (rbac) {
      case "colaborador":
        return ApplicationRbacEnum.colaborador;
      case "colaborador.chat":
        return ApplicationRbacEnum.colaboradorChat;
      case "colaborador.chat.read":
        return ApplicationRbacEnum.colaboradorChatRead;
      case "colaborador.documentos":
        return ApplicationRbacEnum.colaboradorDocumentos;
      case "colaborador.documentos.read":
        return ApplicationRbacEnum.colaboradorDocumentosRead;
      case "colaborador.gestaoEquipe":
        return ApplicationRbacEnum.colaboradorGestaoEquipe;
      case "colaborador.gestaoEquipe.read":
        return ApplicationRbacEnum.colaboradorGestaoEquipeRead;
      case "colaborador.gestaoEquipe.write":
        return ApplicationRbacEnum.colaboradorGestaoEquipeWrite;

      case "colaborador.documentos.holerite":
        return ApplicationRbacEnum.colaboradorDocumentosHolerite;
      case "colaborador.documentos.holerite.read":
        return ApplicationRbacEnum.colaboradorDocumentosHoleriteRead;
      case "colaborador.documentos.ferias":
        return ApplicationRbacEnum.colaboradorDocumentosFerias;
      case "colaborador.documentos.ferias.read":
        return ApplicationRbacEnum.colaboradorDocumentosFeriasRead;
      case "colaborador.documentos.informeRendimentos":
        return ApplicationRbacEnum.colaboradorDocumentosInformeRendimentos;
      case "colaborador.documentos.informeRendimentos.read":
        return ApplicationRbacEnum.colaboradorDocumentosInformeRendimentosRead;
      case "colaborador.documentos.beneficios":
        return ApplicationRbacEnum.colaboradorDocumentosBeneficios;
      case "colaborador.documentos.beneficios.read":
        return ApplicationRbacEnum.colaboradorDocumentosBeneficiosRead;
      case "colaborador.vantagens":
        return ApplicationRbacEnum.colaboradorVantagens;
      case "colaborador.vantagens.read":
        return ApplicationRbacEnum.colaboradorVantagensRead;
      case "colaborador.vantagens.descontos":
        return ApplicationRbacEnum.colaboradorVantagensDescontos;
      case "colaborador.vantagens.descontos.read":
        return ApplicationRbacEnum.colaboradorVantagensDescontosRead;
      case "colaborador.vantagens.indiqueGanhe":
        return ApplicationRbacEnum.colaboradorVantagensIndiqueGanhe;
      case "colaborador.vantagens.indiqueGanhe.read":
        return ApplicationRbacEnum.colaboradorVantagensIndiqueGanheRead;
      case "colaborador.vantagens.indiqueVagas":
        return ApplicationRbacEnum.colaboradorVantagensIndiqueVagas;
      case "colaborador.vantagens.indiqueVagas.read":
        return ApplicationRbacEnum.colaboradorVantagensIndiqueVagasRead;
      case "colaborador.vantagens.condoLivre":
        return ApplicationRbacEnum.colaboradorVantagensCondoLivre;
      case "colaborador.vantagens.condoLivre.read":
        return ApplicationRbacEnum.colaboradorVantagensCondoLivreRead;
      case "colaborador.vantagens.cursos":
        return ApplicationRbacEnum.colaboradorVantagensCursos;
      case "colaborador.vantagens.cursos.read":
        return ApplicationRbacEnum.colaboradorVantagensCursosRead;
      case "colaborador.pontoManual":
        return ApplicationRbacEnum.colaboradorPontoManual;
      case "colaborador.pontoManual.write":
        return ApplicationRbacEnum.colaboradorPontoManualWrite;
      case "colaborador.pontodigital":
        return ApplicationRbacEnum.colaboradorPontodigital;
      case "colaborador.pontodigital.marcarPonto":
        return ApplicationRbacEnum.colaboradorPontodigitalMarcarPonto;
      case "colaborador.pontodigital.marcarPonto.write":
        return ApplicationRbacEnum.colaboradorPontodigitalMarcarPontoWrite;
      case "colaborador.pontodigital.espelhoPonto":
        return ApplicationRbacEnum.colaboradorPontodigitalEspelhoPonto;
      case "colaborador.pontodigital.espelhoPonto.read":
        return ApplicationRbacEnum.colaboradorPontodigitalEspelhoPontoRead;
      case "colaborador.pontodigital.comprovante":
        return ApplicationRbacEnum.colaboradorPontodigitalComprovante;
      case "colaborador.pontodigital.comprovante.read":
        return ApplicationRbacEnum.colaboradorPontodigitalComprovanteRead;
      case "colaborador.pontodigital.atestado":
        return ApplicationRbacEnum.colaboradorPontodigitalAtestado;
      case "colaborador.pontodigital.atestado.write":
        return ApplicationRbacEnum.colaboradorPontodigitalAtestadoWrite;
    }
    return null;
  }
}
