import 'dart:convert';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_rules.dart';
import 'package:drift/drift.dart';

class ExclusionRulesConverter extends TypeConverter<ExclusionRules, String> {
  const ExclusionRulesConverter();

  @override
  ExclusionRules fromSql(String fromDb) {
    if (fromDb.isEmpty) return ExclusionRules();
    try {
      final Map<String, dynamic> json = jsonDecode(fromDb) as Map<String, dynamic>;
      final appsJson = json['apps'] as List<dynamic>? ?? [];
      final apps = appsJson.map((a) {
        final map = a as Map<String, dynamic>;
        return AppInfo(
          name: map['name'] as String? ?? '',
          path: map['path'] as String?,
          identifier: map['identifier'] as String?,
        );
      }).toList();

      return ExclusionRules(
        enable: json['enable'] as bool? ?? false,
        creditCard: json['creditCard'] as bool? ?? true,
        phone: json['phone'] as bool? ?? true,
        passwordManager: json['passwordManager'] as bool? ?? true,
        email: json['email'] as bool? ?? true,
        sensitiveUrls: json['sensitiveUrls'] as bool? ?? true,
        patterns: (json['patterns'] as List<dynamic>?)?.cast<String>() ?? const [],
        titles: (json['titles'] as List<dynamic>?)?.cast<String>() ?? const [],
        urls: (json['urls'] as List<dynamic>?)?.cast<String>() ?? const [],
        apps: apps,
      );
    } catch (_) {
      return ExclusionRules();
    }
  }

  @override
  String toSql(ExclusionRules value) {
    final Map<String, dynamic> json = {
      'enable': value.enable,
      'creditCard': value.creditCard,
      'phone': value.phone,
      'passwordManager': value.passwordManager,
      'email': value.email,
      'sensitiveUrls': value.sensitiveUrls,
      'patterns': value.patterns,
      'titles': value.titles,
      'urls': value.urls,
      'apps': value.apps.map((a) => {
        'name': a.name,
        'path': a.path,
        'identifier': a.identifier,
      }).toList(),
    };
    return jsonEncode(json);
  }
}
