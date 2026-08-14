import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_rule.dart';

import 'agreements_quotas.dart';

class AgreementAllInfo {
  final List<AgreementQuota> quotes;
  final List<Agreement> agreements;
  final AgreementRule rule;

  AgreementAllInfo({
    required this.quotes,
    required this.agreements,
    required this.rule,
  });
}
