import 'package:freezed_annotation/freezed_annotation.dart';

part 'exclusion_rules.freezed.dart';

@freezed
abstract class AppInfo with _$AppInfo {
  const AppInfo._();

  factory AppInfo({
    @Default('') String name,
    String? path,
    String? identifier,
  }) = _AppInfo;
}

@freezed
abstract class ExclusionRules with _$ExclusionRules {
  const ExclusionRules._();
  factory ExclusionRules({
    /// including password patterns and password managers
    @Default(true) bool enable,
    // Exclude credit card
    @Default(false) bool creditCard,
    // Exclude phone number
    @Default(false) bool phone,
    // Exclude password managers
    @Default(true) bool passwordManager,
    // Exclude emails
    @Default(false) bool email,
    // Exclude sensitive urls
    @Default(false) bool sensitiveUrls,
    @Default([]) List<String> patterns,
    @Default([]) List<String> titles,
    @Default([]) List<String> urls,
    @Default([]) List<AppInfo> apps,
  }) = _ExclusionRules;
}

final defaultExclusionRules = ExclusionRules();
