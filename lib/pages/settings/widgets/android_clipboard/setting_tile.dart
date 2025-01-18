import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AndroidClipboardSettingListTile extends StatelessWidget {
  const AndroidClipboardSettingListTile({super.key});

  void openSetting(BuildContext context) {
    context.goNamed(RouteConstants.androidBgClipboardSettings);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.linear_scale_rounded),
      title: Text(context.locale.abc_title),
      subtitle: Text(context.locale.abc__tile__subtitle),
      trailing: const Icon(Icons.navigate_next),
      onTap: () => openSetting(context),
    );
  }
}
