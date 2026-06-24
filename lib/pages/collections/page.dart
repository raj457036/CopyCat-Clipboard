import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/collections/widgets/appbar.dart';
import 'package:clipboard/pages/collections/widgets/collections_grid.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/appconfig_flag.dart';
import 'package:clipboard/widgets/layout/custom_scaffold.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/pro_tip_banner.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  late final ValueNotifier<String> _searchQuery;

  @override
  void initState() {
    super.initState();
    _searchQuery = ValueNotifier('');
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  void _updateSearchQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (_searchQuery.value == normalized) return;
    _searchQuery.value = normalized;
  }

  @override
  Widget build(BuildContext context) {
    final width = context.screenSize.width;
    final isMobile = Breakpoints.isMobile(width);
    final crossAxisCount = Breakpoints.on<int>(
      width,
      fallback: 1,
      tablet: 2,
      desktop: 3,
      largeDesktop: 4,
      ultraWide: 5,
    );
    return CustomScaffold(
      activeIndex: 1,
      appBar: CollectionAppBar(onQueryChanged: _updateSearchQuery),
      body: Column(
        children: [
          if (width > Breakpoints.xs)
            DisableForLocalUser(
              child: AppConfigBuilder(
                when: (c) => c.showCollectionTip,
                builder: (_) => TipTile(
                  tip: context.locale.collections__text__tip,
                  trailing: CloseButton(
                    onPressed: () =>
                        context.read<AppConfigCubit>().showCollectionTip(false),
                  ),
                ),
              ),
            ),
          Expanded(
            child: ScaffoldBody(
              child: ValueListenableBuilder<String>(
                valueListenable: _searchQuery,
                builder: (context, searchQuery, _) {
                  return CollectionsGrid(
                    searchQuery: searchQuery,
                    crossAxisCount: crossAxisCount,
                    isMobile: isMobile,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
