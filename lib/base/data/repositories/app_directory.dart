import 'dart:convert';

import 'package:clipboard/base/domain/model/application_meta/app_directory_entry.dart';
import 'package:clipboard/base/domain/model/application_meta/application_meta.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/base/domain/repositories/app_directory.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_io/io.dart';

const _kMaxIconUploadBytes = 512 * 1024; // 512 KB cap
const _kEdgeFunctionName = 'sync_activity_directory_entry';
const _kDirectoryTable = 'app_activity_directory';

@LazySingleton(as: AppDirectoryRepository)
class AppDirectoryRepositoryImpl implements AppDirectoryRepository {
  final SupabaseClient _supabase;

  AppDirectoryRepositoryImpl(this._supabase);

  String _tag(String sourceId) => '[AppDirectory:$sourceId]';

  @override
  FailureOr<String?> sync(ApplicationMeta app) async {
    try {
      logger.d(
        '${_tag(app.sourceId)} sync start (os=${app.os.name}, hasLocalIconPath=${app.iconLocalPath != null})',
      );
      String? iconBase64;
      if (app.iconLocalPath != null) {
        final file = File(app.iconLocalPath!);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          if (bytes.isNotEmpty && bytes.length <= _kMaxIconUploadBytes) {
            iconBase64 = base64Encode(bytes);
            logger.d(
              '${_tag(app.sourceId)} encoded icon bytes for upload (${bytes.length} bytes)',
            );
          } else {
            logger.w(
              '${_tag(app.sourceId)} icon bytes skipped (empty or above limit: ${bytes.length})',
            );
          }
        } else {
          logger.w(
            '${_tag(app.sourceId)} iconLocalPath file missing: ${app.iconLocalPath}',
          );
        }
      }

      final response = await _supabase.functions
          .invoke(
            _kEdgeFunctionName,
            body: {
              'sourceId': app.sourceId,
              'os': app.os.name,
              'appName': ?app.appName,
              'iconBase64': ?iconBase64,
            },
            method: HttpMethod.post,
          )
          .timeout(const Duration(seconds: 15));

      final data = response.data as Map<String, dynamic>?;
      final iconRemotePath = data?['iconRemotePath'] as String?;
      logger.d(
        '${_tag(app.sourceId)} sync success (hasRemoteIcon=${iconRemotePath != null})',
      );
      return Right(iconRemotePath);
    } catch (e) {
      logger.e('${_tag(app.sourceId)} sync exception: $e');
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<AppDirectoryEntry?> fetchEntry(String sourceId) async {
    try {
      logger.d('${_tag(sourceId)} fetchEntry start');
      final response = await _supabase
          .from(_kDirectoryTable)
          .select('os, iconRemoteUrl')
          .eq('sourceId', sourceId)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        logger.d('${_tag(sourceId)} fetchEntry miss');
        return const Right(null);
      }

      logger.d(
        '${_tag(sourceId)} fetchEntry hit (os=${response['os']}, hasRemoteIcon=${response['iconRemoteUrl'] != null})',
      );
      return Right(
        AppDirectoryEntry(
          sourceId: sourceId,
          os: PlatformOS.values.firstWhere(
            (e) => e.name == (response['os'] as String),
            orElse: () => PlatformOS.linux,
          ),
          iconRemoteUrl: response['iconRemoteUrl'] as String?,
        ),
      );
    } catch (e) {
      logger.w('${_tag(sourceId)} fetchEntry exception: $e');
      return Left(Failure.fromException(e));
    }
  }
}
