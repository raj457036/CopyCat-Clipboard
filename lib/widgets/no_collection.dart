import 'package:clipboard/widgets/empty.dart';
import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoCollectionAvailable extends StatelessWidget {
  const NoCollectionAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EmptyNote(note: context.locale.app__no_collection),
          height20,
          TextButton.icon(
            onPressed: () {
              context.pushNamed(
                RouteConstants.createEditCollection,
                pathParameters: {
                  "id": "new",
                },
              );
            },
            icon: const Icon(Icons.library_add),
            label: Text(context.locale.app__create_collection),
          ),
        ],
      ),
    );
  }
}
