enum WebDavProviderPreset {
  custom,
  koofr,
  pcloud,
  box,
  fastmail,
  nextcloud,
  owncloud,
  infinicloud,
  synology;

  String? get fixedUrl {
    switch (this) {
      case WebDavProviderPreset.koofr:
        return 'https://app.koofr.net/dav/Koofr';
      case WebDavProviderPreset.pcloud:
        return 'https://webdav.pcloud.com';
      case WebDavProviderPreset.box:
        return 'https://dav.box.com/dav';
      case WebDavProviderPreset.fastmail:
        return 'https://myfiles.fastmail.com/';
      case WebDavProviderPreset.custom:
      case WebDavProviderPreset.nextcloud:
      case WebDavProviderPreset.owncloud:
      case WebDavProviderPreset.infinicloud:
      case WebDavProviderPreset.synology:
        return null;
    }
  }

  String get defaultHint {
    switch (this) {
      case WebDavProviderPreset.koofr:
        return 'https://app.koofr.net/dav/Koofr';
      case WebDavProviderPreset.pcloud:
        return 'https://webdav.pcloud.com';
      case WebDavProviderPreset.box:
        return 'https://dav.box.com/dav';
      case WebDavProviderPreset.fastmail:
        return 'https://myfiles.fastmail.com/';
      case WebDavProviderPreset.nextcloud:
      case WebDavProviderPreset.owncloud:
        return 'https://your-domain.com/remote.php/dav/files/username/';
      case WebDavProviderPreset.infinicloud:
        return 'https://your-account.teracloud.jp/dav/';
      case WebDavProviderPreset.synology:
        return 'https://your-nas-ip:5006/';
      case WebDavProviderPreset.custom:
        return 'https://cloud.example.com/remote.php/dav/files/username/';
    }
  }

  String get displayName {
    switch (this) {
      case WebDavProviderPreset.custom:
        return 'Custom';
      case WebDavProviderPreset.koofr:
        return 'Koofr';
      case WebDavProviderPreset.pcloud:
        return 'pCloud';
      case WebDavProviderPreset.box:
        return 'Box';
      case WebDavProviderPreset.fastmail:
        return 'Fastmail';
      case WebDavProviderPreset.nextcloud:
        return 'Nextcloud';
      case WebDavProviderPreset.owncloud:
        return 'ownCloud';
      case WebDavProviderPreset.infinicloud:
        return 'InfiniCLOUD';
      case WebDavProviderPreset.synology:
        return 'Synology NAS';
    }
  }

  static WebDavProviderPreset detectFromUrl(String url) {
    final lower = url.trim().toLowerCase();
    if (lower.isEmpty) return WebDavProviderPreset.custom;
    if (lower.contains('koofr.net')) return WebDavProviderPreset.koofr;
    if (lower.contains('pcloud.com')) return WebDavProviderPreset.pcloud;
    if (lower.contains('box.com')) return WebDavProviderPreset.box;
    if (lower.contains('fastmail.com')) return WebDavProviderPreset.fastmail;
    if (lower.contains('teracloud.jp') || lower.contains('infinicloud')) {
      return WebDavProviderPreset.infinicloud;
    }
    if (lower.contains('/remote.php/')) return WebDavProviderPreset.nextcloud;
    if (lower.contains(':5006')) return WebDavProviderPreset.synology;
    return WebDavProviderPreset.custom;
  }
}
