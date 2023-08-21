import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/constants/local_storage_keys.dart';
import 'package:dw_barbershop/src/core/ui/barbershop_nav_global_key.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
Extende da class Interceptor, 
para controlar os 4 ciclos de vida de uma requisicao http
ciclos: pré requisicao(que antes de executar da requisicao), 
bate no backend(quando bate e volta da requisicao), volta do backend(sucesso ou falha), 
*/
class AuthInterceptor extends Interceptor {
  /* antes de fazer a requisicao */
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    //destruction extraindo os headers e extra
    final RequestOptions(:headers, :extra) = options;
//a chave q vai ser inserido na flag do Authorization
    const authHeaderKey = 'Authorization';
    headers.remove(authHeaderKey);
//extra mapa de chave e valor
//existe uma flag com a chave key e o vlr é verdadeiro
    if (extra case {'DIO_AUTH_KEY': true}) {
      //se tiver q add autenticao, precisa buscar o token autenticado
      final sp = await SharedPreferences.getInstance();
      headers.addAll({
        authHeaderKey: 'Bearer ${sp.getString(LocalStorageKeys.accessToken)}'
      });
    }
    handler.next(options);
  }

  /* controle de erro  para session token
    
   */
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    //extrair(destruction do dart)
    final DioException(requestOptions: RequestOptions(:extra), :response) = err;
    /*
      era req Autenticada
     */

    if (extra case {'DIO_AUTH_KEY': true}) {
      //se veio de uma requisicao autenticacada e for forbidden 403, forçando o contexto por pode ser nulo

      if (response != null && response.statusCode == HttpStatus.forbidden) {
        Navigator.of(BarbershopNavGlobalKey.instance.navKey.currentContext!)
           //redireciona o user para a tela de login
            .pushNamedAndRemoveUntil('/auth/login', (route) => false);
      }
    }
    handler.reject(err);//pode rejeitar a requisicao
  }
}
