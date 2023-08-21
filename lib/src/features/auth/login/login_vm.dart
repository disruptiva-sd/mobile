import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/exceptions/service_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/auth/login/login_state.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_vm.g.dart';

@riverpod
class LoginVm extends _$LoginVm {
  //cria um ciclo de vida nesse processo de gerenciamento de estado
  //qdo cria o riverpod, ele escolhe o tipo de provider conforme a necessidade
  @override
  LoginState build() => LoginState.initial();

  Future<void> login(String email, String password) async {
    //add loader para controlar manualmente o loader
    final loaderHandle = AsyncLoaderHandler()..start();

    //buscar direto no provider
    final loginService = ref.watch(userLoginServiceProvider);

    final result = await loginService.execute(email, password);

    switch (result) {
      case Success():
        /*1. processo de buscar dados do user logado, 
              pq ao logar temos somente o token de acesso
          2. fazer analise para qual tipo de login
        */

        /* invalidando os caches para evitar o login com o user errado */
        ref.invalidate(getMeProvider);
        ref.invalidate(getMyBarbershopProvider);
        
        final userModel =await ref.read(getMeProvider.future);
        switch(userModel){
          case UserModelAdm():
          state = state.copyWith(status:LoginStateStatus.admLogin);
          case UserModelEmployee():
          state = state.copyWith(status:LoginStateStatus.employeeLogin);
        }
        break;
      case //Failure(:final exception):
        //extraindo a exception direto de ServiceException
        Failure(exception: ServiceException(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          //errorMessage: () => exception.message);
          errorMessage: () => message,
        );
    }
    loaderHandle.close();
  }
}
