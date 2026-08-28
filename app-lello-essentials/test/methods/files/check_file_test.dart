import 'dart:io';

import 'package:essentials/methods/files/check_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../helpers/firebase_mocks.dart';
import '../../modal/pdf_test_support.dart';

void main() {
  late FakeRemoteConfigPlatform remoteConfig;
  late FakePdfrxEntryFunctions pdfrx;
  late Directory dir;

  File arquivo(String nome, int tamanho) =>
      File('${dir.path}/$nome')..writeAsBytesSync(List.filled(tamanho, 1));

  setUpAll(() async {
    remoteConfig = await setUpFakeFirebase(
        remoteConfigValues: {'file_max_size_permitted': '100'});
  });

  setUp(() {
    remoteConfig.values = {'file_max_size_permitted': '100'};
    pdfrx = instalaPdfrxFalso();
    dir = criaTemp('check_file');
  });

  group('isFileExceedMaxSizePermitted', () {
    test('limite explícito', () {
      final f = arquivo('a.png', 50);
      expect(
          CheckFile.isFileExceedMaxSizePermitted(
              file: f, optionalFileSizeValuePermitted: 40),
          isTrue);
      expect(
          CheckFile.isFileExceedMaxSizePermitted(
              file: f, optionalFileSizeValuePermitted: 50),
          isFalse);
    });

    test('limite do remote config', () {
      expect(CheckFile.isFileExceedMaxSizePermitted(file: arquivo('g.png', 150)),
          isTrue);
      expect(CheckFile.isFileExceedMaxSizePermitted(file: arquivo('p.png', 100)),
          isFalse);
    });

    test('remote config vazio ou nulo usa 10 MB', () {
      remoteConfig.values = {};
      expect(CheckFile.isFileExceedMaxSizePermitted(file: arquivo('g.png', 150)),
          isFalse);
      remoteConfig.values = {'file_max_size_permitted': 'null'};
      expect(CheckFile.isFileExceedMaxSizePermitted(file: arquivo('h.png', 150)),
          isFalse);
    });
  });

  group('isFileEncrypted', () {
    test('arquivo que não é PDF nunca é protegido', () async {
      expect(await CheckFile.isFileEncrypted(file: arquivo('a.png', 1)), isFalse);
      expect(pdfrx.abertos, isEmpty);
    });

    test('PDF que abre não é protegido', () async {
      pdfrx.erro = null;
      final f = arquivo('a.pdf', 1);
      expect(await CheckFile.isFileEncrypted(file: f), isFalse);
      expect(pdfrx.abertos, [f.path]);
    });

    test('PDF com senha (ArgumentError) é protegido', () async {
      pdfrx.erro = ArgumentError('senha');
      expect(await CheckFile.isFileEncrypted(file: arquivo('a.pdf', 1)), isTrue);
    });

    test('PDF com senha (PdfPasswordException do pdfrx) é protegido', () async {
      pdfrx.erro = const PdfPasswordException('senha');
      expect(await CheckFile.isFileEncrypted(file: arquivo('a.pdf', 1)), isTrue);
    });

    /// Corrigido: só erro de senha conta como "protegido"; outros erros ao
    /// abrir (corrompido, sem lib nativa) devolvem `false`.
    test('outros erros não são tratados como protegido', () async {
      pdfrx.erro = StateError('corrompido');
      expect(await CheckFile.isFileEncrypted(file: arquivo('a.pdf', 1)), isFalse);
      pdfrx.erro = const PdfException('corrompido');
      expect(await CheckFile.isFileEncrypted(file: arquivo('a.pdf', 1)), isFalse);
    });
  });

  group('isFileDifferentFromSupportedFormats', () {
    test('aceita pdf, jpeg, jpg e png sem diferenciar maiúsculas', () async {
      for (final nome in ['a.pdf', 'a.JPEG', 'a.jpg', 'a.PNG']) {
        expect(
            await CheckFile.isFileDifferentFromSupportedFormats(
                file: File('${dir.path}/$nome')),
            isFalse,
            reason: nome);
      }
    });

    test('rejeita outras extensões ou sem extensão', () async {
      expect(
          await CheckFile.isFileDifferentFromSupportedFormats(
              file: File('${dir.path}/a.txt')),
          isTrue);
      expect(
          await CheckFile.isFileDifferentFromSupportedFormats(
              file: File('semextensao')),
          isTrue);
    });
  });

  group('checkAll', () {
    test('tamanho acima do limite', () async {
      expect(await CheckFile.checkAll(file: arquivo('a.png', 150)), FileError.size);
      expect(
          await CheckFile.checkAll(
              file: arquivo('b.png', 10), optionalFileSizeValuePermitted: 5),
          FileError.size);
    });

    test('PDF protegido', () async {
      pdfrx.erro = const PdfPasswordException('senha');
      expect(await CheckFile.checkAll(file: arquivo('a.pdf', 10)),
          FileError.protected);
    });

    test('PDF que falha ao abrir por outro motivo não é protegido', () async {
      pdfrx.erro = StateError('sem pdfium');
      expect(await CheckFile.checkAll(file: arquivo('a.pdf', 10)), FileError.none);
    });

    test('formato não suportado', () async {
      expect(await CheckFile.checkAll(file: arquivo('a.txt', 10)),
          FileError.unsupportedFormat);
    });

    test('arquivo válido', () async {
      expect(await CheckFile.checkAll(file: arquivo('a.jpg', 10)), FileError.none);
      pdfrx.erro = null;
      expect(await CheckFile.checkAll(file: arquivo('b.pdf', 10)), FileError.none);
    });
  });
}
