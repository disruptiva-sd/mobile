sealed class AuthException implements Exception {
  /* util para identificar com o swich qual é o erro para checar todo o tipo de execao*/
  final String message;
  AuthException({required this.message});
}

//erro geral no server
class AuthError extends AuthException {
  AuthError({required super.message});
}

//para o frontend entender os erros
class AuthUnauthorizedException extends AuthException {
  AuthUnauthorizedException() : super(message: '');
}
