import 'package:bloc/bloc.dart';
import 'package:clipboard/base/domain/model/webdav_config/webdav_config.dart';
import 'package:clipboard/base/domain/repositories/webdav_credential.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:injectable/injectable.dart';

part 'webdav_setup_state.dart';

@injectable
class WebDavSetupCubit extends Cubit<WebDavSetupState> {
  static const _logger = AppLogger.scoped('WebDavSetupCubit');
  final WebDavCredentialRepository _repo;

  WebDavSetupCubit(this._repo) : super(const WebDavSetupInitial());

  Future<void> fetch() async {
    emit(const WebDavSetupLoading());
    final result = await _repo.getConfig();
    result.fold(
      (failure) {
        _logger.e('Failed to fetch WebDAV config: $failure');
        emit(WebDavSetupError(failure: failure));
      },
      (config) {
        if (config != null) {
          emit(WebDavSetupConfigured(config: config));
        } else {
          emit(const WebDavSetupDisconnected());
        }
      },
    );
  }

  FailureOr<void> testConnection(WebDavConfig config) {
    return _repo.testConnection(config);
  }

  Future<bool> saveAndConnect(WebDavConfig config) async {
    emit(const WebDavSetupLoading());
    final testResult = await _repo.testConnection(config);
    return testResult.fold(
      (failure) {
        _logger.e('WebDAV test failed during save: $failure');
        emit(WebDavSetupError(failure: failure, config: config));
        return false;
      },
      (_) async {
        final saveResult = await _repo.saveConfig(config);
        return saveResult.fold(
          (failure) {
            _logger.e('Failed to save WebDAV config: $failure');
            emit(WebDavSetupError(failure: failure, config: config));
            return false;
          },
          (_) {
            _logger.i('WebDAV config saved successfully');
            emit(WebDavSetupConfigured(config: config));
            return true;
          },
        );
      },
    );
  }

  Future<void> disconnect() async {
    emit(const WebDavSetupLoading());
    final result = await _repo.deleteConfig();
    result.fold(
      (failure) {
        _logger.e('Failed to delete WebDAV config: $failure');
        emit(WebDavSetupError(failure: failure));
      },
      (_) {
        _logger.i('WebDAV disconnected');
        emit(const WebDavSetupDisconnected());
      },
    );
  }
}
