import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/paginator/meta.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_completed_request_paginated.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request_param.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_filter_requests_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_menu_items.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_details.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_favorite.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_intro.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_review.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_message_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_status.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_requests_filter.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_review_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_subcategories.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_type.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_utils.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_your_condo_remote_config.dart';
import 'package:shared_features/feature/comfort/domain/entity/request_partners_entity.dart';

import '../../../helpers/pump_app.dart';
import '../comfort_core_fixtures.dart';

/// Monta um widget vazio e devolve um `BuildContext` com `AppLocalization`
/// de teste (que devolve a própria chave).
Future<BuildContext> contextWithLoc(WidgetTester tester) async {
  late BuildContext ctx;
  await pumpApp(tester, Builder(builder: (c) {
    ctx = c;
    return const SizedBox();
  }));
  return ctx;
}

void main() {
  group('ComfortCompletedRequest', () {
    test('formata a data da solicitação em dd/MM/yyyy', () {
      final request = buildCompletedRequest(dateRequest: DateTime(2026, 2, 3));
      expect(request.getRequestDateFormatted, '03/02/2026');
      expect(request.isExpanded, isFalse);
    });

    test('statusText e statusColor cobrem todos os status', () {
      final expectedText = {
        ComfortRequestStatus.sended: 'comfort_request_status_sended',
        ComfortRequestStatus.achived: 'comfort_request_status_achived',
        ComfortRequestStatus.canceled: 'comfort_request_status_canceled',
        ComfortRequestStatus.resent: 'comfort_request_status_resent',
      };
      final expectedColor = {
        ComfortRequestStatus.sended: Colors.green,
        ComfortRequestStatus.achived: Colors.grey,
        ComfortRequestStatus.canceled: Colors.red,
        ComfortRequestStatus.resent: Colors.orange,
      };
      for (final status in ComfortRequestStatus.values) {
        final request = buildCompletedRequest(status: status);
        expect(request.statusText, expectedText[status]);
        expect(request.statusColor(ThemeData()), expectedColor[status]);
      }
    });

    testWidgets('getMessageTypeString traduz cada assunto (nulo vira dúvida)',
        (tester) async {
      final ctx = await contextWithLoc(tester);
      final expected = {
        ComfortRequestMessageType.doubt: 'comfort_message_subject_doubt',
        ComfortRequestMessageType.did_not_receive_return:
            'comfort_message_subject_did_not_receive_return',
        ComfortRequestMessageType.other: 'comfort_message_subject_other',
        ComfortRequestMessageType.complaint: 'comfort_message_subject_complaint',
        ComfortRequestMessageType.suggestion:
            'comfort_message_subject_suggestion',
      };
      for (final type in ComfortRequestMessageType.values) {
        expect(ComfortCompletedRequest.getMessageTypeString(ctx, type),
            expected[type]);
      }
      expect(ComfortCompletedRequest.getMessageTypeString(ctx, null),
          'comfort_message_subject_doubt');
    });
  });

  group('ComfortCompletedRequestPaginated', () {
    test('guarda meta e dados', () {
      final paginated = ComfortCompletedRequestPaginated(
        meta: Meta(totalItems: 1),
        data: [buildCompletedRequest()],
      );
      expect(paginated.meta.totalItems, 1);
      expect(paginated.data.single.idRequest, 'r1');
    });
  });

  group('ComfortCouponRequest', () {
    ComfortCouponRequest build(String link, List<ComfortCouponRequestParam?> params) =>
        ComfortCouponRequest(
          idRequest: 'req',
          params: params,
          linkRedirectPartner: link,
          redirectExternal: true,
          cta: ComfortCTA.link,
        );

    final params = <ComfortCouponRequestParam?>[
      ComfortCouponRequestParam(type: 'QUERY', nameParam: 'token', param: 'abc'),
      ComfortCouponRequestParam(type: 'QUERY', nameParam: 'user', param: 'u1'),
      ComfortCouponRequestParam(type: 'HEADER', nameParam: 'x-api', param: 'k'),
      ComfortCouponRequestParam(
          type: 'OTHER', nameParam: 'url-callback', param: 'https://cb'),
      null,
    ];

    test('urlAndQueries monta a URI com esquema, host, caminho e queries', () {
      final uri = build('https://parceiro.com/oferta/1', params).urlAndQueries!;
      expect(uri.scheme, 'https');
      expect(uri.host, 'parceiro.com');
      expect(uri.path, '/oferta/1');
      expect(uri.queryParameters, {'token': 'abc', 'user': 'u1'});
    });

    test('urlAndQueries assume https quando não há esquema e aceita só host',
        () {
      final semEsquema = build('parceiro.com/x', params).urlAndQueries!;
      expect(semEsquema.scheme, 'https');
      expect(semEsquema.host, 'parceiro.com');
      expect(semEsquema.path, '/x');

      final soHost = build('http://parceiro.com', []).urlAndQueries!;
      expect(soHost.scheme, 'http');
      expect(soHost.host, 'parceiro.com');
      expect(soHost.path, '');
      expect(soHost.queryParameters, isEmpty);
    });

    test('urlAndQueries é nulo sem link', () {
      expect(build('', params).urlAndQueries, isNull);
    });

    test('headers só considera parâmetros HEADER', () {
      expect(build('https://p.com', params).headers, {'x-api': 'k'});
      expect(build('https://p.com', []).headers, isEmpty);
    });

    test('callBack devolve o parâmetro url-callback', () {
      expect(build('https://p.com', params).callBack, 'https://cb');
      expect(build('https://p.com', []).callBack, isNull);
    });
  });

  group('ComfortFilterRequestStatusExtension', () {
    testWidgets('converte texto <-> enum usando as traduções', (tester) async {
      final ctx = await contextWithLoc(tester);
      expect(ComfortFilterRequestStatusExtension.stringToEnumStatus(ctx, 'comfort_request_filter_status_all'),
          ComfortFilterRequestStatus.all);
      expect(ComfortFilterRequestStatusExtension.stringToEnumStatus(ctx, 'comfort_request_filter_status_sent'),
          ComfortFilterRequestStatus.sended);
      expect(
          ComfortFilterRequestStatusExtension.stringToEnumStatus(ctx, 'comfort_request_filter_status_resent'),
          ComfortFilterRequestStatus.resent);
      expect(ComfortFilterRequestStatusExtension.stringToEnumStatus(ctx, 'qualquer outra'),
          ComfortFilterRequestStatus.canceled);
      expect(ComfortFilterRequestStatusExtension.stringToEnumStatus(ctx, null),
          ComfortFilterRequestStatus.canceled);

      expect(ComfortFilterRequestStatusExtension.enumToStringStatus(ctx, ComfortFilterRequestStatus.all),
          'comfort_request_filter_status_all');
      expect(ComfortFilterRequestStatusExtension.enumToStringStatus(ctx, ComfortFilterRequestStatus.sended),
          'comfort_request_filter_status_sent');
      expect(ComfortFilterRequestStatusExtension.enumToStringStatus(ctx, ComfortFilterRequestStatus.resent),
          'comfort_request_filter_status_resent');
      expect(ComfortFilterRequestStatusExtension.enumToStringStatus(ctx, ComfortFilterRequestStatus.canceled),
          'comfort_request_filter_status_canceled');
      expect(ComfortFilterRequestStatusExtension.enumToStringStatus(ctx, null), isNull);
    });
  });

  group('ComfortMenuItems', () {
    test('título e ícone por categoria', () {
      final expected = {
        ComfortPartnerCategory.toYou: ('comfort_to_you', 'assets/ic_comfort_to_you.svg'),
        ComfortPartnerCategory.toYourHome:
            ('comfort_to_your_home', 'assets/ic_comfort_to_your_home.svg'),
        ComfortPartnerCategory.toYourPet:
            ('comfort_to_your_pet', 'assets/ic_comfort_to_your_pet.svg'),
        ComfortPartnerCategory.toYourVehicle:
            ('comfort_to_your_vehicle', 'assets/ic_comfort_to_your_vehicle.svg'),
        ComfortPartnerCategory.toYourCondo:
            ('comfort_to_your_condo', 'assets/ic_comfort_to_your_condo.svg'),
        ComfortPartnerCategory.toYourFamily:
            ('comfort_to_your_family', 'assets/ic_comfort_to_your_family.svg'),
        ComfortPartnerCategory.others: ('comfort_others', 'assets/ic_comfort_others.svg'),
      };
      for (final category in ComfortPartnerCategory.values) {
        final item = ComfortMenuItems(category: category, order: 1);
        expect(item.title, expected[category]!.$1);
        expect(item.svgPath, expected[category]!.$2);
        expect(item.order, 1);
      }
    });
  });

  group('ComfortPartner', () {
    test('ratingFormatted usa uma casa decimal', () {
      expect(buildPartner().ratingFormatted, '4.3');
    });

    test('siteFormatted remove o que vem antes de www', () {
      expect(buildPartner(site: 'https://www.lello.com.br').siteFormatted,
          'www.lello.com.br');
      expect(buildPartner(site: 'lello.com.br').siteFormatted, 'lello.com.br');
    });

    test('emailUrl monta o mailto', () {
      expect(buildPartner().emailUrl, 'mailto:contato@p1.com');
    });

    testWidgets('getPartnerSubtitle junta tipo e desconto', (tester) async {
      final ctx = await contextWithLoc(tester);
      expect(buildPartner(biggestDiscount: 30).getPartnerSubtitle(ctx),
          'comfort_cleaning\ncomfort_discount_of_up'.replaceAll('###', '30'));
      expect(buildPartner(biggestDiscount: 0).getPartnerSubtitle(ctx),
          'comfort_cleaning');
    });
  });

  group('ComfortPartnerCoupon', () {
    testWidgets('getComfortType conhece limpeza, manutenção e lavanderia',
        (tester) async {
      final ctx = await contextWithLoc(tester);
      expect(buildCoupon(comfortType: ComfortType.cleaning).getComfortType(ctx),
          'comfort_cleaning');
      expect(
          buildCoupon(comfortType: ComfortType.maintenance).getComfortType(ctx),
          'comfort_maintenance');
      expect(buildCoupon(comfortType: ComfortType.laundry).getComfortType(ctx),
          'comfort_laundry');
      expect(buildCoupon(comfortType: ComfortType.gym).getComfortType(ctx),
          'comfort_others');
      expect(buildCoupon().getComfortType(ctx), 'comfort_others');
    });

    test('campos opcionais começam nulos', () {
      final coupon = buildCoupon();
      expect(coupon.imageLink, isNull);
      expect(coupon.partnerId, isNull);
      coupon.imageLink = '/img';
      expect(coupon.imageLink, '/img');
    });
  });

  group('ComfortPartnerIntro.getComfortType', () {
    /// Defeito: `ComfortPartnerIntro.getComfortType` não trata playroom,
    /// solar_panels, automation, pharmacy, wellness, decoration, biometrics,
    /// energy e connectivity (existem em `ComfortType` e em
    /// `ComfortSubcategories.enumToStringSubcategories`), então esses
    /// parceiros aparecem como "Outros". Comportamento atual documentado.
    const semTraducao = {
      ComfortType.playroom,
      ComfortType.solar_panels,
      ComfortType.automation,
      ComfortType.pharmacy,
      ComfortType.wellness,
      ComfortType.decoration,
      ComfortType.biometrics,
      ComfortType.energy,
      ComfortType.connectivity,
      ComfortType.others,
    };

    testWidgets('traduz cada tipo (os não mapeados caem em outros)',
        (tester) async {
      final ctx = await contextWithLoc(tester);
      for (final type in ComfortType.values) {
        final intro = ComfortPartnerIntro(
          id: '1',
          title: 't',
          comfortType: type,
          partnerDetails: null,
          favorite: false,
        );
        final text = intro.getComfortType(ctx);
        if (semTraducao.contains(type)) {
          expect(text, 'comfort_others', reason: type.name);
        } else if (type == ComfortType.all) {
          expect(text, 'comfort_request_filter_subcategories_all');
        } else {
          // A mesma tradução usada pelas subcategorias.
          expect(text, ComfortSubcategories.enumToStringSubcategories(ctx, type),
              reason: type.name);
          expect(text, isNot('comfort_others'), reason: type.name);
        }
      }
    });
  });

  group('ComfortPartnerReview', () {
    test('reviewTitle combina nome e data', () {
      expect(
          ComfortPartnerReview(
                  name: 'Ana', review: 5, reviewDate: DateTime(2026, 1, 20))
              .reviewTitle,
          'Ana - 20/01/2026');
      expect(ComfortPartnerReview(name: 'Ana', review: 5).reviewTitle, 'Ana');
      expect(
          ComfortPartnerReview(review: 5, reviewDate: DateTime(2026, 1, 20))
              .reviewTitle,
          '20/01/2026');
      expect(ComfortPartnerReview(name: '', review: 5).reviewTitle, '');
      expect(ComfortPartnerReview(review: 5).formattedDate, '');
    });
  });

  group('ComfortRequestPurchase', () {
    test('formattedPurchaseDate', () {
      final base = ComfortRequestPurchase(
          requestId: 'r', userId: 'u', unitId: 'un', purchaseDone: true);
      expect(base.formattedPurchaseDate, '');
      expect(base.canCancel, isFalse);
      expect(base.canResend, isFalse);
      base.purchaseDate = DateTime(2026, 3, 9);
      expect(base.formattedPurchaseDate, '09/03/2026');
    });
  });

  group('ComfortRequestsFilter', () {
    test('isEqualTo compara todos os campos', () {
      final a = ComfortRequestsFilter(
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 31),
          status: ComfortFilterRequestStatus.sended,
          subcategories: ComfortType.cleaning);
      final b = ComfortRequestsFilter(
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 1, 31),
          status: ComfortFilterRequestStatus.sended,
          subcategories: ComfortType.cleaning);
      expect(a.isEqualTo(b), isTrue);
      expect(a.isEqualTo(ComfortRequestsFilter()), isFalse);
      b.subcategories = ComfortType.gym;
      expect(a.isEqualTo(b), isFalse);
      b.subcategories = ComfortType.cleaning;
      b.status = ComfortFilterRequestStatus.all;
      expect(a.isEqualTo(b), isFalse);
      b.status = ComfortFilterRequestStatus.sended;
      b.endDate = DateTime(2026, 2, 1);
      expect(a.isEqualTo(b), isFalse);
    });
  });

  group('ComfortSubcategories', () {
    testWidgets('enumToString e stringToEnum são inversos para todos os tipos',
        (tester) async {
      final ctx = await contextWithLoc(tester);
      final textos = <String>{};
      for (final type in ComfortType.values) {
        final text = ComfortSubcategories.enumToStringSubcategories(ctx, type);
        expect(text, startsWith('comfort_'), reason: type.name);
        textos.add(text);
        expect(ComfortSubcategories.stringToEnumSubcategories(ctx, text), type,
            reason: type.name);
      }
      // Cada tipo tem uma tradução distinta.
      expect(textos.length, ComfortType.values.length);
      expect(ComfortSubcategories.enumToStringSubcategories(ctx, null),
          'comfort_others');
      expect(ComfortSubcategories.stringToEnumSubcategories(ctx, 'xpto'),
          ComfortType.others);
      expect(ComfortSubcategories.stringToEnumSubcategories(ctx, null),
          ComfortType.others);
      expect(ComfortSubcategories(comfortType: ComfortType.gym).comfortType,
          ComfortType.gym);
    });
  });

  group('ComfortUtils.getCondoIdByProject', () {
    test('usa condominium para morador/colaborador e selectedCondominium para síndico',
        () {
      final session = FakeSessionBloc(
        session: FakeSession(
          condominium: FakeCondo(id: 'COND'),
          selectedCondominium: FakeCondo(id: 'SEL'),
        ),
      );
      expect(ComfortUtils.getCondoIdByProject(AppOriginEnum.owner, session),
          'COND');
      expect(ComfortUtils.getCondoIdByProject(AppOriginEnum.employee, session),
          'COND');
      expect(ComfortUtils.getCondoIdByProject(AppOriginEnum.manager, session),
          'SEL');
    });

    test('sem sessão devolve vazio', () {
      final session = FakeSessionBloc(session: FakeSession());
      expect(ComfortUtils.getCondoIdByProject(AppOriginEnum.owner, session), '');
      expect(
          ComfortUtils.getCondoIdByProject(AppOriginEnum.manager, session), '');
    });
  });

  group('ComfortYourCondoRemoteConfig', () {
    test('fromRemote lê os campos', () {
      final cat = buildRemoteCategory(type: 'laundry', title: 'Lavanderia');
      expect(cat.type, 'laundry');
      expect(cat.iconType, 'asset');
      expect(cat.iconPath, 'ic_laundry.svg');
      expect(cat.title, 'Lavanderia');
      expect(cat.body, contains('Lavanderia'));
    });

    testWidgets('ícones: asset vira SvgPicture, senão Icon', (tester) async {
      final asset = buildRemoteCategory();
      final icon = buildRemoteCategory(iconType: 'icon');
      expect(asset.getIcon, isA<SvgPicture>());
      expect(asset.getIconWithColor(Colors.red), isA<SvgPicture>());
      expect(icon.getIcon, isA<Icon>());
      final colored = icon.getIconWithColor(Colors.red) as Icon;
      expect(colored.color, Colors.red);
      expect(colored.icon, Icons.info_outline);

      await pumpApp(
          tester,
          Row(children: [
            asset.getIcon,
            asset.getIconWithColor(Colors.blue),
            icon.getIcon,
            icon.getIconWithColor(Colors.blue),
          ]));
      expect(find.byType(SvgPicture), findsNWidgets(2));
      expect(find.byType(Icon), findsNWidgets(2));
    });
  });

  group('entidades simples', () {
    test('construtores guardam os valores', () {
      final details = ComfortPartnerDetails(id: '1', companyName: 'E', cnpj: 'c');
      expect(details.companyName, 'E');
      final fav = ComfortPartnerFavorite(comfortOwnerId: 'o', isFavorite: true);
      expect(fav.isFavorite, isTrue);
      final review = ComfortReviewRequest(requestId: 'r', rating: 4, comment: null);
      expect(review.rating, 4);
      final req = RequestPartnersEntity(
          email: 'e', whatsapp: 'w', phone: 'p', partners: ['a']);
      expect(req.partners, ['a']);
      final param = ComfortCouponRequestParam(type: 't', nameParam: 'n', param: 'p');
      expect(param.nameParam, 'n');
      expect(ComfortCTA.values, hasLength(3));
      expect(ComfortRequestStatus.values, hasLength(4));
      expect(ComfortRequestMessageType.values, hasLength(5));
    });
  });
}
