import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EncryptedClipsStat extends StatelessWidget {
  final bool withDecryptButton;
  final VoidCallback? onNavigate;
  final ClipboardRepository repository;

  const EncryptedClipsStat({
    super.key,
    required this.repository,
    this.onNavigate,
    this.withDecryptButton = false,
  });

  Future<void> goToDecryptionPage(BuildContext context) async {
    onNavigate?.call();
    context.pushNamed(RouteConstants.rebuildDatabase);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FutureBuilder<Either<Failure, int>>(
      future: repository.fetchEncryptedCount(),
      builder:
          (BuildContext context, AsyncSnapshot<Either<Failure, int>> snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final result = snapshot.data!;
        return result.fold((l) {
          return Text(l.message);
        }, (r) {
          return Column(
            children: [
              if (r > 0)
                Text(
                  "You currently have $r encrypted clips that are inaccessible.",
                  textAlign: TextAlign.center,
                )
              else
                const Text(
                  "🥳 Congratulations! All your clips have been successfully decrypted locally, so rebuilding the database is not required.",
                  textAlign: TextAlign.center,
                ),
              height10,
              if (withDecryptButton && r > 0)
                FilledButton.tonalIcon(
                  style:
                      FilledButton.styleFrom(foregroundColor: colors.primary),
                  onPressed: () => goToDecryptionPage(context),
                  icon: const Icon(Icons.lock_open_rounded),
                  label: const Text(
                    "Rebuid Database",
                  ),
                ),
            ],
          );
        });
      },
    );
  }
}
