import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:copycat_base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:copycat_base/bloc/cloud_persistance_cubit/cloud_persistance_cubit.dart';
import 'package:copycat_base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:copycat_base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:copycat_base/common/failure.dart';
import 'package:copycat_base/constants/key.dart';
import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:copycat_base/db/clip_collection/clipcollection.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> copyToClipboard(
  BuildContext context,
  ClipboardItem item, {
  bool saveFile = false,
  bool noAck = false,
}) async {
  try {
    final ctx = context.mounted ? context : rootNavKey.currentContext!;
    final cubit = ctx.read<OfflinePersistenceCubit>();
    final result = await cubit.copyToClipboard(item, saveFile: saveFile);
    if (!ctx.mounted) return;
    if (noAck) return;
    if (result) {
      showTextSnackbar(
        saveFile ? ctx.locale.exportSuccess : ctx.locale.copySuccess,
        closePrevious: true,
        context: ctx,
      );
    }
  } catch (e) {
    showTextSnackbar(
      "⭕️ Failed to copy. Something went wrong!",
      closePrevious: true,
      context: context,
    );
  }
}

Future<void> preview(BuildContext context, ClipboardItem item) async {
  final ctx = context.mounted ? context : rootNavKey.currentContext!;
  ctx.pushNamed(
    RouteConstants.preview,
    pathParameters: {
      "id": item.id.toString(),
    },
  );
}

Future<void> shareClipboardItem(
  BuildContext context,
  ClipboardItem item,
) async {
  final ctx = context.mounted ? context : rootNavKey.currentContext!;
  try {
    ctx.read<OfflinePersistenceCubit>().shareClipboardItem(ctx, item);
  } catch (e) {
    if (ctx.mounted) {
      showTextSnackbar(ctx.locale.failed);
    }
  }
}

Future<void> selectClip(
  BuildContext context,
  ClipboardItem item,
) async {
  final ctx = context.mounted ? context : rootNavKey.currentContext!;
  ctx.read<SelectedClipsCubit>().select(item);
}

Future<void> decryptItem(BuildContext context, ClipboardItem item) async {
  final persitCubit = context.read<OfflinePersistenceCubit>();
  final appConfig = context.read<AppConfigCubit>();
  if (!appConfig.isE2EESetupDone) {
    showFailureSnackbar(
      Failure(
        message: context.locale.e2eeNotSetup,
        code: "e2ee-no-setup",
      ),
    );
    return;
  }

  final item_ = await item.decrypt();
  persitCubit.persist([item_]);
}

Future<void> downloadFile(
  BuildContext context,
  ClipboardItem item,
) async {
  final ctx = context.mounted ? context : rootNavKey.currentContext!;
  ctx.read<CloudPersistanceCubit>().download(item);
}

Future<void> launchUrl(ClipboardItem item) async {
  if (item.url != null && Uri.tryParse(item.url!) != null) {
    await launchUrlString(item.url!);
  }
}

Future<ClipboardItem?> editTextContent(
    BuildContext context, ClipboardItem item) async {
  final ctx = context.mounted ? context : rootNavKey.currentContext!;
  return await ctx.pushNamed<ClipboardItem?>(
    RouteConstants.createClipNote,
    queryParameters: {
      "id": item.id.toString(),
    },
  );
}

Future<void> launchPhone(ClipboardItem item, {bool message = false}) async {
  if (message) {
    await launchUrlString("sms:${item.text}");
  } else {
    await launchUrlString("tel:${item.text}");
  }
}

Future<void> launchEmail(ClipboardItem item) async {
  await launchUrlString("mailto:${item.text}");
}

Future<void> pasteOnLastWindow(BuildContext context, ClipboardItem item) async {
  final focusManager = WindowFocusManager.of(context);
  focusManager?.toggleAndPaste(item);
}

Future<bool> deleteClipboardItem(
  BuildContext context,
  List<ClipboardItem> items,
) async {
  final ctx = context.mounted ? context : rootNavKey.currentContext!;
  final confirmation = await ConfirmDialog(
    title: context.locale.delete,
    message: context.locale.sureToDeleteItem,
  ).show(ctx);

  if (!confirmation) return false;

  // ignore: use_build_context_synchronously
  await ctx.read<CloudPersistanceCubit>().deleteMany(items);
  return true;
}

Future<void> openFile(ClipboardItem item) async {
  if (item.localPath != null) {
    final result = await OpenFilex.open(item.localPath!);

    switch (result.type) {
      case ResultType.error:
      case ResultType.noAppToOpen:
        final error =
            rootNavKey.currentContext?.locale.noAppFoundToHandleFile ??
                "No application found to open this file.";
        showTextSnackbar(error);
      case ResultType.permissionDenied:
        final error =
            rootNavKey.currentContext?.locale.fileOpenPermissionNotGranted ??
                "Permission to open this file not granted.";
        showTextSnackbar(error);
      case _:
    }
  }
}

Future<void> pasteContent(BuildContext context) async {
  showTextSnackbar(
    "Pasting to clipboard",
    isLoading: true,
    closePrevious: true,
  );
  final ctx = context.mounted ? context : rootNavKey.currentContext!;
  await ctx.read<OfflinePersistenceCubit>().paste();
  showTextSnackbar("Paste success", closePrevious: true);
}

Future<void> changeCollection(
    BuildContext context, List<ClipboardItem> items) async {
  final ctx = context.mounted ? context : rootNavKey.currentContext!;
  final cubit = ctx.read<OfflinePersistenceCubit>();

  final selectedCollectionId =
      items.isNotEmpty ? null : items.firstOrNull?.collectionId;

  final collection = await ctx.pushNamed<ClipCollection>(
    RouteConstants.clipCollectionSelection,
    queryParameters: {
      "id": selectedCollectionId.toString(),
    },
  );

  if (collection != null) {
    final updatedItems = items
        .map((item) => item.copyWith(
              collectionId: collection.id,
              serverCollectionId: collection.serverId,
            )..applyId(item))
        .toList();
    cubit.persist(updatedItems);
  }
}

Future<void> performPrimaryActionOnClip(
    BuildContext context, ClipboardItem item, bool canPaste) async {
  if (item.encrypted) {
    decryptItem(context, item);
  } else if (item.needDownload) {
    downloadFile(context, item);
  } else if (canPaste) {
    pasteOnLastWindow(context, item);
  } else {
    copyToClipboard(context, item);
  }
}
