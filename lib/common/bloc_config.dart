import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart' show AuthCubit;
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart'
    show DriveSetupCubit;
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart'
    show MonetizationCubit;
import 'package:clipboard/base/bloc/webdav_setup_cubit/webdav_setup_cubit.dart'
    show WebDavSetupCubit;
import 'package:clipboard/common/logging.dart';
import 'package:flutter/foundation.dart';

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

    if (kReleaseMode) {
      if (bloc is AuthCubit) return;
      if (bloc is MonetizationCubit) return;
      if (bloc is DriveSetupCubit) return;
      if (bloc is WebDavSetupCubit) return;
    }
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
