//para identificar o perfil do usuario ao realizar o login
import 'package:flutter/material.dart';

enum LoginStateStatus {
  initial,
  error,
  admLogin,
  employeeLogin,
}

class LoginState {
  final LoginStateStatus status;
  final String?
      errorMessage; //pode aceitar nulo, para caso de erro, apresentar a msn para o user

  //construtor nomeado que vai chamar o construtor padrao e vai passar o status inicial
  LoginState.initial() : this(status: LoginStateStatus.initial);
  //cria o construtor

  LoginState({
    required this.status,
    this.errorMessage,
  });
/*
  padrao de projeto

  imutabilidade

  implementar de retornar a instancia q ele esta, 
  recebebe todos atributos como opcional.
  na implementacao(return)

 */
//para tratar das questoes de valores nulos no copyWith
  LoginState copyWith({
    LoginStateStatus? status,
    ValueGetter<String?>? errorMessage, //ValueGetter recebe string como nula
  }) {
    return LoginState(
        status: status ?? this.status,
        errorMessage:
            /*se errorMessage é diferente de null, invoca a errorMessage() 
           senao ele for nulo vai add o vlr q estava anteriormente*/
            errorMessage != null ? errorMessage() : this.errorMessage);
  }
}
