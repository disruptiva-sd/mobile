//option+enter =missing override
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository.dart';
import 'package:dw_barbershop/src/services/user_register/user_register_service.dart';

import '../../core/exceptions/service_exception.dart';
import '../user_login/user_login_service.dart';

class UserRegisterServiceImpl implements UserRegisterService {
//receber dois atributos
  final UserRepository userRepository;
  final UserLoginService userLoginService;

  UserRegisterServiceImpl({
    required this.userRepository,
    required this.userLoginService,
  });
//selecionar UserRegisterServiceImpl e generate constructor

  @override
  Future<Either<ServiceException, Nil>> execute(
      ({String email, String name, String password}) userData) async {
    final registerResult = await userRepository.registerAdmin(userData);
    switch (registerResult) {
      case Success():
        return userLoginService.execute(userData.email, userData.password);
      case Failure(:final exception):
        return Failure(ServiceException(message: exception.toString()));
    }
  }
}
