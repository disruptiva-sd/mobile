//fu-interface
/*erro 500 backend
403 acesso negado user invalido*/
//comand + . = Implements Interface
import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';
import 'package:dw_barbershop/src/model/user_model.dart';

abstract interface class UserRepository {
//contrato
  // Future<Either<Exception, String>> login(String email, String passord);
  //permite retornar AuthException ou filhos dela
  Future<Either<Exception, String>> login(String email, String password);
  Future<Either<RepositoryException, UserModel>> me();
  Future<Either<Exception, Nil>> registerAdmin(
      ({
        //nomear os params
        String name,
        String email,
        String password,
      }) userData);
}
