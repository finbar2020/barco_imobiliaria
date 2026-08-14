import 'package:essentials/paginator/meta.dart';

class Paginator {
  Meta? meta;
  dynamic data;

  Paginator({
    this.meta,
    this.data,
  });

  @override
  String toString() => 'Paginator(meta: $meta, data: $data)';
}
