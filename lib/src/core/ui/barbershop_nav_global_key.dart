/*singleton para ter uma unica instancia por toda a app e nao vou delegar para o riverpod
*/
import 'package:flutter/material.dart';

class BarbershopNavGlobalKey {
  static BarbershopNavGlobalKey? _instance;
  final navKey = GlobalKey<NavigatorState>(); //configurar navKey no barbershop_app.dart
  // Avoid self instance
  BarbershopNavGlobalKey._();
  static BarbershopNavGlobalKey get instance =>
    _instance ??= BarbershopNavGlobalKey._();
}