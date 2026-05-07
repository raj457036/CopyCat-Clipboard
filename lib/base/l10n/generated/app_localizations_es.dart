// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app__name => 'Portapapeles CopyCat';

  @override
  String get app__slogan => 'Un Portapapeles, Posibilidades Ilimitadas';

  @override
  String get app__unknown_error => 'Ocurrió un error inesperado';

  @override
  String get app__downloading => 'Descargando...';

  @override
  String get app__download => 'Descargar';

  @override
  String get app__follow_link => 'Seguir Enlace';

  @override
  String get app__edit => 'Editar';

  @override
  String get app__export => 'Exportar';

  @override
  String get app__delete => 'Eliminar';

  @override
  String get app__later => 'Omitir';

  @override
  String get app__select => 'Seleccionar';

  @override
  String get app__change => 'Cambiar';

  @override
  String get app__confirm => 'Confirmar';

  @override
  String get app__action_required => 'Acción Requerida';

  @override
  String get app__feature_unavailable =>
      'Esta función no está disponible para tu plataforma.';

  @override
  String get app__preview => 'Vista Previa';

  @override
  String get app__open_file => 'Abrir archivo';

  @override
  String get app__change_collection => 'Cambiar Colección';

  @override
  String get app__share => 'Compartir';

  @override
  String get app__loading => 'Loading...';

  @override
  String get app__uploading => 'Subiendo...';

  @override
  String get app__syncing => 'Sincronizando...';

  @override
  String get app__sync => 'Sincronizar';

  @override
  String get app__local => 'Local';

  @override
  String get app__utc => 'UTC';

  @override
  String get app__send_message => 'Enviar Mensaje';

  @override
  String get app__send_email => 'Enviar Correo Electrónico';

  @override
  String get app__empty_clipboard => 'Tu portapapeles está vacío.';

  @override
  String get app__load_more => 'Cargar Más';

  @override
  String get app__search => 'Search';

  @override
  String get app__no_results => 'No results found';

  @override
  String get app__locale_en => 'Inglés';

  @override
  String get app__locale_es => 'Español';

  @override
  String get app__locale_fr => 'Francés';

  @override
  String get app__locale_de => 'Alemán';

  @override
  String get app__locale_zh => 'Chino';

  @override
  String get app__locale_pt => 'Portugués';

  @override
  String get app__language => 'Idioma';

  @override
  String get app__yes => 'Yes';

  @override
  String get app__no => 'No';

  @override
  String get app__quit => 'Quit';

  @override
  String get app__clear => 'Clear';

  @override
  String get app__reset => 'Reset';

  @override
  String get app__continue => 'Continue';

  @override
  String get app__paste => 'Paste';

  @override
  String get app__copycat_logo => 'CopyCat Logo';

  @override
  String get app__logout => 'Cerrar Sesión';

  @override
  String get app__no_collection => 'No Se Encontró Colección';

  @override
  String get app__create_collection => 'Crear Colección';

  @override
  String get app__pro_tip => 'Consejo Profesional';

  @override
  String get app__try_again => 'Intentar de nuevo';

  @override
  String get app__realtime_connected => 'Conectado en tiempo real';

  @override
  String get app__realtime_disconnected => 'Desconectado en tiempo real';

  @override
  String get app__realtime_connecting => 'Conectando en tiempo real...';

  @override
  String get app__ack__exported => 'Exportado';

  @override
  String get app__ack__copied => 'Copiado';

  @override
  String get app__ack__pasted => 'Pegado';

  @override
  String get app__ack__pasting => 'Pegando';

  @override
  String get app__ack__done => 'Hecho';

  @override
  String get app__ack__quit_app => 'Salir de la Aplicación';

  @override
  String get app__ack__deleted => 'Eliminado';

  @override
  String get app__ack__deleting => 'Eliminando';

  @override
  String get app__ack__internet_connected => 'Internet Conectado';

  @override
  String get app__ack__internet_disconnected => 'Internet Desconectado';

  @override
  String get app__ack__logout_success => 'Has cerrado sesión con éxito.';

  @override
  String get app__ack__no_app_for_file =>
      'No se encontró aplicación para abrir este archivo.';

  @override
  String get app__ack__perm_fail_to_open_file =>
      'No se otorgó permiso para abrir este archivo.';

  @override
  String get app__ack__missing_e2e_setup =>
      'Falta configuración de encriptación';

  @override
  String get dialog__delete_clip__title => 'Eliminar Clip';

  @override
  String dialog__delete_clip__subtitle({required int itemCount}) {
    String _temp0 = intl.Intl.pluralLogic(
      itemCount,
      locale: localeName,
      one: '¿Seguro que quieres eliminar este clip?',
      other: '¿Seguro que quieres eliminar estos clips?',
    );
    return '$_temp0';
  }

  @override
  String get dialog__e2e__title => 'Encriptación de Extremo a Extremo';

  @override
  String get dialog__text__e2e_key_export =>
      'Felicidades, has configurado con éxito la encriptación de extremo a extremo.';

  @override
  String get dialog__text__e2e_key_export__note =>
      'Haz clic en el botón de abajo para exportar tu clave de encriptación.\nGuarda la clave en un lugar seguro para asegurarte de poder configurar otros dispositivos para acceder a tu información encriptada.';

  @override
  String get dialog__text__e2e_key_generate =>
      'Genera una clave de encriptación y guárdala de forma segura. Esta clave es necesaria para configurar otros dispositivos para acceder a tus datos encriptados.';

  @override
  String get dialog__button__e2e_generating_key => 'Generando';

  @override
  String get dialog__button__e2e_generate_key => 'Generado';

  @override
  String get dialog__text__invalid_e2e_key =>
      '¡La clave importada es inválida!';

  @override
  String get dialog__text__e2e_key_import__note =>
      'Importa tu clave de encriptación abajo para acceder a tus datos encriptados en este dispositivo.';

  @override
  String get dialog__button__e2e_importing_key => 'Importando';

  @override
  String get dialog__button__e2e_import_key => 'Importar';

  @override
  String get dialog__text__inconsistent_time__title =>
      'Advertencia de Sincronización de Hora';

  @override
  String get dialog__text__inconsistent_time__content =>
      'Se Detectó Hora Inconsistente en el Dispositivo\n\nPara asegurar una sincronización precisa del portapapeles, por favor revisa y corrige la configuración de la hora de tu dispositivo.\n\nLas configuraciones de hora inconsistentes pueden causar problemas de sincronización.';

  @override
  String get dialog__button__try_again => 'Revisar de Nuevo';

  @override
  String get dialog__button__try_fix => 'Intentar Corregir';

  @override
  String get dialog__record_keys__title => 'Registrar Atajo de Teclado';

  @override
  String get dialog__record_keys__subtitle =>
      'Escribe tu atajo usando el teclado y haz clic en ';

  @override
  String dialog__delete_collection__title({required String collectionName}) {
    return 'Eliminar $collectionName';
  }

  @override
  String get dialog__delete_collection__subtitle =>
      '¿Estás seguro de eliminar esta colección?';

  @override
  String get dialog__ack__sub_updated => 'Suscripción Actualizada';

  @override
  String get dialog__grant_entitlement__title => 'Derecho Otorgado';

  @override
  String get dialog__grant_entitlement__subtitle_p1 =>
      'Los Códigos de Derecho Otorgado se comparten con personas específicas para derechos personalizados. Puedes comprobar si las invitaciones aún están disponibles ';

  @override
  String get dialog__grant_entitlement__subtitle_p2 => 'haciéndo clic aquí.';

  @override
  String get dialog__grant_entitlement__enter_code =>
      'Introduce el código y presiona Enviar';

  @override
  String get dialog__grant_entitlement__code_label => 'Code';

  @override
  String get dialog__grant_entitlement__apply_code => 'Aplicar';

  @override
  String get view_button__switch_to_grid => 'Cambiar a Diseño de Cuadrícula';

  @override
  String get view_button__switch_to_list => 'Cambiar a Diseño de Lista';

  @override
  String get view_button__change_view => 'Cambiar Vista';

  @override
  String get view_button__view_window => 'Ventana';

  @override
  String get view_button__view_dock_right => 'Anclar a la Derecha';

  @override
  String get view_button__view_dock_bottom => 'Anclar Abajo';

  @override
  String get view_button__view_dock_left => 'Anclar a la Izquierda';

  @override
  String get view_button__view_dock_top => 'Anclar Arriba';

  @override
  String get view_button__pin => 'Fijar arriba';

  @override
  String get view_button__unpin => 'Desfijar';

  @override
  String get sub_dialog__text__included => 'Incluido';

  @override
  String get sub_dialog__f1__title => 'Elementos Ilimitados del Portapapeles';

  @override
  String get sub_dialog__f1__subtitle =>
      'Nunca te quedes sin espacio con elementos ilimitados en el portapapeles, asegurando siempre el acceso a tus copias más recientes.';

  @override
  String get sub_dialog__f2__title =>
      'Soporta todas las plataformas principales';

  @override
  String get sub_dialog__f2__subtitle =>
      'Sincronización perfecta en todas las plataformas principales—Android, iOS, Windows, macOS, y Linux—para una productividad ininterrumpida en cualquier lugar.';

  @override
  String get sub_dialog__f3__title => 'Soporta Apple Universal Clipboard';

  @override
  String get sub_dialog__f3__subtitle =>
      'Transfiere sin esfuerzo el contenido del portapapeles entre tus dispositivos Apple con el soporte para Apple Universal Clipboard.';

  @override
  String get sub_dialog__f4__title => 'Almacenamiento En el Dispositivo';

  @override
  String get sub_dialog__f4__subtitle =>
      'Mantén tus datos seguros con almacenamiento en el dispositivo, asegurando que los elementos de tu portapapeles siempre estén al alcance y bajo tu control.';

  @override
  String get sub_dialog__f5__title => 'Integración con Google Drive';

  @override
  String get sub_dialog__f5__subtitle =>
      'Almacena de forma segura archivos y medios en Google Drive, integrándose sin esfuerzo con CopyCat Clipboard para una gestión de datos mejorada.';

  @override
  String get sub_dialog__f6__title => 'Búsqueda Instantánea';

  @override
  String get sub_dialog__f6__subtitle =>
      'Encuentra lo que necesitas al instante con potentes capacidades de búsqueda instantánea, haciendo que la recuperación de elementos del portapapeles sea rápida y eficiente.';

  @override
  String get sub_dialog__f7__title =>
      'Sincronización Hasta las Últimas 24 Horas';

  @override
  String get sub_dialog__f7__subtitle =>
      'Accede y sincroniza tu historial del portapapeles en todos tus dispositivos durante las últimas 24 horas. Esto asegura que nunca pierdas elementos copiados importantes, haciendo tu flujo de trabajo fluido y eficiente.';

  @override
  String get sub_dialog__f8__title => 'Hasta 3 Colecciones';

  @override
  String get sub_dialog__f8__subtitle =>
      'Organiza los elementos de tu portapapeles en hasta 3 colecciones, proporcionando una categorización simple para una mejor gestión del flujo de trabajo.';

  @override
  String get sub_dialog__f9__title =>
      'Sincronización Automática Cada 45 Segundos';

  @override
  String get sub_dialog__f9__subtitle =>
      'Disfruta de la sincronización automática de elementos del portapapeles cada 45 segundos, manteniendo tus dispositivos actualizados sin intervención manual.';

  @override
  String get sub_dialog__f10__title =>
      'Soporte para Encriptación de Extremo a Extremo';

  @override
  String get sub_dialog__f10__subtitle =>
      'E2EE hará todo encriptado para una privacidad superior.';

  @override
  String get sub_dialog__text__pro_title => 'Con PRO ✨';

  @override
  String get sub_dialog__text__pro_subtitle => 'Todo incluido en Gratis +';

  @override
  String get sub_dialog__f11__title => 'Hasta 50 Colecciones';

  @override
  String get sub_dialog__f11__subtitle =>
      'Organiza los elementos de tu portapapeles en hasta 50 colecciones para una gestión definitiva.';

  @override
  String get sub_dialog__f12__title =>
      'Sincronización Hasta los Últimos 30 Días';

  @override
  String get sub_dialog__f12__subtitle =>
      'El historial del portapapeles se sincroniza en todos tus dispositivos para clips creados en los últimos 30 días. Esto significa que puedes acceder a cualquier clip que copiaste en el último mes, sin importar qué dispositivo estés usando.';

  @override
  String get sub_dialog__f13__title => 'Sincronización en Tiempo Real';

  @override
  String get sub_dialog__f13__subtitle =>
      'Experimenta sincronización ultra rápida.';

  @override
  String get sub_dialog__f14__title => 'Soporte Más Rápido y Prioritario';

  @override
  String get sub_dialog__f14__subtitle =>
      'Obtén soporte rápido y prioritario como usuario PRO.';

  @override
  String get sub_dialog__f15__title => 'Acceso Temprano a Nuevas Funciones';

  @override
  String get sub_dialog__f15__subtitle =>
      'Sé el primero en probar nuevas características y actualizaciones.';

  @override
  String get sub_dialog__f16__title => 'Reglas de Exclusión Personalizadas';

  @override
  String get sub_dialog__f16__subtitle =>
      'Control preciso sobre tu portapapeles. Te permite definir qué copiar, desde dónde copiar y cuándo copiar.';

  @override
  String get sub_dialog__f17__title => 'Arrastrar y Soltar';

  @override
  String get sub_dialog__f17__subtitle =>
      'Mueve elementos sin esfuerzo en cualquier dirección en tus dispositivos de Escritorio y Tableta.';

  @override
  String get sub_dialog__f18__title => 'Tematización';

  @override
  String get sub_dialog__f18__subtitle =>
      'Personaliza la apariencia completa de la aplicación para que coincida con tus preferencias.';

  @override
  String get paywall_dialog__text__month => 'mes';

  @override
  String get paywall_dialog__text__year => 'año';

  @override
  String get paywall_dialog__text__subscription => 'Suscripción';

  @override
  String get paywall_dialog__text__supported_platform =>
      'Para acceder a las características premium en Copycat Clipboard, por favor suscríbete a través de la Play Store o Apple App Store. Tu suscripción se sincronizará en todos tus dispositivos, incluyendo Linux y Windows.';

  @override
  String get paywall_dialog__text__unlock_pro => 'Desbloquea CopyCat PRO';

  @override
  String get paywall_dialog__text__unlock_pro_p1 =>
      'Disfruta de más de 30 días de historial sincronizado, más de 50 colecciones, encriptación de extremo a extremo, sincronización en tiempo real, acceso a las funciones más nuevas y mucho más.';

  @override
  String get paywall_dialog__text__try_again => 'Por favor intenta de nuevo';

  @override
  String get paywall_dialog__text__current_plan => 'Plan Actual';

  @override
  String get paywall_dialog__text__expired_plan => 'Plan Actual • Expirado';

  @override
  String paywall_dialog__text__trial_till({required DateTime till}) {
    final intl.DateFormat tillDateFormat = intl.DateFormat.yMMMd(localeName);
    final String tillString = tillDateFormat.format(till);

    return 'Prueba hasta $tillString';
  }

  @override
  String get paywall_dialog__text__upgrade => 'Mejorar';

  @override
  String fab__create_collection({required String remaining}) {
    return 'Crear Colección ( $remaining Restante )';
  }

  @override
  String get fab__sync => 'Sincronizar';

  @override
  String get fab__sync_unavailable => 'Sincronización No Disponible';

  @override
  String get fab__sync_up_to_date => 'Ya está actualizado.';

  @override
  String fab__sync_failed({required String message}) {
    return 'Sincronización fallida: $message';
  }

  @override
  String get layout__navbar__clipboard => 'Portapapeles';

  @override
  String get layout__navbar__collections => 'Colecciones';

  @override
  String get layout__navbar__settings => 'Configuraciones';

  @override
  String get search__tooltip__filter => 'Filtros de búsqueda';

  @override
  String manage_sub__ack__promo_sub({required String till}) {
    return 'Estás usando una suscripción promocional hasta $till';
  }

  @override
  String get manage_sub__button__text => 'Gestionar Suscripciones';

  @override
  String get my_account__button__tooltip => 'Mi Cuenta';

  @override
  String get badges__tooltip__experimental =>
      'Esta característica es experimental y puede no funcionar como se espera.';

  @override
  String get badges__label__pro => 'PRO';

  @override
  String get badges__tooltip__pro_only =>
      'Esta característica está disponible solo para usuarios Pro.';

  @override
  String get collection_selector__tile__no_collection => 'Sin Colección';

  @override
  String get collection_selector__button__remove_collection =>
      'Eliminar Colección';

  @override
  String get dialog__logout__title => 'Cerrar Sesión';

  @override
  String get dialog__logout__subtitle =>
      '⚠️ ADVERTENCIA ⚠️\n\nCerrar sesión eliminará los cambios no sincronizados en la base de datos local. ¿Estás seguro de que quieres continuar?';

  @override
  String get dialog__logging_out__ack =>
      '¡Cerrando sesión! Por favor espera...';

  @override
  String get reset_pass__text__label => 'Restablece tu contraseña';

  @override
  String get dnd__text__drop_here => 'Suelta Aquí';

  @override
  String dnd__ack__error_max_drop_count({required int count}) {
    return 'Se permite un máximo de $count elementos a la vez.';
  }

  @override
  String get search_filter__text__title => 'Filtros';

  @override
  String get search_filter__button__apply => 'Aplicar';

  @override
  String get search_filter__text__from => 'De';

  @override
  String get search_filter__text__select => 'Seleccionar';

  @override
  String get search_filter__text__to => 'A';

  @override
  String get search_filter__text__now => 'Ahora';

  @override
  String get search_filter__text__including => 'Incluyendo';

  @override
  String get search_filter__chip__text => 'Texto';

  @override
  String get search_filter__chip__url => 'URL';

  @override
  String get search_filter__chip__media => 'Medios';

  @override
  String get search_filter__chip__docs => 'Documentos';

  @override
  String get search_filter__text__textCategories => 'Categorías de Texto';

  @override
  String get search_filter__text__exclusive => '( Exclusivo )';

  @override
  String get search_filter__text_cat__email => 'Correo Electrónico';

  @override
  String get search_filter__text_cat__phone => 'Teléfono';

  @override
  String get search_filter__text_cat__color => 'Color';

  @override
  String get search_filter__text_cat__struct => 'Struct';

  @override
  String get search_filter__text__sort_by => 'Ordenar Por';

  @override
  String get search_filter__sort_by__last_mod => 'Última Modificación';

  @override
  String get search_filter__sort_by__created => 'Creado';

  @override
  String get search_filter__sort_by__copy_count => 'Conteo de Copias';

  @override
  String get search_filter__sort_by__last_copied => 'Última Copia';

  @override
  String get search_filter__text__sort_order => 'Orden de Clasificación';

  @override
  String get search_filter__sort_ord__asc => 'Ascendente';

  @override
  String get search_filter__sort_ord__desc => 'Descendente';

  @override
  String get search_filter__tooltip__clear => 'Clear';

  @override
  String get search_filter__empty => '∅';

  @override
  String get search_filter__button__reset => 'Reset';

  @override
  String get login__local_signin__tooltip =>
      'Sin sincronización. Todos los datos permanecen en tu dispositivo.';

  @override
  String get login__local_signin__btn__label => 'Modo Offline';

  @override
  String get login__form__input__name => 'Introduce tu buen nombre';

  @override
  String get login__form__input__email => 'Introduce tu correo electrónico';

  @override
  String get login__form__input__error_email =>
      'Por favor introduce una dirección de correo electrónico válida';

  @override
  String get login__form__input__password => 'Introduce tu contraseña';

  @override
  String get login__form__input__error_password_length =>
      'Por favor introduce una contraseña de al menos 6 caracteres';

  @override
  String get login__form__button__signin => 'Iniciar Sesión';

  @override
  String get login__form__button__signup => 'Registrarse';

  @override
  String get login__form__button__forgot_password =>
      '¿Olvidaste tu contraseña?';

  @override
  String get login__form__text__signup => '¿No tienes una cuenta? Regístrate';

  @override
  String get login__form__text__old_user =>
      '¿Ya tienes una cuenta? Iniciar sesión';

  @override
  String get login__form__text__reset_password =>
      'Enviar correo de restablecimiento de contraseña';

  @override
  String get login__form__text__reset_ack =>
      'El correo de restablecimiento de contraseña ha sido enviado';

  @override
  String get login__form__button__back => 'Volver a iniciar sesión';

  @override
  String get login__form__button__update_password => 'Actualizar Contraseña';

  @override
  String get login__form__text_tnc_p1 =>
      'Al continuar, aceptas los siguientes ';

  @override
  String get login__form__text_tnc_p2 => 'Políticas de privacidad';

  @override
  String get login__form__text_tnc_p3 => ' y ';

  @override
  String get login__form__text_tnc_p4 => 'Términos del Servicio.';

  @override
  String get home__search__hint => 'Buscar en el portapapeles';

  @override
  String get home__search__reset => 'Restablecer Búsqueda';

  @override
  String get preview__vert_view__tab1_title => 'Vista Previa';

  @override
  String get preview__vert_view__tab2__title => 'Detalles';

  @override
  String get preview__card__missing_text => 'Este es un Clip Vacío';

  @override
  String get preview__card__video__play => 'Reproducir Video';

  @override
  String get preview__card__file__open => 'Abrir Archivo';

  @override
  String get preview__form__title => 'Editar Detalles';

  @override
  String get preview__form__input__title => 'Título';

  @override
  String get preview__form__input__description => 'Descripción';

  @override
  String get preview__inspector__title => 'Clip Details';

  @override
  String get preview__inspector__untitled => 'Untitled Clip';

  @override
  String get preview__inspector__saved => 'Details updated';

  @override
  String get preview__inspector__save_changes => 'Save changes';

  @override
  String get preview__inspector__decrypt => 'Decrypt';

  @override
  String get preview__inspector__open_source => 'Open Source';

  @override
  String get preview__inspector__section__actions => 'Actions';

  @override
  String get preview__inspector__section__details => 'Details';

  @override
  String get preview__inspector__section__content => 'Content';

  @override
  String get preview__inspector__section__organize => 'Organize';

  @override
  String get preview__inspector__label__created => 'Created';

  @override
  String get preview__inspector__label__modified => 'Modified';

  @override
  String get preview__inspector__label__last_copied => 'Last Copied';

  @override
  String get preview__inspector__label__copied_count => 'Copied Count';

  @override
  String get preview__inspector__label__source_app => 'Source App';

  @override
  String get preview__inspector__label__source_url => 'Source URL';

  @override
  String get preview__inspector__label__file_size => 'File Size';

  @override
  String get preview__inspector__label__mime_type => 'MIME Type';

  @override
  String get preview__inspector__label__extension => 'Extension';

  @override
  String get preview__inspector__label__characters => 'Characters';

  @override
  String get preview__inspector__label__lines => 'Lines';

  @override
  String get preview__inspector__label__link => 'Link';

  @override
  String get preview__inspector__status__encrypted => 'Encrypted';

  @override
  String get preview__inspector__status__local_only => 'Local Only';

  @override
  String get preview__inspector__status__synced => 'Synced';

  @override
  String get preview__inspector__status__not_synced => 'Not Synced';

  @override
  String get preview__inspector__status__download_required =>
      'Download Required';

  @override
  String get preview__inspector__status__available => 'Available Offline';

  @override
  String get preview__inspector__type__text => 'Text';

  @override
  String get preview__inspector__type__media => 'Media';

  @override
  String get preview__inspector__type__file => 'File';

  @override
  String get preview__inspector__type__link => 'Link';

  @override
  String get reset_password__appbar__title => 'Restablece tu contraseña';

  @override
  String get reset_password__success_ack => 'Contraseña restablecida con éxito';

  @override
  String get onboarding__text__welcome => 'Bienvenido a';

  @override
  String get onboarding__text__lets_continue => 'Continuemos';

  @override
  String get onboarding__button__to_login => 'Iniciar sesión';

  @override
  String get onboarding__snackbar__export_success =>
      'Clave de encriptación exportada con éxito.';

  @override
  String get onboarding__dialog__skip_export__title =>
      '✋ Guarda una Copia de Seguridad de tu Clave de Encriptación';

  @override
  String get onboarding__dialog__skip_export__subtitle =>
      'Aún no has exportado tu clave de encriptación. Sin una copia de seguridad, no podrás acceder a tus clips encriptados si pierdes la clave o cambias de dispositivo.\n\n👉 Si ya tienes una copia de seguridad segura de tu clave, puedes continuar sin problemas. De lo contrario, te recomendamos encarecidamente que exportes la clave ahora para evitar la pérdida de datos. ¿Aún deseas continuar?';

  @override
  String get onboarding__dialog__export_info__title =>
      '🤔 ¿Por qué Exportar la Clave de Encriptación?';

  @override
  String get onboarding__dialog__export_info__subtitle =>
      'Exportar tu clave de encriptación es esencial para acceder de forma segura a tus datos encriptados en múltiples dispositivos. Sin la clave, tus datos encriptados permanecerán inaccesibles tras la sincronización.\n\nGuarda una copia de tu clave de encriptación en un lugar seguro para evitar la pérdida de datos. Recuerda, la clave es única para tu cuenta y no se puede recuperar si se pierde.\n\nNota: Copycat no puede acceder a tus clips encriptados ni a tus claves de encriptación. Esto se debe a que valoramos tu privacidad por encima de todo.';

  @override
  String get onboarding__text__export_key_headline =>
      'Encriptación del Portapapeles';

  @override
  String get onboarding__text__export_key_title =>
      '💪 ¡Gran Noticia! La encriptación está activa para tu portapapeles';

  @override
  String get onboarding__button__export_key => 'Exportar Clave';

  @override
  String get onboarding__dialog__skip_gen_key__title =>
      '✋ Tus Clips Estarán Inseguros';

  @override
  String get onboarding__dialog__skip_gen_key__subtitle =>
      'Aún no has generado una clave de encriptación. Sin ella, tus clips permanecerán sin encriptar e inseguros. Puedes generar la clave más adelante en Configuración ❯ Seguridad. ¿Aún deseas continuar?';

  @override
  String get onboarding__dialog__gen_key_info__title =>
      '🤔 ¿Por qué Necesito Encriptación?';

  @override
  String get onboarding__dialog__gen_key_info__subtitle =>
      'La encriptación protege tus datos convirtiéndolos en un formato seguro que solo puede ser accedido con una clave. Sin encriptación, tus clips se almacenan en texto plano, haciéndolos vulnerables al acceso no autorizado. Habilitar la encriptación asegura que solo tú puedas acceder a tus datos sensibles, proporcionando una capa adicional de seguridad contra posibles violaciones.';

  @override
  String get onboarding__text__gen_key_headline =>
      'Configurar Encriptación del Portapapeles';

  @override
  String onboarding__text__key_generated_title({required String keyPreview}) {
    return '🎉 Clave $keyPreview*** generada con éxito 🎉';
  }

  @override
  String get onboarding__button__regenerate_key => 'Regenerar Clave';

  @override
  String get onboarding__text__no_key =>
      'Tu cuenta no tiene ninguna clave de encriptación';

  @override
  String get onboarding__button__generate_key => 'Generar Clave';

  @override
  String get onboarding__button__do_it_later => 'Hacerlo Más Tarde';

  @override
  String get onboarding__button__why_important => '¿Por qué es Importante?';

  @override
  String get onboarding__snackbar__invalid_key =>
      'Esta no es una clave de encriptación CopyCat válida';

  @override
  String get onboarding__dialog__skip_import__title =>
      '✋ Clips Encriptados Inaccesibles';

  @override
  String get onboarding__dialog__skip_import__subtitle =>
      'Aún no has importado la clave de encriptación. Esto significa que todos tus clips encriptados permanecerán inaccesibles localmente tras la sincronización.\n\nPara acceder a ellos, importa la clave desde Configuración ❯ Seguridad.\n¿Aún deseas continuar?';

  @override
  String get onboarding__dialog__reset_key__title =>
      '✋ Eliminar Permanentemente Datos Encriptados';

  @override
  String get onboarding__dialog__reset_key__subtitle =>
      'Esta acción es irreversible. ¿Estás seguro de que deseas eliminar permanentemente todos los datos encriptados del servidor?';

  @override
  String get onboarding__snackbar__reset_key__success =>
      'Encriptación eliminada exitosamente.';

  @override
  String get onboarding__dialog__import_info__title =>
      '🤔 ¿Dónde está mi clave?';

  @override
  String get onboarding__dialog__import_info__subtitle =>
      'Tu clave de encriptación es un archivo seguro generado durante el proceso de configuración de la encriptación. Si la has extraviado, revisa tu carpeta de descargas o cualquier lugar de respaldo donde puedas haberla guardado. Sin esta clave, tus datos encriptados no pueden ser accedidos.\n\nSi has configurado la clave de encriptación en otro dispositivo, puedes exportarla yendo a Configuración ❯ Seguridad ❯ Bóveda E2EE en ese dispositivo. Transfiere la clave de manera segura a este dispositivo para recuperar el acceso a tus datos encriptados.';

  @override
  String get onboarding__text__import_key_headline =>
      'Importar Clave de Encriptación del Portapapeles';

  @override
  String get onboarding__text__import_key_title =>
      'Tu cuenta actualmente tiene encriptación activa.';

  @override
  String get onboarding__button__import_key => 'Importar Clave';

  @override
  String get onboarding__button__reset_key => 'Restablecer Encriptación';

  @override
  String get onboarding__button__where_key => '¿Dónde está la clave?';

  @override
  String get onboarding__text__go_home => 'Vamos a casa';

  @override
  String onboarding__restoration__failed({required String message}) {
    return 'La restauración falló: $message';
  }

  @override
  String get onboarding__restoration_warning =>
      '⚠️ Mantén esta pantalla abierta durante la sincronización para evitar corrupción de datos o inconsistencias.';

  @override
  String get sync_restore__title => 'Restaurando tu espacio de trabajo';

  @override
  String get sync_restore__subtitle =>
      'CopyCat está trayendo tus colecciones sincronizadas y el historial del portapapeles a este dispositivo.';

  @override
  String get sync_restore__checking_backup =>
      'Comprobando la copia de seguridad remota...';

  @override
  String get sync_restore__decrypting_title => 'Decrypting clips';

  @override
  String get sync_restore__decrypting_counting => 'Counting encrypted clips...';

  @override
  String sync_restore__decrypting_progress({
    required int decrypted,
    required int total,
  }) {
    return 'Decrypted $decrypted of $total';
  }

  @override
  String get sync_restore__workspace_restored =>
      'Espacio de trabajo restaurado';

  @override
  String get sync_restore__data_ready =>
      'Tus datos sincronizados están listos en este dispositivo.';

  @override
  String get sync_restore__restoring_collections =>
      'Restaurando colecciones para mantener organizados los elementos del portapapeles.';

  @override
  String get sync_restore__restoring_clips =>
      'Las colecciones se restauraron. Ahora sigue el historial del portapapeles.';

  @override
  String get sync_restore__finishing_checks =>
      'Finalizando comprobaciones de restauración.';

  @override
  String get sync_restore__no_synced_items =>
      'No se encontraron elementos sincronizados';

  @override
  String sync_restore__restored_count({required int count}) {
    return '$count restaurados';
  }

  @override
  String sync_restore__restored_of_total({
    required int synced,
    required int total,
  }) {
    return '$synced de $total restaurados';
  }

  @override
  String get sync_restore__progress_estimating => 'Estimando';

  @override
  String get sync_restore__progress_complete => 'Completado';

  @override
  String get sync_restore__status_ready => 'Listo';

  @override
  String get sync_restore__status_restoring => 'Restaurando';

  @override
  String get sync_restore__collections_title => 'Colecciones';

  @override
  String get sync_restore__collections_description =>
      'Grupos guardados y organización';

  @override
  String get sync_restore__clipboard_items_title =>
      'Elementos del portapapeles';

  @override
  String get sync_restore__clipboard_items_description =>
      'Historial, texto, enlaces, archivos y medios';

  @override
  String sync_restore__count_of_total({required int total}) {
    return 'de $total';
  }

  @override
  String get sync_restore__continue_to_copycat => 'Continuar a CopyCat';

  @override
  String get sync_restore__failed_title => 'La restauración falló';

  @override
  String get restore_clips__text__title => 'Restaurar mi portapapeles';

  @override
  String get restore_clips__error__no_backup =>
      'No se encontró una copia de seguridad del portapapeles';

  @override
  String restore_clips__text__total_count({required int totalCount}) {
    return 'Tienes aproximadamente $totalCount clip(s) para restaurar.';
  }

  @override
  String get restore_clips__sync_disable =>
      'La sincronización está desactivada. Actívala para continuar.';

  @override
  String get restore_clips__preparing =>
      'Preparando para restaurar los clips. Por favor espera...';

  @override
  String restore_clips__restored({required int syncCount}) {
    return 'Tus $syncCount clip(s) se han restaurado con éxito.';
  }

  @override
  String restore_clips__restoring({
    required int synced,
    required int totalCount,
  }) {
    return 'Restaurado: $synced de $totalCount clips.';
  }

  @override
  String get restore_collections__text__title => 'Restaurar mis colecciones';

  @override
  String get restore_collections__error__no_backup =>
      'No se encontró una copia de seguridad de colecciones';

  @override
  String restore_collections__text__total_count({required int totalCount}) {
    return 'Tienes aproximadamente $totalCount colección(es) para restaurar.';
  }

  @override
  String get restore_collections__sync_disable =>
      'La sincronización está desactivada. Actívala para continuar.';

  @override
  String get restore_collections__preparing =>
      'Preparando para restaurar las colecciones. Por favor espera...';

  @override
  String restore_collections__restored({required int syncCount}) {
    return 'Tus $syncCount colección(es) se han restaurado con éxito.';
  }

  @override
  String restore_collections__restoring({
    required int synced,
    required int totalCount,
  }) {
    return 'Restaurado: $synced de $totalCount colecciones.';
  }

  @override
  String get drive__snackbar__success =>
      'La configuración de Drive está ahora completa.';

  @override
  String get drive__text__setting_up => 'Configurando y sincronizando...';

  @override
  String get drive__text__setting_up__warning =>
      'Por favor espera mientras finalizamos esto. No cierres la aplicación.';

  @override
  String get create_clip__appbar__title__new => 'Nuevo Clip';

  @override
  String get create_clip__appbar__title__edit => 'Editar Clip';

  @override
  String get create_clip__button__save_new => 'Guardar como nuevo';

  @override
  String get create_clip__input__hint => 'Escribe aquí el contenido de tu clip';

  @override
  String get collections__text__tip =>
      'Para asegurarte de que tus clips importantes estén siempre disponibles sin importar el tiempo, en todos tus dispositivos, ¡guárdalos en una colección!';

  @override
  String get collections__appbar__title => 'Colecciones';

  @override
  String get collections__appbar__title__create => 'Crear Colección';

  @override
  String get collections__appbar__title__edit => 'Editar Colección';

  @override
  String get collections__input__name => 'Nombre';

  @override
  String get collections__input__description => 'Descripción';

  @override
  String get collections__label__emoji => 'Collection Icon (Click to change)';

  @override
  String get collections__validation__duplicate =>
      'A collection with this icon and name already exists';

  @override
  String get select_collection__appbar__title => 'Seleccionar Colección';

  @override
  String get account__dialog__delete_confirm__title =>
      'Solicitud de Eliminación de Cuenta';

  @override
  String get account__dialog__delete_confirm__description =>
      'Serás redirigido al formulario de solicitud de eliminación de cuenta, ¿estás seguro?';

  @override
  String get account__list_tile__display_name => 'Nombre para Mostrar';

  @override
  String get account__list_tile__email => 'Correo Electrónico';

  @override
  String get account__list_tile__settings => 'Configuraciones de la Cuenta';

  @override
  String get account__list_tile__danger_zone => 'Zona de Peligro';

  @override
  String get account__button__req_delete => 'Solicitar Eliminación de Cuenta';

  @override
  String get account__appbar__title => 'Mi Cuenta';

  @override
  String get settings__appbar__title => 'Configuración';

  @override
  String get settings__header__appearance => 'Appearance';

  @override
  String get settings__header__sorting => 'Default Sorting';

  @override
  String get settings__header__interactions => 'Interactions';

  @override
  String get settings__tab__1 => 'General';

  @override
  String get settings__tab__2 => 'Personalización';

  @override
  String get settings__tab__3 => 'Sincronización';

  @override
  String get settings__tab__4 => 'Encriptación';

  @override
  String get settings__tab__5 => 'Experimental';

  @override
  String get settings__text__encryption => 'Encriptación';

  @override
  String get settings__text__sync_not_available =>
      'Configuraciones relacionadas con la sincronización no están disponibles al usar el portapapeles local.';

  @override
  String get settings__appbar__er__title => 'Reglas de Exclusión';

  @override
  String get settings__text__er__predefine =>
      'Reglas de Exclusión Predefinidas';

  @override
  String get settings__text__er__pass_manager => 'Gestores de Contraseñas';

  @override
  String get settings__text__er__cc => 'Número de Tarjeta de Crédito';

  @override
  String get settings__text__er__phone => 'Número de Teléfono';

  @override
  String get settings__text__er__email => 'Dirección de Correo Electrónico';

  @override
  String get settings__text__er__url => 'URL Sensible';

  @override
  String get settings__text__decrypted__note =>
      '🥳 ¡Felicidades! Todos tus clips han sido desencriptados con éxito localmente,\n por lo que no se requiere reconstruir la base de datos.';

  @override
  String get settings__appbar__cer__title =>
      'Reglas de Exclusión Personalizadas';

  @override
  String get settings__switch__drag_n_drop__title => 'Arrastrar y Soltar';

  @override
  String get settings__switch__drag_n_drop__subtitle =>
      'Permitir que los elementos se muevan libremente en ambas direcciones dentro de la app.';

  @override
  String get settings__dropdown__no_copy_over_limit__title =>
      'No Copiar Automáticamente Más de';

  @override
  String settings__dropdown__no_copy_over_limit__subtitle({
    required String fileSize,
  }) {
    return 'Archivos y medios de más de cierto tamaño ($fileSize) no se copiarán automáticamente.';
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
      'No Subir Automáticamente Más de';

  @override
  String settings__dropdown__no_upload_over_limit__subtitle({
    required String fileSize,
  }) {
    return 'Archivos y medios de más de cierto size ($fileSize) no se subirán automáticamente.';
  }

  @override
  String get settings__dropdown__sync_mode__title => 'Modo de Sincronización';

  @override
  String get settings__dropdown__sync_mode__subtitle =>
      'Selecciona la velocidad de sincronización que mejor funcione para ti.';

  @override
  String get settings__sync_mode__realtime => 'Tiempo Real';

  @override
  String get settings__sync_mode__balanced => 'Equilibrado';

  @override
  String get settings__dropdown__theme__title => 'Modo de Tema';

  @override
  String get settings__dropdown__default_sort__title => 'Sort By';

  @override
  String get settings__dropdown__default_sort_order__title => 'Sort Order';

  @override
  String get settings__theme__system => 'Sistema';

  @override
  String get settings__theme__light => 'Claro';

  @override
  String get settings__theme__dark => 'Oscuro';

  @override
  String get settings__dropdown__color_mode__title => 'Modo de Color';

  @override
  String get settings__dropdown__color_mode__subtitle =>
      'Selecciona el modo de color para personalizar la apariencia de la app. La opción predeterminada es \'Tonal Spot\'.';

  @override
  String get settings__color_mode__tonalSpot => 'Tonal Spot';

  @override
  String get settings__color_mode__content => 'Contenido';

  @override
  String get settings__color_mode__expressive => 'Expresivo';

  @override
  String get settings__color_mode__fidelity => 'Fidelidad';

  @override
  String get settings__color_mode__fruit_salad => 'Ensalada de Frutas';

  @override
  String get settings__color_mode__monochrome => 'Monocromo';

  @override
  String get settings__color_mode__neutral => 'Neutral';

  @override
  String get settings__color_mode__rainbow => 'Arcoíris';

  @override
  String get settings__color_mode__vibrant => 'Vibrante';

  @override
  String get settings__tile__cer_title => 'Reglas Personalizadas';

  @override
  String get settings__tile__cer_subtitle =>
      'Excluir por aplicación, título de ventana de la aplicación/sitio web, URL del sitio web o patrón regex';

  @override
  String get settings__tile__er_title => 'Reglas de Exclusión';

  @override
  String get settings__tile__er_subtitle =>
      'Evita que la información se copie al portapapeles. Haz clic para control avanzado.';

  @override
  String get settings__switch__enable_sync__title =>
      'Sincronización del Portapapeles';

  @override
  String get settings__switch__enable_sync__subtitle =>
      'Sincroniza tu portapapeles entre dispositivos sin esfuerzo.';

  @override
  String get settings__switch__sync_file__title =>
      'Sincronización de Archivos y Medios';

  @override
  String get settings__switch__sync_file__subtitle =>
      'Activa para sincronizar archivos y clips de medios entre dispositivos.';

  @override
  String get settings__switch__paused__title =>
      'Pausar Escucha del Portapapeles';

  @override
  String get settings__switch__paused__subtitle =>
      'Pausa temporalmente el seguimiento del portapapeles hasta una hora establecida.';

  @override
  String settings__switch__paused_active__subtitle({required DateTime time}) {
    final intl.DateFormat timeDateFormat = intl.DateFormat(
      'h:mm a',
      localeName,
    );
    final String timeString = timeDateFormat.format(time);

    return 'Pausado hasta $timeString. Toca para reanudar o ajustar la hora.';
  }

  @override
  String get settings__switch__smart_paste__title => 'Pegado Inteligente';

  @override
  String get settings__switch__smart_paste__subtitle =>
      'Pega contenido directamente en la aplicación enfocada.';

  @override
  String get settings__switch__transform_behavior__title =>
      'Guardar transformaciones como clips nuevos';

  @override
  String get settings__switch__transform_behavior__subtitle =>
      'Si está activado, las acciones de transformación crean un nuevo clip en lugar de copiar o pegar de inmediato.';

  @override
  String get settings__switch__type_search__title => 'Type to Search';

  @override
  String get settings__switch__type_search__subtitle =>
      'Search clips while you type in the search bar.';

  @override
  String get settings__switch__startup__title => 'Iniciar al Iniciar';

  @override
  String get settings__switch__startup__subtitle =>
      'Inicia automáticamente el CopyCat cuando tu dispositivo se encienda.';

  @override
  String get settings__switch__hotkey__title =>
      'Alternar con Tecla de Acceso Rápido';

  @override
  String get settings__switch__hotkey__subtitle =>
      'Usa un atajo de teclado para acceder rápidamente a tu Portapapeles CopyCat';

  @override
  String get settings__switch__quickpaste_hotkey__title => 'Quick Paste Hotkey';

  @override
  String get settings__switch__quickpaste_hotkey__subtitle =>
      'Use a keyboard shortcut to instantly access your top 10 clipboard items';

  @override
  String get settings__hotkey__unassigned => 'No Asignado';

  @override
  String get settings__hotkey__preview_start => 'Presiona ';

  @override
  String get settings__hotkey__preview_end => ' para mostrar u ocultar la app.';

  @override
  String get settings__tile__theme_color__title => 'Color de Tema';

  @override
  String get settings__tile__theme_color__subtitle =>
      'Este color influirá en la apariencia general de la app.';

  @override
  String get settings__tile__desk_client__title =>
      'Descargar Cliente de Escritorio';

  @override
  String get settings__tile__mobile_client__title =>
      'Descargar Cliente para Teléfono';

  @override
  String get settings__tile__client__subtitle =>
      'Accede a tu portapapeles en todos tus dispositivos.';

  @override
  String get settings__tile__e2e_setup__title =>
      'Configuración de Encriptación de Extremo a Extremo';

  @override
  String get settings__tile__e2e_setup__subtitle =>
      'Configura la encriptación para tus clips.';

  @override
  String get settings__switch__e2e__title => 'Activar Encriptación';

  @override
  String get settings__switch__e2e__subtitle =>
      'Activa o desactiva la encriptación de extremo a extremo para tus clips.';

  @override
  String get settings__switch__e2e_nonce__title =>
      'High-Security Mode (Recommended)';

  @override
  String get settings__switch__e2e_nonce__subtitle =>
      'Upgrades encryption to AES-GCM for superior data protection and tamper detection. (Older app versions cannot decrypt these new clips)';

  @override
  String get settings__dialog__conn_gdrive__title =>
      '¿Reconectar Google Drive?';

  @override
  String get settings__dialog__conn_gdrive__subtitle =>
      '¡Tu Google Drive ya está conectado! ¿Te gustaría reconectar?\n\nPara evitar cualquier pérdida de datos, asegúrate de usar la misma cuenta que antes.';

  @override
  String get settings__drive__connected => 'Conectado';

  @override
  String get settings__drive__loading => 'Cargando...';

  @override
  String get settings__drive__authorizing => 'Autorizando...';

  @override
  String get settings__drive__disconnected => 'Desconectado';

  @override
  String get settings__text__cloud__title => 'Unidad en la Nube';

  @override
  String get settings__text__cloud__name => 'Google Drive';

  @override
  String get settings__text__gdrive__error =>
      'Google Drive no está conectado. La sincronización de archivos y medios está actualmente desactivada.';

  @override
  String get settings__text__gdrive__info =>
      'Tus archivos y medios se sincronizan de forma segura entre dispositivos a través de Google Drive, asegurando que tu privacidad esté protegida.';

  @override
  String get settings__tile__other_cloud__title =>
      'Configura Otras Unidades en la Nube';

  @override
  String get settings__tile__other_cloud__subtitle =>
      'Configura otras unidades en la nube como Dropbox, OneDrive, etc.';

  @override
  String get custom_er__nav__1 => 'Aplicación';

  @override
  String get custom_er__nav__2 => 'Título de Ventana';

  @override
  String get custom_er__nav__3 => 'URL';

  @override
  String get custom_er__nav__4 => 'Patrón de Texto';

  @override
  String get custom_er__text__not_supported =>
      'Esta exclusión aún no es soportada';

  @override
  String get custom_er__tile__add_app => 'Agregar una aplicación';

  @override
  String get custom_er__text__no_app =>
      'No se ha excluido ninguna aplicación personalizada';

  @override
  String get custom_er__button__remove_app => 'Eliminar esta aplicación';

  @override
  String get custom_er__tile__pattern =>
      'Evitar copiar cuando el contenido copiado coincide con estos patrones';

  @override
  String get custom_er__text__no_pattern =>
      'No se han excluido patrones personalizados';

  @override
  String get custom_er__button__remove_pattern => 'Eliminar este patrón';

  @override
  String get custom_er__tile__url =>
      'Evitar copiar desde sitios web que coinciden con estos segmentos de URL.';

  @override
  String get custom_er__input__url_hint =>
      'Introduce una URL o parte de una URL aquí.';

  @override
  String get custom_er__text__no_url =>
      'No se han excluido URL(s) personalizadas';

  @override
  String get custom_er__button__remove_url => 'Eliminar esta URL';

  @override
  String get custom_er__tile__title =>
      'Evitar copiar de aplicación o sitio web cuando el título de la ventana coincide.';

  @override
  String get custom_er__text__no_title =>
      'No se han excluido título(s) personalizados';

  @override
  String get custom_er__button__remove_title => 'Eliminar este título';

  @override
  String get about__tile__discord => 'Discord • Conectar';

  @override
  String get about__tile__youtube => 'YouTube • Tutorial';

  @override
  String get about__tile__read_tut => 'Leer • Tutorial';

  @override
  String get about__tile__github => 'Github • Código abierto';

  @override
  String get about__tile__website => 'EntilityStudio • Sitio web';

  @override
  String get about__tile__support => 'Soporte';

  @override
  String get abc_title => 'Portapapeles en segundo plano';

  @override
  String get abc__tile__subtitle => 'Escucha el portapapeles en segundo plano';

  @override
  String get abc__tip__why_title => '¿Por qué se necesitan estos permisos?';

  @override
  String get abc__tip__why_subtitle =>
      'Estos permisos aseguran que CopyCat funcione correctamente en segundo plano, permitiéndole detectar el contenido copiado y brindarle una experiencia fluida sin interrupciones.';

  @override
  String get abc__tip__support_title => 'Soporte limitado';

  @override
  String get abc__tip__support_subtitle =>
      '1. Actualmente, solo se admiten clips de texto.\n2. Algunos sistemas operativos, como HyperOS 1, aún no son compatibles.';

  @override
  String get abc__heading__req_perm => 'Permisos requeridos';

  @override
  String get abc__tile__notification_title => 'Acceso a notificaciones';

  @override
  String get abc__tile__notification_subtitle =>
      'Muestra una notificación persistente para informarle que CopyCat está funcionando en segundo plano, garantizando transparencia y privacidad.';

  @override
  String get abc__tile__battery_opt_title => 'Optimización de batería';

  @override
  String get abc__tile__battery_opt_subtitle =>
      'Evita que el sistema apague CopyCat mientras funciona en segundo plano, asegurando una experiencia fluida.';

  @override
  String get abc__tile__overlay_title => 'Permiso de superposición';

  @override
  String get abc__tile__overlay_subtitle =>
      'Permite que CopyCat lea el portapapeles abriendo brevemente una ventana transparente sobre la pantalla y cerrándola inmediatamente después.';

  @override
  String get abc__tile__acc_title => 'Servicio de accesibilidad';

  @override
  String get abc__tile__acc_subtitle =>
      'Inicia el oyente en segundo plano de CopyCat para detectar cuando copias algo y asegura que el servicio se reinicie automáticamente después de un reinicio.';

  @override
  String get abc__ack__ready => 'Configuración lista para ser configurada.';

  @override
  String get abc__ack__preparing =>
      'Preparando configuración, por favor espere...';

  @override
  String get abc__perm_alert_open_setting__button => 'Abrir configuración';

  @override
  String get abc__overlay_perm_alert__title => 'Permiso de superposición';

  @override
  String get abc__overlay_perm_alert__subtitle =>
      'CopyCat Clipboard necesita el permiso \'Dibujar sobre otras aplicaciones\' para leer el contenido del portapapeles en segundo plano.';

  @override
  String get abc__overlay_perm_alert__p1_prefix => 'Este permiso se ';

  @override
  String get abc__overlay_perm_alert__p1_bold =>
      'usa solo para la detección del portapapeles';

  @override
  String get abc__overlay_perm_alert__p1_suffix =>
      ' cuando copias algo en segundo plano.';

  @override
  String get abc__overlay_perm_alert__p2_prefix =>
      'Cuando está habilitado, CopyCat ';

  @override
  String get abc__overlay_perm_alert__p2_bold =>
      'crea una ventana transparente de 0 píxeles';

  @override
  String get abc__overlay_perm_alert__p2_suffix =>
      ' para llevar brevemente la aplicación al primer plano y leer los datos del portapapeles.';

  @override
  String get abc__overlay_perm_alert__p3_prefix => 'La aplicación ';

  @override
  String get abc__overlay_perm_alert__p3_bold => 'no muestra nada';

  @override
  String get abc__overlay_perm_alert__p3_suffix =>
      ' en tu pantalla durante este proceso.';

  @override
  String get abc__overlay_perm_alert__p4_prefix =>
      'En algunos dispositivos, el sistema puede mostrar un mensaje emergente ';

  @override
  String get abc__overlay_perm_alert__p4_bold =>
      '\'CopyCat pegó desde tu portapapeles\'';

  @override
  String get abc__overlay_perm_alert__p4_suffix =>
      ' cuando CopyCat lee el contenido de tu portapapeles.';

  @override
  String get abc__overlay_perm_alert__agree =>
      'Al otorgar este permiso, aceptas el uso descrito anteriormente.';

  @override
  String get abc__accessibility_perm_alert__title => 'Permiso de accesibilidad';

  @override
  String get abc__accessibility_perm_alert__subtitle =>
      'CopyCat Clipboard requiere el Servicio de Accesibilidad para funcionar en segundo plano y detectar y sincronizar el portapapeles en tiempo real.';

  @override
  String get abc__accessibility_perm_alert__p1_prefix => 'Este servicio se ';

  @override
  String get abc__accessibility_perm_alert__p1_bold => 'usa únicamente';

  @override
  String get abc__accessibility_perm_alert__p1_suffix =>
      ' para detectar el contenido del portapapeles y sincronizarlo entre dispositivos cuando está habilitado.';

  @override
  String get abc__accessibility_perm_alert__p2_prefix => 'Puedes ';

  @override
  String get abc__accessibility_perm_alert__p2_bold =>
      'excluir aplicaciones específicas';

  @override
  String get abc__accessibility_perm_alert__p2_suffix =>
      ' usando la función de Reglas de Exclusión.';

  @override
  String get abc__accessibility_perm_alert__p3_prefix => 'La aplicación ';

  @override
  String get abc__accessibility_perm_alert__p3_bold =>
      'no accede a ningún otro dato';

  @override
  String get abc__accessibility_perm_alert__p3_suffix =>
      ' más allá del contenido del portapapeles.';

  @override
  String get abc__accessibility_perm_alert__p4_prefix =>
      'Los datos del portapapeles ';

  @override
  String get abc__accessibility_perm_alert__p4_bold =>
      'no se comparten externamente';

  @override
  String get abc__accessibility_perm_alert__p4_suffix =>
      ' y permanecen privados en tus dispositivos.';

  @override
  String get abc__accessibility_perm_alert__p5_prefix =>
      'Los datos del portapapeles ';

  @override
  String get abc__accessibility_perm_alert__p5_bold =>
      'están cifrados de extremo a extremo';

  @override
  String get abc__accessibility_perm_alert__p5_suffix =>
      ' (si está habilitado) en tránsito y en reposo, garantizando la privacidad entre dispositivos.';

  @override
  String get abc__accessibility_perm_alert__agree =>
      'Al habilitar el Servicio de Accesibilidad, reconoces y aceptas los términos anteriores.';

  @override
  String get abc__other_setting__title => 'Otras configuraciones';

  @override
  String get abc__enhanced_clip_detection__title =>
      'Detección mejorada del portapapeles';

  @override
  String get abc__enhanced_clip_detection__subtitle =>
      'Habilite esta opción para una detección del portapapeles más precisa. Tenga en cuenta que podría no funcionar en todos los dispositivos.';

  @override
  String get abc__tile__two_way_sync__title => '2-Way Sync';

  @override
  String abc__tile__two_way_sync__subtitle({required String warning}) {
    return 'Keeps your clipboard synced across devices instantly.\n$warning';
  }

  @override
  String get abc__tile__two_way_sync__realtime_required =>
      '⚠️ Realtime mode required.';

  @override
  String current_time__local({required String time}) {
    return 'Local: $time';
  }

  @override
  String current_time__utc({required String time}) {
    return 'UTC: $time';
  }

  @override
  String encrypted_stat__summary({required int count}) {
    return 'You currently have $count encrypted clips that are inaccessible.';
  }

  @override
  String get encrypted_stat__all_decrypted =>
      '🥳 Congratulations! All your clips have been successfully decrypted locally, so rebuilding the database is not required.';

  @override
  String get encrypted_stat__rebuild_database => 'Rebuild Database';

  @override
  String tray__tooltip__paused_till({required String time}) {
    return 'CopyCat Clipboard - Paused till $time';
  }

  @override
  String get tray__menu__resume_copycat => '▶️ Resume CopyCat';

  @override
  String get tray__menu__pause_copycat => '⏸️ Pause CopyCat';

  @override
  String get tray__dialog__quit__subtitle => 'Are you sure you want to quit?';

  @override
  String get splash__checking_authentication =>
      'Checking for authentication...';

  @override
  String paste_stack__title({required int count}) {
    return 'Paste Stack • $count';
  }

  @override
  String get paste_stack__reverse_tooltip => 'Reverse Stack';

  @override
  String get multi_paste__title => 'Multi Paste Setup';

  @override
  String get multi_paste__subtitle =>
      'Control how selected clips are merged and paced.';

  @override
  String get multi_paste__stat__selected => 'Selected';

  @override
  String get multi_paste__stat__text => 'Text';

  @override
  String get multi_paste__stat__non_text => 'Non-text';

  @override
  String get multi_paste__merge__title => 'Merge consecutive text clips';

  @override
  String get multi_paste__merge__subtitle =>
      'Text clips merge until a non-text clip interrupts the sequence.';

  @override
  String get multi_paste__separator__title => 'Separator';

  @override
  String get multi_paste__separator__new_line => 'New line';

  @override
  String get multi_paste__separator__space => 'Space';

  @override
  String get multi_paste__separator__custom => 'Custom';

  @override
  String get multi_paste__separator__custom_label => 'Custom separator';

  @override
  String get multi_paste__separator__custom_hint =>
      'Supports escape sequences like \\n and \\t';

  @override
  String get multi_paste__pacing__title => 'Paste pacing';

  @override
  String get multi_paste__pacing__subtitle =>
      'Increase the delay if the target app misses paste events.';

  @override
  String get multi_paste__wait_between_pastes => 'Wait time between pastes';

  @override
  String get multi_paste__validation__wait_positive =>
      'Wait time must be a positive number.';

  @override
  String get multi_paste__validation__custom_separator_required =>
      'Please enter a custom separator.';

  @override
  String get settings__tile__backup_restore__title => 'Backup & Restore';

  @override
  String get settings__tile__backup_restore__subtitle =>
      'Create .ccbkup backups and restore locally';

  @override
  String get settings__switch__prevent_duplicates__title =>
      'Avoid Immediate Duplicates';

  @override
  String get settings__switch__prevent_duplicates__subtitle =>
      'Avoid copying the same content twice in a row';

  @override
  String get settings__switch__rich_data_capture__title => 'Rich Data Capture';

  @override
  String get settings__switch__rich_data_capture__subtitle =>
      'Keep formatting when you copy and paste between apps.';

  @override
  String get settings__decrypt__title => 'Clipboard Decryption';

  @override
  String settings__decrypt__count({required int count}) {
    return 'Currently you have $count encrypted clips locally.';
  }

  @override
  String settings__decrypt__progress({
    required int decrypted,
    required int total,
  }) {
    return 'Decrypted: $decrypted of $total clips.';
  }

  @override
  String get settings__decrypt__warning =>
      '⚠️ Please keep this screen open during this process to avoid data corruption or inconsistencies.';

  @override
  String get not_found__title => 'Page Not Found';

  @override
  String get not_found__subtitle =>
      'The page you are looking for is not found.';

  @override
  String get not_found__go_home => 'Go Home';

  @override
  String get backup_restore__dialog__save_as => 'Save Backup As';

  @override
  String get backup_restore__busy__creating => 'Creating backup...';

  @override
  String get backup_restore__error__encryption_unavailable =>
      'Encryption is enabled but currently unavailable. Please unlock E2EE and try again.';

  @override
  String backup_restore__snackbar__saved({required String outputPath}) {
    return 'Backup saved to $outputPath';
  }

  @override
  String backup_restore__snackbar__create_failed({required String message}) {
    return 'Backup failed: $message';
  }

  @override
  String get backup_restore__dialog__select_file => 'Select Backup File';

  @override
  String get backup_restore__dialog__restore_title => 'Restore Backup';

  @override
  String get backup_restore__dialog__restore_subtitle =>
      'Enter password if this backup is password-protected.';

  @override
  String get backup_restore__dialog__restore_action => 'Restore';

  @override
  String get backup_restore__busy__restoring => 'Restoring backup...';

  @override
  String backup_restore__snackbar__restore_completed({
    required int clips,
    required int collections,
  }) {
    return 'Restore completed: $clips clips, $collections collections.';
  }

  @override
  String backup_restore__snackbar__restore_failed({required String message}) {
    return 'Restore failed: $message';
  }

  @override
  String get backup_restore__error__select_clip_type =>
      'Select at least one clip type.';

  @override
  String get backup_restore__error__from_after_to =>
      'From date must be earlier than To date.';

  @override
  String get backup_restore__dialog__options__description =>
      'Choose what to include in this backup archive.';

  @override
  String get backup_restore__section__clip_types => 'Clip Types';

  @override
  String get backup_restore__section__cached_files => 'Cached Files';

  @override
  String get backup_restore__input__max_cached_file_size =>
      'Max cached file size (MB)';

  @override
  String get backup_restore__input__max_cached_file_size__hint =>
      'Optional, e.g. 50';

  @override
  String get backup_restore__error__positive_number =>
      'Enter a positive number.';

  @override
  String get backup_restore__text__select_file_media_for_cache_limit =>
      'Select File or Media clip types to configure a max cached file size.';

  @override
  String get backup_restore__section__date_range => 'Date Range';

  @override
  String get backup_restore__from_date => 'From date';

  @override
  String get backup_restore__to_date => 'To date';

  @override
  String get backup_restore__no_minimum_date => 'No minimum date';

  @override
  String get backup_restore__no_maximum_date => 'No maximum date';

  @override
  String get backup_restore__clear_date_filter => 'Clear date filter';

  @override
  String get backup_restore__section__security => 'Security';

  @override
  String get backup_restore__toggle__password_protect =>
      'Protect backup with password';

  @override
  String get backup_restore__input__password => 'Password';

  @override
  String get backup_restore__input__password__hint => 'At least 6 characters';

  @override
  String get backup_restore__error__password_min_length =>
      'Password must be at least 6 characters.';

  @override
  String get backup_restore__dialog__create_manual_title =>
      'Create Manual Backup';

  @override
  String get backup_restore__appbar__title => 'Backup & Restore';

  @override
  String get backup_restore__card__title => 'Manual Backup & Restore';

  @override
  String get backup_restore__card__subtitle =>
      'Create local .ccbkup archives with optional password protection and restore them locally with best-effort dedupe.';

  @override
  String get backup_restore__actions__title => 'Actions';

  @override
  String get backup_restore__button__create => 'Create Backup';

  @override
  String get backup_restore__button__restore => 'Restore Backup';

  @override
  String get backup_restore__snapshot__backup_title => 'Latest Backup Snapshot';

  @override
  String get backup_restore__snapshot__restore_title =>
      'Latest Restore Snapshot';

  @override
  String get backup_restore__snapshot__restore_subtitle =>
      'Best-effort dedupe and integrity report';

  @override
  String get backup_restore__empty_session =>
      'No backup or restore has been run in this session yet.';

  @override
  String get backup_restore__label__collections => 'Collections';

  @override
  String get backup_restore__label__clips => 'Clips';

  @override
  String get backup_restore__label__files_included => 'Files Included';

  @override
  String get backup_restore__label__files_missing => 'Files Missing';

  @override
  String get backup_restore__label__files_skipped_by_size => 'Skipped by Size';

  @override
  String get backup_restore__label__encrypted_clips => 'Encrypted Clips';

  @override
  String get backup_restore__label__collections_restored =>
      'Collections Restored';

  @override
  String get backup_restore__label__collections_duplicates =>
      'Collections Duplicates';

  @override
  String get backup_restore__label__collections_failed => 'Collections Failed';

  @override
  String get backup_restore__label__clips_restored => 'Clips Restored';

  @override
  String get backup_restore__label__clips_duplicates => 'Clips Duplicates';

  @override
  String get backup_restore__label__clips_failed => 'Clips Failed';

  @override
  String get backup_restore__label__attachments_restored =>
      'Attachments Restored';

  @override
  String get backup_restore__label__attachments_missing =>
      'Attachments Missing';

  @override
  String get backup_restore__label__attachments_failed => 'Attachments Failed';

  @override
  String get backup_restore__label__corrupt_entries => 'Corrupt Entries';

  @override
  String get subscription__loading => 'Loading...';

  @override
  String get review__dialog__title => 'Liking CopyCat so far?';

  @override
  String get review__dialog__message =>
      'A quick rating helps more people discover CopyCat and keeps new features coming.';

  @override
  String get review__dialog__never => 'Never';

  @override
  String get review__dialog__remind_later => 'Remind me in 7 days';

  @override
  String get review__dialog__rate_now => 'Give a Quick Rating';

  @override
  String get settings__tile__review__title => 'Rate CopyCat';

  @override
  String get settings__tile__review__subtitle =>
      'Leave a review on the App Store';
}
