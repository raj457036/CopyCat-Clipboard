part of 'android_bg_clipboard_cubit.dart';

@freezed
class AndroidBgClipboardState with _$AndroidBgClipboardState {
  const factory AndroidBgClipboardState.unknown() = AndroidBgClipboardUnknown;
  const factory AndroidBgClipboardState.reading() = AndroidBgClipboardReading;
  const factory AndroidBgClipboardState.completed() =
      AndroidBgClipboardCompleted;
  const factory AndroidBgClipboardState.failed(Failure? failure) =
      AndroidBgClipboardFailed;
}
