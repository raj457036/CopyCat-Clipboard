import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Navigates to the collection edit page for creating a new collection.
void editClipCollection(BuildContext context, {required String collectionId}) {
  context.pushNamed(
    RouteConstants.createEditCollection,
    pathParameters: {"id": collectionId},
  );
}

/// Shows a confirmation dialog and deletes the collection if confirmed.
Future<void> deleteClipCollection(
  BuildContext context, {
  required ClipCollection collection,
}) async {
  final cubit = context.read<ClipCollectionCubit>();
  final confirm = await ConfirmDialog(
    title: context.locale.dialog__delete_collection__title(
      collectionName: collection.title,
    ),
    message: context.locale.dialog__delete_collection__subtitle,
  ).show(context);
  if (!confirm) return;
  cubit.delete(collection);
}
