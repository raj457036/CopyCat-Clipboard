import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/base/l10n/generated/app_localizations.dart';
import 'package:clipboard/base/l10n/generated/app_localizations_en.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/widgets/clip_item/clip_sync_status_footer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _English extends LocalizationsDelegate<AppLocalizations> {
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en';

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture(AppLocalizationsEn());

  @override
  bool shouldReload(_English old) => false;
}

void main() {
  testWidgets('pending, active and failed clips expose distinct states', (
    tester,
  ) async {
    final locale = AppLocalizationsEn();
    final pending = ClipboardItem(
      id: 1,
      created: DateTime.now(),
      modified: DateTime.now(),
      type: ClipItemType.file,
      os: PlatformOS.macos,
      userId: 'user',
      localPath: '/file.txt',
      isQueued: true,
    );

    Future<void> show(ClipboardItem item) => tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: [
          _English(),
          ...AppLocalizations.localizationsDelegates,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(body: ClipSyncStatusFooter(item: item)),
      ),
    );

    await show(pending);
    expect(find.text(locale.app__queued), findsOneWidget);

    await show(pending.copyWith(uploading: true, isQueued: false));
    expect(find.text(locale.app__queued), findsNothing);
    expect(find.text(locale.app__uploading), findsOneWidget);

    await show(
      pending.copyWith(
        isQueued: false,
        failure: const Failure(message: 'Upload timed out', code: 'timeout'),
      ),
    );
    expect(find.text(locale.app__queued), findsNothing);
    expect(find.text(locale.app__sync), findsOneWidget);
    expect(
      tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
      isNotNull,
    );
  });
}
