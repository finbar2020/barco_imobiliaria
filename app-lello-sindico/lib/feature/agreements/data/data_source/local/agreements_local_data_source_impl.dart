import 'package:lello/core/database/agreements_all_info/agreements_agreement_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_installments_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_quote_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_rules_days_dao.dart';
import 'package:lello/core/database/agreements_all_info/agreements_rules_installments_dao.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:lello/feature/agreements/data/data_source/local/agreements_local_data_source.dart';
import 'package:lello/feature/agreements/data/model/agreement_installment_model.dart';
import 'package:lello/feature/agreements/data/model/agreement_model.dart';
import 'package:lello/feature/agreements/data/model/agreement_quote_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_all_info_model.dart';
import 'package:lello/feature/agreements/data/model/agreements_rules_model.dart';
import 'package:drift/drift.dart';

class AgreementsLocalDataSourceImpl extends AgreementsLocalDataSource {
  final AgreementsDao agreementsDao;
  final AgreementsInstallmentsDao agreementsInstallmentsDao;
  final AgreementsQuoteDao agreementsQuoteDao;
  final AgreementsRulesDaysDao agreementsRulesDaysDao;
  final AgreementsRulesInstallmentsDao agreementsRulesInstallmentsDao;
  AgreementsLocalDataSourceImpl({
    required this.agreementsDao,
    required this.agreementsInstallmentsDao,
    required this.agreementsQuoteDao,
    required this.agreementsRulesDaysDao,
    required this.agreementsRulesInstallmentsDao,
  });

  @override
  Future<AgreementsAllInfoModel?> saveAllInfo(
      AgreementsAllInfoModel? model, String condominiumId) async {
    if (model == null) {
      return model;
    }
    agreementsDao.deleteCondominiumAgreements(condominiumId);
    agreementsInstallmentsDao.deleteCondominiumInstallments(condominiumId);
    agreementsQuoteDao.deleteCondominiumQuotes(condominiumId);
    model.agreements
        .forEach((agreement) => _saveAgreementModel(agreement, condominiumId));
    _saveAgreementRules(model.rule, condominiumId);
    return model;
  }

  @override
  Future<AgreementsRulesModel?> saveRules(
      AgreementsRulesModel rules, String condominiumId) async {
    _saveAgreementRules(rules, condominiumId);
    return rules;
  }

  @override
  Future<AgreementsAllInfoModel?> selectAllInfo(String condominiumId) async {
    final AgreementsRulesModel? agreementsRulesModel =
        await _getRules(condominiumId);
    final List<AgreementModel>? agreementsModelList =
        await _getAgreements(condominiumId);

    if (agreementsRulesModel != null && agreementsModelList != null) {
      return AgreementsAllInfoModel(
          agreements: agreementsModelList, rule: agreementsRulesModel);
    }
    return null;
  }

  Future _saveAgreementModel(
      AgreementModel agreement, String condominiumId) async {
    if (agreement.id != null) {
      final agreementDataModel = AgreementsTableCompanion(
        id: Value(agreement.id!),
        condominiumId: Value(condominiumId),
        reference: Value(agreement.reference),
        unit: Value(agreement.unit),
        unitOwner: Value(agreement.unitOwner),
        baseValue: Value(agreement.baseValue),
        fineAndCosts: Value(agreement.fineAndCosts),
        installmentQuantity: Value(agreement.installmentQuantity),
        paymentMethod: Value(agreement.paymentMethod),
        status: Value(agreement.status),
        statusMessage: Value(agreement.statusMessage),
        expiration: Value(agreement.expiration),
        proposaldedDate: Value(agreement.proposaldedDate),
        approvalDate: Value(agreement.approvalDate),
        dueDate: Value(agreement.dueDate),
        lastInstallmentDate: Value(agreement.lastInstallmentDate),
      );
      await agreementsDao.insert(agreementDataModel);

      agreement.installments.forEach((installment) =>
          _saveInstallment(agreement, installment, condominiumId));

      agreement.quotes
          .forEach((quote) => _saveQuote(agreement, quote, condominiumId));
    }
  }

  void _saveInstallment(AgreementModel agreement,
      AgreementInstallmentModel installment, String condominiumId) {
    if (installment.installmentId != null) {
      final agreementInstallmentDataModel =
          AgreementsInstallmentsTableCompanion(
        installmentId: Value(installment.installmentId!),
        agreementId: Value(agreement.id),
        condominiumId: Value(condominiumId),
        reference: Value(agreement.reference),
        value: Value(installment.value),
        dueDate: Value(installment.dueDate),
        status: Value(installment.status),
      );
      agreementsInstallmentsDao.insert(agreementInstallmentDataModel);
    }
  }

  void _saveQuote(AgreementModel agreement, AgreementQuoteModel quote,
      String condominiumId) {
    if (quote.id != null) {
      final agreementQuoteDataModel = AgreementsQuoteTableCompanion(
        id: Value(quote.id!),
        agreementId: Value(agreement.id),
        condominiumId: Value(condominiumId),
        reference: Value(agreement.reference),
        dueDate: Value(quote.dueDate),
        originValue: Value(quote.originValue),
        fineValue: Value(quote.fineValue),
        feeValue: Value(quote.feeValue),
        honoraryValue: Value(quote.honoraryValue),
        overdueMessage: Value(quote.overdueMessage),
      );
      agreementsQuoteDao.insert(agreementQuoteDataModel);
    }
  }

  void _saveAgreementRules(AgreementsRulesModel rule, String condominiumId) {
    agreementsRulesDaysDao.deleteAgreementsRulesDays(condominiumId);
    rule.days.forEach((day) {
      final agreementsRulesDaysDataModel = AgreementsRulesDaysTableCompanion(
        condominiumId: Value(condominiumId),
        days: Value(day),
      );
      agreementsRulesDaysDao.insert(agreementsRulesDaysDataModel);
    });
    final agreementsRulesInstallmentsDataModel =
        AgreementsRulesInstallmentsTableCompanion(
      condominiumId: Value(condominiumId),
      installmentQtd: Value(rule.installmentQtd),
    );
    agreementsRulesInstallmentsDao.insert(agreementsRulesInstallmentsDataModel);
  }

  Future<AgreementsRulesModel?> _getRules(String condominiumId) async {
    int? installmentQtd = await _getRuleInstallments(condominiumId);
    List<int>? days = await _getRuleDays(condominiumId);

    if (installmentQtd != null && days != null) {
      return AgreementsRulesModel(days: days, installmentQtd: installmentQtd);
    }

    return null;
  }

  Future<int?> _getRuleInstallments(String condominiumId) async {
    final AgreementsRulesInstallmentsData? agreementsRulesInstallmentsDataList =
        await agreementsRulesInstallmentsDao
            .getAgreementsRulesInstallments(condominiumId);
    if (agreementsRulesInstallmentsDataList == null) {
      return null;
    }
    final int installmentsQtd =
        agreementsRulesInstallmentsDataList.installmentQtd;

    return installmentsQtd;
  }

  Future<List<int>?> _getRuleDays(String condominiumId) async {
    final List<AgreementsRulesDaysData>? agreementsRulesDaysDataList =
        await agreementsRulesDaysDao.getAgreementsRulesDays(condominiumId);
    if (agreementsRulesDaysDataList == null) {
      return null;
    }
    final List<int> days =
        agreementsRulesDaysDataList.map((e) => e.days).toList();

    return days;
  }

  Future<List<AgreementModel>?> _getAgreements(String condominiumId) async {
    final List<AgreementsData>? agreementsData =
        await agreementsDao.getAgreements(condominiumId);
    if (agreementsData == null) {
      return null;
    }
    return await _getQuotesAndInstallments(agreementsData);
  }

  Future<List<AgreementModel>?> _getQuotesAndInstallments(
      List<AgreementsData> agreementsData) async {
    List<AgreementModel> agreements = [];
    final agreementsFutureList =
        agreementsData.map((agreementData) async {
      List<AgreementQuoteModel>? quotes =
          await _getAgreementQuotes(agreementData.id);
      List<AgreementInstallmentModel>? installments =
          await _getAgreementInstallments(agreementData.id);
      if (quotes != null && installments != null) {
        return AgreementModel(
          id: agreementData.id,
          reference: agreementData.reference,
          unit: agreementData.unit,
          unitOwner: agreementData.unitOwner,
          baseValue: agreementData.baseValue,
          fineAndCosts: agreementData.fineAndCosts,
          installmentQuantity: agreementData.installmentQuantity,
          paymentMethod: agreementData.paymentMethod,
          status: agreementData.status,
          statusMessage: agreementData.statusMessage,
          expiration: agreementData.expiration,
          proposaldedDate: agreementData.proposaldedDate,
          approvalDate: agreementData.approvalDate,
          dueDate: agreementData.dueDate,
          lastInstallmentDate: agreementData.lastInstallmentDate,
          installments: installments,
          quotes: quotes,
        );
      }
    }).toList();
    final agreementsList = await Future.wait(agreementsFutureList);
    agreementsList.forEach((element) {
      if (element != null) {
        agreements.add(element);
      }
    });
    return agreements.isEmpty ? null : agreements;
  }

  Future<List<AgreementQuoteModel>?> _getAgreementQuotes(
      String agreementId) async {
    final List<AgreementsQuoteData>? agreementsQuoteDataList =
        await agreementsQuoteDao.getAgreementsQuote(agreementId);
    if (agreementsQuoteDataList == null) {
      return null;
    }
    final List<AgreementQuoteModel> quotes = agreementsQuoteDataList
        .map((quoteData) => AgreementQuoteModel(
              id: quoteData.id,
              dueDate: quoteData.dueDate,
              originValue: quoteData.originValue,
              fineValue: quoteData.fineValue,
              feeValue: quoteData.feeValue,
              honoraryValue: quoteData.honoraryValue,
              overdueMessage: quoteData.overdueMessage,
            ))
        .toList();

    return quotes;
  }

  Future<List<AgreementInstallmentModel>?> _getAgreementInstallments(
      String agreementId) async {
    final List<AgreementsInstallmentsData>? agreementsInstallmentDataList =
        await agreementsInstallmentsDao.getAgreementsInstallments(agreementId);
    if (agreementsInstallmentDataList == null) {
      return null;
    }
    final List<AgreementInstallmentModel> installments =
        agreementsInstallmentDataList
            .map((installmentData) => AgreementInstallmentModel(
                  installmentId: installmentData.installmentId,
                  value: installmentData.value,
                  dueDate: installmentData.dueDate,
                  status: installmentData.status,
                ))
            .toList();

    return installments;
  }
}
