import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_admin_dashboard/features/login/data/model/login_model.dart';
import 'package:restaurant_admin_dashboard/features/login/domain/usecases/login_usecase.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({required this._loginUseCase})
      : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final loginModel = LoginModel(
        email: event.email,
        password: event.password,
      );
      final success = await _loginUseCase.call(loginModel);
      
      if (success) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(error: 'Invalid email or password'));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}
