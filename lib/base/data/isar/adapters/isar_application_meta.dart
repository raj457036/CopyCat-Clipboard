import 'package:clipboard/base/domain/model/application_meta/application_meta.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:isar_community/isar.dart';

part 'isar_application_meta.g.dart';

@Name('ApplicationMeta')
@Collection()
class IsarApplicationMeta {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String sourceId;

  @Index()
  String? identifier;

  String? appName;
  String? appFilePath;

  @Enumerated(EnumType.name)
  late PlatformOS os;

  String? iconLocalPath;
  String? iconRemotePath;
  late DateTime created;
  late DateTime modified;

  ApplicationMeta toDomain() => ApplicationMeta(
    id: isarId == Isar.autoIncrement ? null : isarId,
    sourceId: sourceId,
    identifier: identifier,
    appName: appName,
    appFilePath: appFilePath,
    os: os,
    iconLocalPath: iconLocalPath,
    iconRemotePath: iconRemotePath,
    created: created,
    modified: modified,
  );

  static IsarApplicationMeta fromDomain(ApplicationMeta item) =>
      IsarApplicationMeta()
        ..isarId = item.id ?? Isar.autoIncrement
        ..sourceId = item.sourceId
        ..identifier = item.identifier
        ..appName = item.appName
        ..appFilePath = item.appFilePath
        ..os = item.os
        ..iconLocalPath = item.iconLocalPath
        ..iconRemotePath = item.iconRemotePath
        ..created = item.created
        ..modified = item.modified;
}
