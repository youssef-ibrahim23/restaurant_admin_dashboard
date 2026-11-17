import 'package:restaurant_admin_dashboard/features/login/data/model/login_model.dart';
import 'package:restaurant_admin_dashboard/features/login/domain/repository/login_repository.dart';

class LoginUseCase {

  final LoginRepository _repository;

  const LoginUseCase({required this._repository});

  Future<bool> call(LoginModel loginModel) async {
    return await _repository.login(loginModel);
  }

}