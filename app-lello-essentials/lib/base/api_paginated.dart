import 'package:essentials/base/api_meta.dart';

class ApiPaginated<Data> {
  ApiMeta meta;
  Data data;

  ApiPaginated({
    required this.meta,
    required this.data,
  });
}
