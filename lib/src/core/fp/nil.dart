//class q nao tem tipo de retorno(ausencia de retorno na programacao funcional)
//conceito do nil: ausencia de valor retorno mas precisa retornar algo.
class Nil {
  @override
  String toString() {
    return 'Nil{}';
  }
}

//metodo facilitador de nivel superior para retornar a instancia da classe
Nil get nil => Nil();
