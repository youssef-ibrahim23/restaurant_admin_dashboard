
import 'package:restaurant_admin_dashboard/features/login/data/model/login_model.dart';

import '../../domain/repository/login_repository.dart';
import '../service/login_service.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginService _loginService;

  const LoginRepositoryImpl({
    required this._loginService,
  });

  @override
  Future<bool> login(LoginModel loginModel) async {
    final response = await _loginService.login(
      email: loginModel.email,
      password: loginModel.password,
    );

    return response.data != null;
  }
}
