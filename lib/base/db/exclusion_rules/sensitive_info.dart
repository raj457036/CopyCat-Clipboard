// Sensitive Info

import 'package:clipboard/base/db/exclusion_rules/exclusion_rules.dart';
import 'package:universal_io/io.dart';

final sensitiveExcludedApps = [
  // Password Managers
  AppInfo(name: "1Password", identifier: 'com.agilebits.onepassword'),
  AppInfo(name: "LastPass", identifier: 'com.lastpass.LastPass'),
  AppInfo(name: "Bitwarden", identifier: 'com.bitwarden.desktop'),
  AppInfo(name: "Dashlane", identifier: 'com.dashlane.Dashlane'),
  AppInfo(name: "Keeper", identifier: 'com.callpod.Keeper'),
  AppInfo(name: "System Settings", identifier: "com.apple.systempreferences"),

  // Common across platforms
  AppInfo(name: "PayPal", identifier: 'com.paypal.desktop'),

  // Linux-only (Password Managers)
  if (Platform.isLinux) ...[
    AppInfo(name: "KeePassXC", identifier: 'org.keepassxc.KeePassXC'),
    // Terminal-based apps that may handle sensitive info (Linux/Unix)
    AppInfo(name: "Gnome Keyring", identifier: 'org.gnome.keyring'),
    AppInfo(
      name: "KWallet",
      identifier: 'org.kde.kwalletd5',
    ), // KDE's password manager]
  ],

  // System Applications Handling Sensitive Data (macOS, Windows)
  if (Platform.isMacOS)
    AppInfo(
      name: "Keychain Access",
      identifier: 'com.apple.KeychainAccess',
    ), // macOS keychain

  if (Platform.isWindows)
    AppInfo(
      name: "Credential Manager",
      identifier: 'com.microsoft.windows.credentials',
    ), // Windows Credential Manager
];

const sensitiveTitlesKeywords = [
  "login",
  "sign in",
  "create account",
  "register",
  "signup",
  "signin",
  "password",
  "passwords",
  "1password",
  "lastpass",
  "bitwarden",
  "dashlane",
  "keeper",
  "secure",
  "verify",
  "authentication",
  "authorization",
  "account",
  "profile",
  "forgot",
  "recover",
  "reset",
  "change password",
  "update password",
  "PIN",
  "OTP",
  "2FA",
  "checkout",
  "payment",
  "transaction",
  "bank",
  "transfer",
  "wallet",
  "credit card",
  "debit card",
  "SSN",
  "confidential",
  "private",
  "secret",
  "sensitive",
  "secure message",
  "security question",
  "encrypted",
  "apply",
  "submit",
  "billing"
];
const sensitiveUrlKeywords = [
  "login",
  "auth",
  "authenticate",
  "signin",
  "oauth",
  "sso",
  "2fa",
  "mfa",
  "register",
  "signup",
  "1password",
  "lastpass",
  "bitwarden",
  "dashlane",
  "keeper",
  "create-account",
  "new-account",
  "join",
  "reset-password",
  "forgot-password",
  "change-password",
  "update-password",
  "password-recovery",
  "password-reset",
  "reset-password",
  "checkout",
  "payment",
  "billing",
  "transaction",
  "pay",
  "purchase",
  "order",
  "bank",
  "transfer",
  "wallet",
  "funds",
  "balance",
  "account-summary",
  "deposit",
  "withdraw",
  "card-payment",
  "secure",
  "confidential",
  "private",
  "ssn",
  "pin",
  "otp",
  "security-question",
  "profile",
  "account",
  "settings",
  "manage",
  "preferences",
  "netbanking",
  "securepayment",
  "paymentgateway",
];
