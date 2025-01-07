import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/presentation/screen/login_screen%20/bloc/login_event.dart';
import 'package:movieapp/presentation/screen/login_screen%20/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  void _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) {
    emit(LoginLoading());

    String emailError = '';
    String passwordError = '';

    if (!_isValidEmail(event.email)) {
      emailError = 'Please enter a valid email address';
    }

    if (!_isValidPassword(event.password)) {
      passwordError = 'Password must be at least 6 characters long';
    }

    if (emailError.isNotEmpty || passwordError.isNotEmpty) {
      emit(LoginError(
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }

    emit(const LoginSuccess());
  }
}
