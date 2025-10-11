import 'dart:async';

import 'package:copycat_base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:copycat_base/common/failure.dart';
import 'package:copycat_base/common/logging.dart';
import 'package:copycat_base/constants/key.dart';
import 'package:copycat_base/constants/strings/strings.dart';
import 'package:copycat_base/data/services/clipboard_service.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/snackbar.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:share_handler/share_handler.dart';
import "package:universal_io/io.dart";

class ShareListener {
  StreamSubscription? subscription;

  BuildContext get context => rootNavKey.currentContext!;
  ShareHandlerPlatform get handler => ShareHandlerPlatform.instance;

  void init() {
    if (!isMobilePlatform) return;
    dispose();
    initPlatformState();
    subscription = handler.sharedMediaStream.listen((SharedMedia media) async {
      logger.i("Received shared media: $media");

      try {
        await putMediaToClipboard(media);
        closeSnackbar();
      } catch (e) {
        if (context.mounted) {
          showTextSnackbar(
            context.locale.app__unknown_error,
            closePrevious: true,
          );
        }
      }
    }, onError: (error) {
      if (context.mounted) {
        showFailureSnackbar(Failure.fromException(error));
      }
    });
  }

  void dispose() {
    subscription?.cancel();
  }

  Future<void> initPlatformState() async {
    final media = await handler.getInitialSharedMedia();
    if (media != null) {
      logger.i("Received initial shared media!");
      await putMediaToClipboard(media);
      await handler.resetInitialSharedMedia();
    }
  }

  Future<ClipItem?> getFileClipItem(String path, String category) async {
    final ext = p.extension(path).replaceFirst(".", "");
    final fileName = p.basenameWithoutExtension(path);
    final (file, mimeType, size) = await writeToClipboardCacheFile(
      folder: category,
      ext: ext,
      fileName: fileName,
      file: File(path),
    );
    if (file != null) {
      ClipItem? clip;
      if (category == "medias") {
        clip = ClipItem.imageFile(
          file: file,
          mimeType: mimeType ?? "application/octet-stream",
          fileName: fileName,
          fileSize: size,
        );
      } else {
        clip = ClipItem.file(
          file: file,
          mimeType: mimeType ?? "application/octet-stream",
          fileName: fileName,
          fileSize: size,
        );
      }
      return clip;
    }
    return null;
  }

  Future<void> putMediaToClipboard(SharedMedia media) async {
    final clips = <ClipItem>[];

    if (media.content != null && media.content!.isNotEmpty) {
      final uri = Uri.tryParse(media.content!);

      final schema = uri?.scheme;

      /// ignore copycat app link
      if (schema == "clipboard") return;

      final isSupported = supportedUriSchemas.contains(schema);

      if (isSupported && uri != null) {
        final clip = ClipItem.uri(
          uri: uri,
        );
        clips.add(clip);
      } else {
        final (category, text) = getTextCategory(media.content!);
        final clip = ClipItem.text(text: text, textCategory: category);
        clips.add(clip);
      }
    }
    if (media.attachments != null) {
      for (final attachment in media.attachments!) {
        await processAttachment(attachment, clips);
      }
    }
    await processImageFilePath(media.imageFilePath, clips);

    if (context.mounted) {
      showSnackbar(context, isFile: media.attachments != null);
      await context
          .read<OfflinePersistenceCubit>()
          .onClips(clips, manualPaste: true);
    }
  }

  Future<void> processAttachment(
      SharedAttachment? attachment, List<ClipItem> clips) async {
    if (attachment == null) return;
    final category =
        attachment.type == SharedAttachmentType.file ? "files" : "medias";
    final clip = await getFileClipItem(attachment.path, category);
    if (clip != null) clips.add(clip);
  }

  Future<void> processImageFilePath(
      String? imageFilePath, List<ClipItem> clips) async {
    if (imageFilePath == null) return;
    final clip = await getFileClipItem(imageFilePath, "medias");
    if (clip != null) clips.add(clip);
  }

  void showSnackbar(BuildContext context, {bool isFile = false}) {
    if (Platform.isAndroid) {
      showTextSnackbar(
        context.locale.app__ack__done,
        closePrevious: true,
        duration: isFile ? 15 : 5,
        isProgress: true,
        action: SnackBarAction(
          label: context.locale.app__ack__quit_app,
          onPressed: () {
            SystemNavigator.pop(animated: true);
          },
        ),
      );
    }
  }
}
