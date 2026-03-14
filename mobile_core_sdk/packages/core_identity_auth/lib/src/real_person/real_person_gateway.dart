import 'real_person_models.dart';

abstract class RealPersonGateway {
  Future<String> fetchToken({required String bizId});

  Future<Map<String, dynamic>> fetchResult({required String bizId});

  Future<Map<String, dynamic>> fetchVerifyImage({required int userId});

  Future<Map<String, dynamic>> uploadPhoto({required String filePath});

  Future<Map<String, dynamic>> uploadPhotoForUserId({required String filePath});

  Future<RealPersonIdentifyResponse> identify(
    RealPersonIdentifyRequest request,
  );
}
