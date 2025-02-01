import 'package:clipboard/pages/settings/pages/android_bg_clipboard/bullet_point.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawOverOtherAppNotice extends StatelessWidget {
  const DrawOverOtherAppNotice({super.key});

  Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => this,
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return AlertDialog(
      title: Text(context.locale.abc__overlay_perm_alert__title),
      titlePadding: const EdgeInsets.only(top: padding16, left: padding16),
      contentPadding: const EdgeInsets.all(padding16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.0,
        children: <Widget>[
          Text(
            context.locale.abc__overlay_perm_alert__subtitle,
            style: textTheme.bodyMedium,
          ),
          Padding(
            padding: const EdgeInsets.only(left: padding10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BulletPoint(
                  prefix: context.locale.abc__overlay_perm_alert__p1_prefix,
                  boldText: context.locale.abc__overlay_perm_alert__p1_bold,
                  suffix: context.locale.abc__overlay_perm_alert__p1_suffix,
                ),
                BulletPoint(
                  prefix: context.locale.abc__overlay_perm_alert__p2_prefix,
                  boldText: context.locale.abc__overlay_perm_alert__p2_bold,
                  suffix: context.locale.abc__overlay_perm_alert__p2_suffix,
                ),
                BulletPoint(
                  prefix: context.locale.abc__overlay_perm_alert__p3_prefix,
                  boldText: context.locale.abc__overlay_perm_alert__p3_bold,
                  suffix: context.locale.abc__overlay_perm_alert__p3_suffix,
                ),
                BulletPoint(
                  prefix: context.locale.abc__overlay_perm_alert__p4_prefix,
                  boldText: context.locale.abc__overlay_perm_alert__p4_bold,
                  suffix: context.locale.abc__overlay_perm_alert__p4_suffix,
                ),
              ],
            ),
          ),
          Text(
            context.locale.abc__overlay_perm_alert__agree,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(context.mlocale.cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () => context.pop(true),
          child: Text(context.locale.abc__perm_alert_open_setting__button),
        ),
      ],
    );
  }
}
