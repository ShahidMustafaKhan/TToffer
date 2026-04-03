import '../../models/authentication_model.dart';

abstract class AuthRepository {
  Future<AuthenticationModel> loginApiWithEmail(dynamic data);

  Future<AuthenticationModel> loginApiWithPhone(dynamic data);

  Future<AuthenticationModel> registerApi(dynamic data);
}
