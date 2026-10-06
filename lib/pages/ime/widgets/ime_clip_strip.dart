import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart'
    show ClipboardSortKey;
import 'package:clipboard/base/enums/sort.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/ime/ime_service.dart';
import 'package:clipboard/pages/ime/widgets/ime_clip_card.dart';
import 'package:flutter/material.dart';

/// Horizontally scrollable strip of recent clips, filtered by [query].
/// Reads directly from the local [ClipboardRepository] (no cubit needed
/// in the IME engine context).
class ImeClipStrip extends StatefulWidget {
  final ImeService imeService;

  const ImeClipStrip({super.key, required this.imeService});

  @override
  State<ImeClipStrip> createState() => _ImeClipStripState();
}

class _ImeClipStripState extends State<ImeClipStrip> {
  static const _limit = 30;

  late final ClipboardRepository _repo = sl<ClipboardRepository>(
    instanceName: 'local',
  );

  List<ClipboardItem> _clips = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
    // Re-render when editor capabilities change (mime types affect card UI).
    widget.imeService.supportedMimeTypes.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(ImeClipStrip old) {
    super.didUpdateWidget(old);
  }

  @override
  void dispose() {
    widget.imeService.supportedMimeTypes.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  Future<void> _fetch() async {
    if (!mounted) return;
    setState(() => _loading = true);

    final result = await _repo.getList(
      limit: _limit,
      search: null,
      sortBy: ClipboardSortKey.modified,
      order: SortOrder.desc,
    );

    if (!mounted) return;
    result.fold(
      (failure) {
        debugPrint('IME getList failed: $failure');
        setState(() => _loading = false);
      },
      (page) => setState(() {
        _clips = page.results;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_loading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_clips.isEmpty) {
      return Center(
        child: Text(
          'No clips yet',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
      );
    }

    return GridView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 160,
      ),
      itemCount: _clips.length,
      itemBuilder: (context, index) =>
          ImeClipCard(clip: _clips[index], imeService: widget.imeService),
    );
  }
}
