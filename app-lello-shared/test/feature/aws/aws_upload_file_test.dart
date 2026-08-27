import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

void main() {
  final file = File('foto.png');
  final s3 = UrlUploadS3(fileName: 'foto.png', url: 'https://s3/foto.png');

  AwsUploadFileParam params({
    Try<UrlUploadS3>? urlResult,
    Try<String>? uploadResult,
    List<String>? uploadedUrls,
  }) =>
      AwsUploadFileParam(
        file: file,
        getUrlUploadS3: () async => urlResult ?? Success(s3),
        uploadFileToS3: (f, url) async {
          uploadedUrls?.add(url);
          return uploadResult ?? Success('ok');
        },
      );

  test('UrlUploadS3 guarda nome e URL', () {
    expect(s3.fileName, 'foto.png');
    expect(s3.url, 'https://s3/foto.png');
  });

  test('pede a URL assinada, envia o arquivo e devolve a URL', () async {
    final uploaded = <String>[];

    final result = await AwsUploadFileUsecaseImpl()
        .call(params(uploadedUrls: uploaded));

    expect(result.fold((_) => null, (r) => r), same(s3));
    expect(uploaded, ['https://s3/foto.png']);
  });

  test('falha ao obter a URL é propagada sem enviar', () async {
    final uploaded = <String>[];
    final failure = UnknownFailure('sem url');

    final result = await AwsUploadFileUsecaseImpl().call(
        params(urlResult: Rejection(failure), uploadedUrls: uploaded));

    expect((result as Rejection).get(), same(failure));
    expect(uploaded, isEmpty);
  });

  test('falha no envio vira KnownFailure de upload', () async {
    final result = await AwsUploadFileUsecaseImpl()
        .call(params(uploadResult: Rejection(UnknownFailure('rede'))));

    final failure = (result as Rejection).get() as KnownFailure;
    expect(failure.code, '500');
    expect(failure.error, 'upload_error');
  });

  test('validate rejeita parâmetros nulos', () {
    final useCase = AwsUploadFileUsecaseImpl();
    expect(useCase.validate(null), isA<InvalidParamFailure>());
    expect(useCase.validate(params()), isNull);
  });

  test('uploadImageToAws delega à função de envio', () async {
    final uploaded = <String>[];
    final result = await AwsUploadFileUsecaseImpl()
        .uploadImageToAws(params(uploadedUrls: uploaded), s3);
    expect(result, isA<Success<String>>());
    expect(uploaded, ['https://s3/foto.png']);
  });
}
