import 'package:dartz/dartz.dart';

import '../try.dart';

extension EitherExtension on Either {
  Try<T> toTry<T>() => this.fold((l) {
        return new Rejection(l);
      }, (r) => Success(r));
}
