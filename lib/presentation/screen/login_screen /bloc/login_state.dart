abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
}

class LoginError extends LoginState {
  final String emailError;
  final String passwordError;

  const LoginError({
    this.emailError = '',
    this.passwordError = '',
  });
}
