import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/model/barbershop_model.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
//option+enter selecionando BarbershopRepository=implements interface
abstract interface class BarbershopRepository {
  //success=BarbershopModel
Future<Either<RepositoryException,BarbershopModel>> getMyBarbershop(UserModel userModel);
}