import 'package:clipboard/base/bloc/app_lock_cubit/app_lock_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

class AppLockOverlay extends StatelessWidget {
  final Widget child;

  const AppLockOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final builder = BlocBuilder<AppLockCubit, AppLockState>(
      builder: (context, state) {
        if (state is AppLockUnlocked) return child;
        return const _LockScreen();
      },
    );

    // On desktop, blur the app window when the system auth dialog appears so
    // it receives focus immediately without requiring a click.
    if (!isDesktopPlatform) return builder;

    return BlocListener<AppLockCubit, AppLockState>(
      listenWhen: (_, curr) => curr is AppLockAuthenticating,
      listener: (_, _) {
        // windowManager.blur();
      },
      child: builder,
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_rounded,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              height24,
              Text(
                context.locale.app__name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              height8,
              Text(
                context.locale.app_lock__screen__locked,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              height32,
              FilledButton.icon(
                onPressed: () => context.read<AppLockCubit>().unlock(),
                icon: const Icon(Icons.fingerprint),
                label: Text(context.locale.app_lock__screen__unlock),
                autofocus: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
