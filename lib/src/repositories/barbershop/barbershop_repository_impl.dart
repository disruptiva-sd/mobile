import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/restClient/rest_client.dart';
import 'package:dw_barbershop/src/model/barbershop_model.dart';
import 'package:dw_barbershop/src/model/user_model.dart';

import './barbershop_repository.dart';

//selecione BarbershopRepositoryImpl + option+enter = create missing overide
class BarbershopRepositoryImpl implements BarbershopRepository {
  final RestClient restClient;
  //selecao na class + option+enter = Generate constructor, add abaixo o construtor
  BarbershopRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
      UserModel userModel) async {
    /* Identificar o perfil de usuario */
    switch (userModel) {
      case UserModelAdm():

        /* 
            conversao DE List(first:data) retorna um array apos consumir, 
            por isso q preciso buscar sempre a primeira posicao

         */
        final Response(data:List(first:data)) = await restClient.auth.get(
          '/barbershop',
          /*nao temos o id da barbearia, 
          pq a barbearia esta associado ao user administrador 
          pq precisamos criar a conta do user para 
          cadastrar o estabelecimento
          */
          /*buscar pelo user logado buscar a barbearia 
          pelo usuario logado para fazer o filtro do barbershop pelo userId
          quando bater no backend ele vai substituir #userAuthRef' pelo id do user logado
          coringa do json rest server
          user_id é a referencia do user logado, retornando uma lista e nao um obj
           */
          queryParameters: {'user_id': '#userAuthRef'},
        );
        //data.first 
        return Success(BarbershopModel.fromMap(data));
      case UserModelEmployee():
        final Response(:data) =
            await restClient.auth.get('/barbershop/${userModel.barbershopId}');
        return Success(BarbershopModel.fromMap(data));
    }
  }
}
