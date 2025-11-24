import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart' as app_info;
import 'package:installed_apps/installed_apps.dart';

class SelectInstalledAppSheet extends StatelessWidget {
  final Set<String> selectedApps;

  const SelectInstalledAppSheet({super.key, this.selectedApps = const {}});

  Future<app_info.AppInfo?> show(BuildContext context) {
    final mqSize = context.mq.size;
    return showModalBottomSheet<app_info.AppInfo>(
      context: context,
      constraints: BoxConstraints(
        maxWidth: mqSize.width * 0.9,
      ),
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return this;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Future<List<app_info.AppInfo>> apps = InstalledApps.getInstalledApps(
      true,
      true,
    );
    return DraggableScrollableSheet(
        expand: false,
        builder: (context, controller) {
          return FutureBuilder<List<app_info.AppInfo>>(
            future: apps,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              final apps = (snapshot.data ?? [])
                  .where((a) => !selectedApps.contains(a.packageName));
              return ListView.builder(
                controller: controller,
                itemCount: apps.length,
                itemBuilder: (context, index) {
                  final app = apps.elementAt(index);
                  return ListTile(
                    leading: app.icon != null
                        ? Image.memory(app.icon!, width: 28)
                        : const Icon(Icons.android_rounded),
                    title: Text(app.name),
                    subtitle: Text(app.packageName),
                    onTap: () {
                      Navigator.of(context).pop(app);
                    },
                  );
                },
              );
            },
          );
        });
  }
}
