sealed class Either<E extends Exception, S> {
  //generic q recebe como primeiro param a exception e o segundo param sucesso
}

//qdo ocorrer o erro q recebe Either
class Failure<E extends Exception, S> extends Either<E, S> {
  final E exception;
  Failure(this.exception);
}

//qdo ocorrer o success
class Success<E extends Exception, S> extends Either<E, S> {
  final S value;
  Success(this.value);
}
