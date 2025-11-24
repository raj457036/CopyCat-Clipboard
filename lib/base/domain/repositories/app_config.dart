import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/common/failure.dart';

abstract class AppConfigRepository {
  FailureOr<AppConfig> get();
  FailureOr<AppConfig> update(AppConfig config);
}
