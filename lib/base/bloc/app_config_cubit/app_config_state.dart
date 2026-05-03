part of 'app_config_cubit.dart';

@freezed
class AppConfigState with _$AppConfigState {
  const factory AppConfigState.loaded({
    required AppConfig config,
    @Default(false) bool isLoading,
    @Default(0) int reviewPromptSignal,
    Failure? failure,
  }) = AppConfigLoaded;
}
