abstract class LoginEvent {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String email; // final String password;
  final String password;
  const LoginButtonPressed({required this.email, required this.password});
}
