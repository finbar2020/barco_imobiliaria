import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/attach_files/bloc/attach_files_bloc.dart';

void main() {
  test('estado inicial é vazio sem erro', () {
    final bloc = AttachFilesBloc();
    final state = bloc.state;
    expect(state, isA<AttachFilesEmptyState>());
    expect((state as AttachFilesEmptyState).errorType, isNull);
    expect(state.fileExtension, isNull);
    expect(state.fileName, isNull);
    bloc.close();
  });

  test('AttachFilesSuccessEvent emite AttachFilesSuccessState com os arquivos',
      () async {
    final bloc = AttachFilesBloc();
    final files = [File('a.png'), File('b.pdf')];
    final future = bloc.stream.first;
    bloc.add(AttachFilesSuccessEvent(files: files));
    final state = await future;
    expect(state, isA<AttachFilesSuccessState>());
    expect((state as AttachFilesSuccessState).files, same(files));
    await bloc.close();
  });

  test('AttachFilesEmptyEvent emite AttachFilesEmptyState com o erro', () async {
    final bloc = AttachFilesBloc();
    final states = <AttachFilesState>[];
    bloc.stream.listen(states.add);
    bloc.add(AttachFilesEmptyEvent(
        errorType: FileError.size, fileExtension: '.pdf', fileName: 'grande'));
    bloc.add(AttachFilesEmptyEvent());
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(states, hasLength(2));
    final first = states[0] as AttachFilesEmptyState;
    expect(first.errorType, FileError.size);
    expect(first.fileExtension, '.pdf');
    expect(first.fileName, 'grande');
    final second = states[1] as AttachFilesEmptyState;
    expect(second.errorType, isNull);
    await bloc.close();
  });

  test('sequência sucesso → vazio → sucesso', () async {
    final bloc = AttachFilesBloc();
    final states = <AttachFilesState>[];
    bloc.stream.listen(states.add);
    bloc.add(AttachFilesSuccessEvent(files: [File('x.png')]));
    bloc.add(AttachFilesEmptyEvent(errorType: FileError.protected));
    bloc.add(AttachFilesSuccessEvent(files: []));
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(states.map((s) => s.runtimeType), [
      AttachFilesSuccessState,
      AttachFilesEmptyState,
      AttachFilesSuccessState,
    ]);
    expect((states.last as AttachFilesSuccessState).files, isEmpty);
    await bloc.close();
  });
}
