import "package:universal_io/io.dart";
import 'package:win32_registry/win32_registry.dart';

Future<void> updateWindowsRegistry() async {
  if (!Platform.isWindows) return;
  final appPath = Platform.resolvedExecutable;

  const protocolRegKey = r'Software\Classes\clipboard';
  const protocolCmdRegKey = r'shell\open\command';

  final regKey = CURRENT_USER.create(protocolRegKey);
  try {
    regKey.setValue('URL Protocol', const RegistryValue.string(''));
    final cmdKey = regKey.create(protocolCmdRegKey);
    try {
      cmdKey.setValue('', RegistryValue.string('"$appPath" "%1"'));
    } finally {
      cmdKey.close();
    }
  } finally {
    regKey.close();
  }
}
