// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get app__name => 'Presse-papiers CopyCat';

  @override
  String get app__slogan => 'Un presse-papiers, des possibilités illimitées';

  @override
  String get app__unknown_error => 'Une erreur inattendue est survenue';

  @override
  String get app__downloading => 'Téléchargement...';

  @override
  String get app__download => 'Télécharger';

  @override
  String get app__follow_link => 'Suivre le lien';

  @override
  String get app__edit => 'Modifier';

  @override
  String get app__export => 'Exporter';

  @override
  String get app__delete => 'Supprimer';

  @override
  String get app__later => 'Passer';

  @override
  String get app__select => 'Sélectionner';

  @override
  String get app__change => 'Changer';

  @override
  String get app__confirm => 'Confirmer';

  @override
  String get app__action_required => 'Action requise';

  @override
  String get app__feature_unavailable =>
      'Cette fonctionnalité n\'est pas disponible pour votre plateforme.';

  @override
  String get app__preview => 'Aperçu';

  @override
  String get app__open_file => 'Ouvrir le fichier';

  @override
  String get app__change_collection => 'Changer de collection';

  @override
  String get app__share => 'Partager';

  @override
  String get app__uploading => 'Téléversement...';

  @override
  String get app__syncing => 'Synchronisation...';

  @override
  String get app__sync => 'Synchroniser';

  @override
  String get app__local => 'Local';

  @override
  String get app__send_message => 'Envoyer un message';

  @override
  String get app__send_email => 'Envoyer un e-mail';

  @override
  String get app__empty_clipboard => 'Votre presse-papiers est vide.';

  @override
  String get app__load_more => 'Charger plus';

  @override
  String get app__locale_en => 'Anglais';

  @override
  String get app__locale_es => 'Espagnol';

  @override
  String get app__locale_fr => 'Français';

  @override
  String get app__locale_de => 'Allemand';

  @override
  String get app__locale_zh => 'Chinois';

  @override
  String get app__locale_pt => 'Portugais';

  @override
  String get app__language => 'Langue';

  @override
  String get app__logout => 'Déconnexion';

  @override
  String get app__no_collection => 'Aucune collection trouvée';

  @override
  String get app__create_collection => 'Créer une collection';

  @override
  String get app__pro_tip => 'Conseil pro';

  @override
  String get app__try_again => 'Essayer à nouveau';

  @override
  String get app__realtime_connected => 'Connecté en temps réel';

  @override
  String get app__realtime_disconnected => 'Déconnecté en temps réel';

  @override
  String get app__realtime_connecting => 'Connexion en temps réel...';

  @override
  String get app__ack__exported => 'Exporté';

  @override
  String get app__ack__copied => 'Copié';

  @override
  String get app__ack__pasted => 'Collé';

  @override
  String get app__ack__pasting => 'Collage';

  @override
  String get app__ack__done => 'Terminé';

  @override
  String get app__ack__quit_app => 'Quitter l\'application';

  @override
  String get app__ack__deleted => 'Supprimé';

  @override
  String get app__ack__deleting => 'Suppression';

  @override
  String get app__ack__internet_connected => 'Internet connecté';

  @override
  String get app__ack__internet_disconnected => 'Internet déconnecté';

  @override
  String get app__ack__logout_success =>
      'Vous vous êtes déconnecté avec succès.';

  @override
  String get app__ack__missing_e2e_setup =>
      'Configuration du chiffrement manquante';

  @override
  String get app__ack__no_app_for_file =>
      'Aucune application trouvée pour ouvrir ce fichier.';

  @override
  String get app__ack__perm_fail_to_open_file =>
      'Autorisation pour ouvrir ce fichier non accordée.';

  @override
  String get dialog__delete_clip__title => 'Supprimer le clip';

  @override
  String dialog__delete_clip__subtitle({required int itemCount}) {
    String _temp0 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      other: 'Êtes-vous sûr de vouloir supprimer ces clips ?',
      one: 'Êtes-vous sûr de vouloir supprimer ce clip ?',
    );
    return '$_temp0';
  }

  @override
  String get dialog__e2e__title => 'Chiffrement de bout en bout';

  @override
  String get dialog__text__e2e_key_export =>
      'Félicitations, vous avez configuré avec succès le chiffrement de bout en bout.';

  @override
  String get dialog__text__e2e_key_export__note =>
      'Cliquez sur le bouton ci-dessous pour exporter votre clé de chiffrement.\nEnregistrez la clé dans un endroit sûr pour vous assurer de pouvoir configurer d\'autres appareils pour accéder à vos informations chiffrées.';

  @override
  String get dialog__text__e2e_key_generate =>
      'Générez une clé de chiffrement et stockez-la en toute sécurité. Cette clé est nécessaire pour configurer d\'autres appareils pour accéder à vos données chiffrées.';

  @override
  String get dialog__button__e2e_generating_key => 'Génération';

  @override
  String get dialog__button__e2e_generate_key => 'Généré';

  @override
  String get dialog__text__invalid_e2e_key => 'La clé importée est invalide !';

  @override
  String get dialog__text__e2e_key_import__note =>
      'Importez votre clé de chiffrement ci-dessous pour accéder à vos données chiffrées sur cet appareil.';

  @override
  String get dialog__button__e2e_importing_key => 'Importation';

  @override
  String get dialog__button__e2e_import_key => 'Importer';

  @override
  String get dialog__text__inconsistent_time__title =>
      'Avertissement de synchronisation temporelle';

  @override
  String get dialog__text__inconsistent_time__content =>
      'Heure de l\'appareil incohérente détectée\n\nPour assurer une synchronisation précise du presse-papiers, veuillez vérifier et corriger les paramètres de l\'heure de votre appareil.\n\nDes paramètres de temps incohérents peuvent entraîner des problèmes de synchronisation.';

  @override
  String get dialog__button__try_again => 'Vérifier à nouveau';

  @override
  String get dialog__button__try_fix => 'Essayer à nouveau';

  @override
  String get dialog__record_keys__title => 'Enregistrer le raccourci clavier';

  @override
  String get dialog__record_keys__subtitle =>
      'Tapez votre raccourci en utilisant votre clavier et cliquez sur ';

  @override
  String dialog__delete_collection__title({required String collectionName}) {
    return 'Supprimer $collectionName';
  }

  @override
  String get dialog__delete_collection__subtitle =>
      'Êtes-vous sûr de vouloir supprimer cette collection ?';

  @override
  String get dialog__ack__sub_updated => 'Abonnement mis à jour';

  @override
  String get dialog__grant_entitlement__title => 'Droit accordé';

  @override
  String get dialog__grant_entitlement__subtitle_p1 =>
      'Les codes de droit accordés sont partagés avec des personnes spécifiques pour des droits personnalisés. Vous pouvez vérifier si des invitations sont encore disponibles en ';

  @override
  String get dialog__grant_entitlement__subtitle_p2 => 'cliquant ici.';

  @override
  String get dialog__grant_entitlement__enter_code =>
      'Saisissez le code et appuyez sur Soumettre';

  @override
  String get dialog__grant_entitlement__apply_code => 'Appliquer';

  @override
  String get view_button__switch_to_grid => 'Passer à la disposition en grille';

  @override
  String get view_button__switch_to_list => 'Passer à la disposition en liste';

  @override
  String get view_button__change_view => 'Changer de vue';

  @override
  String get view_button__view_window => 'Fenêtré';

  @override
  String get view_button__view_dock_right => 'Ancrer à droite';

  @override
  String get view_button__view_dock_bottom => 'Ancrer en bas';

  @override
  String get view_button__view_dock_left => 'Ancrer à gauche';

  @override
  String get view_button__view_dock_top => 'Ancrer en haut';

  @override
  String get view_button__pin => 'Épingler en haut';

  @override
  String get view_button__unpin => 'Désépingler';

  @override
  String get sub_dialog__text__included => 'Inclus';

  @override
  String get sub_dialog__f1__title => 'Éléments de presse-papiers illimités';

  @override
  String get sub_dialog__f1__subtitle =>
      'Ne manquez jamais d\'espace avec des éléments de presse-papiers illimités, en vous assurant d\'avoir toujours accès à vos copies les plus récentes.';

  @override
  String get sub_dialog__f2__title =>
      'Prise en charge de toutes les principales plateformes';

  @override
  String get sub_dialog__f2__subtitle =>
      'Synchronisez sans effort sur toutes les principales plateformes — Android, iOS, Windows, macOS et Linux — pour une productivité ininterrompue partout.';

  @override
  String get sub_dialog__f3__title =>
      'Prend en charge le Presse-papiers Universel d\'Apple';

  @override
  String get sub_dialog__f3__subtitle =>
      'Transférez sans effort le contenu du presse-papiers entre vos appareils Apple avec la prise en charge du Presse-papiers Universel d\'Apple.';

  @override
  String get sub_dialog__f4__title => 'Stockage sur l\'appareil';

  @override
  String get sub_dialog__f4__subtitle =>
      'Gardez vos données en sécurité avec le stockage sur l\'appareil, vous assurant que vos éléments de presse-papiers sont toujours à portée de main et sous votre contrôle.';

  @override
  String get sub_dialog__f5__title => 'Intégration avec Google Drive';

  @override
  String get sub_dialog__f5__subtitle =>
      'Stockez en toute sécurité fichiers et médias sur Google Drive, en s\'intégrant parfaitement avec le Presse-papiers CopyCat pour une meilleure gestion des données.';

  @override
  String get sub_dialog__f6__title => 'Recherche instantanée';

  @override
  String get sub_dialog__f6__subtitle =>
      'Trouvez ce dont vous avez besoin instantanément avec de puissantes capacités de recherche instantanée, rendant la récupération des éléments de presse-papiers rapide et efficace.';

  @override
  String get sub_dialog__f7__title =>
      'Synchronisation jusqu\'aux dernières 24 heures';

  @override
  String get sub_dialog__f7__subtitle =>
      'Accédez à votre historique de presse-papiers et synchronisez-le sur tous vos appareils pour les dernières 24 heures. Cela vous assure de ne jamais perdre d\'éléments copiés importants, rendant votre flux de travail fluide et efficace.';

  @override
  String get sub_dialog__f8__title => 'Jusqu\'à 3 collections';

  @override
  String get sub_dialog__f8__subtitle =>
      'Organisez vos éléments de presse-papiers en jusqu\'à 3 collections, fournissant une catégorisation simple pour une meilleure gestion du flux de travail.';

  @override
  String get sub_dialog__f9__title =>
      'Synchronisation automatique toutes les 45 secondes';

  @override
  String get sub_dialog__f9__subtitle =>
      'Profitez de la synchronisation automatique des éléments de presse-papiers toutes les 45 secondes, gardant vos appareils à jour sans intervention manuelle.';

  @override
  String get sub_dialog__f10__title =>
      'Prise en charge du chiffrement de bout en bout';

  @override
  String get sub_dialog__f10__subtitle =>
      'Le chiffrement de bout en bout rend tout crypté pour une confidentialité supérieure.';

  @override
  String get sub_dialog__text__pro_title => 'Avec PRO ✨';

  @override
  String get sub_dialog__text__pro_subtitle => 'Tout inclus dans Gratuit +';

  @override
  String get sub_dialog__f11__title => 'Jusqu\'à 50 collections';

  @override
  String get sub_dialog__f11__subtitle =>
      'Organisez vos éléments de presse-papiers en jusqu\'à 50 collections pour une gestion ultime.';

  @override
  String get sub_dialog__f12__title =>
      'Synchronisation jusqu\'aux derniers 30 jours';

  @override
  String get sub_dialog__f12__subtitle =>
      'L\'historique des presse-papiers est synchronisé sur tous vos appareils pour les clips créés au cours des 30 derniers jours. Cela signifie que vous pouvez accéder à tout clip que vous avez copié au cours du dernier mois, quel que soit l\'appareil que vous utilisez.';

  @override
  String get sub_dialog__f13__title => 'Synchronisation en temps réel';

  @override
  String get sub_dialog__f13__subtitle =>
      'Bénéficiez d\'une synchronisation à la vitesse de l\'éclair.';

  @override
  String get sub_dialog__f14__title => 'Support rapide et prioritaire';

  @override
  String get sub_dialog__f14__subtitle =>
      'Obtenez un support rapide et prioritaire en tant qu\'utilisateur PRO.';

  @override
  String get sub_dialog__f15__title =>
      'Accès anticipé aux nouvelles fonctionnalités';

  @override
  String get sub_dialog__f15__subtitle =>
      'Soyez le premier à essayer de nouvelles fonctionnalités et mises à jour.';

  @override
  String get sub_dialog__f16__title => 'Règles d\'exclusion personnalisées';

  @override
  String get sub_dialog__f16__subtitle =>
      'Contrôle précis de votre presse-papiers. Vous permet de définir quoi copier, d\'où copier et quand copier.';

  @override
  String get sub_dialog__f17__title => 'Glisser-déposer';

  @override
  String get sub_dialog__f17__subtitle =>
      'Déplacez sans effort les éléments dans toutes les directions sur vos appareils de bureau et tablettes.';

  @override
  String get sub_dialog__f18__title => 'Thématisation';

  @override
  String get sub_dialog__f18__subtitle =>
      'Personnalisez l\'apparence et la convivialité de l\'application selon vos préférences.';

  @override
  String get paywall_dialog__text__month => 'mois';

  @override
  String get paywall_dialog__text__year => 'année';

  @override
  String get paywall_dialog__text__subscription => 'Abonnement';

  @override
  String get paywall_dialog__text__supported_platform =>
      'Pour accéder aux fonctionnalités premium sur le Presse-papiers Copycat, veuillez vous abonner via le Play Store ou l\'App Store d\'Apple. Votre abonnement sera synchronisé sur tous vos appareils, y compris Linux et Windows.';

  @override
  String get paywall_dialog__text__unlock_pro => 'Débloquer CopyCat PRO';

  @override
  String get paywall_dialog__text__unlock_pro_p1 =>
      'Profitez de plus de 30 jours d\'historique synchronisé, plus de 50 collections, du chiffrement de bout en bout, de la synchronisation en temps réel, de l\'accès aux nouvelles fonctionnalités, et bien plus encore.';

  @override
  String get paywall_dialog__text__try_again => 'Veuillez réessayer';

  @override
  String get paywall_dialog__text__current_plan => 'Plan actuel';

  @override
  String get paywall_dialog__text__expired_plan => 'Plan actuel • Expiré';

  @override
  String paywall_dialog__text__trial_till({required DateTime till}) {
    final intl.DateFormat tillDateFormat = intl.DateFormat.yMMMd(localeName);
    final String tillString = tillDateFormat.format(till);

    return 'Essai jusqu\'à $tillString';
  }

  @override
  String get paywall_dialog__text__upgrade => 'Mise à niveau';

  @override
  String fab__create_collection({required String remaining}) {
    return 'Créer une collection ( $remaining restant )';
  }

  @override
  String get fab__sync => 'Synchroniser';

  @override
  String get fab__sync_unavailable => 'Synchronisation indisponible';

  @override
  String get fab__sync_up_to_date => 'Déjà à jour.';

  @override
  String fab__sync_failed({required String message}) {
    return 'Échec de la synchronisation : $message';
  }

  @override
  String get layout__navbar__clipboard => 'Presse-papiers';

  @override
  String get layout__navbar__collections => 'Collections';

  @override
  String get layout__navbar__settings => 'Paramètres';

  @override
  String get search__tooltip__filter => 'Filtres de recherche';

  @override
  String manage_sub__ack__promo_sub({required String till}) {
    return 'Vous utilisez un abonnement promotionnel jusqu\'à $till';
  }

  @override
  String get manage_sub__button__text => 'Gérer les abonnements';

  @override
  String get my_account__button__tooltip => 'Mon Compte';

  @override
  String get badges__tooltip__experimental =>
      'Cette fonctionnalité est expérimentale et peut ne pas fonctionner comme prévu.';

  @override
  String get badges__tooltip__pro_only =>
      'Cette fonctionnalité est disponible uniquement pour les utilisateurs Pro.';

  @override
  String get collection_selector__tile__no_collection => 'Aucune collection';

  @override
  String get collection_selector__button__remove_collection =>
      'Supprimer la collection';

  @override
  String get dialog__logout__title => 'Déconnexion';

  @override
  String get dialog__logout__subtitle =>
      '⚠️ AVERTISSEMENT ⚠️\n\nLa déconnexion supprimera les modifications non synchronisées dans la base de données locale. Êtes-vous sûr de vouloir continuer?';

  @override
  String get dialog__logging_out__ack =>
      'Déconnexion en cours! Veuillez patienter...';

  @override
  String get reset_pass__text__label => 'Réinitialiser votre mot de passe';

  @override
  String get dnd__text__drop_here => 'Déposez ici';

  @override
  String dnd__ack__error_max_drop_count({required int count}) {
    return 'Un maximum de $count éléments déposés est autorisé en une seule fois.';
  }

  @override
  String get search_filter__text__title => 'Filtres';

  @override
  String get search_filter__button__apply => 'Appliquer';

  @override
  String get search_filter__text__from => 'De';

  @override
  String get search_filter__text__select => 'Sélectionner';

  @override
  String get search_filter__text__to => 'À';

  @override
  String get search_filter__text__now => 'Maintenant';

  @override
  String get search_filter__text__including => 'Incluant';

  @override
  String get search_filter__chip__text => 'Texte';

  @override
  String get search_filter__chip__url => 'URL';

  @override
  String get search_filter__chip__media => 'Médias';

  @override
  String get search_filter__chip__docs => 'Docs';

  @override
  String get search_filter__text__textCategories => 'Catégories de texte';

  @override
  String get search_filter__text__exclusive => '( Exclusif )';

  @override
  String get search_filter__text_cat__email => 'E-mail';

  @override
  String get search_filter__text_cat__phone => 'Téléphone';

  @override
  String get search_filter__text_cat__color => 'Couleur';

  @override
  String get search_filter__text__sort_by => 'Trier par';

  @override
  String get search_filter__sort_by__last_mod => 'Dernière modification';

  @override
  String get search_filter__sort_by__created => 'Créé';

  @override
  String get search_filter__sort_by__copy_count => 'Nombre de copies';

  @override
  String get search_filter__sort_by__last_copied => 'Dernier copié';

  @override
  String get search_filter__text__sort_order => 'Ordre de tri';

  @override
  String get search_filter__sort_ord__asc => 'Asc';

  @override
  String get search_filter__sort_ord__desc => 'Desc';

  @override
  String get login__local_signin__tooltip =>
      'Pas de synchronisation. Toutes les données restent sur votre appareil.';

  @override
  String get login__local_signin__btn__label => 'Utiliser localement';

  @override
  String get login__form__input__name => 'Entrez votre bon nom';

  @override
  String get login__form__input__email => 'Entrez votre e-mail';

  @override
  String get login__form__input__error_email =>
      'Veuillez entrer une adresse e-mail valide';

  @override
  String get login__form__input__password => 'Entrez votre mot de passe';

  @override
  String get login__form__input__error_password_length =>
      'Veuillez entrer un mot de passe d\'au moins 6 caractères de long';

  @override
  String get login__form__button__signin => 'Se connecter';

  @override
  String get login__form__button__signup => 'S\'inscrire';

  @override
  String get login__form__button__forgot_password => 'Mot de passe oublié?';

  @override
  String get login__form__text__signup =>
      'Vous n\'avez pas de compte? S\'inscrire';

  @override
  String get login__form__text__old_user =>
      'Vous avez déjà un compte? Se connecter';

  @override
  String get login__form__text__reset_password =>
      'Envoyer un e-mail de réinitialisation de mot de passe';

  @override
  String get login__form__text__reset_ack =>
      'Le courriel de réinitialisation de mot de passe a été envoyé';

  @override
  String get login__form__button__back => 'Retour à la connexion';

  @override
  String get login__form__button__update_password =>
      'Mettre à jour le mot de passe';

  @override
  String get login__form__text_tnc_p1 => 'En continuant, vous acceptez les ';

  @override
  String get login__form__text_tnc_p2 => 'politiques de confidentialité';

  @override
  String get login__form__text_tnc_p3 => ' suivantes et ';

  @override
  String get login__form__text_tnc_p4 => 'les conditions d\'utilisation.';

  @override
  String get home__search__hint => 'Rechercher dans le presse-papiers';

  @override
  String get home__search__reset => 'Réinitialiser la recherche';

  @override
  String get preview__vert_view__tab1_title => 'Aperçu';

  @override
  String get preview__vert_view__tab2__title => 'Détails';

  @override
  String get preview__card__missing_text => 'C\'est un clip vide';

  @override
  String get preview__card__video__play => 'Lire la vidéo';

  @override
  String get preview__card__file__open => 'Ouvrir le fichier';

  @override
  String get preview__form__title => 'Modifier les détails';

  @override
  String get preview__form__input__title => 'Titre';

  @override
  String get preview__form__input__description => 'Description';

  @override
  String get reset_password__appbar__title =>
      'Réinitialiser votre mot de passe';

  @override
  String get reset_password__success_ack =>
      'Mot de passe réinitialisé avec succès';

  @override
  String get onboarding__text__welcome => 'Bienvenue à';

  @override
  String get onboarding__text__lets_continue => 'Continuons';

  @override
  String get onboarding__button__to_login => 'Se connecter';

  @override
  String get onboarding__snackbar__export_success =>
      'Clé de chiffrement exportée avec succès.';

  @override
  String get onboarding__dialog__skip_export__title =>
      '✋ Sauvegardez votre clé de chiffrement';

  @override
  String get onboarding__dialog__skip_export__subtitle =>
      'Vous n\'avez pas encore exporté votre clé de chiffrement. Sans sauvegarde, vous ne pourrez pas accéder à vos clips chiffrés si la clé est perdue ou si vous changez d\'appareil.\n\n👉 Si vous avez déjà une sauvegarde sécurisée de votre clé, vous pouvez continuer en toute sécurité. Sinon, nous vous recommandons fortement d\'exporter la clé maintenant pour éviter toute perte de données. Voulez-vous toujours continuer ?';

  @override
  String get onboarding__dialog__export_info__title =>
      '🤔 Pourquoi exporter la clé de chiffrement ?';

  @override
  String get onboarding__dialog__export_info__subtitle =>
      'Exporter votre clé de chiffrement est essentiel pour accéder en toute sécurité à vos données chiffrées sur plusieurs appareils. Sans la clé, vos données chiffrées resteront inaccessibles après la synchronisation.\n\nGardez une sauvegarde de votre clé de chiffrement dans un endroit sûr pour éviter la perte de données. Souvenez-vous, la clé est unique à votre compte et ne peut être récupérée si elle est perdue.\n\nRemarque : Copycat ne peut pas accéder à vos clips chiffrés ni à vos clés de chiffrement. Cela est dû au fait que nous valorisons votre confidentialité au-dessus de tout.';

  @override
  String get onboarding__text__export_key_headline =>
      'Chiffrement du presse-papiers';

  @override
  String get onboarding__text__export_key_title =>
      '💪 Bonne nouvelle ! Le chiffrement est actif pour votre presse-papiers';

  @override
  String get onboarding__button__export_key => 'Exporter la clé';

  @override
  String get onboarding__dialog__skip_gen_key__title =>
      '✋ Vos clips seront non sécurisés';

  @override
  String get onboarding__dialog__skip_gen_key__subtitle =>
      'Vous n\'avez pas encore généré de clé de chiffrement. Sans cela, vos clips resteront non chiffrés et non sécurisés. Vous pouvez générer la clé plus tard dans Paramètres ❯ Sécurité. Voulez-vous toujours continuer ?';

  @override
  String get onboarding__dialog__gen_key_info__title =>
      '🤔 Pourquoi ai-je besoin du chiffrement ?';

  @override
  String get onboarding__dialog__gen_key_info__subtitle =>
      'Le chiffrement protège vos données en les convertissant en un format sécurisé qui ne peut être accédé qu\'avec une clé. Sans chiffrement, vos clips sont stockés en texte brut, les rendant vulnérables à un accès non autorisé. Activer le chiffrement garantit que vous seul pouvez accéder à vos données sensibles, fournissant une couche supplémentaire de sécurité contre les violations potentielles.';

  @override
  String get onboarding__text__gen_key_headline =>
      'Configurer le chiffrement du presse-papiers';

  @override
  String onboarding__text__key_generated_title({required String keyPreview}) {
    return '🎉 Clé $keyPreview*** générée avec succès 🎉';
  }

  @override
  String get onboarding__button__regenerate_key => 'Régénérer la clé';

  @override
  String get onboarding__text__no_key =>
      'Votre compte n\'a pas de clé de chiffrement';

  @override
  String get onboarding__button__generate_key => 'Générer la clé';

  @override
  String get onboarding__button__do_it_later => 'Le faire plus tard';

  @override
  String get onboarding__button__why_important => 'Pourquoi c\'est important ?';

  @override
  String get onboarding__snackbar__invalid_key =>
      'Ceci n\'est pas une clé de chiffrement CopyCat valide';

  @override
  String get onboarding__dialog__skip_import__title =>
      '✋ Clips chiffrés inaccessibles';

  @override
  String get onboarding__dialog__skip_import__subtitle =>
      'Vous n\'avez pas encore importé la clé de chiffrement. Cela signifie que tous vos clips chiffrés resteront inaccessibles localement après la synchronisation.\n\n Pour y accéder, importez la clé à partir de Paramètres ❯ Sécurité.\nVoulez-vous toujours continuer ?';

  @override
  String get onboarding__dialog__reset_key__title =>
      '✋ Supprimer définitivement les données chiffrées';

  @override
  String get onboarding__dialog__reset_key__subtitle =>
      'Cette action est irréversible. Êtes-vous sûr de vouloir supprimer définitivement toutes les données chiffrées du serveur ?';

  @override
  String get onboarding__snackbar__reset_key__success =>
      'Chiffrement supprimé avec succès.';

  @override
  String get onboarding__dialog__import_info__title => '🤔 Où est ma clé ?';

  @override
  String get onboarding__dialog__import_info__subtitle =>
      'Votre clé de chiffrement est un fichier sécurisé généré lors du processus de configuration du chiffrement. Si vous l\'avez égarée, vérifiez votre dossier de téléchargements ou tout emplacement de sauvegarde où vous auriez pu la sauvegarder. Sans cette clé, vos données chiffrées ne peuvent être accessibles.\n\nSi vous avez configuré la clé de chiffrement sur un autre appareil, vous pouvez l\'exporter en allant dans Paramètres ❯ Sécurité ❯ E2EE Vault sur cet appareil. Transférez la clé en toute sécurité vers cet appareil pour reprendre l\'accès à vos données chiffrées.';

  @override
  String get onboarding__text__import_key_headline =>
      'Importer la clé de chiffrement du presse-papiers';

  @override
  String get onboarding__text__import_key_title =>
      'Votre compte a actuellement un chiffrement actif.';

  @override
  String get onboarding__button__import_key => 'Importer la clé';

  @override
  String get onboarding__button__reset_key => 'Réinitialiser le chiffrement';

  @override
  String get onboarding__button__where_key => 'Où est la clé?';

  @override
  String get onboarding__text__go_home => 'Allons à la maison';

  @override
  String onboarding__restoration__failed({required String message}) {
    return 'Échec de la restauration : $message';
  }

  @override
  String get onboarding__restoration_warning =>
      '⚠️ Veuillez garder cet écran ouvert pendant la synchronisation pour éviter la corruption des données ou des incohérences.';

  @override
  String get restore_clips__text__title => 'Restaurer mon presse-papiers';

  @override
  String get restore_clips__error__no_backup =>
      'Aucune sauvegarde du presse-papiers trouvée';

  @override
  String restore_clips__text__total_count({required int totalCount}) {
    return 'Vous avez environ $totalCount clip(s) à restaurer.';
  }

  @override
  String get restore_clips__sync_disable =>
      'La synchronisation est actuellement désactivée. Veuillez l\'activer pour continuer.';

  @override
  String get restore_clips__preparing =>
      'Préparation de la restauration des clips. Veuillez patienter...';

  @override
  String restore_clips__restored({required int syncCount}) {
    return 'Vos $syncCount clip(s) ont été restaurés avec succès.';
  }

  @override
  String restore_clips__restoring(
      {required int synced, required int totalCount}) {
    return 'Restauré : $synced de $totalCount clips.';
  }

  @override
  String get restore_collections__text__title => 'Restaurer mes collections';

  @override
  String get restore_collections__error__no_backup =>
      'Aucune sauvegarde de collections trouvée';

  @override
  String restore_collections__text__total_count({required int totalCount}) {
    return 'Vous avez environ $totalCount collection(s) à restaurer.';
  }

  @override
  String get restore_collections__sync_disable =>
      'La synchronisation est actuellement désactivée. Veuillez l\'activer pour continuer.';

  @override
  String get restore_collections__preparing =>
      'Préparation de la restauration des collections. Veuillez patienter...';

  @override
  String restore_collections__restored({required int syncCount}) {
    return 'Vos $syncCount collection(s) ont été restaurées avec succès.';
  }

  @override
  String restore_collections__restoring(
      {required int synced, required int totalCount}) {
    return 'Restauré : $synced de $totalCount collections.';
  }

  @override
  String get drive__snackbar__success =>
      'La configuration du lecteur est maintenant terminée.';

  @override
  String get drive__text__setting_up => 'Configuration et synchronisation...';

  @override
  String get drive__text__setting_up__warning =>
      'Veuillez patienter pendant que nous terminons cela. Ne fermez pas l\'application.';

  @override
  String get create_clip__appbar__title__new => 'Nouveau Clip';

  @override
  String get create_clip__appbar__title__edit => 'Modifier le Clip';

  @override
  String get create_clip__button__save_new => 'Enregistrer comme nouveau';

  @override
  String get create_clip__input__hint => 'Écrivez le contenu de votre clip ici';

  @override
  String get collections__text__tip =>
      'Pour vous assurer que vos clips importants sont toujours disponibles, quel que soit le moment, sur tous vos appareils, enregistrez-les dans une collection !';

  @override
  String get collections__appbar__title => 'Collections';

  @override
  String get collections__appbar__title__create => 'Créer une collection';

  @override
  String get collections__appbar__title__edit => 'Modifier la collection';

  @override
  String get collections__input__name => 'Nom';

  @override
  String get collections__input__description => 'Description';

  @override
  String get select_collection__appbar__title => 'Sélectionner la collection';

  @override
  String get account__dialog__delete_confirm__title =>
      'Demande de suppression de compte';

  @override
  String get account__dialog__delete_confirm__description =>
      'Vous serez redirigé vers le formulaire de demande de suppression de compte, êtes-vous sûr ?';

  @override
  String get account__list_tile__display_name => 'Nom d\'affichage';

  @override
  String get account__list_tile__email => 'E-mail';

  @override
  String get account__list_tile__settings => 'Paramètres du compte';

  @override
  String get account__list_tile__danger_zone => 'Zone dangereuse';

  @override
  String get account__button__req_delete => 'Demander la suppression du compte';

  @override
  String get account__appbar__title => 'Mon Compte';

  @override
  String get settings__appbar__title => 'Paramètres';

  @override
  String get settings__tab__1 => 'Général';

  @override
  String get settings__tab__2 => 'Personnalisation';

  @override
  String get settings__tab__3 => 'Synchronisation';

  @override
  String get settings__tab__4 => 'Chiffrement';

  @override
  String get settings__tab__5 => 'Expérimental';

  @override
  String get settings__text__encryption => 'Chiffrement';

  @override
  String get settings__text__sync_not_available =>
      'Les configurations relatives à la synchronisation ne sont pas disponibles lors de l\'utilisation du presse-papiers local.';

  @override
  String get settings__appbar__er__title => 'Règles d\'exclusion';

  @override
  String get settings__text__er__predefine => 'Règles d\'exclusion prédéfinies';

  @override
  String get settings__text__er__pass_manager =>
      'Gestionnaires de mots de passe';

  @override
  String get settings__text__er__cc => 'Numéro de carte de crédit';

  @override
  String get settings__text__er__phone => 'Numéro de téléphone';

  @override
  String get settings__text__er__email => 'Adresse e-mail';

  @override
  String get settings__text__er__url => 'URL sensible';

  @override
  String get settings__text__decrypted__note =>
      '🥳 Félicitations ! Tous vos clips ont été décryptés avec succès localement,\n il n\'est donc pas nécessaire de reconstruire la base de données.';

  @override
  String get settings__appbar__cer__title =>
      'Règles d\'exclusion personnalisées';

  @override
  String get settings__switch__drag_n_drop__title => 'Glisser et déposer';

  @override
  String get settings__switch__drag_n_drop__subtitle =>
      'Autoriser les éléments à être déplacés librement dans les deux sens au sein de l\'application.';

  @override
  String get settings__dropdown__no_copy_over_limit__title =>
      'Ne pas copier automatiquement au-delà de';

  @override
  String settings__dropdown__no_copy_over_limit__subtitle(
      {required String fileSize}) {
    return 'Les fichiers et médias de plus d\'une certaine taille ($fileSize) ne seront pas copiés automatiquement.';
  }

  @override
  String get settings__text__5MB => '5 Mo';

  @override
  String get settings__text__10MB => '10 Mo';

  @override
  String get settings__text__20MB => '20 Mo';

  @override
  String get settings__text__50MB => '50 Mo';

  @override
  String get settings__text__100MB => '100 Mo';

  @override
  String get settings__dropdown__no_upload_over_limit__title =>
      'Ne pas téléverser automatiquement au-delà de';

  @override
  String settings__dropdown__no_upload_over_limit__subtitle(
      {required String fileSize}) {
    return 'Les fichiers et médias de plus d\'une certaine taille ($fileSize) ne seront pas téléversés automatiquement.';
  }

  @override
  String get settings__dropdown__sync_mode__title => 'Mode de synchronisation';

  @override
  String get settings__dropdown__sync_mode__subtitle =>
      'Sélectionnez la vitesse de synchronisation qui vous convient le mieux.';

  @override
  String get settings__sync_mode__realtime => 'Temps réel';

  @override
  String get settings__sync_mode__balanced => 'Équilibré';

  @override
  String get settings__dropdown__theme__title => 'Mode thème';

  @override
  String get settings__theme__system => 'Système';

  @override
  String get settings__theme__light => 'Clair';

  @override
  String get settings__theme__dark => 'Sombre';

  @override
  String get settings__dropdown__color_mode__title => 'Mode couleur';

  @override
  String get settings__dropdown__color_mode__subtitle =>
      'Sélectionnez le mode de couleur pour personnaliser l\'apparence de l\'application. L\'option par défaut est \"Spot tonal\".';

  @override
  String get settings__color_mode__tonalSpot => 'Spot tonal';

  @override
  String get settings__color_mode__content => 'Contenu';

  @override
  String get settings__color_mode__expressive => 'Expressif';

  @override
  String get settings__color_mode__fidelity => 'Fidélité';

  @override
  String get settings__color_mode__fruit_salad => 'Salade de fruits';

  @override
  String get settings__color_mode__monochrome => 'Monochrome';

  @override
  String get settings__color_mode__neutral => 'Neutre';

  @override
  String get settings__color_mode__rainbow => 'Arc-en-ciel';

  @override
  String get settings__color_mode__vibrant => 'Vibrant';

  @override
  String get settings__tile__cer_title => 'Règles personnalisées';

  @override
  String get settings__tile__cer_subtitle =>
      'Exclure par application, par fenêtre/application titre, URL de site Web ou motif Regex';

  @override
  String get settings__tile__er_title => 'Règles d\'exclusion';

  @override
  String get settings__tile__er_subtitle =>
      'Empêcher les informations de se copier dans le presse-papiers. Cliquez pour un contrôle avancé.';

  @override
  String get settings__switch__enable_sync__title =>
      'Synchronisation du presse-papiers';

  @override
  String get settings__switch__enable_sync__subtitle =>
      'Synchronisez votre presse-papiers entre les appareils sans effort.';

  @override
  String get settings__switch__sync_file__title =>
      'Synchronisation des fichiers et médias';

  @override
  String get settings__switch__sync_file__subtitle =>
      'Basculer pour synchroniser les fichiers et les clips multimédias entre les appareils.';

  @override
  String get settings__switch__paused__title =>
      'Mettre en pause l\'écouteur du presse-papiers';

  @override
  String get settings__switch__paused__subtitle =>
      'Suspendre temporairement le suivi du presse-papiers jusqu\'à une heure définie.';

  @override
  String settings__switch__paused_active__subtitle({required DateTime time}) {
    final intl.DateFormat timeDateFormat =
        intl.DateFormat('h:mm a', localeName);
    final String timeString = timeDateFormat.format(time);

    return 'En pause jusqu\'à $timeString. Appuyez pour reprendre ou ajuster le temps.';
  }

  @override
  String get settings__switch__smart_paste__title => 'Collage intelligent';

  @override
  String get settings__switch__smart_paste__subtitle =>
      'Collez du contenu directement sur l\'application ciblée.';

  @override
  String get settings__switch__startup__title => 'Lancer au démarrage';

  @override
  String get settings__switch__startup__subtitle =>
      'Lancez automatiquement CopyCat lorsque votre appareil s\'allume.';

  @override
  String get settings__switch__hotkey__title => 'Activer avec le raccourci';

  @override
  String get settings__switch__hotkey__subtitle =>
      'Utilisez un raccourci clavier pour accéder rapidement à votre presse-papiers CopyCat';

  @override
  String get settings__hotkey__unassigned => 'Non assigné';

  @override
  String get settings__hotkey__preview_start => 'Presser ';

  @override
  String get settings__hotkey__preview_end =>
      ' pour montrer ou cacher l\'application.';

  @override
  String get settings__tile__theme_color__title => 'Couleur du thème';

  @override
  String get settings__tile__theme_color__subtitle =>
      'Cette couleur influencera l\'apparence générale de l\'application.';

  @override
  String get settings__tile__desk_client__title =>
      'Télécharger le client de bureau';

  @override
  String get settings__tile__mobile_client__title =>
      'Télécharger le client mobile';

  @override
  String get settings__tile__client__subtitle =>
      'Accédez à votre presse-papiers sur tous vos appareils.';

  @override
  String get settings__tile__e2e_setup__title =>
      'Configuration du chiffrement de bout en bout';

  @override
  String get settings__tile__e2e_setup__subtitle =>
      'Configurer le chiffrement pour vos clips.';

  @override
  String get settings__switch__e2e__title => 'Activer le chiffrement';

  @override
  String get settings__switch__e2e__subtitle =>
      'Basculer pour activer ou désactiver le chiffrement de bout en bout pour vos clips.';

  @override
  String get settings__dialog__conn_gdrive__title =>
      'Reconnecter Google Drive?';

  @override
  String get settings__dialog__conn_gdrive__subtitle =>
      'Votre Google Drive est déjà connecté ! Souhaitez-vous vous reconnecter ?\n\nPour éviter toute perte de données, assurez-vous d\'utiliser le même compte qu\'auparavant.';

  @override
  String get settings__drive__connected => 'Connecté';

  @override
  String get settings__drive__loading => 'Chargement...';

  @override
  String get settings__drive__authorizing => 'Autorisation...';

  @override
  String get settings__drive__disconnected => 'Déconnecté';

  @override
  String get settings__text__cloud__title => 'Cloud Drive';

  @override
  String get settings__text__cloud__name => 'Google Drive';

  @override
  String get settings__text__gdrive__error =>
      'Google Drive n\'est pas connecté. La synchronisation des fichiers et médias est actuellement désactivée.';

  @override
  String get settings__text__gdrive__info =>
      'Vos fichiers et médias sont synchronisés en toute sécurité entre les appareils via Google Drive, assurant la protection de votre confidentialité.';

  @override
  String get settings__tile__other_cloud__title =>
      'Configurer un autre cloud drive';

  @override
  String get settings__tile__other_cloud__subtitle =>
      'Configurez d\'autres lecteurs cloud comme Dropbox, OneDrive, etc.';

  @override
  String get custom_er__nav__1 => 'Application';

  @override
  String get custom_er__nav__2 => 'Titre de la fenêtre';

  @override
  String get custom_er__nav__3 => 'Url';

  @override
  String get custom_er__nav__4 => 'Modèle de texte';

  @override
  String get custom_er__text__not_supported =>
      'Cette exclusion n\'est pas encore supportée';

  @override
  String get custom_er__tile__add_app => 'Ajouter une application';

  @override
  String get custom_er__text__no_app =>
      'Aucune application personnalisée exclue pour le moment';

  @override
  String get custom_er__button__remove_app => 'Retirer cette application';

  @override
  String get custom_er__tile__pattern =>
      'Éviter la copie lorsque le contenu copié correspond à ces modèles';

  @override
  String get custom_er__text__no_pattern => 'Aucun modèle personnalisé exclu';

  @override
  String get custom_er__button__remove_pattern => 'Retirer ce modèle';

  @override
  String get custom_er__tile__url =>
      'Empêcher la copie depuis le site web correspondant à ces segments d\'URL.';

  @override
  String get custom_er__input__url_hint =>
      'Saisissez une URL ou une partie d\'une URL ici.';

  @override
  String get custom_er__text__no_url => 'Aucune URL personnalisée exclue';

  @override
  String get custom_er__button__remove_url => 'Retirer cette URL';

  @override
  String get custom_er__tile__title =>
      'Empêcher la copie d\'une application ou d\'un site web lorsque le titre de la fenêtre correspond.';

  @override
  String get custom_er__text__no_title => 'Aucun titre personnalisé exclu';

  @override
  String get custom_er__button__remove_title => 'Retirer ce titre';

  @override
  String get about__tile__discord => 'Discord • Connexion';

  @override
  String get about__tile__youtube => 'YouTube • Tutoriel';

  @override
  String get about__tile__read_tut => 'Lire • Tutoriel';

  @override
  String get about__tile__github => 'Github • Open source';

  @override
  String get about__tile__website => 'EntilityStudio • Site web';

  @override
  String get about__tile__support => 'Support';

  @override
  String get abc_title => 'Presse-papiers en arrière-plan';

  @override
  String get abc__tile__subtitle => 'Écoutez le presse-papiers en arrière-plan';

  @override
  String get abc__tip__why_title =>
      'Pourquoi ces autorisations sont-elles nécessaires ?';

  @override
  String get abc__tip__why_subtitle =>
      'Ces autorisations garantissent que CopyCat fonctionne correctement en arrière-plan, permettant de détecter le contenu copié et de vous offrir une expérience fluide sans interruptions.';

  @override
  String get abc__tip__support_title => 'Support limité';

  @override
  String get abc__tip__support_subtitle =>
      '1. Actuellement, seuls les clips texte sont pris en charge.\n2. Certains systèmes d\'exploitation, comme HyperOS 1, ne sont pas encore pris en charge.';

  @override
  String get abc__heading__req_perm => 'Autorisations requises';

  @override
  String get abc__tile__notification_title => 'Accès aux notifications';

  @override
  String get abc__tile__notification_subtitle =>
      'Affiche une notification persistante pour vous informer que CopyCat fonctionne en arrière-plan, garantissant transparence et confidentialité.';

  @override
  String get abc__tile__battery_opt_title => 'Optimisation de la batterie';

  @override
  String get abc__tile__battery_opt_subtitle =>
      'Empêche le système d\'arrêter CopyCat lorsqu\'il fonctionne en arrière-plan, garantissant une expérience fluide.';

  @override
  String get abc__tile__overlay_title => 'Autorisation de superposition';

  @override
  String get abc__tile__overlay_subtitle =>
      'Permet à CopyCat de lire le presse-papiers en ouvrant brièvement une fenêtre transparente au-dessus de l\'écran et de la fermer immédiatement après.';

  @override
  String get abc__tile__acc_title => 'Service d\'accessibilité';

  @override
  String get abc__tile__acc_subtitle =>
      'Démarre l\'écouteur en arrière-plan de CopyCat pour détecter lorsque vous copiez quelque chose et assure le redémarrage automatique du service après un redémarrage.';

  @override
  String get abc__ack__ready => 'Configuration prête à être configurée.';

  @override
  String get abc__ack__preparing =>
      'Préparation de la configuration, veuillez patienter...';

  @override
  String get abc__perm_alert_open_setting__button => 'Ouvrir les paramètres';

  @override
  String get abc__overlay_perm_alert__title => 'Permission de superposition';

  @override
  String get abc__overlay_perm_alert__subtitle =>
      'CopyCat Clipboard a besoin de la permission \'Dessiner par-dessus d\'autres applications\' pour lire le contenu du presse-papiers en arrière-plan.';

  @override
  String get abc__overlay_perm_alert__p1_prefix => 'Cette permission est ';

  @override
  String get abc__overlay_perm_alert__p1_bold =>
      'utilisée uniquement pour la détection du presse-papiers';

  @override
  String get abc__overlay_perm_alert__p1_suffix =>
      ' lorsque vous copiez quelque chose en arrière-plan.';

  @override
  String get abc__overlay_perm_alert__p2_prefix =>
      'Lorsqu\'elle est activée, CopyCat ';

  @override
  String get abc__overlay_perm_alert__p2_bold =>
      'crée une fenêtre transparente de 0 pixel';

  @override
  String get abc__overlay_perm_alert__p2_suffix =>
      ' pour amener brièvement l\'application au premier plan et lire les données du presse-papiers.';

  @override
  String get abc__overlay_perm_alert__p3_prefix => 'L\'application ';

  @override
  String get abc__overlay_perm_alert__p3_bold => 'n\'affiche rien';

  @override
  String get abc__overlay_perm_alert__p3_suffix =>
      ' sur votre écran pendant ce processus.';

  @override
  String get abc__overlay_perm_alert__p4_prefix =>
      'Sur certains appareils, le système peut afficher un message toast ';

  @override
  String get abc__overlay_perm_alert__p4_bold =>
      '\'CopyCat a collé depuis votre presse-papiers\'';

  @override
  String get abc__overlay_perm_alert__p4_suffix =>
      ' lorsque CopyCat lit le contenu de votre presse-papiers.';

  @override
  String get abc__overlay_perm_alert__agree =>
      'En accordant cette permission, vous acceptez l\'utilisation décrite ci-dessus.';

  @override
  String get abc__accessibility_perm_alert__title =>
      'Permission d\'accessibilité';

  @override
  String get abc__accessibility_perm_alert__subtitle =>
      'CopyCat Clipboard nécessite le Service d\'Accessibilité pour fonctionner en arrière-plan et détecter et synchroniser le presse-papiers en temps réel.';

  @override
  String get abc__accessibility_perm_alert__p1_prefix => 'Ce service est ';

  @override
  String get abc__accessibility_perm_alert__p1_bold => 'utilisé uniquement';

  @override
  String get abc__accessibility_perm_alert__p1_suffix =>
      ' pour détecter le contenu du presse-papiers et le synchroniser entre les appareils lorsqu\'il est activé.';

  @override
  String get abc__accessibility_perm_alert__p2_prefix => 'Vous pouvez ';

  @override
  String get abc__accessibility_perm_alert__p2_bold =>
      'exclure des applications spécifiques';

  @override
  String get abc__accessibility_perm_alert__p2_suffix =>
      ' en utilisant la fonctionnalité de Règles d\'Exclusion.';

  @override
  String get abc__accessibility_perm_alert__p3_prefix => 'L\'application ';

  @override
  String get abc__accessibility_perm_alert__p3_bold =>
      'n\'accède à aucune autre donnée';

  @override
  String get abc__accessibility_perm_alert__p3_suffix =>
      ' au-delà du contenu du presse-papiers.';

  @override
  String get abc__accessibility_perm_alert__p4_prefix =>
      'Les données du presse-papiers ';

  @override
  String get abc__accessibility_perm_alert__p4_bold =>
      'ne sont pas partagées à l\'extérieur';

  @override
  String get abc__accessibility_perm_alert__p4_suffix =>
      ' et restent privées sur vos appareils.';

  @override
  String get abc__accessibility_perm_alert__p5_prefix =>
      'Les données du presse-papiers ';

  @override
  String get abc__accessibility_perm_alert__p5_bold =>
      'sont chiffrées de bout en bout';

  @override
  String get abc__accessibility_perm_alert__p5_suffix =>
      ' (si activé) en transit et au repos, garantissant la confidentialité entre les appareils.';

  @override
  String get abc__accessibility_perm_alert__agree =>
      'En activant le Service d\'Accessibilité, vous reconnaissez et acceptez les termes ci-dessus.';

  @override
  String get abc__other_setting__title => 'Autres paramètres';

  @override
  String get abc__enhanced_clip_detection__title =>
      'Détection améliorée du presse-papiers';

  @override
  String get abc__enhanced_clip_detection__subtitle =>
      'Activez cette option pour une détection plus précise du presse-papiers. Notez qu\'elle pourrait ne pas fonctionner sur tous les appareils.';
}
