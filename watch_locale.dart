// ignore_for_file: avoid_print

import 'dart:io';

void callFlutterGenerate(FileSystemEvent event) {
  print("running flutter gen-l10n");

  try {
    final result = Process.runSync(
      "flutter",
      ["gen-l10n"],
      runInShell: true,
      workingDirectory: "./packages/copycat_base/",
    );

    print("Out ${result.exitCode}: ${result.stdout}");
    if (result.stderr != null) {
      print("Error: ${result.stderr}");
    }
  } catch (e) {
    print(e);
  }
}

void main(List<String> args) {
  final arbFile = File(
    "./packages/copycat_base/lib/l10n/locale_en.arb",
  );

  print("listening to $arbFile");

  final stream = arbFile.watch(events: FileSystemEvent.all);

  stream.listen(callFlutterGenerate);
}
