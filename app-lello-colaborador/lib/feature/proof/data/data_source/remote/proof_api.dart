import 'package:chopper/chopper.dart';

part 'proof_api.chopper.dart';

@ChopperApi()
abstract class ProofApi extends ChopperService {
  @Get(path: "condominiums/{condominium_id}/digital_point/proof")
  Future<Response> getProof(
    @Path("condominium_id") String condominiumId,
    @Query() DateTime date,
  );

  @Get(path: "condominiums/{condominium_id}/digital_point/proof/download")
  Future<Response> getFileProof(
    @Path("condominium_id") String condominiumId,
    @Query() String fileName,
  );

  static ProofApi create(ChopperClient client) {
    return _$ProofApi(client);
  }
}
