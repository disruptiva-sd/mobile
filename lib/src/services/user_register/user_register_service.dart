import 'package:dw_barbershop/src/core/exceptions/service_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';



//option+enter no UserRegisterService = implements interface, gera o arquivo user_register_impl.dart
abstract interface class UserRegisterService {
 Future<Either<ServiceException, Nil>> execute(
      ({
        //nomear os params
        String name,
        String email,
        String password,
      }) userData);
}