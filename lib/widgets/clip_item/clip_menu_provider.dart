import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/clip_item/clip_transform_menu_items.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipMenuProvider extends StatefulWidget {
  final Widget child;
  final ClipboardItem item;
  const ClipMenuProvider({super.key, required this.item, required this.child});

  @override
  State<ClipMenuProvider> createState() => _ClipMenuProviderState();
}

class _ClipMenuProviderState extends State<ClipMenuProvider> {
  late ClipboardItem _resolvedItem;
  bool _resolving = false;
  List<MenuItem> _menuItems = const [];

  @override
  void initState() {
    super.initState();
    _resolvedItem = widget.item;
  }

  @override
  void didUpdateWidget(covariant ClipMenuProvider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      _resolvedItem = widget.item;
    }
  }

  Future<void> _ensureResolvedItem() async {
    if (_resolving) return;
    if (!_resolvedItem.previewOnly || _resolvedItem.id == null) return;

    _resolving = true;
    final targetId = _resolvedItem.id!;
    final full = await context.read<OfflinePersistenceCubit>().getItem(
      id: targetId,
    );
    _resolving = false;

    if (!mounted || full == null) return;
    if (_resolvedItem.id != targetId) return;

    setState(() {
      _resolvedItem = full;
    });
  }

  List<MenuItem> _buildMenuItems(BuildContext context, ClipboardItem item) {
    final transformItems = buildSmartTransformMenuItems(context, item);
    return [
      MenuItem(
        icon: Icons.check_circle_outline_rounded,
        text: context.locale.app__select,
        section: 'Clip Actions',
        onPressed: () => selectClip(context, item),
      ),
      if (!item.inCache && !item.encrypted)
        MenuItem(
          icon: Icons.download_for_offline_outlined,
          text: context.locale.app__download,
          section: 'Clip Actions',
          onPressed: () => downloadFile(context, item),
        ),
      if (item.inCache && !item.encrypted)
        MenuItem(
          icon: Icons.copy,
          text: context.mlocale.copyButtonLabel.title,
          section: 'Clip Actions',
          onPressed: () => copyToClipboard(context, item),
        ),
      if (item.inCache && !item.encrypted)
        MenuItem(
          icon: Icons.ios_share,
          text: context.locale.app__share,
          section: 'Clip Actions',
          onPressed: () => shareClipboardItem(context, item),
        ),
      if (!item.encrypted)
        MenuItem(
          icon: Icons.edit_note_rounded,
          text: context.locale.app__preview,
          section: 'Clip Actions',
          onPressed: () => openClipPreview(context, item),
        ),
      if (item.type == ClipItemType.url && !item.encrypted)
        MenuItem(
          icon: Icons.open_in_new,
          text: context.locale.app__follow_link,
          onPressed: () => launchUrl(item),
        ),
      if ((item.type == ClipItemType.file || item.type == ClipItemType.media) &&
          item.inCache &&
          !item.encrypted)
        MenuItem(
          icon: Icons.save_alt_rounded,
          text: context.locale.app__export,
          section: 'Clip Actions',
          onPressed: () => copyToClipboard(context, item, saveFile: true),
        ),
      if ((item.type == ClipItemType.file || item.type == ClipItemType.media) &&
          item.inCache &&
          !item.encrypted)
        MenuItem(
          icon: Icons.open_in_new,
          text: context.locale.app__open_file,
          section: 'Clip Actions',
          onPressed: () => openFile(item),
        ),
      MenuItem(
        icon: Icons.collections_bookmark_outlined,
        text: context.locale.app__change_collection,
        section: 'Clip Actions',
        onPressed: () => changeCollection(context, [item]),
      ),
      if (!item.encrypted)
        MenuItem(
          icon: Icons.delete_outline,
          text: context.locale.app__delete,
          section: 'Clip Actions',
          onPressed: () => deleteClipboardItem(context, [item]),
        ),
      if (!item.encrypted) ...transformItems,
    ];
  }

  Future<void> _prepareMenuItems() async {
    await _ensureResolvedItem();
    if (!mounted) return;

    final menuItems = _buildMenuItems(context, _resolvedItem);
    setState(() {
      _menuItems = menuItems;
    });
  }

  void _clearMenuItems() {
    if (!mounted) return;
    if (_menuItems.isEmpty) return;
    setState(() {
      _menuItems = const [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Menu(
      onBeforeOpen: _prepareMenuItems,
      onAfterClose: _clearMenuItems,
      items: _menuItems,
      child: widget.child,
    );
  }
}
