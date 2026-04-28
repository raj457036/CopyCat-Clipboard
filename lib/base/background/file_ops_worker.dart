import 'package:clipboard/common/logging.dart';
import 'package:easy_worker/easy_worker.dart';
import 'package:universal_io/io.dart';

void copyFileEntrypoint((String, String) paths, Sender sender) {
  final (from, to) = paths;
  final fromFile = File(from);
  try {
    fromFile.copySync(to);
    sender(true);
  } catch (e) {
    logger.e("Failed to copy file in isolate", error: e);
    sender(false);
  }
}

Future<bool> copyFileInBackground(String from, String to) {
  return EasyWorker.compute<bool, (String, String)>(copyFileEntrypoint, (
    from,
    to,
  ), name: "Copy File");
}
