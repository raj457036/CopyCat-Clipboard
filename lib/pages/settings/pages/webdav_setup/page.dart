import 'package:clipboard/base/bloc/webdav_setup_cubit/webdav_setup_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/domain/model/webdav_config/webdav_config.dart';
import 'package:clipboard/base/domain/model/webdav_config/webdav_provider_preset.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:clipboard/widgets/yarn_ball_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WebDavSetupPage extends StatefulWidget {
  const WebDavSetupPage({super.key});

  @override
  State<WebDavSetupPage> createState() => _WebDavSetupPageState();
}

class _WebDavSetupPageState extends State<WebDavSetupPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _serverUrlController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _basePathController;

  bool _obscurePassword = true;
  bool _allowSelfSigned = false;
  bool _autoCleanInactiveFiles = false;
  bool _isTesting = false;
  String? _testResult;
  bool _testSuccess = false;
  bool _initializedFromState = false;
  WebDavProviderPreset _selectedPreset = WebDavProviderPreset.custom;

  @override
  void initState() {
    super.initState();
    _serverUrlController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _basePathController = TextEditingController(text: defaultWebDavBasePath);
    _serverUrlController.addListener(_onServerUrlChanged);
  }

  @override
  void dispose() {
    _serverUrlController.removeListener(_onServerUrlChanged);
    _serverUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _basePathController.dispose();
    super.dispose();
  }

  void _onServerUrlChanged() {
    final detected =
        WebDavProviderPreset.detectFromUrl(_serverUrlController.text);
    if (detected != _selectedPreset) {
      setState(() {
        _selectedPreset = detected;
      });
    }
  }

  void _onPresetChanged(WebDavProviderPreset? preset) {
    if (preset == null) return;
    setState(() {
      _selectedPreset = preset;
      if (preset.fixedUrl != null) {
        _serverUrlController.text = preset.fixedUrl!;
      }
    });
  }

  void _populateFromConfig(WebDavConfig config) {
    if (_initializedFromState) return;
    _initializedFromState = true;
    _serverUrlController.text = config.serverUrl;
    _usernameController.text = config.username;
    _passwordController.text = config.password;
    _basePathController.text = config.basePath.isNotEmpty
        ? config.basePath
        : defaultWebDavBasePath;
    _allowSelfSigned = config.allowSelfSignedCert;
    _autoCleanInactiveFiles = config.autoCleanInactiveFiles;
    _selectedPreset = WebDavProviderPreset.detectFromUrl(config.serverUrl);
  }

  WebDavConfig _buildConfig() {
    return WebDavConfig(
      serverUrl: _serverUrlController.text.trim(),
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      basePath: _basePathController.text.trim().isEmpty
          ? defaultWebDavBasePath
          : _basePathController.text.trim(),
      allowSelfSignedCert: _allowSelfSigned,
      autoCleanInactiveFiles: _autoCleanInactiveFiles,
    );
  }

  Future<void> _onTestConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isTesting = true;
      _testResult = null;
      _testSuccess = false;
    });

    final cubit = context.read<WebDavSetupCubit>();
    final config = _buildConfig();
    final result = await cubit.testConnection(config);

    if (!mounted) return;

    setState(() {
      _isTesting = false;
      result.fold(
        (failure) {
          _testSuccess = false;
          _testResult = failure.message;
        },
        (_) {
          _testSuccess = true;
          _testResult = context.locale.settings__dialog__webdav__test_success;
        },
      );
    });
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<WebDavSetupCubit>();
    final config = _buildConfig();
    final success = await cubit.saveAndConnect(config);

    if (!mounted) return;

    if (success) {
      InAppNotificationService.i.notify(
        NotificationMessage.builder(
          builder: (context) => NotificationContent(
            body: 'WebDAV storage connected successfully.',
          ),
          id: 'webdav-setup-success',
        ),
      );
      context.pop();
    }
  }

  Future<void> _onDisconnect() async {
    final confirm = await const ConfirmDialog(
      title: 'Disconnect WebDAV',
      message:
          'Are you sure you want to disconnect WebDAV storage? Existing synced files will remain on your server.',
    ).show(context);

    if (!confirm || !mounted) return;

    final cubit = context.read<WebDavSetupCubit>();
    await cubit.disconnect();

    if (!mounted) return;
    InAppNotificationService.i.notify(
      NotificationMessage.builder(
        builder: (context) =>
            NotificationContent(body: 'WebDAV storage disconnected.'),
        id: 'webdav-disconnect-success',
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return BlocConsumer<WebDavSetupCubit, WebDavSetupState>(
      listener: (context, state) {
        if (state is WebDavSetupConfigured) {
          _populateFromConfig(state.config);
        } else if (state is WebDavSetupError && state.config != null) {
          _populateFromConfig(state.config!);
        }
      },
      builder: (context, state) {
        if (state is WebDavSetupConfigured && !_initializedFromState) {
          _populateFromConfig(state.config);
        }

        final isConfigured =
            state is WebDavSetupConfigured && state.config.password.isNotEmpty;
        final isLoading = state is WebDavSetupLoading;

        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Text(context.locale.settings__dialog__webdav__title),
          ),
          body: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 640,
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: padding16,
                    vertical: padding16,
                  ),
                  children: [
                    DropdownButtonFormField<WebDavProviderPreset>(
                      value: _selectedPreset,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(12),
                      menuMaxHeight: 350,
                      alignment: AlignmentDirectional.centerStart,
                      decoration: InputDecoration(
                        labelText: context
                            .locale
                            .settings__dialog__webdav__preset_provider,
                        border: const OutlineInputBorder(),
                      ),
                      items: WebDavProviderPreset.values.map((preset) {
                        return DropdownMenuItem(
                          value: preset,
                          child: Text(preset.displayName),
                        );
                      }).toList(),
                      onChanged: _onPresetChanged,
                    ),
                    height16,
                    TextFormField(
                      controller: _serverUrlController,
                      decoration: InputDecoration(
                        labelText:
                            context.locale.settings__dialog__webdav__server_url,
                        hintText: _selectedPreset.defaultHint,
                        helperText: _selectedPreset.fixedUrl == null
                            ? 'e.g. ${_selectedPreset.defaultHint}'
                            : null,
                        helperMaxLines: 2,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context
                              .locale
                              .settings__dialog__webdav__url_required;
                        }
                        final uri = Uri.tryParse(value.trim());
                        if (uri == null ||
                            !uri.hasScheme ||
                            (!value.trim().startsWith('http://') &&
                                !value.trim().startsWith('https://'))) {
                          return context
                              .locale
                              .settings__dialog__webdav__url_required;
                        }
                        return null;
                      },
                    ),
                    height16,
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText:
                            context.locale.settings__dialog__webdav__username,
                        border: const OutlineInputBorder(),
                      ),
                      autocorrect: false,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return context
                              .locale
                              .settings__dialog__webdav__username_required;
                        }
                        return null;
                      },
                    ),
                    height16,
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText:
                            context.locale.settings__dialog__webdav__password,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context
                              .locale
                              .settings__dialog__webdav__password_required;
                        }
                        return null;
                      },
                    ),
                    ExpansionTileTheme(
                      data: const ExpansionTileThemeData(
                        shape: RoundedRectangleBorder(),
                      ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                        ),
                        title: Text(
                          context.locale.settings__dialog__webdav__advanced,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.outline,
                          ),
                        ),
                        dense: true,
                        children: [
                          TextFormField(
                            controller: _basePathController,
                            enabled: !isConfigured,
                            decoration: InputDecoration(
                              labelText: context
                                  .locale
                                  .settings__dialog__webdav__base_path,
                              hintText: defaultWebDavBasePath,
                              helperText: isConfigured
                                  ? context
                                        .locale
                                        .settings__dialog__webdav__base_path_helper
                                  : null,
                              helperMaxLines: 2,
                              border: const OutlineInputBorder(),
                            ),
                            autocorrect: false,
                          ),
                          height12,
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              context
                                  .locale
                                  .settings__dialog__webdav__self_signed,
                            ),
                            value: _allowSelfSigned,
                            onChanged: (val) {
                              setState(() {
                                _allowSelfSigned = val;
                              });
                            },
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              context
                                  .locale
                                  .settings__dialog__webdav__auto_clean,
                            ),
                            subtitle: Text(
                              context
                                  .locale
                                  .settings__dialog__webdav__auto_clean_subtitle,
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.outline,
                              ),
                            ),
                            value: _autoCleanInactiveFiles,
                            onChanged: (val) {
                              setState(() {
                                _autoCleanInactiveFiles = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    height16,
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: (_isTesting || isLoading)
                              ? null
                              : _onTestConnection,
                          child: _isTesting
                              ? const YarnBallLoading(size: 16)
                              : Text(
                                  context
                                      .locale
                                      .settings__dialog__webdav__test_conn,
                                ),
                        ),
                        if (_testResult != null) ...[
                          width12,
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  _testSuccess
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.error_outline_rounded,
                                  color: _testSuccess
                                      ? colors.primary
                                      : colors.error,
                                  size: 18,
                                ),
                                width6,
                                Expanded(
                                  child: Text(
                                    _testResult!,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: _testSuccess
                                          ? colors.primary
                                          : colors.error,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    height32,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: padding12,
                      children: [
                        if (isConfigured)
                          TextButton(
                            onPressed: (isLoading || _isTesting)
                                ? null
                                : _onDisconnect,
                            style: TextButton.styleFrom(
                              foregroundColor: colors.error,
                            ),
                            child: Text(
                              context
                                  .locale
                                  .settings__dialog__webdav__disconnect,
                            ),
                          ),
                        FilledButton(
                          onPressed: (isLoading || _isTesting) ? null : _onSave,
                          child: isLoading
                              ? const YarnBallLoading(size: 16)
                              : Text(
                                  context.locale.settings__dialog__webdav__save,
                                  style: const TextStyle(
                                    fontVariations: fontVarW600,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
