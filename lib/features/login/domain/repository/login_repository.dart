import 'package:restaurant_admin_dashboard/features/login/data/model/login_model.dart';

abstract class LoginRepository {
  Future<bool> login(LoginModel loginModel);
}