import 'package:bloc/bloc.dart';
import 'package:clipboard/common/logging.dart';

class CustomBlocObserver extends BlocObserver {
  static const _logger = AppLogger.scoped('Bloc');

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.i(() => 'onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.i(() => "onEvent -- $event");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _logger.e(
      () => "onError -- ${bloc.runtimeType}, $error",
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.d(
      () =>
          'onChange(${bloc.runtimeType}) -- ${change.currentState} → ${change.nextState}',
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.i(() => 'onClose -- ${bloc.runtimeType}');
  }
}
