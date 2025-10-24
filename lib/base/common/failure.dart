import 'package:dartz/dartz.dart';
import 'package:universal_io/io.dart';

class Failure {
  final String message;
  final String code;

  const Failure({
    required this.message,
    required this.code,
  });

  factory Failure.fromMessage(String message) {
    return Failure(
      message: message,
      code: "common-failure",
    );
  }

  factory Failure.fromException(dynamic e) {
    if (e is Failure) return e;
    if (e is SocketException) return noInternetConnectionFailure;
    try {
      return Failure(
        message: e.message,
        code: e.runtimeType.toString(),
      );
    } catch (e) {
      return Failure(
        message: e.toString(),
        code: e.runtimeType.toString(),
      );
    }
  }

  @override
  String toString() {
    return "An error occurred: $message (code: $code)";
  }
}

const noInternetConnectionFailure = Failure(
  message: 'No internet connection',
  code: 'no_internet',
);

const authFailure = Failure(
  message: 'Not logged in',
  code: 'not_logged_in',
);

const driveFailure = Failure(
  message: 'Google Drive is not available.',
  code: 'gdrive_not_available',
);

Failure frequentSyncing(int seconds) {
  return Failure(
    message: 'Too frequent request. Try after $seconds seconds',
    code: 'frequent-sync-request',
  );
}

typedef FailureOr<T> = Future<Either<Failure, T>>;
