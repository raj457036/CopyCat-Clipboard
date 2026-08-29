part of 'webdav_setup_cubit.dart';

sealed class WebDavSetupState {
  const WebDavSetupState();
}

class WebDavSetupInitial extends WebDavSetupState {
  const WebDavSetupInitial();
}

class WebDavSetupLoading extends WebDavSetupState {
  const WebDavSetupLoading();
}

class WebDavSetupConfigured extends WebDavSetupState {
  final WebDavConfig config;
  const WebDavSetupConfigured({required this.config});
}

class WebDavSetupDisconnected extends WebDavSetupState {
  const WebDavSetupDisconnected();
}

class WebDavSetupError extends WebDavSetupState {
  final Failure failure;
  final WebDavConfig? config;
  const WebDavSetupError({required this.failure, this.config});
}
