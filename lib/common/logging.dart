import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class CustomOutput extends LogOutput {
  late final LogOutput _output;

  @override
  Future<void> init() async {
    if (kDebugMode) {
      _output = ConsoleOutput();
      return;
    }
    final directory = await path_provider.getApplicationSupportDirectory();
    _output = AdvancedFileOutput(path: directory.path);
  }

  @override
  void output(OutputEvent event) {
    _output.output(event);
  }
}

final logger = Logger(
  level: kDebugMode ? Level.debug : Level.warning,
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 10,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
  filter: kReleaseMode ? ProductionFilter() : null,
  output: CustomOutput(),
);
