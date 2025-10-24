const kLocalUserId = "local_user";
const klocalAuthKey = "auth__user_local_signed_in";

const supportedUriSchemas = {
  "http",
  "https",
  "ftp",
  "file",
  "mailto",
  "tel",
  "data",
  "ws",
  "wss",
  "ldap",
  "urn",
  "git",
  "ssh",
  "irc",
  "news"
};

const androidTestAdUnit = "ca-app-pub-3940256099942544/6300978111";
const iosTestAdUnit = "ca-app-pub-3940256099942544/2934735716";

const macAppcastUrl = String.fromEnvironment("MACOS_UPGRADE_APPCAST_URL");
const windowsAppcastUrl = String.fromEnvironment("WINDOWS_UPGRADE_APPCAST_URL");
const linuxAppcastUrl = String.fromEnvironment("LINUX_UPGRADE_APPCAST_URL");

const devMacAppcastUrl =
    String.fromEnvironment("DEV_MACOS_UPGRADE_APPCAST_URL");
const devWindowsAppcastUrl =
    String.fromEnvironment("DEV_WINDOWS_UPGRADE_APPCAST_URL");
const devLinuxAppcastUrl =
    String.fromEnvironment("DEV_LINUX_UPGRADE_APPCAST_URL");

const tutorialsUrl = String.fromEnvironment("TUTORIALS_URL");
const githubUrl = String.fromEnvironment("GITHUB_URL");
const websiteUrl = String.fromEnvironment("WEBSITE_URL");
const youtubePlaylistUrl = String.fromEnvironment("YOUTUBE_PLAYLIST_URL");
const supportUrl = String.fromEnvironment("SUPPORT_URL");
const discordUrl = String.fromEnvironment("DISCORD_URL");
const downloadUrl = String.fromEnvironment("DOWNLOAD_URL");
const smartPasteDemoVideo = String.fromEnvironment("SMART_PASTE_DEMO_VIDEO");
const keyboardShortcutDemoVideo =
    String.fromEnvironment("KEYBOARD_SHORTCUT_DEMO_VIDEO");

const googleOAuthClientID = String.fromEnvironment("GOOGLE_OAUTH_CLIENT_ID");

const dbName = "CopyCat-Clipboard-DB";

const sentryDSN = String.fromEnvironment("SENTRY_DSN");
