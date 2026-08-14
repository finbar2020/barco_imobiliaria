import 'dart:async';

class Semaphore {
  final int maxConcurrent;
  int _current = 0;
  final _queue = <Completer<void>>[];

  Semaphore(this.maxConcurrent);

  Future<void> acquire() {
    if (_current < maxConcurrent) {
      _current++;
      return Future.value();
    } else {
      final completer = Completer<void>();
      _queue.add(completer);
      return completer.future;
    }
  }

  void release() {
    if (_queue.isNotEmpty) {
      final completer = _queue.removeAt(0);
      completer.complete();
    } else {
      _current--;
    }
  }
}
