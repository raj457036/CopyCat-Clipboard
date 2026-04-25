import 'package:clipboard/base/domain/model/application_meta/activity_meta_payload.dart';

abstract class ApplicationMetaResolver {
  String? resolveSourceId(ActivityMetaPayload? payload);
  Future<String?> syncFromActivity(ActivityMetaPayload? payload);
  Future<String?> getIconPathBySourceId(String sourceId);
}
