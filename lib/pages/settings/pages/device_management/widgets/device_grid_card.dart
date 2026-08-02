import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/settings/pages/device_management/widgets/device_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceGridCard extends StatefulWidget {
  final SyncDeviceInfo device;
  final bool isCurrentDevice;
  final String lastSeenText;
  final Future<void> Function()? onRevoke;
  final Future<void> Function(String? name)? onRename;
  final bool isSavingName;
  final bool isRevoking;

  const DeviceGridCard({
    super.key,
    required this.device,
    required this.isCurrentDevice,
    required this.lastSeenText,
    required this.onRevoke,
    required this.onRename,
    required this.isSavingName,
    required this.isRevoking,
  });

  @override
  State<DeviceGridCard> createState() => _DeviceGridCardState();
}

class _DeviceGridCardState extends State<DeviceGridCard> {
  late final TextEditingController _nameController;
  late final FocusNode _nameFocusNode;
  bool _isEditingName = false;
  bool _isSubmittingName = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.device.name?.trim() ?? '',
    );
    _nameFocusNode = FocusNode();
    _nameFocusNode.addListener(_handleNameFocusChange);
  }

  @override
  void didUpdateWidget(covariant DeviceGridCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.device.deviceId != widget.device.deviceId ||
        oldWidget.device.name != widget.device.name) {
      _nameController.text = widget.device.name?.trim() ?? '';
    }
  }

  @override
  void dispose() {
    _nameFocusNode.removeListener(_handleNameFocusChange);
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _handleNameFocusChange() {
    if (!_nameFocusNode.hasFocus && _isEditingName && !_isSubmittingName) {
      _cancelEditing();
    }
  }

  Future<void> _submitName() async {
    if (widget.onRename == null) return;

    final trimmedName = _nameController.text.trim();
    final nextName = trimmedName.isEmpty ? null : trimmedName;
    final currentName = widget.device.name?.trim();

    if (nextName == currentName) {
      setState(() => _isEditingName = false);
      return;
    }

    setState(() => _isSubmittingName = true);
    await widget.onRename!(nextName);
    if (mounted) {
      setState(() => _isSubmittingName = false);
      setState(() => _isEditingName = false);
    }
  }

  void _startEditing() {
    if (widget.device.isRevoked) return;
    _nameController.text = widget.device.name?.trim() ?? '';
    _nameController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _nameController.text.length,
    );
    setState(() => _isEditingName = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _nameFocusNode.requestFocus();
      }
    });
  }

  void _cancelEditing() {
    _nameController.text = widget.device.name?.trim() ?? '';
    setState(() {
      _isEditingName = false;
      _isSubmittingName = false;
    });
  }

  String _displayName(SyncDeviceInfo device) {
    final explicitName = device.name?.trim();
    if (explicitName != null && explicitName.isNotEmpty) {
      return explicitName;
    }

    final platform = device.platform.toLowerCase();

    if (platform.contains('android')) {
      return device.deviceId.contains('tablet')
          ? 'Android Tablet'
          : 'Android Phone';
    }
    if (platform.contains('ios') || platform.contains('iphone')) {
      return 'iPhone';
    }
    if (platform.contains('ipad')) {
      return 'iPad';
    }
    if (platform.contains('macos')) {
      return 'Mac';
    }
    if (platform.contains('windows')) {
      return 'Windows';
    }
    if (platform.contains('linux')) {
      return 'Linux';
    }
    if (platform.contains('web')) {
      return 'Web';
    }
    return device.platform;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final titleColor = widget.device.isRevoked
        ? colorScheme.onSurface.withValues(alpha: 0.6)
        : colorScheme.onSurface;

    final subtitle = widget.device.isRevoked
        ? 'Revoked'
        : '${widget.lastSeenText} • ${widget.device.platform}';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      leading: Icon(
        _platformIcon(widget.device),
        color: widget.device.isRevoked
            ? colorScheme.onSurface.withValues(alpha: 0.5)
            : colorScheme.onSurfaceVariant,
      ),
      title: _isEditingName
          ? TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submitName(),
              onTapOutside: (_) => _cancelEditing(),
              inputFormatters: [LengthLimitingTextInputFormatter(40)],
              decoration: const InputDecoration(
                hintText: 'Device name',
                isDense: true,
                border: InputBorder.none,
                counterText: '',
              ),
            )
          : Text(
              _displayName(widget.device),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          DeviceStatusBadge(
            status: widget.isCurrentDevice
                ? DeviceStatusBadgeType.current
                : (widget.device.isRevoked
                      ? DeviceStatusBadgeType.revoked
                      : DeviceStatusBadgeType.active),
          ),
        ],
      ),
      trailing: _buildTrailingActions(context),
    );
  }

  Widget _buildTrailingActions(BuildContext context) {
    if (_isEditingName) {
      if (_isSubmittingName || widget.isSavingName) {
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      }

      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!widget.device.isRevoked)
          IconButton(
            tooltip: 'Edit name',
            icon: const Icon(Icons.edit_rounded),
            onPressed: widget.isSavingName ? null : _startEditing,
          ),
        if (widget.onRevoke != null)
          TextButton.icon(
            onPressed: widget.isRevoking || widget.device.isRevoked
                ? null
                : () async {
                    if (widget.onRevoke != null) {
                      await widget.onRevoke!();
                    }
                  },
            icon: widget.isRevoking
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.link_off_rounded, size: 16),
            label: Text(
              widget.isRevoking
                  ? 'Revoking…'
                  : context.locale.settings__device_card__revoke,
            ),
          ),
      ],
    );
  }

  IconData _platformIcon(SyncDeviceInfo device) {
    final platform = device.platform.toLowerCase();
    final id = device.deviceId.toLowerCase();

    if (platform.contains('android')) {
      if (id.contains('tablet') || id.contains('tab')) {
        return Icons.tablet_android_rounded;
      }
      return Icons.smartphone_rounded;
    }
    if (platform.contains('ios') || platform.contains('iphone')) {
      return Icons.phone_iphone_rounded;
    }
    if (platform.contains('ipad')) {
      return Icons.tablet_mac_rounded;
    }
    if (platform.contains('macos') || platform.contains('darwin')) {
      return Icons.laptop_mac_rounded;
    }
    if (platform.contains('windows')) {
      return Icons.desktop_windows_rounded;
    }
    if (platform.contains('linux')) {
      return Icons.computer_rounded;
    }
    if (platform.contains('web') || platform.contains('browser')) {
      return Icons.language_rounded;
    }
    return Icons.devices_other_rounded;
  }
}
