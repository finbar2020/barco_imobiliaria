import 'package:essentials/functional/failure.dart';
import 'package:morar/feature/easy_fix/cnd/domain/entity/unit_profile_entity.dart';
import 'package:morar/feature/easy_fix/cnd/domain/use_case/cnd_pdf_use_case.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/bloc/cnd_bloc.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/bloc/cnd_event.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';
import 'package:morar/feature/easy_fix/domain/use_case/get_easy_fix_unit_usecase.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class CertificateNoOutstandingDebtController {
  final SessionBloc sessionBloc;
  final CertificateNoOutstandingDebtBloc bloc;
  final CndPdfUseCase cndPdfUseCase;
  final GetEasyFixUnitUsecase getEasyFixUnitUsecase;

  CertificateNoOutstandingDebtController(
      {required this.sessionBloc,
      required this.bloc,
      required this.cndPdfUseCase,
      required this.getEasyFixUnitUsecase});

  EasyFixUnit? unit;
  String email = "";
  String mobilePhone = "";
  String phone = "";

  Future<void> getEasyFixUnit() async {
    bloc.add(UnitProfileLoadingEvent());
    final result = await getEasyFixUnitUsecase(
      GetEasyFixUnitParam(
          condominiumId: sessionBloc.state.session!.condominium!.id ?? ""),
    );
    result.fold(
      (failure) {
        bloc.add(UnitProfileFailureEvent(failure: failure));
      },
      (unit) async {
        this.unit = unit;
        setTextFields(unit);
        if (email.isEmpty || mobilePhone.isEmpty || phone.isEmpty) {
          // Cadastro incompleto: mostra o formulário para completar os dados
          // antes de gerar a certidão.
          bloc.add(UnitProfileLoadedEvent(unit: unit));
          return;
        }
        generateCertificateNoOutstandingDebt(
            unitProfile: requestCertificateNoOutstandingDebt);
      },
    );
  }

  Future<void>? generateCertificateNoOutstandingDebt(
      {required UnitProfileEntity unitProfile}) async {
    bloc.add(CertificateNoOutstandingDebtLoadingEvent());

    final response = await cndPdfUseCase(
      CndPdfParams(
        unitProfileEntity: unitProfile,
        condominiumId: sessionBloc.state.session!.condominium!.id ?? "",
      ),
    );
    response.fold((failure) {
      if (failure is KnownFailure && failure.code != null) {
        return bloc.add(
          HasOutstandingDebtEvent(),
        );
      } else {
        bloc.add(
          CertificateNoOutstandingDebtFailureEvent(failure: failure),
        );
      }
    }, (res) {
      return bloc.add(
        CertificateNoOutstandingDebtSucessEvent(pdf: res.data!),
      );
    });
  }

  UnitProfileEntity get requestCertificateNoOutstandingDebt {
    return UnitProfileEntity(
      email: email,
      mobilePhone: mobilePhone.replaceAll(RegExp('[^0-9]'), ''),
      phone: phone.replaceAll(RegExp('[^0-9]'), ''),
    );
  }

  void setTextFields(EasyFixUnit unit) {
    email = unit.email;
    mobilePhone = unit.cellphone;
    phone = unit.phone;
  }

  String? landlineFormatted(String phone) {
    if (phone.isNotEmpty) {
      final ddd = phone.substring(0, 2);
      final first = phone.substring(2, 6);
      final second = phone.substring(6);
      return "($ddd) $first-$second";
    }
    return null;
  }

  String? mobilePhoneFormatted(String phone) {
    if (phone.isNotEmpty) {
      final ddd = phone.substring(0, 2);
      final first = phone.substring(2, 7);
      final second = phone.substring(7);
      return "($ddd) $first-$second";
    }
    return null;
  }
}
