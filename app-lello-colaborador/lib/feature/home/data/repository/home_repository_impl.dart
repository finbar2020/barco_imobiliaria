import 'package:colaborador/feature/home/data/data_source/home_remote_data_source.dart';
import 'package:colaborador/feature/home/domain/repository/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeRemoteDataSource dataSource;

  HomeRepositoryImpl({required this.dataSource});
}
