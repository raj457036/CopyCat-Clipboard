// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get app__name => 'CopyCat Zwischenablage';

  @override
  String get app__slogan => 'Eine Zwischenablage, unbegrenzte Möglichkeiten';

  @override
  String get app__unknown_error => 'Ein unerwarteter Fehler ist aufgetreten';

  @override
  String get app__downloading => 'Herunterladen...';

  @override
  String get app__download => 'Herunterladen';

  @override
  String get app__follow_link => 'Link folgen';

  @override
  String get app__edit => 'Bearbeiten';

  @override
  String get app__export => 'Exportieren';

  @override
  String get app__delete => 'Löschen';

  @override
  String get app__later => 'Überspringen';

  @override
  String get app__select => 'Wählen';

  @override
  String get app__change => 'Ändern';

  @override
  String get app__confirm => 'Bestätigen';

  @override
  String get app__action_required => 'Aktion erforderlich';

  @override
  String get app__feature_unavailable =>
      'Diese Funktion ist für Ihre Plattform nicht verfügbar.';

  @override
  String get app__preview => 'Vorschau';

  @override
  String get app__open_file => 'Datei öffnen';

  @override
  String get app__change_collection => 'Sammlung ändern';

  @override
  String get app__share => 'Teilen';

  @override
  String get app__loading => 'Lädt...';

  @override
  String get app__uploading => 'Hochladen...';

  @override
  String get app__syncing => 'Synchronisieren...';

  @override
  String get app__sync => 'Synchronisieren';

  @override
  String get app__queued => 'In Warteschlange';

  @override
  String get app__local => 'Lokal';

  @override
  String get app__utc => 'UTC';

  @override
  String get app__send_message => 'Nachricht senden';

  @override
  String get app__send_email => 'E-Mail senden';

  @override
  String get app__empty_clipboard => 'Ihre Zwischenablage ist leer.';

  @override
  String get app__load_more => 'Mehr laden';

  @override
  String get app__search => 'Suchen';

  @override
  String get app__no_results => 'Keine Ergebnisse gefunden';

  @override
  String get app__locale_en => 'Englisch';

  @override
  String get app__locale_es => 'Spanisch';

  @override
  String get app__locale_fr => 'Französisch';

  @override
  String get app__locale_de => 'Deutsch';

  @override
  String get app__locale_zh => 'Chinesisch';

  @override
  String get app__locale_pt => 'Portugiesisch';

  @override
  String get app__language => 'Sprache';

  @override
  String get app__yes => 'Ja';

  @override
  String get app__no => 'Nein';

  @override
  String get app__quit => 'Beenden';

  @override
  String get app__clear => 'Leeren';

  @override
  String get app__reset => 'Zurücksetzen';

  @override
  String get app__continue => 'Weiter';

  @override
  String get app__paste => 'Einfügen';

  @override
  String get app__copycat_logo => 'CopyCat-Logo';

  @override
  String get app__logout => 'Abmelden';

  @override
  String get app__no_collection => 'Keine Sammlung gefunden';

  @override
  String get app__create_collection => 'Sammlung erstellen';

  @override
  String get app__create => 'Erstellen';

  @override
  String get app__pro_tip => 'Pro Tipp';

  @override
  String get app__try_again => 'Erneut versuchen';

  @override
  String get app__realtime_connected => 'Echtzeit verbunden';

  @override
  String get app__realtime_disconnected => 'Echtzeit getrennt';

  @override
  String get app__realtime_connecting => 'Echtzeit Verbindung...';

  @override
  String get app__ack__exported => 'Exportiert';

  @override
  String get app__ack__copied => 'Kopiert';

  @override
  String get app__ack__pasted => 'Eingefügt';

  @override
  String get app__ack__pasting => 'Einfügen';

  @override
  String get app__ack__done => 'Fertig';

  @override
  String get app__ack__quit_app => 'App beenden';

  @override
  String get app__ack__deleted => 'Gelöscht';

  @override
  String get app__ack__internet_connected => 'Internet verbunden';

  @override
  String get app__ack__internet_disconnected => 'Internet getrennt';

  @override
  String get app__ack__logout_success => 'Sie wurden erfolgreich abgemeldet.';

  @override
  String get app__ack__no_app_for_file =>
      'Keine Anwendung gefunden, um diese Datei zu öffnen.';

  @override
  String get app__ack__perm_fail_to_open_file =>
      'Berechtigung zum Öffnen dieser Datei nicht erteilt.';

  @override
  String get app__ack__missing_e2e_setup => 'Verschlüsselungseinrichtung fehlt';

  @override
  String app__ack__failed_to_sync({
    required String entityType,
    required String message,
  }) {
    return '$entityType konnte nicht synchronisiert werden: $message';
  }

  @override
  String get dialog__delete_clip__title => 'Clip löschen';

  @override
  String dialog__delete_clip__subtitle({required int itemCount}) {
    String _temp0 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      one: 'Möchten Sie diesen Clip wirklich löschen?',
      other: 'Möchten Sie diese Clips wirklich löschen?',
    );
    return '$_temp0';
  }

  @override
  String get dialog__e2e__title => 'End-to-End-Verschlüsselung';

  @override
  String get dialog__text__e2e_key_export =>
      'Glückwunsch, Sie haben die End-to-End-Verschlüsselung erfolgreich konfiguriert.';

  @override
  String get dialog__text__e2e_key_export__note =>
      'Klicken Sie auf die Schaltfläche unten, um Ihren Verschlüsselungsschlüssel zu exportieren. \nSpeichern Sie den Schlüssel an einem sicheren Ort, um sicherzustellen, dass Sie andere Geräte einrichten können, um auf Ihre verschlüsselten Informationen zuzugreifen.';

  @override
  String get dialog__text__e2e_key_generate =>
      'Generieren Sie einen Verschlüsselungsschlüssel und speichern Sie ihn sicher. Dieser Schlüssel wird benötigt, um andere Geräte einzurichten, die auf Ihre verschlüsselten Daten zugreifen können.';

  @override
  String get dialog__button__e2e_generating_key => 'Erzeugen';

  @override
  String get dialog__button__e2e_generate_key => 'Erzeugt';

  @override
  String get dialog__text__invalid_e2e_key =>
      'Der importierte Schlüssel ist ungültig!';

  @override
  String get dialog__text__e2e_key_import__note =>
      'Importieren Sie Ihren Verschlüsselungsschlüssel unten, um auf Ihre verschlüsselten Daten auf diesem Gerät zuzugreifen.';

  @override
  String get dialog__button__e2e_importing_key => 'Importieren';

  @override
  String get dialog__button__e2e_import_key => 'Importieren';

  @override
  String get dialog__text__inconsistent_time__title =>
      'Warnung zur Uhrzeitsynchronisation';

  @override
  String get dialog__text__inconsistent_time__content =>
      'Inkonsistente Gerätezeit erkannt\n\nUm eine genaue Synchronisation der Zwischenablage zu gewährleisten, überprüfen und korrigieren Sie bitte die Uhrzeiteinstellungen Ihres Geräts.\n\nInkonsistente Uhrzeiteinstellungen können Synchronisationsprobleme verursachen.';

  @override
  String get dialog__text__inconsistent_time__still_off =>
      'Die Uhr ist weiterhin nicht synchron. Bitte aktualisieren Sie Ihre Systemzeit manuell.';

  @override
  String get dialog__text__inconsistent_time__ntp_unreachable =>
      'Der Zeitserver konnte nicht erreicht werden. Bitte prüfen Sie Ihre Internetverbindung und synchronisieren Sie Ihre Uhr manuell.';

  @override
  String get dialog__text__inconsistent_time__check_failed =>
      'Zeitprüfung fehlgeschlagen. Bitte aktualisieren Sie Ihre Systemuhr manuell.';

  @override
  String get dialog__button__try_again => 'Erneut überprüfen';

  @override
  String get dialog__button__try_fix => 'Versuchen Sie es';

  @override
  String get dialog__record_keys__title => 'Tastenkombination aufzeichnen';

  @override
  String get dialog__record_keys__subtitle =>
      'Geben Sie Ihre Tastenkombination über Ihre Tastatur ein und klicken Sie ';

  @override
  String dialog__delete_collection__title({required String collectionName}) {
    return '$collectionName löschen';
  }

  @override
  String get dialog__delete_collection__subtitle =>
      'Sind Sie sicher, dass Sie diese Sammlung löschen möchten?';

  @override
  String get dialog__ack__sub_updated => 'Abonnement aktualisiert';

  @override
  String get dialog__grant_entitlement__title => 'Berechtigung gewährt';

  @override
  String get dialog__grant_entitlement__subtitle_p1 =>
      'Berechtigungscodes werden mit bestimmten Personen für benutzerdefinierte Berechtigungen geteilt. Sie können überprüfen, ob Einladungen noch verfügbar sind, indem Sie ';

  @override
  String get dialog__grant_entitlement__subtitle_p2 => 'Hier klicken.';

  @override
  String get dialog__grant_entitlement__enter_code =>
      'Geben Sie den Code ein und drücken Sie Absenden';

  @override
  String get dialog__grant_entitlement__code_label => 'Code';

  @override
  String get dialog__grant_entitlement__apply_code => 'Anwenden';

  @override
  String get view_button__switch_to_grid => 'Wechseln zu Raster-Layout';

  @override
  String get view_button__switch_to_list => 'Wechseln zu Listen-Layout';

  @override
  String get view_button__change_view => 'Ansicht ändern';

  @override
  String get view_button__view_window => 'Fensteransicht';

  @override
  String get view_button__view_dock_right => 'Rechts andocken';

  @override
  String get view_button__view_dock_bottom => 'Unten andocken';

  @override
  String get view_button__view_dock_left => 'Links andocken';

  @override
  String get view_button__view_dock_top => 'Oben andocken';

  @override
  String get view_button__pin => 'Oben anheften';

  @override
  String get view_button__unpin => 'Abheften';

  @override
  String get sub_dialog__text__included => 'Enthalten';

  @override
  String get sub_dialog__f1__title => 'Unbegrenzte Zwischenablage-Elemente';

  @override
  String get sub_dialog__f1__subtitle =>
      'Laufen Sie nie aus Platz mit unbegrenzten Zwischenablage-Elementen, die Sie jederzeit auf Ihre zuletzt kopierten Elemente zugreifen lassen.';

  @override
  String get sub_dialog__f2__title => 'Unterstützung aller großen Plattformen';

  @override
  String get sub_dialog__f2__subtitle =>
      'Synchronisieren Sie nahtlos über alle großen Plattformen hinweg – Android, iOS, Windows, macOS und Linux – für ununterbrochene Produktivität überall.';

  @override
  String get sub_dialog__f3__title => 'Unterstützt Apple Universal Clipboard';

  @override
  String get sub_dialog__f3__subtitle =>
      'Übertragen Sie Inhalte der Zwischenablage mühelos zwischen Ihren Apple-Geräten mit Unterstützung des Universal Clipboard von Apple.';

  @override
  String get sub_dialog__f4__title => 'Speicherung auf dem Gerät';

  @override
  String get sub_dialog__f4__subtitle =>
      'Bewahren Sie Ihre Daten sicher mit der Speicherung auf dem Gerät auf, sodass Ihre Zwischenablage-Elemente immer erreichbar und unter Ihrer Kontrolle sind.';

  @override
  String get sub_dialog__f5__title => 'Google Drive Integration';

  @override
  String get sub_dialog__f5__subtitle =>
      'Speichern Sie Dateien und Medien sicher auf Google Drive, nahtlos integriert mit CopyCat Zwischenablage für umfassendes Datenmanagement.';

  @override
  String get sub_dialog__f6__title => 'Sofortsuche';

  @override
  String get sub_dialog__f6__subtitle =>
      'Finden Sie sofort, was Sie brauchen, mit leistungsstarken Sofortsuche-Funktionen, die das Abrufen von Zwischenablage-Elementen schnell und effizient machen.';

  @override
  String get sub_dialog__f7__title => 'Synchronisation der letzten 24 Stunden';

  @override
  String get sub_dialog__f7__subtitle =>
      'Greifen Sie auf die Geschichte Ihrer Zwischenablage zu und synchronisieren Sie sie auf allen Ihren Geräten innerhalb der letzten 24 Stunden. So verlieren Sie nie wichtige kopierte Elemente, was Ihren Arbeitsablauf nahtlos und effizient macht.';

  @override
  String get sub_dialog__f8__title => 'Bis zu 3 Sammlungen';

  @override
  String get sub_dialog__f8__subtitle =>
      'Organisieren Sie Ihre Zwischenablage-Elemente in bis zu 3 Sammlungen, was einfache Kategorisierung für bessere Arbeitsablaufverwaltung bietet.';

  @override
  String get sub_dialog__f9__title =>
      'Automatische Synchronisation alle 45 Sekunden';

  @override
  String get sub_dialog__f9__subtitle =>
      'Genießen Sie die automatische Synchronisation von Zwischenablage-Elementen alle 45 Sekunden, halten Sie Ihre Geräte immer auf dem neuesten Stand, ohne manuelles Eingreifen.';

  @override
  String get sub_dialog__f10__title =>
      'Unterstützung der End-to-End-Verschlüsselung';

  @override
  String get sub_dialog__f10__subtitle =>
      'Ende-zu-Ende-Verschlüsselung macht alles für überlegene Privatsphäre verschlüsselt.';

  @override
  String get sub_dialog__text__pro_title => 'Mit PRO ✨';

  @override
  String get sub_dialog__text__pro_subtitle => 'Alles in Freemium enthalten +';

  @override
  String get sub_dialog__f11__title => 'Bis zu 50 Sammlungen';

  @override
  String get sub_dialog__f11__subtitle =>
      'Organisieren Sie Ihre Zwischenablage-Elemente in bis zu 50 Sammlungen für ultimative Verwaltung.';

  @override
  String get sub_dialog__f12__title => 'Synchronisation der letzten 30 Tage';

  @override
  String get sub_dialog__f12__subtitle =>
      'Die Zwischenablage-Historie ist auf allen Ihren Geräten für Clips synchronisiert, die in den letzten 30 Tagen erstellt wurden. Das bedeutet, dass Sie auf jeden Clip zugreifen können, den Sie im vergangenen Monat kopiert haben, egal welches Gerät Sie verwenden.';

  @override
  String get sub_dialog__f13__title => 'Echtzeit-Synchronisation';

  @override
  String get sub_dialog__f13__subtitle =>
      'Erleben Sie blitzschnelle Synchronisation.';

  @override
  String get sub_dialog__f14__title =>
      'Schnellere und Priorisierte Unterstützung';

  @override
  String get sub_dialog__f14__subtitle =>
      'Erhalten Sie schnellen und priorisierten Support als PRO-Benutzer.';

  @override
  String get sub_dialog__f15__title => 'Früher Zugang zu neuen Funktionen';

  @override
  String get sub_dialog__f15__subtitle =>
      'Seien Sie der Erste, der neue Funktionen und Updates ausprobieren kann.';

  @override
  String get sub_dialog__f16__title => 'Benutzerdefinierte Ausschlussregeln';

  @override
  String get sub_dialog__f16__subtitle =>
      'Präzise Kontrolle über Ihre Zwischenablage. Ermöglicht es Ihnen zu definieren, was kopiert wird, woher es kopiert wird und wann es kopiert wird.';

  @override
  String get sub_dialog__f17__title => 'Ziehen & Ablegen';

  @override
  String get sub_dialog__f17__subtitle =>
      'Verschieben Sie Elemente nahtlos in jede Richtung auf Ihren Desktop- und Tablet-Geräten.';

  @override
  String get sub_dialog__f18__title => 'Themen';

  @override
  String get sub_dialog__f18__subtitle =>
      'Passen Sie den gesamten Look und das Gefühl der App an, um Ihren Vorlieben zu entsprechen.';

  @override
  String get paywall_dialog__text__month => 'Monat';

  @override
  String get paywall_dialog__text__year => 'Jahr';

  @override
  String get paywall_dialog__text__subscription => 'Abonnement';

  @override
  String get paywall_dialog__text__supported_platform =>
      'Um auf Premium-Funktionen in der CopyCat Zwischenablage zuzugreifen, abonnieren Sie bitte über den Play Store oder den Apple App Store. Ihr Abonnement wird auf all Ihren Geräten synchronisiert, einschließlich Linux und Windows.';

  @override
  String get paywall_dialog__text__unlock_pro => 'CopyCat PRO freischalten';

  @override
  String get paywall_dialog__text__unlock_pro_p1 =>
      'Genießen Sie über 30 Tage synchronisierte Geschichte, über 50 Sammlungen, Ende-zu-Ende-Verschlüsselung, Echtzeit-Synchronisation, Zugriff auf die neuesten Funktionen und vieles mehr.';

  @override
  String get paywall_dialog__text__try_again => 'Bitte erneut versuchen';

  @override
  String get paywall_dialog__text__current_plan => 'Aktueller Plan';

  @override
  String get paywall_dialog__text__expired_plan =>
      'Aktueller Plan • Abgelaufen';

  @override
  String paywall_dialog__text__trial_till({required DateTime till}) {
    final intl.DateFormat tillDateFormat = intl.DateFormat.yMMMd(localeName);
    final String tillString = tillDateFormat.format(till);

    return 'Testversion bis $tillString';
  }

  @override
  String get paywall_dialog__text__upgrade => 'Upgrade';

  @override
  String fab__create_collection({required String remaining}) {
    return 'Sammlung erstellen ( $remaining verbleibend )';
  }

  @override
  String get fab__sync => 'Synchronisieren';

  @override
  String get fab__sync_unavailable => 'Synchronisierung nicht verfügbar';

  @override
  String get fab__sync_up_to_date => 'Bereits auf dem neuesten Stand.';

  @override
  String fab__sync_failed({required String message}) {
    return 'Synchronisierung fehlgeschlagen: $message';
  }

  @override
  String get layout__navbar__clipboard => 'Zwischenablage';

  @override
  String get layout__navbar__collections => 'Sammlungen';

  @override
  String get layout__navbar__settings => 'Einstellungen';

  @override
  String get search__tooltip__filter => 'Suchfilter';

  @override
  String manage_sub__ack__promo_sub({required String till}) {
    return 'Sie verwenden ein Promo-Abonnement bis $till';
  }

  @override
  String get manage_sub__button__text => 'Abonnements verwalten';

  @override
  String get my_account__button__tooltip => 'Mein Konto';

  @override
  String get badges__tooltip__experimental =>
      'Diese Funktion ist experimentell und funktioniert möglicherweise nicht wie erwartet.';

  @override
  String get badges__label__pro => 'PRO';

  @override
  String get badges__tooltip__pro_only =>
      'Diese Funktion ist nur für Pro-Benutzer verfügbar.';

  @override
  String get collection_selector__tile__no_collection => 'Keine Sammlung';

  @override
  String get collection_selector__button__remove_collection =>
      'Sammlung entfernen';

  @override
  String get dialog__logout__title => 'Abmelden';

  @override
  String get dialog__logout__subtitle =>
      '⚠️ WARNUNG ⚠️\n\nDas Abmelden löscht nicht synchronisierte Änderungen in der lokalen Datenbank. Möchten Sie wirklich fortfahren?';

  @override
  String get dialog__logging_out__ack =>
      'Sie werden abgemeldet! Bitte warten...';

  @override
  String get reset_pass__text__label => 'Setzen Sie Ihr Passwort zurück';

  @override
  String get dnd__text__drop_here => 'Hier ablegen';

  @override
  String dnd__ack__error_max_drop_count({required int count}) {
    return 'Maximal $count Ablageelemente sind gleichzeitig erlaubt.';
  }

  @override
  String get search_filter__text__title => 'Filter';

  @override
  String get search_filter__button__apply => 'Anwenden';

  @override
  String get search_filter__text__from => 'Von';

  @override
  String get search_filter__text__select => 'Wählen';

  @override
  String get search_filter__text__to => 'An';

  @override
  String get search_filter__text__now => 'Jetzt';

  @override
  String get search_filter__text__including => 'Einschließlich';

  @override
  String get search_filter__chip__text => 'Text';

  @override
  String get search_filter__chip__url => 'URL';

  @override
  String get search_filter__chip__media => 'Medien';

  @override
  String get search_filter__chip__docs => 'Dokumente';

  @override
  String get search_filter__text__textCategories => 'Textkategorien';

  @override
  String get search_filter__text__exclusive => '( Exklusiv )';

  @override
  String get search_filter__text_cat__email => 'E-Mail';

  @override
  String get search_filter__text_cat__phone => 'Telefon';

  @override
  String get search_filter__text_cat__color => 'Farbe';

  @override
  String get search_filter__text_cat__struct => 'Struktur';

  @override
  String get search_filter__text__sort_by => 'Sortieren nach';

  @override
  String get search_filter__sort_by__last_mod => 'Zuletzt geändert';

  @override
  String get search_filter__sort_by__created => 'Erstellt';

  @override
  String get search_filter__sort_by__copy_count => 'Kopieranzahl';

  @override
  String get search_filter__sort_by__last_copied => 'Zuletzt kopiert';

  @override
  String get search_filter__text__sort_order => 'Sortierreihenfolge';

  @override
  String get search_filter__sort_ord__asc => 'Aufsteigend';

  @override
  String get search_filter__sort_ord__desc => 'Absteigend';

  @override
  String get search_filter__tooltip__clear => 'Leeren';

  @override
  String get search_filter__empty => '∅';

  @override
  String get search_filter__button__reset => 'Zurücksetzen';

  @override
  String get login__local_signin__tooltip =>
      'Keine Synchronisation. Alle Daten bleiben auf Ihrem Gerät.';

  @override
  String get login__local_signin__btn__label => 'Offline-Modus';

  @override
  String get login__form__input__name => 'Geben Sie Ihren Namen ein';

  @override
  String get login__form__input__email => 'Geben Sie Ihre E-Mail ein';

  @override
  String get login__form__input__error_email =>
      'Bitte geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get login__form__input__password => 'Geben Sie Ihr Passwort ein';

  @override
  String get login__form__input__error_password_length =>
      'Bitte geben Sie ein Passwort mit mindestens 6 Zeichen ein';

  @override
  String get login__form__button__signin => 'Einloggen';

  @override
  String get login__form__button__signup => 'Registrieren';

  @override
  String get login__form__button__forgot_password => 'Passwort vergessen?';

  @override
  String get login__form__text__signup => 'Kein Konto? Jetzt registrieren';

  @override
  String get login__form__text__old_user =>
      'Haben Sie bereits ein Konto? Anmelden';

  @override
  String get login__form__text__reset_password =>
      'Passwort-Reset-E-Mail senden';

  @override
  String get login__form__text__reset_ack =>
      'Passwort-Reset-E-Mail wurde gesendet';

  @override
  String get login__form__button__back => 'Zurück zur Anmeldung';

  @override
  String get login__form__button__update_password => 'Passwort aktualisieren';

  @override
  String get login__form__text_tnc_p1 =>
      'Mit der Fortsetzung stimmen Sie den folgenden ';

  @override
  String get login__form__text_tnc_p2 => 'Datenschutzrichtlinien';

  @override
  String get login__form__text_tnc_p3 => ' und ';

  @override
  String get login__form__text_tnc_p4 => 'Nutzungsbedingungen zu.';

  @override
  String get home__search__hint => 'In der Zwischenablage suchen';

  @override
  String get collections__search__hint => 'Sammlung suchen';

  @override
  String get home__search__reset => 'Suche zurücksetzen';

  @override
  String get preview__vert_view__tab1_title => 'Vorschau';

  @override
  String get preview__vert_view__tab2__title => 'Details';

  @override
  String get preview__card__missing_text => 'Dies ist ein leerer Clip';

  @override
  String get preview__card__video__play => 'Video abspielen';

  @override
  String get preview__card__file__open => 'Datei öffnen';

  @override
  String get preview__form__title => 'Details bearbeiten';

  @override
  String get preview__form__input__title => 'Titel';

  @override
  String get preview__form__input__description => 'Beschreibung';

  @override
  String get preview__inspector__title => 'Clip-Details';

  @override
  String get preview__inspector__untitled => 'Unbenannter Clip';

  @override
  String get preview__inspector__saved => 'Details gespeichert';

  @override
  String get preview__inspector__save_changes => 'Änderungen speichern';

  @override
  String get preview__inspector__decrypt => 'Entschlüsseln';

  @override
  String get preview__inspector__open_source => 'Quelle öffnen';

  @override
  String get preview__inspector__section__actions => 'Aktionen';

  @override
  String get preview__inspector__section__details => 'Details';

  @override
  String get preview__inspector__section__content => 'Inhalt';

  @override
  String get preview__inspector__section__organize => 'Organisieren';

  @override
  String get preview__inspector__label__created => 'Erstellt';

  @override
  String get preview__inspector__label__modified => 'Geändert';

  @override
  String get preview__inspector__label__last_copied => 'Zuletzt kopiert';

  @override
  String get preview__inspector__label__copied_count => 'Anzahl Kopien';

  @override
  String get preview__inspector__label__source_app => 'Quell-App';

  @override
  String get preview__inspector__label__source_url => 'Quell-URL';

  @override
  String get preview__inspector__label__file_size => 'Dateigröße';

  @override
  String get preview__inspector__label__mime_type => 'MIME-Typ';

  @override
  String get preview__inspector__label__extension => 'Erweiterung';

  @override
  String get preview__inspector__label__characters => 'Zeichen';

  @override
  String get preview__inspector__label__lines => 'Zeilen';

  @override
  String get preview__inspector__label__link => 'Link';

  @override
  String get preview__inspector__status__encrypted => 'Verschlüsselt';

  @override
  String get preview__inspector__status__local_only => 'Nur lokal';

  @override
  String get preview__inspector__status__synced => 'Synchronisiert';

  @override
  String get preview__inspector__status__not_synced => 'Nicht synchronisiert';

  @override
  String get preview__inspector__status__download_required =>
      'Download erforderlich';

  @override
  String get preview__inspector__status__available => 'Offline verfügbar';

  @override
  String get preview__inspector__type__text => 'Text';

  @override
  String get preview__inspector__type__media => 'Medien';

  @override
  String get preview__inspector__type__file => 'Datei';

  @override
  String get preview__inspector__type__link => 'Link';

  @override
  String get reset_password__appbar__title => 'Setzen Sie Ihr Passwort zurück';

  @override
  String get reset_password__success_ack =>
      'Passwort erfolgreich zurückgesetzt';

  @override
  String get onboarding__text__welcome => 'Willkommen bei';

  @override
  String get onboarding__text__lets_continue => 'Lass uns fortfahren';

  @override
  String get onboarding__button__to_login => 'Anmelden';

  @override
  String get onboarding__snackbar__export_success =>
      'Verschlüsselungsschlüssel erfolgreich exportiert.';

  @override
  String get onboarding__dialog__skip_export__title =>
      '✋ Sichern Sie Ihren Verschlüsselungsschlüssel';

  @override
  String get onboarding__dialog__skip_export__subtitle =>
      'Sie haben Ihren Verschlüsselungsschlüssel noch nicht exportiert. Wenn Sie kein Backup haben, können Sie nicht auf Ihre verschlüsselten Clips zugreifen, falls der Schlüssel verloren geht oder Sie das Gerät wechseln.\n\n👉 Wenn Sie bereits eine sichere Sicherung Ihres Schlüssels haben, können Sie sicher fortfahren. Andernfalls empfehlen wir dringend, den Schlüssel jetzt zu exportieren, um Datenverlust zu vermeiden. Möchten Sie trotzdem fortfahren?';

  @override
  String get onboarding__dialog__export_info__title =>
      '🤔 Warum den Verschlüsselungsschlüssel exportieren?';

  @override
  String get onboarding__dialog__export_info__subtitle =>
      'Der Export Ihres Verschlüsselungsschlüssels ist wichtig, um sicher auf Ihre verschlüsselten Daten auf mehreren Geräten zugreifen zu können. Ohne den Schlüssel bleiben Ihre verschlüsselten Daten nach der Synchronisation unzugänglich.\n\nBewahren Sie eine Sicherung Ihres Verschlüsselungsschlüssels an einem sicheren Ort auf, um Datenverlust zu vermeiden. Denken Sie daran, der Schlüssel ist einzigartig für Ihr Konto und kann nicht wiederhergestellt werden, wenn er verloren geht.\n\nAchtung: CopyCat hat keinen Zugriff auf Ihre verschlüsselten Clips oder Ihre Verschlüsselungsschlüssel. Dies erfolgt, weil wir Ihre Privatsphäre über alles andere stellen.';

  @override
  String get onboarding__text__export_key_headline =>
      'Zwischenablagenverschlüsselung';

  @override
  String get onboarding__text__export_key_title =>
      '💪 Gute Nachrichten! Verschlüsselung ist für Ihre Zwischenablage aktiviert';

  @override
  String get onboarding__button__export_key => 'Schlüssel exportieren';

  @override
  String get onboarding__dialog__skip_gen_key__title =>
      '✋ Ihre Clips sind unsicher';

  @override
  String get onboarding__dialog__skip_gen_key__subtitle =>
      'Sie haben noch keinen Verschlüsselungsschlüssel erstellt. Ohne ihn bleiben Ihre Clips unverschlüsselt und unsicher. Sie können den Schlüssel später in Einstellungen ❯ Sicherheit generieren. Möchten Sie trotzdem fortfahren?';

  @override
  String get onboarding__dialog__gen_key_info__title =>
      '🤔 Warum brauche ich Verschlüsselung?';

  @override
  String get onboarding__dialog__gen_key_info__subtitle =>
      'Verschlüsselung schützt Ihre Daten, indem sie in ein sicheres Format umgewandelt wird, auf das nur mit einem Schlüssel zugegriffen werden kann. Ohne Verschlüsselung werden Ihre Clips im Klartext gespeichert und sind anfällig für unberechtigten Zugriff. Die Aktivierung der Verschlüsselung gewährleistet, dass nur Sie auf Ihre sensiblen Daten zugreifen können, was eine zusätzliche Sicherheitsebene gegen mögliche Verstöße bietet.';

  @override
  String get onboarding__text__gen_key_headline =>
      'Zwischenablagenverschlüsselung einrichten';

  @override
  String onboarding__text__key_generated_title({required String keyPreview}) {
    return '🎉 Schlüssel $keyPreview*** erfolgreich erstellt 🎉';
  }

  @override
  String get onboarding__button__regenerate_key => 'Schlüssel neu generieren';

  @override
  String get onboarding__text__no_key =>
      'Ihr Konto hat keinen Verschlüsselungsschlüssel';

  @override
  String get onboarding__button__generate_key => 'Schlüssel generieren';

  @override
  String get onboarding__button__do_it_later => 'Später machen';

  @override
  String get onboarding__button__why_important => 'Warum ist es wichtig?';

  @override
  String get onboarding__snackbar__invalid_key =>
      'Dies ist kein gültiger CopyCat-Verschlüsselungsschlüssel';

  @override
  String get onboarding__dialog__skip_import__title =>
      '✋ Verschlüsselte Clips nicht zugänglich';

  @override
  String get onboarding__dialog__skip_import__subtitle =>
      'Sie haben Ihren Verschlüsselungsschlüssel noch nicht importiert. Dies bedeutet, dass alle Ihre verschlüsselten Clips lokal nach der Synchronisation unzugänglich bleiben.\n\nUm auf sie zuzugreifen, importieren Sie den Schlüssel aus Einstellungen ❯ Sicherheit.\nMöchten Sie trotzdem fortfahren?';

  @override
  String get onboarding__dialog__reset_key__title =>
      '✋ Verschlüsselte Daten dauerhaft löschen';

  @override
  String get onboarding__dialog__reset_key__subtitle =>
      'Diese Aktion ist nicht umkehrbar. Möchten Sie wirklich alle verschlüsselten Daten vom Server dauerhaft löschen?';

  @override
  String get onboarding__snackbar__reset_key__success =>
      'Verschlüsselung erfolgreich entfernt.';

  @override
  String get onboarding__dialog__import_info__title =>
      '🤔 Wo ist mein Schlüssel?';

  @override
  String get onboarding__dialog__import_info__subtitle =>
      'Ihr Verschlüsselungsschlüssel ist eine sichere Datei, die während des Verschlüsselungssetups erstellt wurde. Wenn Sie ihn verloren haben, überprüfen Sie Ihren Downloads-Ordner oder jeden Sicherungsort, an dem Sie ihn möglicherweise gespeichert haben. Ohne diesen Schlüssel können Ihre verschlüsselten Daten nicht abgerufen werden.\n\nWenn Sie den Verschlüsselungsschlüssel auf einem anderen Gerät eingerichtet haben, können Sie ihn exportieren, indem Sie auf diesem Gerät zu Einstellungen ❯ Sicherheit ❯ E2EE Tresor wechseln. Übertragen Sie den Schlüssel sicher auf dieses Gerät, um den Zugriff auf Ihre verschlüsselten Daten wiederzuerlangen.';

  @override
  String get onboarding__text__import_key_headline =>
      'Zwischenablagenverschlüsselungsschlüssel importieren';

  @override
  String get onboarding__text__import_key_title =>
      'Ihr Konto hat derzeit eine aktive Verschlüsselung.';

  @override
  String get onboarding__button__import_key => 'Schlüssel importieren';

  @override
  String get onboarding__button__reset_key => 'Verschlüsselung zurücksetzen';

  @override
  String get onboarding__button__where_key => 'Wo ist der Schlüssel?';

  @override
  String get onboarding__text__go_home => 'Gehen wir nach Hause';

  @override
  String onboarding__restoration__failed({required String message}) {
    return 'Wiederherstellung fehlgeschlagen: $message';
  }

  @override
  String get onboarding__restoration_warning =>
      '⚠️ Bitte lassen Sie diesen Bildschirm während der Synchronisierung geöffnet, um Datenbeschädigung oder Inkonsistenzen zu vermeiden.';

  @override
  String get sync_restore__title => 'Arbeitsbereich wird wiederhergestellt';

  @override
  String get sync_restore__subtitle =>
      'CopyCat lädt Ihre synchronisierten Sammlungen und den Zwischenablageverlauf auf dieses Gerät.';

  @override
  String get sync_restore__checking_backup => 'Remote-Backup wird geprüft...';

  @override
  String get sync_restore__decrypting_title => 'Clips werden entschlüsselt';

  @override
  String get sync_restore__decrypting_counting =>
      'Verschlüsselte Clips werden gezählt...';

  @override
  String sync_restore__decrypting_progress({
    required int decrypted,
    required int total,
  }) {
    return '$decrypted von $total entschlüsselt';
  }

  @override
  String get sync_restore__workspace_restored =>
      'Arbeitsbereich wiederhergestellt';

  @override
  String get sync_restore__data_ready =>
      'Ihre synchronisierten Daten sind auf diesem Gerät bereit.';

  @override
  String get sync_restore__restoring_collections =>
      'Sammlungen werden wiederhergestellt, damit Zwischenablageelemente organisiert bleiben.';

  @override
  String get sync_restore__restoring_clips =>
      'Sammlungen sind wiederhergestellt. Als Nächstes folgt der Zwischenablageverlauf.';

  @override
  String get sync_restore__finishing_checks =>
      'Wiederherstellungsprüfungen werden abgeschlossen.';

  @override
  String get sync_restore__no_synced_items =>
      'Keine synchronisierten Elemente gefunden';

  @override
  String sync_restore__restored_count({required int count}) {
    return '$count wiederhergestellt';
  }

  @override
  String sync_restore__restored_of_total({
    required int synced,
    required int total,
  }) {
    return '$synced von $total wiederhergestellt';
  }

  @override
  String get sync_restore__progress_estimating => 'Wird geschätzt';

  @override
  String get sync_restore__progress_complete => 'Abgeschlossen';

  @override
  String get sync_restore__status_ready => 'Bereit';

  @override
  String get sync_restore__status_restoring => 'Wiederherstellung';

  @override
  String get sync_restore__collections_title => 'Sammlungen';

  @override
  String get sync_restore__collections_description =>
      'Gespeicherte Gruppen und Organisation';

  @override
  String get sync_restore__clipboard_items_title => 'Zwischenablageelemente';

  @override
  String get sync_restore__clipboard_items_description =>
      'Verlauf, Text, Links, Dateien und Medien';

  @override
  String sync_restore__count_of_total({required int total}) {
    return 'von $total';
  }

  @override
  String get sync_restore__continue_to_copycat => 'Weiter zu CopyCat';

  @override
  String get sync_restore__failed_title => 'Wiederherstellung fehlgeschlagen';

  @override
  String get restore_clips__text__title =>
      'Mein Zwischenablage wiederherstellen';

  @override
  String get restore_clips__error__no_backup =>
      'Kein Zwischenablage-Backup gefunden';

  @override
  String restore_clips__text__total_count({required int totalCount}) {
    return 'Sie haben etwa $totalCount Clip(s), die wiederhergestellt werden müssen.';
  }

  @override
  String get restore_clips__sync_disable =>
      'Die Synchronisierung ist derzeit deaktiviert. Bitte aktivieren Sie sie, um fortzufahren.';

  @override
  String get restore_clips__preparing =>
      'Vorbereitung der Wiederherstellung der Clips. Bitte warten...';

  @override
  String restore_clips__restored({required int syncCount}) {
    return 'Ihre $syncCount Clip(s) wurden erfolgreich wiederhergestellt.';
  }

  @override
  String restore_clips__restoring({
    required int synced,
    required int totalCount,
  }) {
    return 'Wiederhergestellt: $synced von $totalCount Clips.';
  }

  @override
  String get restore_collections__text__title =>
      'Meine Sammlungen wiederherstellen';

  @override
  String get restore_collections__error__no_backup =>
      'Kein Sammlungs-Backup gefunden';

  @override
  String restore_collections__text__total_count({required int totalCount}) {
    return 'Sie haben etwa $totalCount Sammlung(en), die wiederhergestellt werden müssen.';
  }

  @override
  String get restore_collections__sync_disable =>
      'Die Synchronisierung ist derzeit deaktiviert. Bitte aktivieren Sie sie, um fortzufahren.';

  @override
  String get restore_collections__preparing =>
      'Vorbereitung der Wiederherstellung der Sammlungen. Bitte warten...';

  @override
  String restore_collections__restored({required int syncCount}) {
    return 'Ihre $syncCount Sammlung(en) wurden erfolgreich wiederhergestellt.';
  }

  @override
  String restore_collections__restoring({
    required int synced,
    required int totalCount,
  }) {
    return 'Wiederhergestellt: $synced von $totalCount Sammlungen.';
  }

  @override
  String get drive__snackbar__success => 'Laufwerksetup ist nun abgeschlossen.';

  @override
  String get drive__text__setting_up => 'Einrichten und Synchronisieren...';

  @override
  String get drive__text__setting_up__warning =>
      'Bitte warten Sie, während wir dies abschließen. Schließen Sie die App nicht.';

  @override
  String get create_clip__appbar__title__new => 'Neuer Clip';

  @override
  String get create_clip__appbar__title__edit => 'Clip bearbeiten';

  @override
  String get create_clip__button__save_new => 'Als neu speichern';

  @override
  String get create_clip__input__hint =>
      'Schreiben Sie hier den Inhalt Ihres Clips';

  @override
  String get collections__text__tip =>
      'Um sicherzustellen, dass Ihre wichtigen Clips jederzeit, unabhängig von der Zeit, auf all Ihren Geräten verfügbar sind, speichern Sie sie in einer Sammlung!';

  @override
  String get collections__appbar__title => 'Sammlungen';

  @override
  String get collections__appbar__title__create => 'Sammlung erstellen';

  @override
  String get collections__appbar__title__edit => 'Sammlung bearbeiten';

  @override
  String get collections__input__name => 'Name';

  @override
  String get collections__input__description => 'Beschreibung';

  @override
  String get collections__label__emoji =>
      'Sammlungssymbol (zum Ändern klicken)';

  @override
  String get collections__validation__duplicate =>
      'Eine Sammlung mit diesem Symbol und Namen existiert bereits';

  @override
  String get collections__validation__name_required =>
      'Bitte geben Sie einen Namen ein.';

  @override
  String get collections__validation__name_max_length =>
      'Der Name darf höchstens 30 Zeichen lang sein.';

  @override
  String get select_collection__appbar__title => 'Sammlung auswählen';

  @override
  String get account__dialog__delete_confirm__title => 'Konto-Löschanfrage';

  @override
  String get account__dialog__delete_confirm__description =>
      'Sie werden zum Formular für die Konto-Löschanfrage weitergeleitet, sind Sie sicher?';

  @override
  String get account__list_tile__display_name => 'Anzeigename';

  @override
  String get account__list_tile__email => 'E-Mail';

  @override
  String get account__list_tile__settings => 'Kontoeinstellungen';

  @override
  String get account__list_tile__danger_zone => 'Gefahrenzone';

  @override
  String get account__button__req_delete => 'Konto-Löschung anfordern';

  @override
  String get account__appbar__title => 'Mein Konto';

  @override
  String get settings__appbar__title => 'Einstellungen';

  @override
  String get settings__header__appearance => 'Darstellung';

  @override
  String get settings__header__sorting => 'Standardsortierung';

  @override
  String get settings__header__interactions => 'Interaktionen';

  @override
  String get settings__tab__1 => 'Allgemein';

  @override
  String get settings__tab__2 => 'Anpassung';

  @override
  String get settings__tab__3 => 'Cloud';

  @override
  String get settings__tab__4 => 'Sicherheit';

  @override
  String get settings__tab__5 => 'Experimentell';

  @override
  String get settings__text__encryption => 'Verschlüsselung';

  @override
  String get settings__text__sync_not_available =>
      'Synchronisierungsbezogene Konfigurationen sind nicht verfügbar, wenn die lokale Zwischenablage verwendet wird.';

  @override
  String get settings__appbar__er__title => 'Ausschlussregeln';

  @override
  String get settings__text__er__predefine => 'Vordefinierte Ausschlussregeln';

  @override
  String get settings__text__er__pass_manager => 'Passwortmanager';

  @override
  String get settings__text__er__cc => 'Kreditkartennummer';

  @override
  String get settings__text__er__phone => 'Telefonnummer';

  @override
  String get settings__text__er__email => 'E-Mail-Adresse';

  @override
  String get settings__text__er__url => 'Empfindliche URL';

  @override
  String get settings__text__decrypted__note =>
      '🥳 Glückwunsch! Alle Ihre Clips wurden erfolgreich lokal entschlüsselt, \n sodass das Erneuern der Datenbank nicht erforderlich ist.';

  @override
  String get settings__appbar__cer__title =>
      'Benutzerdefinierte Ausschlussregeln';

  @override
  String get settings__switch__drag_n_drop__title => 'Ziehen und Ablegen';

  @override
  String get settings__switch__drag_n_drop__subtitle =>
      'Ermöglichen Sie es, Elemente innerhalb der App frei in beiden Richtungen zu bewegen.';

  @override
  String get settings__dropdown__no_copy_over_limit__title =>
      'Nicht automatisch kopieren über';

  @override
  String settings__dropdown__no_copy_over_limit__subtitle({
    required String fileSize,
  }) {
    return 'Dateien und Medien über eine bestimmte Größe ($fileSize) werden nicht automatisch kopiert.';
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
      'Nicht automatisch hochladen über';

  @override
  String settings__dropdown__no_upload_over_limit__subtitle({
    required String fileSize,
  }) {
    return 'Dateien und Medien über eine bestimmte Größe ($fileSize) werden nicht automatisch hochgeladen.';
  }

  @override
  String get settings__dropdown__sync_mode__title => 'Synchronisierungsmodus';

  @override
  String get settings__dropdown__sync_mode__subtitle =>
      'Wählen Sie die Synchronisierungsgeschwindigkeit, die am besten für Sie funktioniert.';

  @override
  String get settings__sync_mode__realtime => 'Echtzeit';

  @override
  String get settings__sync_mode__balanced => 'Ausgeglichen';

  @override
  String get settings__dropdown__theme__title => 'Themenmodus';

  @override
  String get settings__dropdown__default_sort__title => 'Sortieren nach';

  @override
  String get settings__dropdown__default_sort_order__title =>
      'Sortierreihenfolge';

  @override
  String get settings__theme__system => 'System';

  @override
  String get settings__theme__light => 'Hell';

  @override
  String get settings__theme__dark => 'Dunkel';

  @override
  String get settings__dropdown__color_mode__title => 'Farbmodus';

  @override
  String get settings__dropdown__color_mode__subtitle =>
      'Wählen Sie den Farbmodus, um das Erscheinungsbild der App anzupassen. Die Standardoption ist \'Tonal Spot\'.';

  @override
  String get settings__color_mode__tonalSpot => 'Tonal Spot';

  @override
  String get settings__color_mode__content => 'Inhalt';

  @override
  String get settings__color_mode__expressive => 'Ausdrucksstark';

  @override
  String get settings__color_mode__fidelity => 'Fidelität';

  @override
  String get settings__color_mode__fruit_salad => 'Obstsalat';

  @override
  String get settings__color_mode__monochrome => 'Monochrom';

  @override
  String get settings__color_mode__neutral => 'Neutral';

  @override
  String get settings__color_mode__rainbow => 'Regenbogen';

  @override
  String get settings__color_mode__vibrant => 'Lebendig';

  @override
  String get settings__tile__cer_title => 'Benutzerdefinierte Regeln';

  @override
  String get settings__tile__cer_subtitle =>
      'Ausschluss nach App, App-Fenster/Website-Titel, Website-URL oder Regex-Muster';

  @override
  String get settings__tile__er_title => 'Ausschlussregeln';

  @override
  String get settings__tile__er_subtitle =>
      'Verhindern, dass Informationen in die Zwischenablage kopiert werden. Für erweiterte Kontrolle klicken.';

  @override
  String get settings__switch__enable_sync__title =>
      'Zwischenablage-Synchronisierung';

  @override
  String get settings__switch__enable_sync__subtitle =>
      'Synchronisieren Sie Ihre Zwischenablage mühelos über mehrere Geräte.';

  @override
  String get settings__switch__sync_file__title =>
      'Datei- und Medien-Synchronisierung';

  @override
  String get settings__switch__sync_file__subtitle =>
      'Aktivieren, um Dateien und Medien-Clips über Geräte hinweg zu synchronisieren.';

  @override
  String get settings__switch__paused__title =>
      'Zwischenablage-Listener pausieren';

  @override
  String get settings__switch__paused__subtitle =>
      'Halten Sie das Zwischenablagen-Tracking vorübergehend an, bis zu einer festgelegten Zeit.';

  @override
  String settings__switch__paused_active__subtitle({required DateTime time}) {
    final intl.DateFormat timeDateFormat = intl.DateFormat(
      'h:mm a',
      localeName,
    );
    final String timeString = timeDateFormat.format(time);

    return 'Pausiert bis $timeString. Tippen Sie, um fortzusetzen oder die Zeit anzupassen.';
  }

  @override
  String get settings__switch__smart_paste__title => 'Smartes Einfügen';

  @override
  String get settings__switch__smart_paste__subtitle =>
      'Fügen Sie Inhalte direkt in die fokussierte App ein.';

  @override
  String get settings__switch__transform_behavior__title =>
      'Transformationen als neue Clips speichern';

  @override
  String get settings__switch__transform_behavior__subtitle =>
      'Wenn aktiviert, erstellen Transformationsaktionen einen neuen Clip, statt sofort zu kopieren oder einzufügen.';

  @override
  String get settings__switch__type_search__title =>
      'Suche während der Eingabe';

  @override
  String get settings__switch__type_search__subtitle =>
      'Durchsuchen Sie Clips während der Eingabe in der Suchleiste.';

  @override
  String get settings__switch__startup__title => 'Beim Start starten';

  @override
  String get settings__switch__startup__subtitle =>
      'Starten Sie CopyCat automatisch, wenn Ihr Gerät eingeschaltet wird.';

  @override
  String get settings__switch__tray_icon__title =>
      'Menüleisten-Symbol anzeigen';

  @override
  String get settings__switch__tray_icon__subtitle =>
      'Zeigt das CopyCat-Symbol in der System-Menüleiste bzw. im Tray an.';

  @override
  String get settings__switch__hide_from_screen_capture__title =>
      'Vor Bildschirmaufnahmen schützen';

  @override
  String get settings__switch__hide_from_screen_capture__subtitle =>
      'Wenn aktiviert, werden CopyCat-Inhalte bei Bildschirmfotos und Aufzeichnungen auf unterstützten Plattformen ausgeblendet.';

  @override
  String get settings__switch__hotkey__title =>
      'Mit Tastenkombination umschalten';

  @override
  String get settings__switch__hotkey__subtitle =>
      'Verwenden Sie eine Tastenkombination, um schnell auf Ihre CopyCat Zwischenablage zuzugreifen';

  @override
  String get settings__switch__paste_stack_hotkey__title =>
      'Paste-Stack-Hotkey';

  @override
  String get settings__switch__paste_stack_hotkey__subtitle =>
      'Verwenden Sie eine Tastenkombination, um den Paste Stack zu öffnen oder zu schließen';

  @override
  String get settings__switch__quickpaste_hotkey__title => 'Quick-Paste-Hotkey';

  @override
  String get settings__switch__quickpaste_hotkey__subtitle =>
      'Verwenden Sie eine Tastenkombination, um sofort auf Ihre obersten 10 Zwischenablageelemente zuzugreifen';

  @override
  String get settings__hotkey__unassigned => 'Nicht zugewiesen';

  @override
  String get settings__hotkey__preview_start => 'Drücken ';

  @override
  String get settings__hotkey__preview_end =>
      ', um die App anzuzeigen oder auszublenden.';

  @override
  String get settings__tile__theme_color__title => 'Themenfarbe';

  @override
  String get settings__tile__theme_color__subtitle =>
      'Diese Farbe beeinflusst das gesamte Erscheinungsbild der App.';

  @override
  String get settings__tile__desk_client__title =>
      'Desktop-Client herunterladen';

  @override
  String get settings__tile__mobile_client__title =>
      'Telefonclient herunterladen';

  @override
  String get settings__tile__client__subtitle =>
      'Greifen Sie auf Ihrer Zwischenablage auf all Ihren Geräten zu.';

  @override
  String get settings__tile__e2e_setup__title =>
      'Einrichtung der Ende-zu-Ende-Verschlüsselung';

  @override
  String get settings__tile__e2e_setup__subtitle =>
      'Verschlüsselung für Ihre Clips einrichten.';

  @override
  String get settings__switch__e2e__title => 'Verschlüsselung aktivieren';

  @override
  String get settings__switch__e2e__subtitle =>
      'Umschalten, um Ende-zu-Ende-Verschlüsselung für Ihre Clips zu aktivieren oder zu deaktivieren.';

  @override
  String get settings__switch__e2e_nonce__title =>
      'Hochsicherheitsmodus (Empfohlen)';

  @override
  String get settings__switch__e2e_nonce__subtitle =>
      'Verwendet AES-GCM für besseren Datenschutz und die Erkennung von Manipulationen. (Ältere App-Versionen können diese neuen Clips nicht entschlüsseln)';

  @override
  String get settings__dialog__conn_gdrive__title =>
      'Google Drive erneut verbinden?';

  @override
  String get settings__dialog__conn_gdrive__subtitle =>
      'Ihr Google Drive ist bereits verbunden! Möchten Sie die Verbindung erneut herstellen?\n\nUm jeglichen Datenverlust zu vermeiden, verwenden Sie bitte dasselbe Konto wie zuvor.';

  @override
  String get settings__drive__connected => 'Verbunden';

  @override
  String get settings__drive__loading => 'Laden...';

  @override
  String get settings__drive__authorizing => 'Autorisieren...';

  @override
  String get settings__drive__disconnected => 'Getrennt';

  @override
  String get settings__text__cloud__title => 'Cloud-Laufwerk';

  @override
  String get settings__text__cloud__name => 'Google Drive';

  @override
  String get settings__text__gdrive__error =>
      'Google Drive ist nicht verbunden. Datei- und Mediensynchronisation sind derzeit deaktiviert.';

  @override
  String get settings__text__gdrive__info =>
      'Ihre Dateien und Medien werden sicher über Google Drive hinweg synchronisiert und gewährleisten so den Schutz Ihrer Privatsphäre.';

  @override
  String get settings__tile__other_cloud__title =>
      'Anderen Cloud-Speicher einrichten';

  @override
  String get settings__tile__other_cloud__subtitle =>
      'Richten Sie andere Cloud-Speicher wie Dropbox, OneDrive usw. ein.';

  @override
  String get settings__app_lock__title => 'App-Sperre';

  @override
  String get settings__app_lock__tile__subtitle =>
      'Biometrie oder Geräte-PIN für den Zugriff auf die Zwischenablage erforderlich';

  @override
  String get settings__app_lock__no_biometrics =>
      'Keine Biometrie oder Geräteanmeldedaten gefunden. Richten Sie zuerst eine PIN oder Biometrie in den Geräteeinstellungen ein.';

  @override
  String get settings__app_lock__lock_after__title => 'Sperren nach';

  @override
  String get settings__app_lock__lock_after__subtitle =>
      'Automatisch sperren, wenn die App in den Hintergrund geht';

  @override
  String get settings__app_lock__timeout__immediately => 'Sofort';

  @override
  String settings__app_lock__timeout__minutes({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Minuten',
      one: 'Minute',
    );
    return '$count $_temp0';
  }

  @override
  String get app_lock__screen__locked => 'Gesperrt';

  @override
  String get app_lock__screen__unlock => 'Entsperren';

  @override
  String get settings__lan__title => 'Lokales Netzwerk';

  @override
  String get settings__lan__service_inactive =>
      'Starten Sie den Hintergrunddienst zur LAN-Synchronisierung';

  @override
  String get settings__lan__subtitle__disabled =>
      'Zwischenablage sofort mit Geräten in der Nähe synchronisieren';

  @override
  String get settings__lan__subtitle__mobile =>
      'Hintergrunddienst sucht nach Geräten in der Nähe';

  @override
  String get settings__lan__searching => 'Suche nach Geräten…';

  @override
  String settings__lan__devices_found({required int count}) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Geräte',
      one: 'Gerät',
    );
    return '$count $_temp0 im Netzwerk gefunden';
  }

  @override
  String get settings__auto_write__title =>
      'Automatisch schreiben beim Empfang';

  @override
  String get settings__auto_write__subtitle =>
      'Eingehende Clips automatisch in die Zwischenablage kopieren';

  @override
  String get settings__sync__manage_devices__title =>
      'Synchronisierungsgeräte verwalten';

  @override
  String get settings__sync__manage_devices__subtitle =>
      'Aktive Geräte anzeigen und Geräte aus dem Synchronisierungszugriff entfernen.';

  @override
  String get settings__lan_mesh__app_bar_title => 'Lokales Netzwerk';

  @override
  String get settings__lan_mesh__unknown_device => 'Unbekanntes Gerät';

  @override
  String get settings__lan_mesh__searching => 'Suche nach Geräten im Netzwerk…';

  @override
  String get settings__lan_mesh__reachable => 'Erreichbar';

  @override
  String get settings__lan_mesh__unreachable => 'Nicht erreichbar';

  @override
  String get settings__lan_mesh__disabled_banner =>
      'LAN-Sofortsynchronisierung ist deaktiviert. Aktivieren Sie sie in den Einstellungen, um Geräte in der Nähe zu entdecken.';

  @override
  String get settings__device_mgmt__app_bar_title =>
      'Synchronisierungsgeräte verwalten';

  @override
  String get settings__device_mgmt__dialog_title =>
      'Synchronisierungszugriff entfernen';

  @override
  String get settings__device_mgmt__dialog_cancel => 'Abbrechen';

  @override
  String get settings__device_mgmt__dialog_remove => 'Entfernen';

  @override
  String get settings__device_mgmt__revoke_failed =>
      'Fehler beim Entfernen des Synchronisierungszugriffs.';

  @override
  String get settings__device_mgmt__active_now => 'Gerade aktiv';

  @override
  String settings__device_mgmt__today_at({required String time}) {
    return 'Heute um $time';
  }

  @override
  String settings__device_mgmt__days_ago({required int count}) {
    return 'vor ${count}T';
  }

  @override
  String get settings__device_mgmt__load_failed =>
      'Fehler beim Laden der Geräte.';

  @override
  String get settings__device_mgmt__retry => 'Erneut versuchen';

  @override
  String get settings__device_mgmt__empty =>
      'Keine Synchronisierungsgeräte gefunden.';

  @override
  String get settings__device_mgmt__max_limit_tooltip =>
      'Maximale Anzahl von Geräten, die Sie mit Ihrem aktuellen Plan synchronisieren können.';

  @override
  String settings__device_mgmt__max_limit_label({required int count}) {
    return 'Max. Limit • $count';
  }

  @override
  String get settings__device_mgmt__active_count_tooltip =>
      'Anzahl der derzeit aktiven Geräte.';

  @override
  String settings__device_mgmt__active_count_label({required int count}) {
    return 'Aktiv • $count';
  }

  @override
  String settings__device_card__last_seen({required String time}) {
    return 'Zuletzt gesehen: $time';
  }

  @override
  String get settings__device_card__revoke => 'Widerrufen';

  @override
  String get custom_er__nav__1 => 'App';

  @override
  String get custom_er__nav__2 => 'Fenstertitel';

  @override
  String get custom_er__nav__3 => 'Url';

  @override
  String get custom_er__nav__4 => 'Textmuster';

  @override
  String get custom_er__text__not_supported =>
      'Dieser Ausschluss wird noch nicht unterstützt';

  @override
  String get custom_er__tile__add_app => 'Eine App hinzufügen';

  @override
  String get custom_er__text__no_app =>
      'Noch keine benutzerdefinierte App ausgeschlossen';

  @override
  String get custom_er__button__remove_app => 'Diese App entfernen';

  @override
  String get custom_er__tile__pattern =>
      'Kopieren verhindern, wenn der kopierte Inhalt diesen Mustern entspricht';

  @override
  String get custom_er__text__no_pattern =>
      'Keine benutzerdefinierten Muster ausgeschlossen';

  @override
  String get custom_er__button__remove_pattern => 'Dieses Muster entfernen';

  @override
  String get custom_er__tile__url =>
      'Kopieren aus einer Website verhindern, die diesen URL-Bereichen entspricht.';

  @override
  String get custom_er__input__url_hint =>
      'Geben Sie hier eine URL oder einen Teil einer URL ein.';

  @override
  String get custom_er__text__no_url =>
      'Keine benutzerdefinierten URLs ausgeschlossen';

  @override
  String get custom_er__button__remove_url => 'Diese URL entfernen';

  @override
  String get custom_er__tile__title =>
      'Kopieren aus App oder Website verhindern, wenn der Fenstertitel übereinstimmt.';

  @override
  String get custom_er__text__no_title =>
      'Keine benutzerdefinierten Titel ausgeschlossen';

  @override
  String get custom_er__button__remove_title => 'Diesen Titel entfernen';

  @override
  String get about__tile__discord => 'Discord • Verbinden';

  @override
  String get about__tile__youtube => 'YouTube • Tutorial';

  @override
  String get about__tile__read_tut => 'Lesen • Tutorial';

  @override
  String get about__tile__github => 'Github • Open Source';

  @override
  String get about__tile__website => 'EntilityStudio • Website';

  @override
  String get about__tile__support => 'Unterstützung';

  @override
  String get abc_title => 'Hintergrund-Clipboard';

  @override
  String get abc__tile__subtitle => 'Hören Sie den Clipboard im Hintergrund';

  @override
  String get abc__tip__why_title =>
      'Warum werden diese Berechtigungen benötigt?';

  @override
  String get abc__tip__why_subtitle =>
      'Diese Berechtigungen stellen sicher, dass CopyCat im Hintergrund korrekt funktioniert, kopierte Inhalte erkennt und Ihnen eine nahtlose Erfahrung ohne Unterbrechungen bietet.';

  @override
  String get abc__tip__support_title => 'Begrenzte Unterstützung';

  @override
  String get abc__tip__support_subtitle =>
      '1. Derzeit werden nur Textclips unterstützt.\n2. Einige Betriebssysteme, wie HyperOS 1, werden noch nicht unterstützt.';

  @override
  String get abc__heading__req_perm => 'Erforderliche Berechtigungen';

  @override
  String get abc__tile__notification_title => 'Benachrichtigungszugriff';

  @override
  String get abc__tile__notification_subtitle =>
      'Zeigt eine persistente Benachrichtigung an, um Sie darüber zu informieren, dass CopyCat im Hintergrund läuft, wodurch Transparenz und Datenschutz gewährleistet werden.';

  @override
  String get abc__tile__battery_opt_title => 'Batterieoptimierung';

  @override
  String get abc__tile__battery_opt_subtitle =>
      'Verhindert, dass das System CopyCat im Hintergrund schließt, und sorgt so für eine unterbrechungsfreie Erfahrung.';

  @override
  String get abc__tile__overlay_title => 'Overlay-Berechtigung';

  @override
  String get abc__tile__overlay_subtitle =>
      'Ermöglicht es CopyCat, das Clipboard zu lesen, indem ein transparentes Fenster über dem Bildschirm geöffnet und sofort wieder geschlossen wird.';

  @override
  String get abc__tile__acc_title => 'Zugriffsservice';

  @override
  String get abc__tile__acc_subtitle =>
      'Startet den Hintergrund-Listener von CopyCat, um zu erkennen, wann Sie etwas kopieren, und stellt sicher, dass der Service nach einem Neustart automatisch neu gestartet wird.';

  @override
  String get abc__ack__ready => 'Setup bereit zur Konfiguration.';

  @override
  String get abc__ack__preparing => 'Setup wird vorbereitet, bitte warten...';

  @override
  String get abc__perm_alert_open_setting__button => 'Einstellungen öffnen';

  @override
  String get abc__overlay_perm_alert__title => 'Overlay-Berechtigung';

  @override
  String get abc__overlay_perm_alert__subtitle =>
      'CopyCat Clipboard benötigt die \'Über andere Apps zeichnen\' Berechtigung, um den Inhalt der Zwischenablage im Hintergrund zu lesen.';

  @override
  String get abc__overlay_perm_alert__p1_prefix => 'Diese Berechtigung wird ';

  @override
  String get abc__overlay_perm_alert__p1_bold =>
      'nur zur Zwischenablageerkennung verwendet';

  @override
  String get abc__overlay_perm_alert__p1_suffix =>
      ' wenn Sie etwas im Hintergrund kopieren.';

  @override
  String get abc__overlay_perm_alert__p2_prefix => 'Wenn aktiviert, ';

  @override
  String get abc__overlay_perm_alert__p2_bold =>
      'erstellt CopyCat ein transparentes Fenster mit 0 Pixel';

  @override
  String get abc__overlay_perm_alert__p2_suffix =>
      ' um die App kurz in den Vordergrund zu bringen, um die Zwischenablagedaten zu lesen.';

  @override
  String get abc__overlay_perm_alert__p3_prefix => 'Die App ';

  @override
  String get abc__overlay_perm_alert__p3_bold => 'zeigt nichts an';

  @override
  String get abc__overlay_perm_alert__p3_suffix =>
      ' auf Ihrem Bildschirm während dieses Prozesses.';

  @override
  String get abc__overlay_perm_alert__p4_prefix =>
      'Auf einigen Geräten kann das System eine Toast-Nachricht anzeigen ';

  @override
  String get abc__overlay_perm_alert__p4_bold =>
      '\'CopyCat hat aus Ihrer Zwischenablage eingefügt\'';

  @override
  String get abc__overlay_perm_alert__p4_suffix =>
      ' wenn CopyCat Ihren Zwischenablageinhalt liest.';

  @override
  String get abc__overlay_perm_alert__agree =>
      'Durch die Erteilung dieser Berechtigung stimmen Sie der oben genannten Nutzung zu.';

  @override
  String get abc__accessibility_perm_alert__title =>
      'Zugriffsberechtigungsservice';

  @override
  String get abc__accessibility_perm_alert__subtitle =>
      'CopyCat Clipboard benötigt den Zugriffsservice, um im Hintergrund zu laufen und die Zwischenablage in Echtzeit zu erkennen und zu synchronisieren.';

  @override
  String get abc__accessibility_perm_alert__p1_prefix => 'Dieser Service wird ';

  @override
  String get abc__accessibility_perm_alert__p1_bold => 'nur verwendet';

  @override
  String get abc__accessibility_perm_alert__p1_suffix =>
      ' zur Erkennung des Zwischenablageinhalts und zur Synchronisierung über Geräte hinweg, wenn er aktiviert ist.';

  @override
  String get abc__accessibility_perm_alert__p2_prefix => 'Sie können ';

  @override
  String get abc__accessibility_perm_alert__p2_bold =>
      'bestimmte Apps ausschließen';

  @override
  String get abc__accessibility_perm_alert__p2_suffix =>
      ' mit der Funktion Ausschlussregeln.';

  @override
  String get abc__accessibility_perm_alert__p3_prefix => 'Die App ';

  @override
  String get abc__accessibility_perm_alert__p3_bold =>
      'greift nicht auf andere Daten zu';

  @override
  String get abc__accessibility_perm_alert__p3_suffix =>
      ' über den Zwischenablageinhalt hinaus.';

  @override
  String get abc__accessibility_perm_alert__p4_prefix => 'Zwischenablagedaten ';

  @override
  String get abc__accessibility_perm_alert__p4_bold =>
      'werden nicht extern geteilt';

  @override
  String get abc__accessibility_perm_alert__p4_suffix =>
      ' und bleiben privat auf Ihren Geräten.';

  @override
  String get abc__accessibility_perm_alert__p5_prefix => 'Zwischenablagedaten ';

  @override
  String get abc__accessibility_perm_alert__p5_bold =>
      'werden Ende-zu-Ende verschlüsselt';

  @override
  String get abc__accessibility_perm_alert__p5_suffix =>
      ' (wenn aktiviert) während der Übertragung und im Ruhezustand, um die Privatsphäre über Geräte hinweg zu gewährleisten.';

  @override
  String get abc__accessibility_perm_alert__agree =>
      'Durch das Aktivieren des Zugriffsservices erkennen Sie die oben genannten Bedingungen an und stimmen ihnen zu.';

  @override
  String get abc__other_setting__title => 'Weitere Einstellungen';

  @override
  String get abc__tile__two_way_sync__title => '2-Wege-Synchronisierung';

  @override
  String abc__tile__two_way_sync__subtitle({required String warning}) {
    return 'Hält Ihre Zwischenablage geräteübergreifend sofort synchron.\n$warning';
  }

  @override
  String get abc__tile__two_way_sync__realtime_required =>
      '⚠️ Echtzeitmodus erforderlich.';

  @override
  String get abc__ack__detection_mode_cleared =>
      'Erkennungsmodus zurückgesetzt';

  @override
  String get abc__ack__detection_mode_updated => 'Erkennungsmodus aktualisiert';

  @override
  String abc__ack__detection_mode_update_failed({required String message}) {
    return 'Erkennungsmodus konnte nicht aktualisiert werden: $message';
  }

  @override
  String get abc__detection_mode__title => 'Erkennungsmodus';

  @override
  String get abc__detection_mode__subtitle__enabled =>
      'Wählen Sie, wie CopyCat Kopiervorganäge in anderen Apps erkennt. CopyCat bleibt inaktiv, bis Sie einen Modus auswählen.';

  @override
  String get abc__detection_mode__subtitle__disabled =>
      'Aktivieren Sie zuerst den Bedienungshilfendienst und wählen Sie dann einen Erkennungsmodus.';

  @override
  String get abc__network__header => 'Netzwerk';

  @override
  String current_time__local({required String time}) {
    return 'Lokal: $time';
  }

  @override
  String current_time__utc({required String time}) {
    return 'UTC: $time';
  }

  @override
  String encrypted_stat__summary({required int count}) {
    return 'Sie haben derzeit $count verschlüsselte Clips, auf die nicht zugegriffen werden kann.';
  }

  @override
  String get encrypted_stat__all_decrypted =>
      '🥳 Glückwunsch! Alle Ihre Clips wurden erfolgreich lokal entschlüsselt, daher ist kein Neuaufbau der Datenbank erforderlich.';

  @override
  String get encrypted_stat__rebuild_database => 'Datenbank neu aufbauen';

  @override
  String tray__tooltip__paused_till({required String time}) {
    return 'CopyCat Zwischenablage - Pausiert bis $time';
  }

  @override
  String get tray__menu__resume_copycat => 'Fortsetzen';

  @override
  String get tray__menu__pause_copycat => 'Pausieren';

  @override
  String get tray__menu__paste_stack => 'Paste Stack';

  @override
  String get tray__dialog__quit__subtitle =>
      'Möchten Sie die Anwendung wirklich beenden?';

  @override
  String get splash__checking_authentication =>
      'Authentifizierung wird überprüft...';

  @override
  String paste_stack__title({required int count}) {
    return 'Paste Stack • $count';
  }

  @override
  String get paste_stack__reverse_tooltip => 'Stapel umkehren';

  @override
  String get multi_paste__title => 'Mehrfaches Einfügen konfigurieren';

  @override
  String get multi_paste__subtitle =>
      'Steuern Sie, wie ausgewählte Clips zusammengeführt und getaktet werden.';

  @override
  String get multi_paste__stat__selected => 'Ausgewählt';

  @override
  String get multi_paste__stat__text => 'Text';

  @override
  String get multi_paste__stat__non_text => 'Nicht-textlicher Inhalt';

  @override
  String get multi_paste__merge__title =>
      'Aufeinanderfolgende Textclips zusammenführen';

  @override
  String get multi_paste__merge__subtitle =>
      'Textclips werden zusammengeführt, bis ein Nicht-Text-Clip die Sequenz unterbricht.';

  @override
  String get multi_paste__separator__title => 'Trennzeichen';

  @override
  String get multi_paste__separator__new_line => 'Neue Zeile';

  @override
  String get multi_paste__separator__space => 'Leerzeichen';

  @override
  String get multi_paste__separator__custom => 'Benutzerdefiniert';

  @override
  String get multi_paste__separator__custom_label =>
      'Benutzerdefiniertes Trennzeichen';

  @override
  String get multi_paste__separator__custom_hint =>
      'Unterstützt Escape-Sequenzen wie \\n und \\t';

  @override
  String get multi_paste__pacing__title => 'Einfügeverzögerung';

  @override
  String get multi_paste__pacing__subtitle =>
      'Erhöhen Sie die Verzögerung, wenn die Ziel-App Einfügeereignisse verpasst.';

  @override
  String get multi_paste__wait_between_pastes =>
      'Verzögerung zwischen Einfügevorgängen';

  @override
  String get multi_paste__validation__wait_positive =>
      'Die Wartezeit muss eine positive Zahl sein.';

  @override
  String get multi_paste__validation__custom_separator_required =>
      'Bitte geben Sie ein benutzerdefiniertes Trennzeichen ein.';

  @override
  String get settings__tile__backup_restore__title =>
      'Backup & Wiederherstellung';

  @override
  String get settings__tile__backup_restore__subtitle =>
      'Erstellen Sie .ccbkup-Backups und stellen Sie lokal wieder her';

  @override
  String get settings__switch__rich_data_capture__title => 'Rich Data Capture';

  @override
  String get settings__switch__rich_data_capture__subtitle =>
      'Formatierungen beim Kopieren und Einfügen zwischen Apps beibehalten.';

  @override
  String get settings__decrypt__title => 'Zwischenablage-Entschlüsselung';

  @override
  String settings__decrypt__count({required int count}) {
    return 'Derzeit haben Sie lokal $count verschlüsselte Clips.';
  }

  @override
  String settings__decrypt__progress({
    required int decrypted,
    required int total,
  }) {
    return 'Entschlüsselt: $decrypted von $total Clips.';
  }

  @override
  String get settings__decrypt__warning =>
      '⚠️ Bitte lassen Sie diesen Bildschirm während dieses Vorgangs geöffnet, um Datenbeschädigungen oder Inkonsistenzen zu vermeiden.';

  @override
  String get not_found__title => 'Seite nicht gefunden';

  @override
  String get not_found__subtitle => 'Die gesuchte Seite wurde nicht gefunden.';

  @override
  String get not_found__go_home => 'Zur Startseite';

  @override
  String get backup_restore__dialog__save_as => 'Backup speichern unter';

  @override
  String get backup_restore__busy__creating => 'Backup wird erstellt...';

  @override
  String get backup_restore__error__encryption_unavailable =>
      'Die Verschlüsselung ist aktiviert, derzeit aber nicht verfügbar. Bitte entsperren Sie E2EE und versuchen Sie es erneut.';

  @override
  String backup_restore__snackbar__saved({required String outputPath}) {
    return 'Backup gespeichert unter $outputPath';
  }

  @override
  String backup_restore__snackbar__create_failed({required String message}) {
    return 'Backup fehlgeschlagen: $message';
  }

  @override
  String get backup_restore__dialog__select_file => 'Backup-Datei auswählen';

  @override
  String get backup_restore__dialog__restore_title => 'Backup wiederherstellen';

  @override
  String get backup_restore__dialog__restore_subtitle =>
      'Geben Sie ein Passwort ein, falls dieses Backup passwortgeschützt ist.';

  @override
  String get backup_restore__dialog__restore_action => 'Wiederherstellen';

  @override
  String get backup_restore__busy__restoring =>
      'Backup wird wiederhergestellt...';

  @override
  String backup_restore__snackbar__restore_completed({
    required int clips,
    required int collections,
  }) {
    return 'Wiederherstellung abgeschlossen: $clips Clips, $collections Sammlungen.';
  }

  @override
  String backup_restore__snackbar__restore_failed({required String message}) {
    return 'Wiederherstellung fehlgeschlagen: $message';
  }

  @override
  String get backup_restore__error__select_clip_type =>
      'Wählen Sie mindestens einen Clip-Typ aus.';

  @override
  String get backup_restore__error__from_after_to =>
      'Das Von-Datum muss vor dem Bis-Datum liegen.';

  @override
  String get backup_restore__dialog__options__description =>
      'Wählen Sie aus, was in dieses Backup-Archiv aufgenommen werden soll.';

  @override
  String get backup_restore__section__clip_types => 'Clip-Typen';

  @override
  String get backup_restore__section__cached_files =>
      'Zwischengespeicherte Dateien';

  @override
  String get backup_restore__input__max_cached_file_size =>
      'Maximale Größe zwischengespeicherter Dateien (MB)';

  @override
  String get backup_restore__input__max_cached_file_size__hint =>
      'Optional, z. B. 50';

  @override
  String get backup_restore__error__positive_number =>
      'Geben Sie eine positive Zahl ein.';

  @override
  String get backup_restore__text__select_file_media_for_cache_limit =>
      'Wählen Sie Datei- oder Medien-Cliptypen aus, um eine maximale Größe für den Cache festzulegen.';

  @override
  String get backup_restore__section__date_range => 'Datumsbereich';

  @override
  String get backup_restore__from_date => 'Von-Datum';

  @override
  String get backup_restore__to_date => 'Bis-Datum';

  @override
  String get backup_restore__no_minimum_date => 'Kein Mindestdatum';

  @override
  String get backup_restore__no_maximum_date => 'Kein Höchstdatum';

  @override
  String get backup_restore__clear_date_filter => 'Datumsfilter löschen';

  @override
  String get backup_restore__section__security => 'Sicherheit';

  @override
  String get backup_restore__toggle__password_protect =>
      'Backup mit Passwort schützen';

  @override
  String get backup_restore__input__password => 'Passwort';

  @override
  String get backup_restore__input__password__hint => 'Mindestens 6 Zeichen';

  @override
  String get backup_restore__error__password_min_length =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get backup_restore__dialog__create_manual_title =>
      'Manuelles Backup erstellen';

  @override
  String get backup_restore__appbar__title => 'Backup & Wiederherstellung';

  @override
  String get backup_restore__card__title =>
      'Manuelles Backup & Wiederherstellung';

  @override
  String get backup_restore__card__subtitle =>
      'Erstellen Sie lokale .ccbkup-Archive mit optionalem Passwortschutz und stellen Sie sie lokal mit Best-Effort-Deduplizierung wieder her.';

  @override
  String get backup_restore__actions__title => 'Aktionen';

  @override
  String get backup_restore__button__create => 'Backup erstellen';

  @override
  String get backup_restore__button__restore => 'Backup wiederherstellen';

  @override
  String get backup_restore__snapshot__backup_title =>
      'Letzte Backup-Zusammenfassung';

  @override
  String get backup_restore__snapshot__restore_title =>
      'Letzte Wiederherstellungs-Zusammenfassung';

  @override
  String get backup_restore__snapshot__restore_subtitle =>
      'Best-Effort-Deduplizierung und Integritätsbericht';

  @override
  String get backup_restore__empty_session =>
      'In dieser Sitzung wurde noch kein Backup oder keine Wiederherstellung ausgeführt.';

  @override
  String get backup_restore__label__collections => 'Sammlungen';

  @override
  String get backup_restore__label__clips => 'Clips';

  @override
  String get backup_restore__label__files_included => 'Dateien enthalten';

  @override
  String get backup_restore__label__files_missing => 'Dateien fehlen';

  @override
  String get backup_restore__label__files_skipped_by_size =>
      'Wegen Größe übersprungen';

  @override
  String get backup_restore__label__encrypted_clips => 'Verschlüsselte Clips';

  @override
  String get backup_restore__label__collections_restored =>
      'Sammlungen wiederhergestellt';

  @override
  String get backup_restore__label__collections_duplicates =>
      'Doppelte Sammlungen';

  @override
  String get backup_restore__label__collections_failed =>
      'Sammlungen fehlgeschlagen';

  @override
  String get backup_restore__label__clips_restored => 'Clips wiederhergestellt';

  @override
  String get backup_restore__label__clips_duplicates => 'Doppelte Clips';

  @override
  String get backup_restore__label__clips_failed => 'Clips fehlgeschlagen';

  @override
  String get backup_restore__label__attachments_restored =>
      'Anhänge wiederhergestellt';

  @override
  String get backup_restore__label__attachments_missing => 'Anhänge fehlen';

  @override
  String get backup_restore__label__attachments_failed =>
      'Anhänge fehlgeschlagen';

  @override
  String get backup_restore__label__corrupt_entries => 'Beschädigte Einträge';

  @override
  String get subscription__loading => 'Lädt...';

  @override
  String get review__dialog__title => 'Gefällt Ihnen CopyCat bisher?';

  @override
  String get review__dialog__message =>
      'Eine kurze Bewertung hilft mehr Menschen, CopyCat zu entdecken, und unterstützt neue Funktionen.';

  @override
  String get review__dialog__never => 'Nie';

  @override
  String get review__dialog__remind_later => 'In 7 Tagen erinnern';

  @override
  String get review__dialog__rate_now => 'Jetzt bewerten';

  @override
  String get settings__tile__review__title => 'CopyCat bewerten';

  @override
  String get settings__tile__review__subtitle =>
      'Hinterlassen Sie eine Bewertung im App Store';

  @override
  String get collections__read_only__banner =>
      'In Ihrem aktuellen Plan schreibgeschützt. Upgrade, um diese Sammlung zu bearbeiten.';

  @override
  String get collections__read_only__toast =>
      'Diese Sammlung ist in Ihrem aktuellen Plan schreibgeschützt. Upgrade, um alle Sammlungen zu bearbeiten.';

  @override
  String get collections__read_only__upgrade_action => 'Upgrade';

  @override
  String get collections__locked_section__label => 'Gesperrt';
}
