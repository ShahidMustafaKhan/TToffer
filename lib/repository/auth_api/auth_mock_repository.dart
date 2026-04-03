import '../../mock/user_mock_data.dart';
import '../../models/authentication_model.dart';
import '../../models/user_model.dart';
import 'auth_repository.dart';

class AuthMockRepository implements AuthRepository {
  UserModel mockUser = getMockUser();

  @override
  Future<AuthenticationModel> loginApiWithEmail(dynamic data) async {
    await Future.delayed(const Duration(seconds: 2));

    return AuthenticationModel(data: Data(user: mockUser, token: "mockToken"));
  }

  @override
  Future<AuthenticationModel> loginApiWithPhone(dynamic data) async {
    await Future.delayed(const Duration(seconds: 2));

    return AuthenticationModel(data: Data(user: mockUser, token: "mockToken"));
  }

  @override
  Future<AuthenticationModel> registerApi(dynamic data) async {
    await Future.delayed(const Duration(seconds: 2));

    return AuthenticationModel(data: Data(user: mockUser, token: "mockToken"));
  }
}
