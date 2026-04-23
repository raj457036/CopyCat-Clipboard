import "package:universal_io/io.dart";
import 'package:win32_registry/win32_registry.dart';

Future<void> updateWindowsRegistry() async {
  if (!Platform.isWindows) return;
  String appPath = Platform.resolvedExecutable;

  String protocolRegKey = 'Software\\Classes\\clipboard';
  RegistryValue protocolRegValue = const RegistryValue.string(
    'URL Protocol',
    '',
  );
  String protocolCmdRegKey = 'shell\\open\\command';
  RegistryValue protocolCmdRegValue = RegistryValue.string(
    '',
    '"$appPath" "%1"',
  );

  final regKey = Registry.currentUser.createKey(protocolRegKey);
  regKey.createValue(protocolRegValue);
  regKey.createKey(protocolCmdRegKey).createValue(protocolCmdRegValue);
}
