import 'failure.dart';

sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  });
}

class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return onSuccess(data);
  }
}

class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;

  @override
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return onFailure(failure);
  }
}
