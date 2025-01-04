import 'dart:async';

import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:copycat_base/common/failure.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/domain/repositories/clipboard.dart';
import 'package:copycat_base/domain/sources/clipboard.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/snackbar.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DecryptClipsPage extends StatefulWidget {
  final ClipboardRepository clipboardRepository;
  const DecryptClipsPage({
    super.key,
    required this.clipboardRepository,
  });

  @override
  State<DecryptClipsPage> createState() => _DecryptClipsPageState();
}

class _DecryptClipsPageState extends State<DecryptClipsPage> {
  bool decrypting = false;
  bool loading = true;
  int totalEncrypted = -1;
  int decryptedCount = 0;
  bool stopped = false;

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    setState(() {
      loading = true;
    });
    try {
      final countResult =
          await widget.clipboardRepository.fetchEncryptedCount();
      countResult.fold((l) => showFailureSnackbar(l), (r) {
        totalEncrypted = r;
        startDecryption();
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> startDecryption() async {
    bool hasMore = true;

    while (hasMore && !stopped) {
      final result = await widget.clipboardRepository.getList(
        limit: 350,
        encrypted: true,
        sortBy: ClipboardSortKey.modified,
      );

      await result.fold(
        (l) async {
          showFailureSnackbar(l);
          hasMore = false;
          totalEncrypted = -1;
          decryptedCount = 0;
          return;
        },
        (r) async {
          if (r.results.isNotEmpty) {
            final toSave = <ClipboardItem>[];
            for (int i = 0; i < r.results.length && !stopped; i++) {
              final item = r.results[i];
              try {
                final decrypted = await item.decrypt(throwException: true);
                toSave.add(decrypted);
                decryptedCount++;
              } catch (e) {
                showFailureSnackbar(Failure.fromException(e));
                hasMore = false;
                totalEncrypted = -1;
                decryptedCount = 0;
                return;
              }

              // Update the UI every 10 items for better performance
              if (mounted && decryptedCount % 10 == 0) setState(() {});
            }
            await widget.clipboardRepository.updateAll(toSave);
          } else {
            hasMore = false;
          }
          if (mounted) setState(() {});
          await wait(30);
        },
      );
    }
  }

  void cancel() async {
    stopped = true;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final cancelButton =
        TextButton.icon(onPressed: cancel, label: Text(context.locale.cancel));
    return Scaffold(
      body: ScaffoldBody(
        margin: const EdgeInsets.all(padding16),
        borderRadius: radius16,
        child: Padding(
          padding: const EdgeInsets.all(padding16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_open_rounded,
                  size: 28,
                ),
                height10,
                Text(
                  "Clipboard Decryption",
                  style: textTheme.headlineMedium,
                ),
                height16,
                Column(
                  children: [
                    if (loading) ...[
                      const CircularProgressIndicator(),
                      cancelButton
                    ] else if (decryptedCount == totalEncrypted)
                      Column(
                        children: [
                          Text(
                            "🥳 Congratulations! All your clips have been successfully decrypted locally,\n so rebuilding the database is not required.",
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium,
                          ),
                          height10,
                          FilledButton(
                            onPressed: context.pop,
                            child: Text(context.locale.continue_),
                          )
                        ],
                      )
                    else if (totalEncrypted < 0)
                      Column(
                        children: [
                          const Text("Something went wrong!"),
                          height10,
                          OverflowBar(
                            children: [
                              ElevatedButton(
                                onPressed: start,
                                child: const Text('Try Again'),
                              ),
                              cancelButton,
                            ],
                          ),
                        ],
                      )
                    else if (totalEncrypted > 0)
                      Column(
                        children: [
                          Text(
                            "Currently you have $totalEncrypted encrypted clips locally.",
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium,
                          ),
                          height10,
                          SizedBox(
                            width: 250,
                            child: LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(10),
                              value: decryptedCount / totalEncrypted,
                            ),
                          ),
                          height10,
                          Text(
                            "Decrypted: $decryptedCount of $totalEncrypted clips.",
                            textAlign: TextAlign.center,
                          ),
                          height10,
                          cancelButton,
                          height10,
                          Text(
                            "⚠️ Please keep this screen open during this process to avoid data corruption or inconsistencies.",
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.deepOrange,
                            ),
                          )
                        ],
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
