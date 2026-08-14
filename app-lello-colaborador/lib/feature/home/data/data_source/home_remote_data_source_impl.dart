import 'package:colaborador/feature/home/data/data_source/home_api.dart';
import 'package:colaborador/feature/home/data/data_source/home_remote_data_source.dart';

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final HomeApi api;

  HomeRemoteDataSourceImpl({required this.api});
}
