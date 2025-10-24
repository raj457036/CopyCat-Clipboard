// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app__name => 'CopyCat Clipboard';

  @override
  String get app__slogan => 'One Clipboard, Limitless Possibility';

  @override
  String get app__unknown_error => 'An unexpected error occurred';

  @override
  String get app__downloading => 'Downloading...';

  @override
  String get app__download => 'Download';

  @override
  String get app__follow_link => 'Follow Link';

  @override
  String get app__edit => 'Edit';

  @override
  String get app__export => 'Export';

  @override
  String get app__delete => 'Delete';

  @override
  String get app__later => 'Skip';

  @override
  String get app__select => 'Select';

  @override
  String get app__change => 'Change';

  @override
  String get app__confirm => 'Confirm';

  @override
  String get app__action_required => 'Action Required';

  @override
  String get app__feature_unavailable =>
      'This feature is not available for your platform.';

  @override
  String get app__preview => 'Preview';

  @override
  String get app__open_file => 'Open file';

  @override
  String get app__change_collection => 'Change Collection';

  @override
  String get app__share => 'Share';

  @override
  String get app__uploading => 'Uploading...';

  @override
  String get app__syncing => 'Syncing...';

  @override
  String get app__sync => 'Sync';

  @override
  String get app__local => 'Local';

  @override
  String get app__send_message => 'Send Message';

  @override
  String get app__send_email => 'Send Email';

  @override
  String get app__empty_clipboard => 'Your clipboard is empty.';

  @override
  String get app__load_more => 'Fetch More';

  @override
  String get app__locale_en => 'English';

  @override
  String get app__locale_es => 'Spanish';

  @override
  String get app__locale_fr => 'French';

  @override
  String get app__locale_de => 'German';

  @override
  String get app__locale_zh => 'Chinese';

  @override
  String get app__locale_pt => 'Portuguese';

  @override
  String get app__language => 'Language';

  @override
  String get app__logout => 'Logout';

  @override
  String get app__no_collection => 'No Collection Found';

  @override
  String get app__create_collection => 'Create Collection';

  @override
  String get app__pro_tip => 'Pro Tip';

  @override
  String get app__try_again => 'Try Again';

  @override
  String get app__realtime_connected => 'Realtime Connected';

  @override
  String get app__realtime_disconnected => 'Realtime Disconnected';

  @override
  String get app__realtime_connecting => 'Realtime Connecting...';

  @override
  String get app__ack__exported => 'Exported';

  @override
  String get app__ack__copied => 'Copied';

  @override
  String get app__ack__pasted => 'Pasted';

  @override
  String get app__ack__pasting => 'Pasting';

  @override
  String get app__ack__done => 'Done';

  @override
  String get app__ack__quit_app => 'Quit App';

  @override
  String get app__ack__deleted => 'Deleted';

  @override
  String get app__ack__deleting => 'Deleting';

  @override
  String get app__ack__internet_connected => 'Internet Connected';

  @override
  String get app__ack__internet_disconnected => 'Internet Disconnected';

  @override
  String get app__ack__logout_success => 'You are successfully logged out.';

  @override
  String get app__ack__missing_e2e_setup => 'Missing encryption setup';

  @override
  String get app__ack__no_app_for_file =>
      'No application found to open this file.';

  @override
  String get app__ack__perm_fail_to_open_file =>
      'Permission to open this file not granted.';

  @override
  String get dialog__delete_clip__title => 'Delete Clip';

  @override
  String dialog__delete_clip__subtitle({required int itemCount}) {
    String _temp0 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      one: 'Are you sure you want to delete this clip?',
      other: 'Are you sure you want to delete these clips?',
    );
    return '$_temp0';
  }

  @override
  String get dialog__e2e__title => 'End to End Encryption';

  @override
  String get dialog__text__e2e_key_export =>
      'Congratulations, you have successfully configured the end-to-end encryption.';

  @override
  String get dialog__text__e2e_key_export__note =>
      'Click the button below to export your encryption key.\nSave the key in a secure location to ensure you can set up other devices to access your encrypted information.';

  @override
  String get dialog__text__e2e_key_generate =>
      'Generate an encryption key and store it securely. This key is required to set up other devices for accessing your encrypted data.';

  @override
  String get dialog__button__e2e_generating_key => 'Generating';

  @override
  String get dialog__button__e2e_generate_key => 'Generated';

  @override
  String get dialog__text__invalid_e2e_key => 'The imported key is invalid!';

  @override
  String get dialog__text__e2e_key_import__note =>
      'Import your encryption key below to access your encrypted data on this device.';

  @override
  String get dialog__button__e2e_importing_key => 'Importing';

  @override
  String get dialog__button__e2e_import_key => 'Import';

  @override
  String get dialog__text__inconsistent_time__title => 'Time Sync Warning';

  @override
  String get dialog__text__inconsistent_time__content =>
      'Inconsistent Device Time Detected\n\nTo ensure accurate clipboard syncing, please check and correct your device\'s time settings.\n\nInconsistent time settings may cause synchronization issues.';

  @override
  String get dialog__button__try_again => 'Check Again';

  @override
  String get dialog__record_keys__title => 'Record Keyboard Shortcut';

  @override
  String get dialog__record_keys__subtitle =>
      'Type your shortcut using your keyboard and click ';

  @override
  String dialog__delete_collection__title({required String collectionName}) {
    return 'Delete $collectionName';
  }

  @override
  String get dialog__delete_collection__subtitle =>
      'Are you sure to delete this collection?';

  @override
  String get dialog__ack__sub_updated => 'Subscription Updated';

  @override
  String get dialog__grant_entitlement__title => 'Granted Entitlement';

  @override
  String get dialog__grant_entitlement__subtitle_p1 =>
      'Granted Entitlement Codes are shared with specific individuals for custom entitlements. You can check if invitations are still available by ';

  @override
  String get dialog__grant_entitlement__subtitle_p2 => 'Clicking Here.';

  @override
  String get dialog__grant_entitlement__enter_code =>
      'Enter the code and press Submit';

  @override
  String get dialog__grant_entitlement__apply_code => 'Apply';

  @override
  String get view_button__switch_to_grid => 'Switch to Grid Layout';

  @override
  String get view_button__switch_to_list => 'Switch to List Layout';

  @override
  String get view_button__change_view => 'Change View';

  @override
  String get view_button__view_window => 'Windowed';

  @override
  String get view_button__view_dock_right => 'Dock Right';

  @override
  String get view_button__view_dock_bottom => 'Dock Bottom';

  @override
  String get view_button__view_dock_left => 'Dock Left';

  @override
  String get view_button__view_dock_top => 'Dock Top';

  @override
  String get view_button__pin => 'Pin to top';

  @override
  String get view_button__unpin => 'Unpin';

  @override
  String get sub_dialog__text__included => 'Included';

  @override
  String get sub_dialog__f1__title => 'Unlimited Clipboard Items';

  @override
  String get sub_dialog__f1__subtitle =>
      'Never run out of space with unlimited clipboard items, ensuring you always have access to your most recent copies.';

  @override
  String get sub_dialog__f2__title => 'Support all major platforms';

  @override
  String get sub_dialog__f2__subtitle =>
      'Seamlessly sync across all major platforms—Android, iOS, Windows, macOS, and Linux —for uninterrupted productivity anywhere.';

  @override
  String get sub_dialog__f3__title => 'Supports Apple Universal Clipboard';

  @override
  String get sub_dialog__f3__subtitle =>
      'Effortlessly transfer clipboard content between your Apple devices with support for Apple\'s Universal Clipboard.';

  @override
  String get sub_dialog__f4__title => 'On-Device Storage';

  @override
  String get sub_dialog__f4__subtitle =>
      'Keep your data secure with on-device storage, ensuring your clipboard items are always within reach and under your control.';

  @override
  String get sub_dialog__f5__title => 'Google Drive Integration';

  @override
  String get sub_dialog__f5__subtitle =>
      'Securely store files and media on Google Drive, integrating seamlessly with CopyCat Clipboard for enhanced data management.';

  @override
  String get sub_dialog__f6__title => 'Instant Search';

  @override
  String get sub_dialog__f6__subtitle =>
      'Find what you need instantly with powerful instant search capabilities, making retrieval of clipboard items fast and efficient.';

  @override
  String get sub_dialog__f7__title => 'Syncing Up to the Last 24 Hours';

  @override
  String get sub_dialog__f7__subtitle =>
      'Access and sync your clipboard history across all your devices for the past 24 hours. This ensures you never lose important copied items, making your workflow seamless and efficient.';

  @override
  String get sub_dialog__f8__title => 'Up to 3 Collections';

  @override
  String get sub_dialog__f8__subtitle =>
      'Organize your clipboard items into up to 3 collections, providing simple categorization for better workflow management.';

  @override
  String get sub_dialog__f9__title => 'Auto-Sync Every 45 Seconds';

  @override
  String get sub_dialog__f9__subtitle =>
      'Enjoy automatic syncing of clipboard items every 45 seconds, keeping your devices up-to-date without manual intervention.';

  @override
  String get sub_dialog__f10__title => 'Support End-to-End Encryption';

  @override
  String get sub_dialog__f10__subtitle =>
      'E2EE will make everything encrypted for superior privacy.';

  @override
  String get sub_dialog__text__pro_title => 'With PRO ✨';

  @override
  String get sub_dialog__text__pro_subtitle => 'Everything included in Free +';

  @override
  String get sub_dialog__f11__title => 'Up to 50 Collections';

  @override
  String get sub_dialog__f11__subtitle =>
      'Organize your clipboard items into up to 50 collections for ultimate management.';

  @override
  String get sub_dialog__f12__title => 'Syncing Up to the Last 30 Days';

  @override
  String get sub_dialog__f12__subtitle =>
      'Clipboard history is synced across all your devices for clips created within the last 30 days. This means you can access any clip you copied in the past month, no matter which device you are using.';

  @override
  String get sub_dialog__f13__title => 'Real Time Synchronization';

  @override
  String get sub_dialog__f13__subtitle => 'Experience lightning-fast syncing.';

  @override
  String get sub_dialog__f14__title => 'Faster and Priority Support';

  @override
  String get sub_dialog__f14__subtitle =>
      'Get prompt and prioritized support as a PRO user.';

  @override
  String get sub_dialog__f15__title => 'Early Access to New Features';

  @override
  String get sub_dialog__f15__subtitle =>
      'Be the first to try out new features and updates.';

  @override
  String get sub_dialog__f16__title => 'Custom Exclusion Rules';

  @override
  String get sub_dialog__f16__subtitle =>
      'Precise control over your clipboard. Allows you to define what to copy, from where to copy and when to copy.';

  @override
  String get sub_dialog__f17__title => 'Drag & Drop';

  @override
  String get sub_dialog__f17__subtitle =>
      'Seamlessly move items in any direction on your Desktop and Tablet devices.';

  @override
  String get sub_dialog__f18__title => 'Theming';

  @override
  String get sub_dialog__f18__subtitle =>
      'Customize the entire look and feel of the app to match your preferences.';

  @override
  String get paywall_dialog__text__month => 'month';

  @override
  String get paywall_dialog__text__year => 'year';

  @override
  String get paywall_dialog__text__subscription => 'Subscription';

  @override
  String get paywall_dialog__text__supported_platform =>
      'To access premium features on Copycat Clipboard, please subscribe through the Play Store or Apple App Store. Your subscription will be synced across all your devices, including Linux and Windows.';

  @override
  String get paywall_dialog__text__unlock_pro => 'Unlock CopyCat PRO';

  @override
  String get paywall_dialog__text__unlock_pro_p1 =>
      'Enjoy over 30 days of synced history, over 50 collections, end-to-end encryption, real-time syncing, access to the newest features, and much more.';

  @override
  String get paywall_dialog__text__try_again => 'Please try again';

  @override
  String get paywall_dialog__text__current_plan => 'Current Plan';

  @override
  String get paywall_dialog__text__expired_plan => 'Current Plan • Expired';

  @override
  String paywall_dialog__text__trial_till({required DateTime till}) {
    final intl.DateFormat tillDateFormat = intl.DateFormat.yMMMd(localeName);
    final String tillString = tillDateFormat.format(till);

    return 'Trial till $tillString';
  }

  @override
  String get paywall_dialog__text__upgrade => 'Upgrade';

  @override
  String fab__create_collection({required String remaining}) {
    return 'Create Collection ( $remaining Remaining )';
  }

  @override
  String get fab__sync => 'Sync';

  @override
  String get fab__sync_unavailable => 'Sync Unavailable';

  @override
  String get fab__sync_up_to_date => 'Already up to date.';

  @override
  String fab__sync_failed({required String message}) {
    return 'Sync failed : $message';
  }

  @override
  String get layout__navbar__clipboard => 'Clipboard';

  @override
  String get layout__navbar__collections => 'Collections';

  @override
  String get layout__navbar__settings => 'Settings';

  @override
  String get search__tooltip__filter => 'Search filters';

  @override
  String manage_sub__ack__promo_sub({required String till}) {
    return 'You are using a promo subscription till $till';
  }

  @override
  String get manage_sub__button__text => 'Manage Subscriptions';

  @override
  String get my_account__button__tooltip => 'My Account';

  @override
  String get badges__tooltip__experimental =>
      'This feature is experimental and might not work as expected.';

  @override
  String get badges__tooltip__pro_only =>
      'This feature is available for Pro users only.';

  @override
  String get collection_selector__tile__no_collection => 'No Collection';

  @override
  String get collection_selector__button__remove_collection =>
      'Remove Collection';

  @override
  String get dialog__logout__title => 'Logout';

  @override
  String get dialog__logout__subtitle =>
      '⚠️ WARNING ⚠️\n\nLogging out will delete unsynced changes in the local database. Are you sure you want to proceed?';

  @override
  String get dialog__logging_out__ack => 'Logging you out! Please wait...';

  @override
  String get reset_pass__text__label => 'Reset your password';

  @override
  String get dnd__text__drop_here => 'Drop Here';

  @override
  String dnd__ack__error_max_drop_count({required int count}) {
    return 'Maximum $count drop items are allowed at once.';
  }

  @override
  String get search_filter__text__title => 'Filters';

  @override
  String get search_filter__button__apply => 'Apply';

  @override
  String get search_filter__text__from => 'From';

  @override
  String get search_filter__text__select => 'Select';

  @override
  String get search_filter__text__to => 'To';

  @override
  String get search_filter__text__now => 'Now';

  @override
  String get search_filter__text__including => 'Including';

  @override
  String get search_filter__chip__text => 'Text';

  @override
  String get search_filter__chip__url => 'URL';

  @override
  String get search_filter__chip__media => 'Media';

  @override
  String get search_filter__chip__docs => 'Docs';

  @override
  String get search_filter__text__textCategories => 'Text Categories';

  @override
  String get search_filter__text__exclusive => '( Exclusive )';

  @override
  String get search_filter__text_cat__email => 'Email';

  @override
  String get search_filter__text_cat__phone => 'Phone';

  @override
  String get search_filter__text_cat__color => 'Color';

  @override
  String get search_filter__text__sort_by => 'Sort By';

  @override
  String get search_filter__sort_by__last_mod => 'Last Modified';

  @override
  String get search_filter__sort_by__created => 'Created';

  @override
  String get search_filter__sort_by__copy_count => 'Copy Count';

  @override
  String get search_filter__sort_by__last_copied => 'Last Copied';

  @override
  String get search_filter__text__sort_order => 'Sort Order';

  @override
  String get search_filter__sort_ord__asc => 'Asc';

  @override
  String get search_filter__sort_ord__desc => 'Desc';

  @override
  String get login__local_signin__tooltip =>
      'No syncing. All data stays on your device.';

  @override
  String get login__local_signin__btn__label => 'Use Locally';

  @override
  String get login__form__input__name => 'Enter your good name';

  @override
  String get login__form__input__email => 'Enter your email';

  @override
  String get login__form__input__error_email =>
      'Please enter a valid email address';

  @override
  String get login__form__input__password => 'Enter your password';

  @override
  String get login__form__input__error_password_length =>
      'Please enter a password that is at least 6 characters long';

  @override
  String get login__form__button__signin => 'Sign In';

  @override
  String get login__form__button__signup => 'Sign Up';

  @override
  String get login__form__button__forgot_password => 'Forgot your password?';

  @override
  String get login__form__text__signup => 'Don\'t have an account? Sign up';

  @override
  String get login__form__text__old_user => 'Already have an account? Sign in';

  @override
  String get login__form__text__reset_password => 'Send password reset email';

  @override
  String get login__form__text__reset_ack =>
      'Password reset email has been sent';

  @override
  String get login__form__button__back => 'Back to sign in';

  @override
  String get login__form__button__update_password => 'Update Password';

  @override
  String get login__form__text_tnc_p1 =>
      'By continuing you agree to the following ';

  @override
  String get login__form__text_tnc_p2 => 'Privacy policies';

  @override
  String get login__form__text_tnc_p3 => ' and ';

  @override
  String get login__form__text_tnc_p4 => 'Terms of Service.';

  @override
  String get home__search__hint => 'Search in clipboard';

  @override
  String get home__search__reset => 'Reset Search';

  @override
  String get preview__vert_view__tab1_title => 'Preview';

  @override
  String get preview__vert_view__tab2__title => 'Details';

  @override
  String get preview__card__missing_text => 'This is an Empty Clip';

  @override
  String get preview__card__video__play => 'Play Video';

  @override
  String get preview__card__file__open => 'Open File';

  @override
  String get preview__form__title => 'Edit Details';

  @override
  String get preview__form__input__title => 'Title';

  @override
  String get preview__form__input__description => 'Description';

  @override
  String get reset_password__appbar__title => 'Reset your password';

  @override
  String get reset_password__success_ack => 'Password reset successfully';

  @override
  String get onboarding__text__welcome => 'Welcome to';

  @override
  String get onboarding__text__lets_continue => 'Let\'s Continue';

  @override
  String get onboarding__button__to_login => 'Sign in';

  @override
  String get onboarding__snackbar__export_success =>
      'Encryption key successfully exported.';

  @override
  String get onboarding__dialog__skip_export__title =>
      '✋ Backup Your Encryption Key';

  @override
  String get onboarding__dialog__skip_export__subtitle =>
      'You haven’t exported your encryption key yet. Without a backup, you won’t be able to access your encrypted clips if the key is lost or you switch devices.\n\n👉 If you already have a secure backup of your key, you can safely continue. Otherwise, we strongly recommend exporting the key now to avoid data loss. Do you still want to continue?';

  @override
  String get onboarding__dialog__export_info__title =>
      '🤔 Why Export the Encryption Key?';

  @override
  String get onboarding__dialog__export_info__subtitle =>
      'Exporting your encryption key is essential for securely accessing your encrypted data on multiple devices. Without the key, your encrypted data will remain inaccessible after sync.\n\nKeep a backup of your encryption key in a secure location to prevent data loss. Remember, the key is unique to your account and cannot be recovered if lost.\n\nNote: Copycat cannot access your encrypted clips or your encryption keys. This is because we value your privacy above everything else.';

  @override
  String get onboarding__text__export_key_headline => 'Clipboard Encryption';

  @override
  String get onboarding__text__export_key_title =>
      '💪 Great News! Encryption is active for your clipboard';

  @override
  String get onboarding__button__export_key => 'Export Key';

  @override
  String get onboarding__dialog__skip_gen_key__title =>
      '✋ Your Clips Will Be Insecure';

  @override
  String get onboarding__dialog__skip_gen_key__subtitle =>
      'You haven’t generated an encryption key yet. Without it, your clips will remain unencrypted and insecure. You can generate the key later in Settings ❯ Security. Do you still want to continue?';

  @override
  String get onboarding__dialog__gen_key_info__title =>
      '🤔 Why Do I Need Encryption?';

  @override
  String get onboarding__dialog__gen_key_info__subtitle =>
      'Encryption protects your data by converting it into a secure format that can only be accessed with a key. Without encryption, your clips are stored in plain text, making them vulnerable to unauthorized access. Enabling encryption ensures that only you can access your sensitive data, providing an extra layer of security against potential breaches.';

  @override
  String get onboarding__text__gen_key_headline => 'Setup Clipboard Encryption';

  @override
  String onboarding__text__key_generated_title({required String keyPreview}) {
    return '🎉 Key $keyPreview*** successfully generated 🎉';
  }

  @override
  String get onboarding__button__regenerate_key => 'Re-Generate Key';

  @override
  String get onboarding__text__no_key =>
      'Your account doesn\'t have any encryption key';

  @override
  String get onboarding__button__generate_key => 'Generate Key';

  @override
  String get onboarding__button__do_it_later => 'Do it later';

  @override
  String get onboarding__button__why_important => 'Why It\'s Important?';

  @override
  String get onboarding__snackbar__invalid_key =>
      'This is not a valid CopyCat encryption key';

  @override
  String get onboarding__dialog__skip_import__title =>
      '✋ Encrypted Clips Inaccessible';

  @override
  String get onboarding__dialog__skip_import__subtitle =>
      'You haven’t imported the encryption key yet. This means all your encrypted clips will remain inaccessible locally after sync.\n\nTo access them, import the key from Settings ❯ Security.\nDo you still want to continue?';

  @override
  String get onboarding__dialog__reset_key__title =>
      '✋ Permanently Delete Encrypted Data';

  @override
  String get onboarding__dialog__reset_key__subtitle =>
      'This action is irreversible. Are you sure you want to permanently delete all encrypted data from the server?';

  @override
  String get onboarding__snackbar__reset_key__success =>
      'Encryption successfully removed.';

  @override
  String get onboarding__dialog__import_info__title => '🤔 Where is my key?';

  @override
  String get onboarding__dialog__import_info__subtitle =>
      'Your encryption key is a secure file generated during the encryption setup process. If you’ve misplaced it, check your downloads folder or any backup location where you might have saved it. Without this key, your encrypted data cannot be accessed.\n\nIf you’ve set up the encryption key on another device, you can export it by going to Settings ❯ Security ❯ E2EE Vault on that device. Transfer the key securely to this device to regain access to your encrypted data.';

  @override
  String get onboarding__text__import_key_headline =>
      'Import Clipboard Encryption Key';

  @override
  String get onboarding__text__import_key_title =>
      'Your account currently has active encryption.';

  @override
  String get onboarding__button__import_key => 'Import Key';

  @override
  String get onboarding__button__reset_key => 'Reset Encryption';

  @override
  String get onboarding__button__where_key => 'Where is the key?';

  @override
  String get onboarding__text__go_home => 'Let\'s go home';

  @override
  String onboarding__restoration__failed({required String message}) {
    return 'Restoration failed: $message';
  }

  @override
  String get onboarding__restoration_warning =>
      '⚠️ Please keep this screen open during syncing to avoid data corruption or inconsistencies.';

  @override
  String get restore_clips__text__title => 'Restore My Clipboard';

  @override
  String get restore_clips__error__no_backup => 'No clipboard backup found';

  @override
  String restore_clips__text__total_count({required int totalCount}) {
    String _temp0 = intl.Intl.pluralLogic(
      totalCount,
      locale: localeName,
      zero: 'clip',
      one: 'clip',
      other: 'clips',
    );
    return 'You have approximately $totalCount $_temp0 to restore.';
  }

  @override
  String get restore_clips__sync_disable =>
      'Syncing is currently disabled. Please enable it to continue.';

  @override
  String get restore_clips__preparing =>
      'Preparing to restore clips. Please wait...';

  @override
  String restore_clips__restored({required int syncCount}) {
    String _temp0 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      zero: 'clip',
      one: 'clip',
      other: 'clips',
    );
    return 'Your $syncCount $_temp0 have been restored successfully.';
  }

  @override
  String restore_clips__restoring(
      {required int synced, required int totalCount}) {
    return 'Restored: $synced of $totalCount clips.';
  }

  @override
  String get restore_collections__text__title => 'Restore My Collections';

  @override
  String get restore_collections__error__no_backup =>
      'No collection backup found';

  @override
  String restore_collections__text__total_count({required int totalCount}) {
    String _temp0 = intl.Intl.pluralLogic(
      totalCount,
      locale: localeName,
      zero: 'collection',
      one: 'collection',
      other: 'collections',
    );
    return 'You have approximately $totalCount $_temp0 to restore.';
  }

  @override
  String get restore_collections__sync_disable =>
      'Syncing is currently disabled. Please enable it to continue.';

  @override
  String get restore_collections__preparing =>
      'Preparing to restore collections. Please wait...';

  @override
  String restore_collections__restored({required int syncCount}) {
    String _temp0 = intl.Intl.pluralLogic(
      syncCount,
      locale: localeName,
      zero: 'collection',
      one: 'collection',
      other: 'collections',
    );
    return 'Your $syncCount $_temp0 have been restored successfully.';
  }

  @override
  String restore_collections__restoring(
      {required int synced, required int totalCount}) {
    return 'Restored: $synced of $totalCount collections.';
  }

  @override
  String get drive__snackbar__success => 'Drive Setup is Now Complete.';

  @override
  String get drive__text__setting_up => 'Setting up and syncing...';

  @override
  String get drive__text__setting_up__warning =>
      'Please wait while we finish this up. Do not close the app.';

  @override
  String get create_clip__appbar__title__new => 'New Clip';

  @override
  String get create_clip__appbar__title__edit => 'Edit Clip';

  @override
  String get create_clip__button__save_new => 'Save as new';

  @override
  String get create_clip__input__hint => 'Write your clip content here';

  @override
  String get collections__text__tip =>
      'To ensure your important clips are always available regardless of time, across all your devices, save them in a collection!';

  @override
  String get collections__appbar__title => 'Collections';

  @override
  String get collections__appbar__title__create => 'Create Collection';

  @override
  String get collections__appbar__title__edit => 'Edit Collection';

  @override
  String get collections__input__name => 'Name';

  @override
  String get collections__input__description => 'Description';

  @override
  String get select_collection__appbar__title => 'Select Collection';

  @override
  String get account__dialog__delete_confirm__title => 'Account Delete Request';

  @override
  String get account__dialog__delete_confirm__description =>
      'You will be redirected to the account delete request form, are you sure?';

  @override
  String get account__list_tile__display_name => 'Display Name';

  @override
  String get account__list_tile__email => 'Email';

  @override
  String get account__list_tile__settings => 'Account Settings';

  @override
  String get account__list_tile__danger_zone => 'Danger Zone';

  @override
  String get account__button__req_delete => 'Request Account Deletion';

  @override
  String get account__appbar__title => 'My Account';

  @override
  String get settings__appbar__title => 'Settings';

  @override
  String get settings__tab__1 => 'General';

  @override
  String get settings__tab__2 => 'Customization';

  @override
  String get settings__tab__3 => 'Syncing';

  @override
  String get settings__tab__4 => 'Encryption';

  @override
  String get settings__tab__5 => 'Experimental';

  @override
  String get settings__text__encryption => 'Encryption';

  @override
  String get settings__text__sync_not_available =>
      'Sync-related configurations are not available while using the local clipboard.';

  @override
  String get settings__appbar__er__title => 'Exclusion Rules';

  @override
  String get settings__text__er__predefine => 'Predefined Exclusion Rules';

  @override
  String get settings__text__er__pass_manager => 'Password Managers';

  @override
  String get settings__text__er__cc => 'Credit Card Number';

  @override
  String get settings__text__er__phone => 'Phone number';

  @override
  String get settings__text__er__email => 'Email Address';

  @override
  String get settings__text__er__url => 'Sensitive Url';

  @override
  String get settings__text__decrypted__note =>
      '🥳 Congratulations! All your clips have been successfully decrypted locally,\n so rebuilding the database is not required.';

  @override
  String get settings__appbar__cer__title => 'Custom Exclusion Rules';

  @override
  String get settings__switch__drag_n_drop__title => 'Drag and Drop';

  @override
  String get settings__switch__drag_n_drop__subtitle =>
      'Allow items to be moved freely in both directions within the app.';

  @override
  String get settings__dropdown__no_copy_over_limit__title =>
      'Don\'t Auto Copy Over';

  @override
  String settings__dropdown__no_copy_over_limit__subtitle(
      {required String fileSize}) {
    return 'Files and Media over a certain size ($fileSize) will not be copied automatically.';
  }

  @override
  String get settings__text__5MB => '5 MB';

  @override
  String get settings__text__10MB => '10 MB';

  @override
  String get settings__text__20MB => '20 MB';

  @override
  String get settings__text__50MB => '50 MB';

  @override
  String get settings__text__100MB => '100 MB';

  @override
  String get settings__dropdown__no_upload_over_limit__title =>
      'Don\'t Auto Upload Over';

  @override
  String settings__dropdown__no_upload_over_limit__subtitle(
      {required String fileSize}) {
    return 'Files and Media over a certain size ($fileSize) will not be uploaded automatically.';
  }

  @override
  String get settings__dropdown__sync_mode__title => 'Sync Mode';

  @override
  String get settings__dropdown__sync_mode__subtitle =>
      'Select the syncing speed that works best for you.';

  @override
  String get settings__sync_mode__realtime => 'Realtime';

  @override
  String get settings__sync_mode__balanced => 'Balanced';

  @override
  String get settings__dropdown__theme__title => 'Theme Mode';

  @override
  String get settings__theme__system => 'System';

  @override
  String get settings__theme__light => 'Light';

  @override
  String get settings__theme__dark => 'Dark';

  @override
  String get settings__dropdown__color_mode__title => 'Color Mode';

  @override
  String get settings__dropdown__color_mode__subtitle =>
      'Select the color mode to customize the appearance of the app. The default option is \'Tonal Spot\'.';

  @override
  String get settings__color_mode__tonalSpot => 'Tonal Spot';

  @override
  String get settings__color_mode__content => 'Content';

  @override
  String get settings__color_mode__expressive => 'Expressive';

  @override
  String get settings__color_mode__fidelity => 'Fidelity';

  @override
  String get settings__color_mode__fruit_salad => 'Fruit Salad';

  @override
  String get settings__color_mode__monochrome => 'Monochrome';

  @override
  String get settings__color_mode__neutral => 'Neutral';

  @override
  String get settings__color_mode__rainbow => 'Rainbow';

  @override
  String get settings__color_mode__vibrant => 'Vibrant';

  @override
  String get settings__tile__cer_title => 'Custom Rules';

  @override
  String get settings__tile__cer_subtitle =>
      'Exclude by app, app window/website title, website url or regex pattern';

  @override
  String get settings__tile__er_title => 'Exclusion Rules';

  @override
  String get settings__tile__er_subtitle =>
      'Prevent information from copying to clipboard. Click for Advance control.';

  @override
  String get settings__switch__enable_sync__title => 'Clipboard Syncing';

  @override
  String get settings__switch__enable_sync__subtitle =>
      'Sync your clipboard across devices effortlessly.';

  @override
  String get settings__switch__sync_file__title => 'File and Media Syncing';

  @override
  String get settings__switch__sync_file__subtitle =>
      'Toggle to sync files and media clips across devices.';

  @override
  String get settings__switch__paused__title => 'Pause Clipboard Listener';

  @override
  String get settings__switch__paused__subtitle =>
      'Temporarily pause clipboard tracking until a set time.';

  @override
  String settings__switch__paused_active__subtitle({required DateTime time}) {
    final intl.DateFormat timeDateFormat =
        intl.DateFormat('h:mm a', localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Paused until $timeString. Tap to resume or adjust the time.';
  }

  @override
  String get settings__switch__smart_paste__title => 'Smart Paste';

  @override
  String get settings__switch__smart_paste__subtitle =>
      'Paste content directly on the focused app.';

  @override
  String get settings__switch__startup__title => 'Launch at Startup';

  @override
  String get settings__switch__startup__subtitle =>
      'Automatically start the CopyCat when your device powers on.';

  @override
  String get settings__switch__hotkey__title => 'Toggle with Hotkey';

  @override
  String get settings__switch__hotkey__subtitle =>
      'Use a keyboard shortcut to quickly access your CopyCat Clipboard';

  @override
  String get settings__hotkey__unassigned => 'Not Assigned';

  @override
  String get settings__hotkey__preview_start => 'Press ';

  @override
  String get settings__hotkey__preview_end => ' to show or hide the app.';

  @override
  String get settings__tile__theme_color__title => 'Theme Color';

  @override
  String get settings__tile__theme_color__subtitle =>
      'This color will influence the overall look and feel of the app.';

  @override
  String get settings__tile__desk_client__title => 'Download Desktop Client';

  @override
  String get settings__tile__mobile_client__title => 'Download Phone Client';

  @override
  String get settings__tile__client__subtitle =>
      'Access your clipboard on all your devices.';

  @override
  String get settings__tile__e2e_setup__title => 'End to End Encryption Setup';

  @override
  String get settings__tile__e2e_setup__subtitle =>
      'Configure encryption for your clips.';

  @override
  String get settings__switch__e2e__title => 'Enable Encryption';

  @override
  String get settings__switch__e2e__subtitle =>
      'Toggle to activate or deactivate end-to-end encryption for your clips.';

  @override
  String get settings__dialog__conn_gdrive__title => 'Re-Connect Google Drive?';

  @override
  String get settings__dialog__conn_gdrive__subtitle =>
      'Your google drive is already connected! Would you like to reconnect?\n\nTo avoid any data loss, please ensure you use the same account as before.';

  @override
  String get settings__drive__connected => 'Connected';

  @override
  String get settings__drive__loading => 'Loading...';

  @override
  String get settings__drive__authorizing => 'Authorizing...';

  @override
  String get settings__drive__disconnected => 'Disconnected';

  @override
  String get settings__text__cloud__title => 'Cloud Drive';

  @override
  String get settings__text__cloud__name => 'Google Drive';

  @override
  String get settings__text__gdrive__error =>
      'Google Drive is not connected. File and media syncing are currently disabled.';

  @override
  String get settings__text__gdrive__info =>
      'Your files and media are securely synced across devices via Google Drive, ensuring your privacy is protected.';

  @override
  String get settings__tile__other_cloud__title => 'Setup Other Cloud Drive';

  @override
  String get settings__tile__other_cloud__subtitle =>
      'Setup other cloud drives like Dropbox, OneDrive, etc.';

  @override
  String get custom_er__nav__1 => 'App';

  @override
  String get custom_er__nav__2 => 'Window Title';

  @override
  String get custom_er__nav__3 => 'Url';

  @override
  String get custom_er__nav__4 => 'Text Pattern';

  @override
  String get custom_er__text__not_supported =>
      'This exclusion is not supported yet';

  @override
  String get custom_er__tile__add_app => 'Add an app';

  @override
  String get custom_er__text__no_app => 'No custom app excluded yet';

  @override
  String get custom_er__button__remove_app => 'Remove this app';

  @override
  String get custom_er__tile__pattern =>
      'Prevent copy when copied content matches these patterns';

  @override
  String get custom_er__text__no_pattern => 'No custom pattern(s) excluded';

  @override
  String get custom_er__button__remove_pattern => 'Remove this pattern';

  @override
  String get custom_er__tile__url =>
      'Prevent copy from website matching these url segments.';

  @override
  String get custom_er__input__url_hint => 'Enter a url or part of a url here.';

  @override
  String get custom_er__text__no_url => 'No custom url(s) excluded';

  @override
  String get custom_er__button__remove_url => 'Remove this url';

  @override
  String get custom_er__tile__title =>
      'Prevent copy from app or website when window title matches.';

  @override
  String get custom_er__text__no_title => 'No custom title(s) excluded';

  @override
  String get custom_er__button__remove_title => 'Remove this title';

  @override
  String get about__tile__discord => 'Discord • Connect';

  @override
  String get about__tile__youtube => 'YouTube • Tutorial';

  @override
  String get about__tile__read_tut => 'Read • Tutorial';

  @override
  String get about__tile__github => 'Github • Open Source';

  @override
  String get about__tile__website => 'EntilityStudio • Website';

  @override
  String get about__tile__support => 'Support';

  @override
  String get abc_title => 'Background Clipboard';

  @override
  String get abc__tile__subtitle => 'Listen to the clipboard in the background';

  @override
  String get abc__tip__why_title => 'Why are these permissions needed?';

  @override
  String get abc__tip__why_subtitle =>
      'These permissions ensure CopyCat works correctly in the background, allowing it to detect copied content and provide you with a seamless experience without interruptions.';

  @override
  String get abc__tip__support_title => 'Limited Support';

  @override
  String get abc__tip__support_subtitle =>
      '1. Currently, only text clips are supported.\n2. Some operating systems, like HyperOS 1, are not supported yet.';

  @override
  String get abc__heading__req_perm => 'Required Permissions';

  @override
  String get abc__tile__notification_title => 'Notification Access';

  @override
  String get abc__tile__notification_subtitle =>
      'Displays a persistent notification to inform you that CopyCat is running in the background, ensuring transparency and privacy.';

  @override
  String get abc__tile__battery_opt_title => 'Battery Optimization';

  @override
  String get abc__tile__battery_opt_subtitle =>
      'Prevents the system from shutting down CopyCat while running in the background, ensuring a seamless experience.';

  @override
  String get abc__tile__overlay_title => 'Overlay Permission';

  @override
  String get abc__tile__overlay_subtitle =>
      'Allows CopyCat to read the clipboard by briefly opening a transparent window over the screen and closing it immediately after.';

  @override
  String get abc__tile__acc_title => 'Accessibility Service';

  @override
  String get abc__tile__acc_subtitle =>
      'Start the CopyCat background listener to detect when you copy something and ensure the service restarts automatically after a reboot.';

  @override
  String get abc__ack__ready => 'Setup ready to be configured.';

  @override
  String get abc__ack__preparing => 'Preparing setup, please wait...';

  @override
  String get abc__perm_alert_open_setting__button => 'Open Setting';

  @override
  String get abc__overlay_perm_alert__title => 'Overlay Permission';

  @override
  String get abc__overlay_perm_alert__subtitle =>
      'CopyCat Clipboard needs the \'Draw Over Other Apps\' permission to read clipboard content in the background.';

  @override
  String get abc__overlay_perm_alert__p1_prefix => 'This permission is ';

  @override
  String get abc__overlay_perm_alert__p1_bold =>
      'used only for clipboard detection';

  @override
  String get abc__overlay_perm_alert__p1_suffix =>
      ' when you\'re copying something in the background.';

  @override
  String get abc__overlay_perm_alert__p2_prefix => 'When enabled, CopyCat ';

  @override
  String get abc__overlay_perm_alert__p2_bold =>
      'creates a 0-pixel transparent window';

  @override
  String get abc__overlay_perm_alert__p2_suffix =>
      ' to briefly bring the app to the foreground to read clipboard data.';

  @override
  String get abc__overlay_perm_alert__p3_prefix => 'The app ';

  @override
  String get abc__overlay_perm_alert__p3_bold => 'does not show anything';

  @override
  String get abc__overlay_perm_alert__p3_suffix =>
      ' on your screen during this process.';

  @override
  String get abc__overlay_perm_alert__p4_prefix =>
      'On some devices, the system may show a toast message ';

  @override
  String get abc__overlay_perm_alert__p4_bold =>
      '\'CopyCat pasted from your clipboard\'';

  @override
  String get abc__overlay_perm_alert__p4_suffix =>
      ' when CopyCat reads your clipboard content.';

  @override
  String get abc__overlay_perm_alert__agree =>
      'By granting this permission, you agree to the above usage.';

  @override
  String get abc__accessibility_perm_alert__title => 'Accessibility Permission';

  @override
  String get abc__accessibility_perm_alert__subtitle =>
      'CopyCat Clipboard requires the Accessibility Service to run in the background for real-time clipboard detection and syncing.';

  @override
  String get abc__accessibility_perm_alert__p1_prefix => 'This service is ';

  @override
  String get abc__accessibility_perm_alert__p1_bold => 'only used';

  @override
  String get abc__accessibility_perm_alert__p1_suffix =>
      ' for detecting clipboard content and syncing it across devices when enabled.';

  @override
  String get abc__accessibility_perm_alert__p2_prefix => 'You can ';

  @override
  String get abc__accessibility_perm_alert__p2_bold => 'exclude specific apps';

  @override
  String get abc__accessibility_perm_alert__p2_suffix =>
      ' using the Exclusion Rules feature.';

  @override
  String get abc__accessibility_perm_alert__p3_prefix => 'The app ';

  @override
  String get abc__accessibility_perm_alert__p3_bold =>
      'does not access any other data';

  @override
  String get abc__accessibility_perm_alert__p3_suffix =>
      ' beyond clipboard content.';

  @override
  String get abc__accessibility_perm_alert__p4_prefix => 'Clipboard data ';

  @override
  String get abc__accessibility_perm_alert__p4_bold =>
      'is not shared externally';

  @override
  String get abc__accessibility_perm_alert__p4_suffix =>
      ' and remains private to your devices.';

  @override
  String get abc__accessibility_perm_alert__p5_prefix => 'Clipboard data ';

  @override
  String get abc__accessibility_perm_alert__p5_bold =>
      'is end-to-end encrypted';

  @override
  String get abc__accessibility_perm_alert__p5_suffix =>
      ' (if enabled) in transit and at rest, ensuring privacy across devices.';

  @override
  String get abc__accessibility_perm_alert__agree =>
      'By enabling the Accessibility Service, you acknowledge and agree to the above terms.';

  @override
  String get abc__other_setting__title => 'Other Settings';

  @override
  String get abc__enhanced_clip_detection__title =>
      'Enhanced Clipboard Detection';

  @override
  String get abc__enhanced_clip_detection__subtitle =>
      'Enable this option for more accurate clipboard detection. Note that it might not work on every device.';
}
