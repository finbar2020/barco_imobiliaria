import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:morar/feature/change_ownership/domain/entity/can_change_entity.dart';
import 'package:morar/feature/change_ownership/domain/entity/ownership_entity.dart';
import 'package:shared_features/shared_features.dart';

abstract class ChangeOwnershipRepository {
  Future<Try<UrlUploadS3>> getAws(String reference, OwnershipEntity entity);
  Future<Try<String>> postChange(String condoId, OwnershipEntity entity);
  Future<Try<String>> uploadImageToAws(File file, String url);
  Future<Try<CanChangeEntity>> getCanChange(String condoId);
}
