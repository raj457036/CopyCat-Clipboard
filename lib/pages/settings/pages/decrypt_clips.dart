import 'dart:async';

import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DecryptClipsPage extends StatefulWidget {
  final ClipboardRepository clipboardRepository;
  const DecryptClipsPage({super.key, required this.clipboardRepository});

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
      final countResult = await widget.clipboardRepository
          .fetchEncryptedCount();
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
        limit: 20,
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
                final decrypted = await item.decrypt(throwException: false);
                toSave.add(decrypted);
                decryptedCount++;
                await Future(dud);
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
    final cancelButton = TextButton.icon(
      onPressed: cancel,
      label: Text(context.mlocale.cancelButtonLabel),
    );
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
                const Icon(Icons.lock_open_rounded, size: 28),
                height10,
                Text(
                  context.locale.settings__decrypt__title,
                  style: textTheme.headlineMedium,
                ),
                height16,
                Column(
                  children: [
                    if (loading) ...[
                      const CircularProgressIndicator(),
                      cancelButton,
                    ] else if (decryptedCount == totalEncrypted)
                      Column(
                        children: [
                          Text(
                            context.locale.settings__text__decrypted__note,
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium,
                          ),
                          height10,
                          FilledButton(
                            onPressed: context.pop,
                            child: Text(
                              context.mlocale.continueButtonLabel.title,
                            ),
                          ),
                        ],
                      )
                    else if (totalEncrypted < 0)
                      Column(
                        children: [
                          Text(context.locale.app__unknown_error),
                          height10,
                          OverflowBar(
                            children: [
                              ElevatedButton(
                                onPressed: start,
                                child: Text(context.locale.app__try_again),
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
                            context.locale.settings__decrypt__count(
                              count: totalEncrypted,
                            ),
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
                            context.locale.settings__decrypt__progress(
                              decrypted: decryptedCount,
                              total: totalEncrypted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          height10,
                          cancelButton,
                          height10,
                          Text(
                            context.locale.settings__decrypt__warning,
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
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
