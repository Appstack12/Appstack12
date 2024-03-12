import 'package:fit_for_life/constants/index.dart';
import 'package:fit_for_life/services/index.dart';

class UserService {
  final _apiClass = ApiClass();

  Future<Map<String, dynamic>> sendOtp(Object body) async {
    final response = await _apiClass.onCallPostApi(ApiEndpoints.login, body);

    return response;
  }

  Future<Map<String, dynamic>> verifyOtp(Object body) async {
    final response =
        await _apiClass.onCallPostApi(ApiEndpoints.verifyOtp, body);

    return response;
  }

  Future<Map<String, dynamic>> updateUserDetails(Object body) async {
    final response =
        await _apiClass.onCallPostApi(ApiEndpoints.updateUserDetails, body);

    return response;
  }


  
  Future<Map<String, dynamic>> editUserDetails(Object body) async {
    final response =
    await _apiClass.onCallPatchApi(ApiEndpoints.editUserDetails, body);

    return response;
  }

  Future<Map<String, dynamic>> uploadImage(String path) async {
    final response = await _apiClass.onCallMultipartFormApi(
      ApiEndpoints.uploadImage,
      path,
    );

    return response;
  }
}
