import 'package:essentials/configs/custom_firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('chaves do remote config têm os nomes esperados', () {
    expect(CustomFirebaseRemoteConfig.useTerms, 'link_termos_de_uso_pdf');
    expect(CustomFirebaseRemoteConfig.whatsapp, 'link_whatsapp');
    expect(CustomFirebaseRemoteConfig.resolvaFacil, 'link_resolva_facil');
    expect(CustomFirebaseRemoteConfig.resolvaFacilWhatsApp,
        'link_resolva_facil_whatsapp');
    expect(CustomFirebaseRemoteConfig.appStoreLink, 'link_app_store');
    expect(CustomFirebaseRemoteConfig.customRbac, 'rbac_custom_features');
    expect(CustomFirebaseRemoteConfig.forceUpdate, 'force_update');
    expect(CustomFirebaseRemoteConfig.reviewAppInterval,
        'interval_days_check_review_app');
    expect(CustomFirebaseRemoteConfig.fileMaxSizePermitted,
        'file_max_size_permitted');
    expect(CustomFirebaseRemoteConfig.comfortDialogShowInterval,
        'comfort_dialog_show_interval');
    expect(CustomFirebaseRemoteConfig.comfortPartnersRandomic,
        'comfort_partners_randomic');
    expect(CustomFirebaseRemoteConfig.comfortPartnerCategoryFilter,
        'comfort_partner_category_filter');
    expect(CustomFirebaseRemoteConfig.mailRemoveAccount, 'mail_remove_account');
    expect(CustomFirebaseRemoteConfig.pontoDigital,
        'link_conheca_ponto_digital');
    expect(CustomFirebaseRemoteConfig.storeVersion, 'store_version');
    expect(CustomFirebaseRemoteConfig.indiqueGanhe, 'link_indique_ganhe');
    expect(CustomFirebaseRemoteConfig.condoLivre, 'link_condolivre');
    expect(CustomFirebaseRemoteConfig.cursos, 'link_cursos');
    expect(CustomFirebaseRemoteConfig.coordinatesRangeConfig,
        'coordinates_range_config');
    expect(CustomFirebaseRemoteConfig.mostAccessedCards, 'most_accessed_cards');
    expect(CustomFirebaseRemoteConfig.rolloutRegistration,
        'rolout_registration');
    expect(CustomFirebaseRemoteConfig.rentSellLink, 'rent_sell_link');
    expect(CustomFirebaseRemoteConfig.newHome, 'new_home');
    expect(CustomFirebaseRemoteConfig.mostAcessedManager,
        'most_accessed_cards');
    expect(CustomFirebaseRemoteConfig.circuitBreaker, 'circuit_breaker_json');
    expect(CustomFirebaseRemoteConfig.horta, 'horta');
    expect(CustomFirebaseRemoteConfig.comfortYourCondo,
        'comfort_your_condo_new');
    expect(CustomFirebaseRemoteConfig.agreementsDialogShowInterval,
        'agreements_dialog_show_interval');
    expect(CustomFirebaseRemoteConfig.showAccessProfileJanitorWithGDP,
        'show_access_profile_janitor_with_gdp');
    expect(CustomFirebaseRemoteConfig.insuranceTable,
        'insurance_casa_protegida_with_title');
    expect(CustomFirebaseRemoteConfig.insuranceTermsUrl,
        'insurance_terms_url');
    expect(CustomFirebaseRemoteConfig.insuranceTermsUrlCompleto,
        'insurance_terms_url_completo');
    expect(CustomFirebaseRemoteConfig.notificationsPermsDaysDelay,
        'notifications_perms_days_delay');
    expect(CustomFirebaseRemoteConfig.homePersonalizationActive,
        'home_personalization_active');
    expect(CustomFirebaseRemoteConfig.splashIgnoreBiometric,
        'splash_ignore_biometric');
    expect(CustomFirebaseRemoteConfig.lifeValidationConfig,
        'life_validation_config');
  });

  /// Documentado (não é defeito): `mostAcessedManager` é um alias legado de
  /// `mostAccessedCards`; nenhum app usa o alias e o síndico lê
  /// `mostAccessedCards` com a chave "most_accessed_cards". Mantido igual por
  /// compatibilidade.
  test('mostAcessedManager é alias de mostAccessedCards', () {
    expect(CustomFirebaseRemoteConfig.mostAccessedCards, 'most_accessed_cards');
    expect(CustomFirebaseRemoteConfig.mostAcessedManager,
        CustomFirebaseRemoteConfig.mostAccessedCards);
  });

  test('chaves usadas pela checagem de atualização', () {
    expect(CustomFirebaseRemoteConfig.storeVersion, 'store_version');
    expect(CustomFirebaseRemoteConfig.forceUpdate, 'force_update');
  });
}
