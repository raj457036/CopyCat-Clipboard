import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_rules.dart';
import 'package:isar_community/isar.dart';

part 'isar_exclusion_rules.g.dart';

@Name("AppInfo")
@Embedded(ignore: {"copyWith"})
class IsarAppInfo {
  String name = '';
  String? path;
  String? identifier;

  AppInfo toDomain() => AppInfo(name: name, path: path, identifier: identifier);

  static IsarAppInfo fromDomain(AppInfo info) => IsarAppInfo()
    ..name = info.name
    ..path = info.path
    ..identifier = info.identifier;
}

@Name("ExclusionRules")
@Embedded(ignore: {"copyWith"})
class IsarExclusionRules {
  bool enable = false;
  bool creditCard = true;
  bool phone = true;
  bool passwordManager = true;
  bool email = true;
  bool sensitiveUrls = true;
  List<String> patterns = [];
  List<String> titles = [];
  List<String> urls = [];
  List<IsarAppInfo> apps = [];

  ExclusionRules toDomain() => ExclusionRules(
    enable: enable,
    creditCard: creditCard,
    phone: phone,
    passwordManager: passwordManager,
    email: email,
    sensitiveUrls: sensitiveUrls,
    patterns: patterns,
    titles: titles,
    urls: urls,
    apps: apps.map((a) => a.toDomain()).toList(),
  );

  static IsarExclusionRules fromDomain(ExclusionRules rules) =>
      IsarExclusionRules()
        ..enable = rules.enable
        ..creditCard = rules.creditCard
        ..phone = rules.phone
        ..passwordManager = rules.passwordManager
        ..email = rules.email
        ..sensitiveUrls = rules.sensitiveUrls
        ..patterns = rules.patterns
        ..titles = rules.titles
        ..urls = rules.urls
        ..apps = rules.apps.map(IsarAppInfo.fromDomain).toList();
}
