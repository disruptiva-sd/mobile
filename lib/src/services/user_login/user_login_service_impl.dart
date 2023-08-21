import 'package:dw_barbershop/src/core/constants/local_storage_keys.dart';
import 'package:dw_barbershop/src/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/exceptions/service_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository.dart';
import './user_login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginServiceImpl implements UserLoginService {
  final UserRepository userRepository;
  UserLoginServiceImpl({
    required this.userRepository,
  });

  @override
  Future<Either<ServiceException, Nil>> execute(
      String email, String password) async {
    final loginResult = await userRepository.login(email, password);
    //avaliar o result para saber se da falha ou sucesso
    //checar todas as possibilidades
    switch (loginResult) {
      ///se sucesso, guarda o token
      case Success(value: final accessToken):
        final sp = await SharedPreferences.getInstance();
        sp.setString(LocalStorageKeys.accessToken, accessToken);
        return Success(nil);
      case Failure(:final exception):
        switch (exception) {
          case AuthError():
            return Failure(ServiceException(message: 'Erro ao realizar login'));
          case AuthUnauthorizedException():
            return Failure(
                ServiceException(message: 'Login ou senha inválidos'));
          default:
            return Failure(ServiceException(message: 'Erro Login!!!'));
        }
      //extrair a exception...tem que validar todos os tipos de erros e exceptions
      /*case Failure(:final exception):
        switch (exception) {
          case AuthError():
            return Failure(
                ServiceException(message: 'Erro ao realizar o login'));
          case AuthUnauthorizedException():
            return Failure(
                ServiceException(message: 'Login ou senha inválidos'));
        }*/
    }
  }
}
