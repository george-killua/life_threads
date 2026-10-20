// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get send => 'Enviar';

  @override
  String get preparing => 'Preparando...';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get languageTitle => 'Idioma';

  @override
  String get languageBody =>
      'Elige el idioma de la app. Sistema usa el idioma de tu teléfono si LifeThreads lo admite.';

  @override
  String get systemLanguage => 'Sistema';

  @override
  String get englishLanguage => 'English';

  @override
  String get germanLanguage => 'Deutsch';

  @override
  String get arabicLanguage => 'العربية';

  @override
  String languageSelected(Object language) {
    return 'Idioma cambiado a $language.';
  }

  @override
  String get privacyTitle => 'Privacidad';

  @override
  String get privacyBody =>
      'LifeThreads funciona en local: sin cuenta y sin perfil público. Tus recuerdos se quedan en este dispositivo, salvo que exportes una copia, compartas una cápsula cifrada o muestres tu muro en otra pantalla.';

  @override
  String get viewPrivacyPolicy => 'Ver política de privacidad';

  @override
  String get termsTitle => 'Condiciones de uso';

  @override
  String get viewTerms => 'Ver condiciones';

  @override
  String get betaFeedbackTitle => 'Comentarios de la beta';

  @override
  String get betaFeedbackBody =>
      'Envía comentarios de la beta con diagnósticos seguros. Los registros solo incluyen eventos de la app y tipos de error, nunca textos de recuerdos, rutas de fotos, copias ni ubicaciones exactas.';

  @override
  String get closedBetaBadge => 'Beta cerrada';

  @override
  String get sendFeedback => 'Enviar comentarios';

  @override
  String get backupArchiveBody =>
      'Guárdalo todo – recuerdos, fotos, notas, hilos y diseño – en un solo archivo. Guárdalo en tu ordenador o en tu propia nube, y añade una contraseña para cifrarlo.';

  @override
  String get backupArchiveTitle => 'Copia de seguridad';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Desbloquear';

  @override
  String get exportArchive => 'Exportar archivo';

  @override
  String get importArchive => 'Importar archivo';

  @override
  String get importCapsule => 'Importar cápsula';

  @override
  String get moveDevices => 'Cambiar de dispositivo';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeBody =>
      'Elige cómo quieres que se sienta tu muro privado. La versión gratis incluye Sala cálida. Premium desbloquea todos los ambientes.';

  @override
  String get oneFreeBadge => '1 gratis';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'La suscripción Premium está activa.';

  @override
  String get premiumLockedBody =>
      'Anual o mensual: recuerdos ilimitados, varios muros, historias, temas y diseños.';

  @override
  String get activeBadge => 'Activo';

  @override
  String get openPremium => 'Abrir Premium';

  @override
  String get appVersionTitle => 'Versión de la app';

  @override
  String get clearAllDataTitle => 'Borrar todos los datos';

  @override
  String get clearAllDataBody =>
      'Elimina de este dispositivo todos los recuerdos, conexiones, notas, clavos y fotos copiadas.';

  @override
  String get clearData => 'Borrar datos';

  @override
  String exportFailed(Object error) {
    return 'Error al exportar: $error';
  }

  @override
  String importRejected(Object message) {
    return 'Importación rechazada: $message';
  }

  @override
  String importFailed(Object error) {
    return 'Error al importar: $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'Error al eliminar: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'Cápsula rechazada: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'Error al importar la cápsula: $error';
  }

  @override
  String get clearAllDataQuestion => '¿Borrar todos los datos?';

  @override
  String get clearAllDataQuestionBody =>
      'Esto elimina para siempre todos los datos locales de LifeThreads en este dispositivo. Si quieres conservarlos, exporta antes una copia.';

  @override
  String get clearAll => 'Borrar todo';

  @override
  String get allLocalDataCleared => 'Se han borrado todos los datos locales.';

  @override
  String get feedbackGeneral => 'Comentario general';

  @override
  String get feedbackBug => 'Error';

  @override
  String get feedbackCrash => 'Cierre inesperado';

  @override
  String get feedbackDesign => 'Problema de diseño';

  @override
  String get feedbackMissingFeature => 'Falta una función';

  @override
  String get feedbackPerformance => 'Rendimiento';

  @override
  String get betaFeedbackIntro =>
      'Cuenta qué pasó o qué no te pareció bien. Se adjuntarán diagnósticos seguros sin contenido privado de tus recuerdos.';

  @override
  String get feedbackType => 'Tipo';

  @override
  String get feedbackLabel => 'Comentario';

  @override
  String get feedbackHint =>
      'Ejemplo: toqué Añadir > Foto rápida y la pantalla se congeló.';

  @override
  String get betaFeedbackNotIncluded =>
      'No se incluye: títulos de recuerdos, historias, notas, rutas de fotos, rutas de copias ni ubicaciones exactas.';

  @override
  String get feedbackEmpty => 'Escribe primero un comentario breve.';

  @override
  String get feedbackCopied =>
      'No se abrió ninguna app de correo. Comentario copiado al portapapeles para info@gkcoding.dev.';

  @override
  String themeSelected(Object theme) {
    return '$theme seleccionado.';
  }

  @override
  String get onboardingHeadline => 'Crea tu muro vivo.';

  @override
  String get onboardingBody =>
      'Una sala privada de recuerdos donde fotos, lugares, personas y pequeñas notas se unen con hilos emocionales.';

  @override
  String get onboardingPrivacy =>
      'Tus recuerdos son privados por defecto: sin cuenta y sin perfil público. Compartir cifrado en la nube y las copias solo ocurren si tú lo eliges.';

  @override
  String get onboardingPrivacyShort =>
      'Sin cuenta y sin perfil público. Tus recuerdos se quedan en este dispositivo, salvo que elijas otra cosa.';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingNameTitle => '¿Cómo te llamamos?';

  @override
  String get onboardingNameHint => 'Tu nombre';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'Encantados, $name.';
  }

  @override
  String get onboardingGetStartedTitle => 'Elige cómo empezar';

  @override
  String get onboardingGetStartedBody =>
      'Mira un muro de ejemplo o empieza con uno vacío y cuelga tus propios recuerdos.';

  @override
  String get settingsNameTitle => 'Tu nombre';

  @override
  String get settingsNameBody => 'Aparece como saludo en tu muro.';

  @override
  String get settingsNameHint => 'Tu nombre';

  @override
  String get settingsNameSaved => 'Nombre actualizado.';

  @override
  String get storyPrivacyTitle => 'Tus recuerdos son privados';

  @override
  String get storyConnectTitle => 'Conecta momentos';

  @override
  String get storyConnectText =>
      'Une recuerdos, notas y lugares para que cada capítulo tenga contexto.';

  @override
  String get storyWallTitle => 'Crea tu muro vivo';

  @override
  String get storyWallText =>
      'Empieza con una foto y deja que el muro crezca hasta sentirse vivo.';

  @override
  String get previewDemoWall => 'Ver muro de ejemplo';

  @override
  String get startFresh => 'Empezar de cero';

  @override
  String get optionalDemoPreview => 'Vista previa opcional';

  @override
  String get quickTutorial => 'Tutorial rápido';

  @override
  String get tutorialIntro =>
      'Primero lo básico – guardar, conectar, ordenar – y luego todo lo demás que puede hacer tu muro.';

  @override
  String get gotIt => 'Entendido';

  @override
  String get howItWorks => 'Cómo funciona';

  @override
  String get tutorialAddTitle => 'Añade un recuerdo';

  @override
  String get tutorialAddText =>
      'Toca +, elige Recuerdo o Foto rápida y guarda el título, la fecha, las personas y la foto. Si sales antes de guardar, se conserva como borrador.';

  @override
  String get tutorialConnectTitle => 'Conecta recuerdos';

  @override
  String get tutorialConnectText =>
      'Abre una tarjeta, toca el icono de conectar, elige recuerdos relacionados y añade un motivo breve.';

  @override
  String get tutorialArrangeTitle => 'Ordena el muro';

  @override
  String get tutorialArrangeText =>
      'Arrastra tarjetas, notas y clavos a su sitio. Ver › Ordenar los organiza por fecha, categoría o lugar – se aplica con Listo.';

  @override
  String get tutorialShowBoardTitle => 'Muestra el tablero';

  @override
  String get tutorialShowBoardText =>
      'Abre lifethreads.gkcoding.dev/display en otra pantalla, elige Más › Mostrar muro y escanea el código para mostrar un tablero temporal de solo lectura.';

  @override
  String get tutorialBackupTitle => 'Privacidad y copias';

  @override
  String get tutorialBackupText =>
      'Ajustes › Privacidad › Bloqueo de la app abre LifeThreads con Face ID. Antes de cambiar de teléfono, exporta una copia en Ajustes › Copias y datos.';

  @override
  String get scanDisplayQr => 'Escanear QR de pantalla';

  @override
  String get scannerHintTitle => '¿Dónde está el código QR?';

  @override
  String get addMemoryBeforeDisplay =>
      'Añade un recuerdo antes de mostrar un muro.';

  @override
  String get notLifeThreadsDisplayQr =>
      'Este no es un QR de pantalla de LifeThreads.';

  @override
  String get displayWallQuestion => '¿Mostrar este muro?';

  @override
  String displayWallBody(int memoryCount) {
    return 'LifeThreads enviará una vista temporal de solo lectura con $memoryCount recuerdos a la sesión del navegador que escaneaste. Se abre en lifethreads.gkcoding.dev/display y caduca sola.';
  }

  @override
  String get displayAction => 'Mostrar';

  @override
  String get soon => 'pronto';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'El muro se muestra con $memoryCount recuerdos hasta $expires.';
  }

  @override
  String get preparingWallDisplay => 'Preparando la pantalla del muro...';

  @override
  String get open => 'Abrir';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Guardar';

  @override
  String get done => 'Listo';

  @override
  String get back => 'Atrás';

  @override
  String get continueAction => 'Continuar';

  @override
  String get close => 'Cerrar';

  @override
  String get add => 'Añadir';

  @override
  String get saveReason => 'Guardar motivo';

  @override
  String get chooseBackup => 'Elegir copia';

  @override
  String get chooseArchive => 'Elegir archivo';

  @override
  String get chooseCapsule => 'Elegir cápsula';

  @override
  String get exportAction => 'Exportar';

  @override
  String get addToWall => 'Añadir al muro';

  @override
  String get cinemaSkip => 'Saltar';

  @override
  String get cinemaNotNow => 'Ahora no';

  @override
  String get cinemaSharedChapter => 'Un capítulo compartido';

  @override
  String get cinemaConnectedThread => 'Hilo conectado';

  @override
  String get cinemaInviteTitle => '¿Añadir este recuerdo a tu muro?';

  @override
  String get useSelected => 'Usar selección';

  @override
  String photoGridItem(String date) {
    return 'Foto del $date';
  }

  @override
  String get noPhotosFound => 'No se encontraron fotos.';

  @override
  String get manage => 'Gestionar';

  @override
  String get manageAccess => 'Gestionar acceso';

  @override
  String get saveNow => 'Guardar ya';

  @override
  String get hangOnWall => 'Colgar en el muro';

  @override
  String get placeHere => 'Colocar aquí';

  @override
  String get openSettings => 'Abrir Ajustes';

  @override
  String get viewPremium => 'Ver Premium';

  @override
  String get memoryNotFound => 'Recuerdo no encontrado';

  @override
  String get memoryTypeMoment => 'Momento';

  @override
  String get memoryTypeTrip => 'Viaje';

  @override
  String get memoryTypePerson => 'Persona';

  @override
  String get memoryTypePlace => 'Lugar';

  @override
  String get memoryTypeNote => 'Nota';

  @override
  String get memoryTypeMomentDescription =>
      'Una pequeña escena que vale la pena guardar';

  @override
  String get memoryTypeTripDescription => 'Un viaje o un día fuera';

  @override
  String get memoryTypePersonDescription => 'Alguien importante';

  @override
  String get memoryTypePlaceDescription => 'Un lugar con significado';

  @override
  String get memoryTypeNoteDescription =>
      'Un pensamiento, una cita o un recordatorio';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get categoryFamily => 'Familia';

  @override
  String get categoryTravel => 'Viajes';

  @override
  String get feelingWarm => 'Cálido';

  @override
  String get feelingNostalgic => 'Nostálgico';

  @override
  String get feelingProud => 'Orgulloso';

  @override
  String get feelingCalm => 'Tranquilo';

  @override
  String get feelingImportant => 'Importante';

  @override
  String get feelingWarmDescription => 'Suave, cercano, lleno de amor.';

  @override
  String get feelingNostalgicDescription => 'Un recuerdo que te hace volver.';

  @override
  String get feelingProudDescription => 'Un momento que demostró algo.';

  @override
  String get feelingCalmDescription => 'Silencioso, seguro, en paz.';

  @override
  String get feelingImportantDescription =>
      'Un recuerdo que cambió la historia.';

  @override
  String get addPeopleHint =>
      'Añade a las personas de este momento. Los contactos se quedan en tu dispositivo.';

  @override
  String get addPerson => 'Añadir persona';

  @override
  String get editPerson => 'Editar persona';

  @override
  String get chooseFromContacts => 'Elegir de contactos';

  @override
  String get personNameLabel => 'Nombre';

  @override
  String get personNameHint => 'Escribe para buscar personas guardadas';

  @override
  String get relationshipLabel => 'Relación';

  @override
  String get relationshipHint => 'Amiga, madre, pareja...';

  @override
  String get phoneOptionalLabel => 'Teléfono (opcional)';

  @override
  String get emailOptionalLabel => 'Correo (opcional)';

  @override
  String get nameRelationshipRequired =>
      'El nombre y la relación son obligatorios.';

  @override
  String get contactAccessDenied => 'No se concedió acceso a los contactos.';

  @override
  String get couldNotOpenContacts => 'No se pudieron abrir los contactos.';

  @override
  String get chooseContact => 'Elegir contacto';

  @override
  String get searchContacts => 'Buscar contactos';

  @override
  String get noContactsFound => 'No se encontraron contactos.';

  @override
  String get unnamedContact => 'Contacto sin nombre';

  @override
  String get contactRelationship => 'Contacto';

  @override
  String get couldNotLoadContacts => 'No se pudieron cargar los contactos.';

  @override
  String get saveMomentTitle => 'Guarda un momento';

  @override
  String get todayEyebrow => 'Hoy';

  @override
  String get addMemoryStepTitle => '¿Qué pasó que no quieres perder?';

  @override
  String get addMemoryStepSubtitle =>
      'Escribe una línea, añade una foto si la tienes y guarda. Los detalles pueden esperar.';

  @override
  String get momentLabel => 'Momento';

  @override
  String get momentHint =>
      'Cena con Lara, primer lanzamiento, paseo tranquilo...';

  @override
  String get storyWorthLabel => '¿Por qué vale la pena guardarlo?';

  @override
  String get storyWorthHint => 'Bastan unas palabras.';

  @override
  String get feelingEyebrow => 'Sentimiento';

  @override
  String get feelingStepTitle => '¿Cómo debería sentirse cuando vuelva?';

  @override
  String get feelingStepSubtitle =>
      'Así será más fácil redescubrir el recuerdo más adelante.';

  @override
  String get contextEyebrow => 'Contexto';

  @override
  String get whenWasItTitle => '¿Cuándo fue?';

  @override
  String get photoGpsStepSubtitle =>
      'El mapa usa el GPS guardado en las fotos elegidas. Si una foto no tiene GPS, no se muestra ningún lugar.';

  @override
  String get peopleThreadsEyebrow => 'Personas e hilos';

  @override
  String get peopleThreadsTitle => '¿Con quién o con qué se conecta?';

  @override
  String get peopleThreadsSubtitle =>
      'Los detalles opcionales convierten momentos sueltos en un hilo de vida.';

  @override
  String get connectExistingMemoryLabel => 'Conectar con un recuerdo existente';

  @override
  String get noConnectionYet => 'Aún sin conexión';

  @override
  String get connectionReasonLabel => '¿Por qué están conectados?';

  @override
  String get connectionReasonHint =>
      'Ejemplo: mismo viaje, misma persona, antes / después...';

  @override
  String get writeMomentOrPhotoFirst =>
      'Escribe un momento o añade una foto primero.';

  @override
  String get todaysMoment => 'El momento de hoy';

  @override
  String get savedFromTodaysPrompt => 'Guardado desde la pregunta de hoy.';

  @override
  String get saveItBeforeItFades => 'Guárdalo antes de que se borre';

  @override
  String get chooseDate => 'Elegir fecha';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get untitledMemory => 'Recuerdo sin título';

  @override
  String get organize => 'Organizar';

  @override
  String get memoryShape => 'Forma del recuerdo';

  @override
  String get wallCategory => 'Categoría del muro';

  @override
  String get privatePhotos => 'Fotos privadas';

  @override
  String get pick => 'Elegir';

  @override
  String get addMore => 'Añadir más';

  @override
  String get takePhoto => 'Hacer foto';

  @override
  String get takePhotosNow => 'Hacer fotos ahora';

  @override
  String get takePhotosFabTooltip => 'Hacer fotos para un recuerdo nuevo';

  @override
  String get takeAnotherPhoto => 'Hacer otra foto';

  @override
  String get continueWithPhotos => 'Continuar con estas fotos';

  @override
  String get addPhotosToMemory => 'Añadir al recuerdo';

  @override
  String get takeAnotherOrContinueBody =>
      'Sigue haciendo fotos para este recuerdo, o continúa y añade la historia.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos hechas',
      one: '1 foto hecha',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'LifeThreads copia las fotos elegidas en el almacenamiento privado de la app y conserva la fecha y la ubicación si están disponibles.';

  @override
  String get limitedPhotoAccessActive =>
      'El acceso limitado a fotos está activo. Puedes permitir más fotos.';

  @override
  String get selectPhotos => 'Seleccionar fotos';

  @override
  String get photoAccessOff => 'El acceso a fotos está desactivado';

  @override
  String get photoAccessOffBody =>
      'Activa el acceso a fotos para elegir recuerdos. Tus fotos se quedan en este dispositivo.';

  @override
  String get freeMemoryLimitReached => 'Límite gratuito alcanzado';

  @override
  String get freeMemoryLimitBody =>
      'Los muros gratis incluyen 30 recuerdos. Mejora tu plan para seguir creando tu muro vivo.';

  @override
  String get photoAccessNeeded => 'Primero hace falta acceso a las fotos.';

  @override
  String get quickPhotoMemory => 'Foto rápida';

  @override
  String get quickPhotoDescription =>
      'Una foto que vale la pena guardar. Añade la historia cuando quieras.';

  @override
  String get hangQuickPhoto => 'Colgar foto rápida';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'GPS de la foto detectado: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'No se detectó GPS en la foto. Este recuerdo no aparecerá en el mapa.';

  @override
  String memoryPreviewSummary(
    Object title,
    Object type,
    Object feeling,
    int photoCount,
  ) {
    return '$title • $type • $feeling • $photoCount foto(s)';
  }

  @override
  String metadataDates(int count, int total) {
    return '$count/$total fechas';
  }

  @override
  String metadataLocations(int count, int total) {
    return '$count/$total ubicaciones';
  }

  @override
  String metadataSizes(int count, int total) {
    return '$count/$total tamaños';
  }

  @override
  String newSelected(int count) {
    return '$count nuevas seleccionadas';
  }

  @override
  String selectedCount(int count) {
    return '$count seleccionadas';
  }

  @override
  String get editMemoryTitle => 'Editar recuerdo';

  @override
  String get storyPanel => 'Historia';

  @override
  String get memoryTitleLabel => 'Título del recuerdo';

  @override
  String get addTitleValidation => 'Añade un título';

  @override
  String get storyDescriptionLabel => 'Historia / descripción';

  @override
  String get addStoryValidation => 'Añade una historia breve';

  @override
  String get shapeFeelingTitle => 'Forma y sentimiento';

  @override
  String get memoryTypeLabel => 'Tipo de recuerdo';

  @override
  String get feelingLabel => 'Sentimiento';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get timePhotoGpsTitle => 'Fecha y GPS de la foto';

  @override
  String get memoryDateLabel => 'Fecha del recuerdo';

  @override
  String get peopleTitle => 'Personas';

  @override
  String get galleryTitle => 'Galería';

  @override
  String get addPhotos => 'Añadir fotos';

  @override
  String get saveMemory => 'Guardar recuerdo';

  @override
  String get memorySaveFailed =>
      'No se pudo guardar este recuerdo. Inténtalo de nuevo.';

  @override
  String get passwordOnlySpaces => 'Una contraseña no puede ser solo espacios.';

  @override
  String get somethingWentWrong => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get mapUnavailable => 'El mapa no está disponible ahora.';

  @override
  String get coverPhoto => 'Foto de portada';

  @override
  String get galleryPhoto => 'Foto de la galería';

  @override
  String get setAsCover => 'Usar como portada';

  @override
  String get replacePhoto => 'Cambiar foto';

  @override
  String get removePhoto => 'Quitar foto';

  @override
  String get choosePhoto => 'Elegir foto';

  @override
  String get threadReasonsTitle => 'Motivos del hilo';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'Crea más recuerdos antes de conectarlos.';

  @override
  String get connectionHeaderBody =>
      'Conecta recuerdos con un motivo. La cuerda debe explicar por qué dos momentos van juntos.';

  @override
  String get connectedMemory => 'recuerdo conectado';

  @override
  String get whyConnectedTitle => '¿Por qué están conectados?';

  @override
  String get exportPremiumArchiveTitle => 'Exportar copia';

  @override
  String get importArchiveTitle => 'Importar archivo';

  @override
  String get archiveExportBody =>
      'Añade una contraseña para cifrar el archivo. Déjala vacía para un zip local normal.';

  @override
  String get archiveImportBody =>
      'Si este archivo está cifrado, introduce su contraseña. Déjala vacía para copias antiguas o sin protección.';

  @override
  String get archivePasswordOptional => 'Contraseña del archivo (opcional)';

  @override
  String get archivePasswordLabel => 'Contraseña del archivo';

  @override
  String get archivePasswordWarning =>
      'Guarda la contraseña en un lugar seguro. Si la pierdes, no se puede recuperar.';

  @override
  String get sendArchiveTitle => 'Enviar archivo de LifeThreads';

  @override
  String get sendArchiveSubject => 'Archivo de recuerdos de LifeThreads';

  @override
  String get sendEncryptedArchiveText =>
      'Archivo cifrado de LifeThreads. Usa la contraseña que elegiste para importarlo en otro dispositivo.';

  @override
  String get sendArchiveText =>
      'Archivo de LifeThreads. Impórtalo en LifeThreads para abrir tu muro de recuerdos en otro dispositivo.';

  @override
  String get archiveReadyToSend =>
      'Copia lista. Guárdala en un lugar seguro, fuera de este teléfono.';

  @override
  String get archiveNotSaved =>
      'Copia no guardada. Vuelve a exportar cuando quieras.';

  @override
  String get archiveSharingUnavailable =>
      'Compartir no está disponible en este dispositivo.';

  @override
  String archiveShareFailed(Object error) {
    return 'Archivo guardado, pero no se pudo compartir: $error';
  }

  @override
  String get archiveImportedTitle => 'Archivo importado';

  @override
  String get memoriesLabel => 'Recuerdos';

  @override
  String get photosLabel => 'Fotos';

  @override
  String get wallNotesNailsLabel => 'Notas / clavos';

  @override
  String get connectionsLabel => 'Conexiones';

  @override
  String get archiveImportSummary =>
      'Tu muro actual se ha conservado. Los recuerdos importados se añadieron de forma segura.';

  @override
  String get shareEncryptedCapsuleTitle => 'Compartir cápsula cifrada';

  @override
  String get openSharedCapsuleTitle => 'Abrir cápsula compartida';

  @override
  String get exportMemoryCapsuleTitle => 'Exportar cápsula de recuerdo';

  @override
  String get importCapsuleDialogTitle => 'Importar cápsula';

  @override
  String get secureSharePasswordBody =>
      'Crea una contraseña antes de subir esta cápsula. Envía la contraseña por separado a quien la reciba.';

  @override
  String get sharedCapsulePasswordBody =>
      'Introduce la contraseña que recibiste para este recuerdo compartido.';

  @override
  String get capsuleExportBody =>
      'Añade una contraseña si quieres proteger este recuerdo antes de enviarlo. Déjala vacía para una cápsula normal.';

  @override
  String get capsuleImportBody =>
      'Si esta cápsula tiene contraseña, introdúcela. Si no, déjala vacía.';

  @override
  String get capsulePasswordLabel => 'Contraseña de la cápsula';

  @override
  String get sharedCapsulePasswordLabel =>
      'Contraseña de la cápsula compartida';

  @override
  String get capsulePasswordOptional => 'Contraseña de la cápsula (opcional)';

  @override
  String get capsulePasswordWarning =>
      'LifeThreads no puede recuperar esta contraseña después.';

  @override
  String get passwordRequiredCloudSharing =>
      'Se necesita una contraseña para compartir en la nube.';

  @override
  String get createSecureShare => 'Crear enlace seguro';

  @override
  String get previewMemory => 'Vista previa';

  @override
  String get sendCapsuleTitle => 'Compartir recuerdo de LifeThreads';

  @override
  String get sendCapsuleSubject => 'Cápsula de recuerdo de LifeThreads';

  @override
  String get sendEncryptedCapsuleText =>
      'Hola, he compartido contigo un recuerdo protegido de LifeThreads. Usa la contraseña que te envié para importarlo.';

  @override
  String get sendCapsuleText =>
      'Hola, he compartido contigo un recuerdo de LifeThreads. Importa la cápsula en LifeThreads para añadirlo a tu muro.';

  @override
  String get capsuleReadyToSend => 'Cápsula lista para enviar.';

  @override
  String get capsuleSavedLater =>
      'Cápsula guardada. Puedes compartirla más tarde.';

  @override
  String get capsuleSharingUnavailable =>
      'Cápsula guardada, pero compartir no está disponible.';

  @override
  String capsuleShareFailed(Object error) {
    return 'Cápsula guardada, pero no se pudo compartir: $error';
  }

  @override
  String get importThisMemory => '¿Importar este recuerdo?';

  @override
  String get noStoryTextIncluded => 'No incluye texto de la historia.';

  @override
  String get placeLabel => 'Lugar';

  @override
  String get notesLabel => 'Notas';

  @override
  String get capsulePasswordProtected =>
      'Esta cápsula estaba protegida con contraseña.';

  @override
  String get openingSharedMemory => 'Abriendo recuerdo compartido...';

  @override
  String get lifeThreadsMemoryTitle => 'Recuerdo de LifeThreads';

  @override
  String shareMemoryText(Object url) {
    return 'Hola, he compartido un recuerdo contigo en LifeThreads.\n\n$url';
  }

  @override
  String get shareLinkReady => 'Enlace listo.';

  @override
  String get shareLinkCreated => 'Enlace creado.';

  @override
  String get shareLinkUnavailable =>
      'Enlace creado, pero compartir no está disponible.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label El enlace caduca solo. Puedes eliminarlo ahora.';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'Error al compartir en la nube: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'Enlace del recuerdo eliminado.';

  @override
  String get creatingSecureMemoryLink => 'Creando enlace seguro...';

  @override
  String get shareMemoryCapsule => 'Compartir cápsula';

  @override
  String get editStory => 'Editar historia';

  @override
  String get metaType => 'Tipo';

  @override
  String get metaFeeling => 'Sentimiento';

  @override
  String get metaCategory => 'Categoría';

  @override
  String get metaDate => 'Fecha';

  @override
  String get storyEyebrow => 'Historia';

  @override
  String get whyMemoryMatters => 'Por qué importa este recuerdo';

  @override
  String get galleryEyebrow => 'Galería';

  @override
  String editSectionTooltip(String section) {
    return 'Editar $section';
  }

  @override
  String get openInMaps => 'Abrir en Mapas';

  @override
  String get memoryChangesSaved => 'Cambios guardados.';

  @override
  String get memoryDeletedToast => 'Recuerdo eliminado.';

  @override
  String get noteDeletedToast => 'Nota eliminada.';

  @override
  String get nailDeletedToast => 'Clavo quitado.';

  @override
  String get undo => 'Deshacer';

  @override
  String photoPlaceDetected(String place) {
    return 'Lugar de la foto: $place';
  }

  @override
  String get settingsGroupYou => 'Tú';

  @override
  String get settingsGroupReminders => 'Recordatorios';

  @override
  String get settingsGroupMore => 'Más';

  @override
  String get backupDataTitle => 'Copias y datos';

  @override
  String get backupDataSubtitle => 'Copia, restaura, pasa a un teléfono nuevo';

  @override
  String get aboutHelpTitle => 'Información y ayuda';

  @override
  String get aboutHelpSubtitle => 'Comentarios, privacidad, música, versión';

  @override
  String get discardChangesTitle => '¿Descartar cambios?';

  @override
  String get discardChangesBody => 'Lo que cambiaste aquí se perderá.';

  @override
  String get discardChanges => 'Descartar';

  @override
  String get keepEditing => 'Seguir editando';

  @override
  String get settingsGroupPrivacy => 'Privacidad';

  @override
  String get appLockTitle => 'Bloqueo de la app';

  @override
  String get appLockSubtitle => 'Face ID o código para abrir LifeThreads';

  @override
  String get appLockReason => 'Desbloquea tus recuerdos';

  @override
  String get appLockLockedTitle => 'LifeThreads está bloqueado';

  @override
  String get appLockUnlock => 'Desbloquear';

  @override
  String get appLockUnavailable =>
      'Configura primero Face ID o un código en este teléfono.';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Te espera un recuerdo de hace $years años.',
      one: 'Te espera un recuerdo de hace 1 año.',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'Buscar';

  @override
  String get searchHint => 'Título, lugar, persona o año';

  @override
  String get searchClear => 'Borrar búsqueda';

  @override
  String get searchNoResults => 'Ningún recuerdo coincide.';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recuerdos',
      one: '1 recuerdo',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => 'Buscar recuerdos';

  @override
  String get premiumFeatureWalls => 'Más muros';

  @override
  String get newWall => 'Nuevo muro';

  @override
  String get wallNameLabel => 'Nombre del muro';

  @override
  String get newWallHint => 'p. ej., Viajes 2025';

  @override
  String get createWall => 'Crear';

  @override
  String get renameWall => 'Cambiar nombre';

  @override
  String get deleteWall => 'Eliminar muro';

  @override
  String deleteWallQuestion(String name) {
    return '¿Eliminar «$name»?';
  }

  @override
  String get deleteWallBody =>
      'Sus recuerdos pasan a Mi muro; no se pierde nada.';

  @override
  String get personalWallSubtitle => 'Tu muro, en este dispositivo';

  @override
  String get wallOptions => 'Opciones del muro';

  @override
  String get moveToWall => 'Mover a muro…';

  @override
  String movedToWall(String name) {
    return 'Movido a $name.';
  }

  @override
  String get hideMemory => 'Ocultar';

  @override
  String get unhideMemory => 'Mostrar de nuevo';

  @override
  String get memoryHiddenToast =>
      'Oculto. Lo encontrarás en Ver › Recuerdos ocultos.';

  @override
  String get showHiddenMemories => 'Recuerdos ocultos';

  @override
  String get showHiddenReason => 'Mostrar recuerdos ocultos';

  @override
  String get yearThreadFirstTitle => 'Tu primer Hilo del año';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de 3 recuerdos',
      one: '1 de 3 recuerdos',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => 'O crea una historia ahora';

  @override
  String get moveMemoriesHere => 'Mover recuerdos aquí';

  @override
  String get moveMemoriesTitle => 'Elige los recuerdos que quieres mover aquí';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mover $count recuerdos',
      one: 'Mover 1 recuerdo',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => 'Mostrar todo';

  @override
  String get addAMemory => 'Añadir un recuerdo';

  @override
  String get mapAddPhotoMemory => 'Añade una foto con su lugar';

  @override
  String get searchSuggestions => 'Prueba con uno tuyo';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Esta semana, hace $years años',
      one: 'Esta semana, hace 1 año',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => '¿Quién estaba?';

  @override
  String get premiumPlanYearly => 'Anual';

  @override
  String get premiumPlanMonthly => 'Mensual';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/año';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Ahorra un $percent %';
  }

  @override
  String purchasesHandledYearly(String store) {
    return 'El pago se carga en tu cuenta de $store. La suscripción se renueva automáticamente cada año, salvo que la canceles al menos 24 horas antes de que termine el periodo actual. Gestiónala o cancélala en los ajustes de tu cuenta de $store.';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos guardadas',
      one: '1 foto guardada',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => 'Personas';

  @override
  String get partOfMemory => 'Parte de este recuerdo';

  @override
  String get notesEyebrow => 'Notas';

  @override
  String get attachedThoughts => 'Pensamientos añadidos';

  @override
  String get stickyNote => 'Nota adhesiva';

  @override
  String get placeEyebrow => 'Lugar';

  @override
  String get threadsEyebrow => 'Hilos';

  @override
  String get connectedMemories => 'Recuerdos conectados';

  @override
  String get noConnectedMemoriesYet =>
      'Aún no hay recuerdos conectados. Conecta este capítulo con otro momento para empezar un hilo de vida visible.';

  @override
  String get backToWall => 'Volver al muro';

  @override
  String get addTextToWall => 'Añadir texto al muro';

  @override
  String get addTextAction => 'Añadir texto';

  @override
  String get textNoteHint =>
      'Escribe un pequeño recuerdo, una cita o una nota...';

  @override
  String get placeTextNote => 'Colocar nota';

  @override
  String get placeRopeAnchor => 'Colocar anclaje';

  @override
  String get nailSubtitle =>
      'Un clavo puede unir cuerdas a mano entre recuerdos.';

  @override
  String get clearDemoWallQuestion => '¿Borrar muro de ejemplo?';

  @override
  String get clearDemoWallBody =>
      'Esto quita los recuerdos de ejemplo para que empieces con un muro privado vacío.';

  @override
  String get importBackupQuestion => '¿Importar copia?';

  @override
  String get importBackupBody =>
      'Esto restaura recuerdos de un archivo de LifeThreads y conserva tu muro actual.';

  @override
  String get deleteMemoryQuestion => '¿Eliminar recuerdo?';

  @override
  String get deleteMemoryBody =>
      'Esto elimina el recuerdo y todos sus enlaces en el muro.';

  @override
  String get editText => 'Editar texto';

  @override
  String get editTextTitle => 'Editar texto';

  @override
  String get connectRope => 'Conectar cuerda';

  @override
  String get connectRopeSubtitle => 'Une este clavo a recuerdos.';

  @override
  String get deleteNail => 'Eliminar clavo';

  @override
  String get connectNailTitle => 'Conectar clavo a recuerdos';

  @override
  String get connectNailSubtitle =>
      'Los recuerdos elegidos colgarán de este anclaje.';

  @override
  String get timelineTitle => 'Cronología';

  @override
  String get timelineSubtitle => 'Tus recuerdos ordenados por fecha.';

  @override
  String get noMemoriesFilter => 'No hay recuerdos con este filtro';

  @override
  String get noMemoriesFilterBody =>
      'Cambia el filtro o añade un recuerdo para crear la cronología.';

  @override
  String get memoryMapTitle => 'Mapa de recuerdos';

  @override
  String get memoryMapSubtitle => 'Tus recuerdos agrupados por lugar.';

  @override
  String get noMappedMemories => 'Aún no hay recuerdos en el mapa';

  @override
  String get displayWallTooltip => 'Mostrar muro';

  @override
  String get tutorialTooltip => 'Tutorial';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get freeformLayout => 'Libre';

  @override
  String get categoryLayout => 'Categoría';

  @override
  String get locationLayout => 'Lugar';

  @override
  String get saveToday => 'Guardar hoy';

  @override
  String get rememberThis => 'Recuerda esto';

  @override
  String get whatHappenedToday => '¿Qué pasó hoy?';

  @override
  String get tapToOpenDrag => 'Toca para abrir • arrastra para mover';

  @override
  String get demoWallPreview =>
      'Muro de ejemplo. Bórralo cuando quieras empezar de cero.';

  @override
  String get clearDemo => 'Borrar ejemplo';

  @override
  String get chooseQuickPhoto => 'Elegir foto rápida';

  @override
  String get wallView => 'Muro';

  @override
  String get timelineView => 'Cronología';

  @override
  String get mapView => 'Mapa';

  @override
  String get wallFilterAll => 'Todo';

  @override
  String get wallViewButton => 'Ver';

  @override
  String get wallShowAs => 'Mostrar como';

  @override
  String get wallArrange => 'Ordenar';

  @override
  String get wallShowOnly => 'Mostrar';

  @override
  String get layoutByDate => 'Por fecha';

  @override
  String get moreActionsTooltip => 'Más';

  @override
  String get addToWallTitle => 'Añadir a tu muro';

  @override
  String get expandableMemory => 'Recuerdo';

  @override
  String get expandableMemorySubtitle => 'Historia guiada completa';

  @override
  String get expandableQuickPhoto => 'Foto rápida';

  @override
  String get expandableQuickPhotoSubtitle => 'Elige una foto y cuélgala';

  @override
  String get expandableTextNote => 'Nota de texto';

  @override
  String get expandableTextNoteSubtitle => 'Una idea en el muro';

  @override
  String get expandableNail => 'Clavo / anclaje';

  @override
  String get expandableNailSubtitle => 'Punto manual para cuerdas';

  @override
  String get startWithOneThing => 'Empieza con algo de hoy';

  @override
  String get emptyWallBody =>
      'Guarda un momento antes de que se borre. Basta una frase o una foto.';

  @override
  String get usePhoto => 'Usar una foto';

  @override
  String get editMemoryTooltip => 'Editar recuerdo';

  @override
  String get connectMemoryTooltip => 'Conectar recuerdo';

  @override
  String get archiveTransferTitle => 'Abrir en otro dispositivo';

  @override
  String get archiveTransferHeroTitle =>
      'Lleva tus recuerdos a otro dispositivo de forma segura.';

  @override
  String get archiveTransferHeroBody =>
      'Una copia es un zip con tus recuerdos, fotos, notas, hilos, posiciones en el muro y metadatos, opcionalmente con contraseña. No guardamos ninguna copia: tú decides dónde va.';

  @override
  String get archiveTransferStep1Title => 'Exporta un archivo';

  @override
  String get archiveTransferStep1Body =>
      'Abre Ajustes, elige Exportar archivo y añade una contraseña si quieres protegerlo.';

  @override
  String get archiveTransferStep2Title => 'Mueve el zip';

  @override
  String get archiveTransferStep2Body =>
      'Pásalo por AirDrop, USB, tu propia nube o correo.';

  @override
  String get archiveTransferStep3Title => 'Importa con seguridad';

  @override
  String get archiveTransferStep3Body =>
      'Instala LifeThreads en el otro dispositivo, elige Importar archivo, introduce la contraseña si hace falta y restaura sin borrar datos existentes.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled =>
      'Desbloqueo Premium de desarrollo activado.';

  @override
  String get lifetimeActive => 'Suscripción activa';

  @override
  String get oneTimeLifetimeUnlock => 'Anual o mensual';

  @override
  String get premiumHeroActiveTitle => 'Tu muro de recuerdos no tiene límites.';

  @override
  String get premiumHeroLockedTitle => 'Convierte tus recuerdos en historias.';

  @override
  String get premiumHeroActiveBody =>
      'Tu suscripción Premium está activa. Historias con música, Hilo del año, muros familiares y recuerdos ilimitados son tuyos.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'La versión gratis incluye $limit recuerdos y copias completas. Premium añade historias y películas con música, Hilo del año, muros familiares y recuerdos ilimitados.';
  }

  @override
  String get premiumMemories => 'Recuerdos Premium';

  @override
  String get freeMemories => 'Recuerdos gratis';

  @override
  String get unlimited => 'ilimitados';

  @override
  String get benefitUnlimitedTitle => 'Recuerdos ilimitados';

  @override
  String get benefitUnlimitedBody =>
      'Sin el límite de 30 recuerdos. Sigue creando el muro mientras la vida crece.';

  @override
  String get benefitThemesTitle => 'Temas Premium';

  @override
  String get benefitThemesBody =>
      'Desbloquea ambientes más ricos, temas de temporada y Auto según la hora del día.';

  @override
  String get benefitLayoutsTitle => 'Diseños avanzados';

  @override
  String get benefitLayoutsBody =>
      'Más formas de ordenar hilos, cronologías, anclajes y grupos de recuerdos.';

  @override
  String get lifetimeUnlock => 'Suscripción Premium';

  @override
  String get premiumActiveOnDevice =>
      'Premium está activo en este dispositivo.';

  @override
  String onePurchaseBody(String store) {
    return 'Suscríbete anual o mensualmente para tener historias con música, Hilo del año, muros familiares y recuerdos ilimitados. Cancela cuando quieras en los ajustes de $store.';
  }

  @override
  String get premiumActiveButton => 'Premium activo';

  @override
  String get processing => 'Procesando...';

  @override
  String get unlockPremium => 'Suscribirse a Premium';

  @override
  String get restorePurchase => 'Restaurar suscripción';

  @override
  String get enableDebugMockUnlock => 'Activar desbloqueo de prueba';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'El pago se carga en tu cuenta de $store. La suscripción se renueva automáticamente cada mes, salvo que la canceles al menos 24 horas antes de que termine el periodo actual. Gestiónala o cancélala en los ajustes de tu cuenta de $store.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'La tienda no se pudo actualizar. Inténtalo de nuevo.';

  @override
  String get premiumMessageStoreUnavailable =>
      'Las compras no están disponibles en este dispositivo.';

  @override
  String get premiumMessageProductUnavailable =>
      'Premium aún no está disponible en la tienda. Inténtalo más tarde.';

  @override
  String get premiumMessageLoadFailed =>
      'No se pudo cargar Premium desde la tienda. Inténtalo de nuevo.';

  @override
  String get premiumMessageOpeningCheckout => 'Abriendo el pago…';

  @override
  String get premiumMessageCheckoutFailed =>
      'No se pudo abrir el pago. Inténtalo de nuevo.';

  @override
  String get premiumMessageChecking => 'Comprobando tu suscripción…';

  @override
  String get premiumMessageRestoreFailed =>
      'No se pudo restaurar. Inténtalo de nuevo.';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'No se encontró ninguna suscripción Premium activa.';

  @override
  String get premiumMessagePending =>
      'Tu compra está pendiente. Premium se desbloquea cuando se apruebe.';

  @override
  String get premiumMessagePurchaseFailed =>
      'La compra no se completó. Inténtalo de nuevo.';

  @override
  String get premiumMessageCanceled => 'Compra cancelada.';

  @override
  String get premiumMessageRestored =>
      'Tu suscripción Premium se ha restaurado.';

  @override
  String get premiumMessageActive => 'Tu suscripción Premium está activa.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/mes';
  }

  @override
  String get loadingPlayStoreProduct => 'Cargando la suscripción…';

  @override
  String get playStoreUnavailable => 'La tienda no está disponible ahora';

  @override
  String get productNotConfigured => 'Premium no está disponible ahora';

  @override
  String get purchasePending => 'Compra pendiente';

  @override
  String get purchased => 'Comprado';

  @override
  String get restored => 'Restaurado';

  @override
  String get premiumTryAgain => 'Reintentar';

  @override
  String get purchaseFailed => 'Compra fallida';

  @override
  String get preparingCheckout => 'Preparando el pago...';

  @override
  String get premiumLocalFirstTitle => 'Premium también es local';

  @override
  String get premiumLocalFirstBody =>
      'Tus recuerdos se quedan en tu dispositivo, y las copias son gratis para todos.';

  @override
  String get noMappedMemoriesBody =>
      'Añade fotos con datos GPS para ver recuerdos aquí.';

  @override
  String get peopleLabel => 'Personas';

  @override
  String get connect => 'Conectar';

  @override
  String get themeWarmMemoryRoom => 'Sala cálida';

  @override
  String get themeWarmMemoryRoomDescription =>
      'Calidez oscura y suave, luz dorada y la intimidad de una sala privada.';

  @override
  String get themeMidnightArchive => 'Archivo de medianoche';

  @override
  String get themeMidnightArchiveDescription =>
      'Sala de archivo azul profundo con la calma de un museo.';

  @override
  String get themeSoftPaperWall => 'Papel suave';

  @override
  String get themeSoftPaperWallDescription =>
      'Papel crema, sombras de tinta y la calma de un álbum de recortes.';

  @override
  String get themeTravelCorkboard => 'Corcho de viaje';

  @override
  String get themeTravelCorkboardDescription =>
      'La calidez del corcho con toques de mapa para viajes y lugares.';

  @override
  String get themeAutoTitle => 'Auto según la hora';

  @override
  String get themeAutoDescription =>
      'Papel suave de día, Sala cálida por la tarde, Archivo de medianoche por la noche.';

  @override
  String get themeAutoSelected => 'Tu muro ahora sigue la hora del día.';

  @override
  String get themeSeasonalTitle => 'De temporada';

  @override
  String get themeSeasonalBody =>
      'Temas Premium limitados, cada uno disponible solo en su temporada.';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Hasta el $dateString';
  }

  @override
  String get themeUseButton => 'Usar este tema';

  @override
  String get themeInUse => 'En uso';

  @override
  String get themeUnlockButton => 'Desbloquear con Premium';

  @override
  String get themeAutumnHarvest => 'Cosecha de otoño';

  @override
  String get themeAutumnHarvestDescription =>
      'Luz ámbar, tarjetas de papel kraft y el brillo de las hojas que caen.';

  @override
  String get themeWinterLights => 'Luces de invierno';

  @override
  String get themeWinterLightsDescription =>
      'Tarjetas escarchadas y guirnaldas cálidas en una fría noche azul.';

  @override
  String get themeSpringBlossom => 'Flor de primavera';

  @override
  String get themeSpringBlossomDescription =>
      'Tarjetas de flores pálidas con un suave brillo rosa.';

  @override
  String get themeSummerEvening => 'Tarde de verano';

  @override
  String get themeSummerEveningDescription =>
      'Colores de atardecer y tarjetas de foto instantánea.';

  @override
  String get themeYearRoundTitle => 'Siempre disponibles';

  @override
  String get themeComingTitle => 'Próximamente';

  @override
  String get themeComingBody =>
      'Mira las próximas temporadas. Cada tema se abre el primer día de su temporada.';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Desde el $dateString';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ver todos los temas, $count de esta temporada',
      one: 'Ver todos los temas, 1 de esta temporada',
      zero: 'Ver todos los temas',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => 'Junto al mar';

  @override
  String get themeSeasideDescription =>
      'Agua turquesa, papel arena y cálida luz de verano.';

  @override
  String get themeSnowyCabin => 'Cabaña nevada';

  @override
  String get themeSnowyCabinDescription =>
      'Madera junto al fuego, tarjetas escarchadas y nieve suave fuera.';

  @override
  String get themeSpringMeadow => 'Prado de primavera';

  @override
  String get themeSpringMeadowDescription =>
      'Hierba verde, tarjetas claras y sol amarillo.';

  @override
  String get themeMistyForest => 'Bosque de niebla';

  @override
  String get themeMistyForestDescription =>
      'Pinos tranquilos, niebla matinal y hojas doradas.';

  @override
  String get demoFirstDanceTitle => 'Nuestro primer baile';

  @override
  String get demoFirstDanceStory =>
      'La banda tocó nuestra canción y todo el granero se quedó en silencio. Te pisé dos veces, te reíste todo el rato y durante tres minutos no había nadie más.';

  @override
  String get demoFirstDancePlace => 'Salzburgo';

  @override
  String get demoNewbornTitle => 'Bienvenida a casa, Lina';

  @override
  String get demoNewbornStory =>
      'Su manita entera cabía alrededor de un dedo. La primera mañana tranquila en casa.';

  @override
  String get demoNewbornPlace => 'Viena';

  @override
  String get demoBeachSunsetTitle => 'Verano junto al mar';

  @override
  String get demoBeachSunsetStory =>
      'Descalzos hasta la puesta de sol, Lina dormida sobre tus hombros a la vuelta.';

  @override
  String get demoBeachSunsetPlace => 'Split, Croacia';

  @override
  String get demoGrandmaKitchenTitle => 'La cocina de la abuela';

  @override
  String get demoGrandmaKitchenStory =>
      'Su tarta de albaricoque, por fin escrita – y harina por todas partes.';

  @override
  String get demoGrandmaKitchenPlace => 'Graz';

  @override
  String get demoGraduationTitle => 'Día de la graduación';

  @override
  String get demoGraduationStory =>
      'Papá lloró antes de que cayeran los birretes.';

  @override
  String get demoGraduationPlace => 'Innsbruck';

  @override
  String get demoFirstHomeTitle => 'Las llaves de nuestra primera casa';

  @override
  String get demoFirstHomeStory =>
      'Aún sin muebles, solo cajas, pizza en el suelo y muchos planes.';

  @override
  String get demoFirstHomePlace => 'Linz';

  @override
  String get demoAlpineSummitTitle => 'Por encima de las nubes';

  @override
  String get demoAlpineSummitStory =>
      'En pie a las 4 de la mañana para esto. Valió cada paso.';

  @override
  String get demoAlpineSummitPlace => 'Grossglockner';

  @override
  String get demoFirstBikeTitle => 'Primera vuelta, sin manos';

  @override
  String get demoFirstBikeStory =>
      'Tres pedaladas, un tambaleo y se fue – y qué orgulloso.';

  @override
  String get demoFirstBikePlace => 'Prater, Viena';

  @override
  String get demoGardenDinnerTitle => 'Los 80 del abuelo';

  @override
  String get demoGardenDinnerStory =>
      'Cuatro generaciones en una mesa larga, y él seguía contando las mejores historias.';

  @override
  String get demoGardenDinnerPlace => 'Wachau';

  @override
  String get demoThreadFirstDanceToFirstHome => 'Nuestra historia';

  @override
  String get demoThreadFirstHomeToNewborn => 'Luego llegó Lina';

  @override
  String get demoThreadNewbornToBeachSunset => 'Su primer verano';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'Familia';

  @override
  String get demoThreadGraduationToFirstHome => 'Nuevo capítulo';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'Pequeñas aventuras';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'El abuelo miraba';

  @override
  String get demoRelationGrandpa => 'Abuelo';

  @override
  String get demoRelationGrandma => 'Abuela';

  @override
  String get demoRelationDaughter => 'Hija';

  @override
  String get demoRelationWife => 'Esposa';

  @override
  String get demoRelationBestMan => 'Padrino';

  @override
  String get demoRelationMother => 'Madre';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Guardado en $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recuerdos aún no están en una copia.',
      one: '1 recuerdo aún no está en una copia.',
    );
    return '$_temp0';
  }

  @override
  String get later => 'Más tarde';

  @override
  String get backUp => 'Hacer copia';

  @override
  String get onThisDayTitle => 'Un día como hoy';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Hoy hace $years años',
      one: 'Hoy hace 1 año',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'hace $years años',
      one: 'hace 1 año',
    );
    return 'Un día como hoy · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'Los días en que vuelve un recuerdo de un año anterior, LifeThreads te envía un aviso discreto.';

  @override
  String get onThisDayReminderSwitch => 'Recordatorio diario';

  @override
  String onThisDayReminderAt(String time) {
    return 'A las $time';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'Las notificaciones de LifeThreads están desactivadas. Actívalas en los ajustes del teléfono.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Hoy hace $years años: $title',
      one: 'Hoy hace 1 año: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recuerdos más',
      one: '1 recuerdo más',
    );
    return '$title y $_temp0 de este día';
  }

  @override
  String get onThisDayChannelDescription =>
      'Un recuerdo de este día en un año anterior.';

  @override
  String get benefitOnThisDayBody =>
      'Un aviso cuando vuelve un recuerdo de un año anterior, abierto como su propio capítulo.';

  @override
  String get premiumFeatureStoryImage => 'Imágenes de historia';

  @override
  String get premiumFeatureStoryVideo => 'Vídeos de historia';

  @override
  String get premiumFeatureThreadOfTheYear => 'Hilo del año';

  @override
  String get premiumFeatureFamilyWall => 'Muro familiar';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature es parte de Premium.';
  }

  @override
  String get yearThreadTitle => 'Hilo del año';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recuerdos',
      one: '1 recuerdo',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lugares',
      one: '1 lugar',
    );
    return '$_temp0';
  }

  @override
  String yearThreadPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personas',
      one: '1 persona',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '1 mes',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'Lo más sentido: $feeling';
  }

  @override
  String get yearThreadClosingLine => 'Un año, hilado.';

  @override
  String get yearThreadMyYear => 'Mi año';

  @override
  String get yearThreadWallCardTitle => 'Tu año en recuerdos';

  @override
  String yearThreadWallCardBody(String year) {
    return 'Convierte $year en una película corta.';
  }

  @override
  String get yearThreadDismiss => 'Ahora no';

  @override
  String get yearThreadSettingsBody =>
      'Convierte cualquier año con al menos 3 recuerdos en una película corta, en orden y unida por el hilo.';

  @override
  String get yearThreadOpen => 'Crear la película';

  @override
  String get yearThreadNoYears =>
      'El Hilo del año necesita un año con al menos 3 recuerdos. Sigue guardando momentos y vuelve.';

  @override
  String get yearThreadYear => 'Año';

  @override
  String get yearThreadLength => 'Duración';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'Película · $seconds s';
  }

  @override
  String get yearThreadLengthStory => 'Historia · 20 s';

  @override
  String get yearThreadMusic => 'Música';

  @override
  String get yearThreadNoMusic => 'Sin música';

  @override
  String get yearThreadInFilm => 'En la película';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count de $max';
  }

  @override
  String get yearThreadAddMemory => 'Añadir un recuerdo';

  @override
  String get yearThreadSwap => 'Cambiar';

  @override
  String get yearThreadRemove => 'Quitar';

  @override
  String get yearThreadUseSuggestions => 'Usar sugerencias';

  @override
  String yearThreadPickTitle(String year) {
    return 'Elige un recuerdo de $year';
  }

  @override
  String get yearThreadNoOthers =>
      'Todos los recuerdos de este año ya están en la película.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recuerdos',
      one: '1 recuerdo',
    );
    return 'Elige al menos $_temp0.';
  }

  @override
  String get yearThreadPreview => 'Vista previa';

  @override
  String get yearThreadExportVideo => 'Exportar vídeo';

  @override
  String get yearThreadExportImage => 'Exportar imagen';

  @override
  String get yearThreadShare => 'Compartir';

  @override
  String get yearThreadSave => 'Guardar en Fotos';

  @override
  String get yearThreadMakingFilm => 'Creando tu película…';

  @override
  String get yearThreadMakingImage => 'Creando tu imagen…';

  @override
  String get yearThreadFilmReady => 'Tu película está lista';

  @override
  String get yearThreadImageReady => 'Tu imagen está lista';

  @override
  String get yearThreadSaved => 'Guardado en tus fotos.';

  @override
  String get yearThreadExportFailed => 'No ha funcionado. Inténtalo de nuevo.';

  @override
  String get yearThreadPlay => 'Reproducir';

  @override
  String get yearThreadPause => 'Pausa';

  @override
  String get createStory => 'Crear historia';

  @override
  String get storyPickTitle => 'Elige recuerdos';

  @override
  String storyPickBody(int max) {
    return 'Elige hasta $max recuerdos para una historia.';
  }

  @override
  String storyPickCount(int count, int max) {
    return '$count de $max elegidos';
  }

  @override
  String storyPickLimit(int max) {
    return 'Una historia admite hasta $max recuerdos.';
  }

  @override
  String get storyPickContinue => 'Continuar';

  @override
  String get storyNoMemories =>
      'Guarda primero un recuerdo y luego conviértelo en historia.';

  @override
  String get storyEditorTitle => 'Tu historia';

  @override
  String get storyChangeMemories => 'Cambiar recuerdos';

  @override
  String get storyTemplateSingle => 'Un recuerdo';

  @override
  String get storyTemplateThread => 'Muro con hilo';

  @override
  String get storyTemplateCollage => 'Collage';

  @override
  String get storyTemplateQuote => 'Palabras';

  @override
  String get storySwipeHint => 'Desliza para ver otra versión';

  @override
  String get storyCaptionLabel => 'Texto';

  @override
  String get storyCaptionHint => 'Una línea de tu historia';

  @override
  String get storyVideoSwitch => 'Vídeo';

  @override
  String get storyVideoBody =>
      'Una película corta para Stories y Reels, con movimiento y música.';

  @override
  String get storyMusicTitle => 'Música';

  @override
  String get storyMusicNone => 'Sin música';

  @override
  String get storyMusicNoneHint =>
      'También puedes añadir música en Instagram al publicar.';

  @override
  String get storyMoodWarm => 'Cálida';

  @override
  String get storyMoodJoyful => 'Alegre';

  @override
  String get storyMoodCalm => 'Tranquila';

  @override
  String get storyMoodNostalgic => 'Nostálgica';

  @override
  String get storyMoodEpic => 'Épica';

  @override
  String get storyMoodEmotional => 'Emotiva';

  @override
  String get storyMusicTrimHint =>
      'Arrastra el recuadro dorado para elegir la parte de la canción';

  @override
  String get storySearchHint => 'Busca recuerdos, lugares, años';

  @override
  String storySearchEmpty(String query) {
    return 'Ningún recuerdo coincide con «$query».';
  }

  @override
  String get storyMemoriesInStory => 'En tu historia';

  @override
  String get storyMemoriesReorderHint =>
      'Mantén pulsado y arrastra para cambiar el orden';

  @override
  String get storyAddMemory => 'Añadir';

  @override
  String get storyAddMemoryTitle => 'Añadir un recuerdo';

  @override
  String storyRemoveMemory(String title) {
    return 'Quitar $title de la historia';
  }

  @override
  String get storyAllMemoriesAdded =>
      'Todos los recuerdos ya están en esta historia.';

  @override
  String get storyShare => 'Compartir';

  @override
  String get storySaveToPhotos => 'Guardar en Fotos';

  @override
  String get storySaved => 'Guardado en tus fotos.';

  @override
  String get storySaveDenied =>
      'LifeThreads no puede añadir a tus fotos. Permítelo en los ajustes del teléfono.';

  @override
  String storyExportFailed(String error) {
    return 'No se pudo crear la historia: $error';
  }

  @override
  String get storyRenderingTitle => 'Creando tu película';

  @override
  String get storyRenderingBody =>
      'Mantén LifeThreads abierto, tarda unos segundos.';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent %';
  }

  @override
  String get storyPreviewFree =>
      'La vista previa es gratis. Compartir y guardar historias es parte de Premium.';

  @override
  String get benefitStoriesTitle => 'Crear historia';

  @override
  String get benefitStoriesBody =>
      'Convierte recuerdos en imágenes de historia y películas cortas con música para Instagram, WhatsApp y más.';

  @override
  String get musicCreditsTitle => 'Créditos musicales';

  @override
  String get musicCreditsBody =>
      'Canciones incluidas para los vídeos de historia, con sus licencias.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'Tu año como película corta: los momentos importantes, en orden y con música.';

  @override
  String get benefitFamilyTitle => 'Muros familiares';

  @override
  String get benefitFamilyBody =>
      'Un muro compartido para tu familia, con cifrado de extremo a extremo. Cada uno añade sus momentos.';

  @override
  String get myWall => 'Mi muro';

  @override
  String get myWallSubtitle => 'Privado, en este dispositivo';

  @override
  String get switchWall => 'Cambiar de muro';

  @override
  String get familyWallsTitle => 'Muros familiares';

  @override
  String get familyWallsSettingsBody =>
      'Comparte un muro con familia o amigos: todos añaden recuerdos, con cifrado de extremo a extremo. Mi muro sigue siendo privado en este dispositivo.';

  @override
  String get familyWallsOpen => 'Abrir muros familiares';

  @override
  String get familyWallsManage => 'Gestionar muros familiares';

  @override
  String get familyWallsHeadline => 'Un muro, toda la familia';

  @override
  String get familyWallsIntro =>
      'Un muro familiar se comparte con las personas que invitas. Los recuerdos y las fotos se cifran en tu teléfono antes de subirse; solo los miembros pueden abrirlos. Mi muro no se comparte y se queda en este dispositivo.';

  @override
  String get familyUnavailableTitle => 'Aún no disponible';

  @override
  String get familyUnavailable =>
      'Los muros familiares aún no están disponibles en esta versión de LifeThreads.';

  @override
  String get familySignInNeededTitle =>
      'Inicia sesión para usar muros familiares';

  @override
  String get familySignInNeededBody =>
      'Un muro compartido necesita una cuenta para que la familia sepa quién añadió qué. Mi muro funciona sin ella.';

  @override
  String get familySignIn => 'Iniciar sesión';

  @override
  String get familyLoadFailed => 'No se pudo cargar';

  @override
  String get familyRetry => 'Reintentar';

  @override
  String get familyNoWallsYet =>
      'Aún no hay muros familiares. Crea uno o únete con un enlace de invitación.';

  @override
  String get familyStartTitle => 'Crear o unirse';

  @override
  String get familyStartBody =>
      'Crear un muro familiar requiere Premium. Unirse es gratis: el Premium del creador cubre a la familia.';

  @override
  String get familyCreateAction => 'Crear muro familiar';

  @override
  String get familyCreateTitle => 'Nuevo muro familiar';

  @override
  String get familyNameLabel => 'Nombre del muro';

  @override
  String get familyNameHint => 'p. ej., Los García';

  @override
  String get familyMyNameLabel => 'Tu nombre en este muro';

  @override
  String get familyMyNameHelper =>
      'Los miembros lo ven en tus recuerdos. Está cifrado como todo en el muro.';

  @override
  String get familyMyNameSaved => 'Nombre guardado.';

  @override
  String get familySetMyName => 'Mi nombre';

  @override
  String get familyCheckingSubscription => 'Comprobando tu Premium…';

  @override
  String get familyCreating => 'Creando el muro…';

  @override
  String get familyJoinWithLink => 'Unirse con enlace';

  @override
  String get familyInviteLinkLabel => 'Enlace de invitación';

  @override
  String get familyJoinTitle => '¿Unirte a este muro familiar?';

  @override
  String get familyJoinBody =>
      'Los miembros verán tu nombre y los recuerdos que añadas, y tú verás los suyos. Puedes salir cuando quieras.';

  @override
  String get familyJoinAction => 'Unirse';

  @override
  String get familyJoining => 'Uniéndote…';

  @override
  String familyJoined(String family) {
    return 'Te has unido a $family.';
  }

  @override
  String get familyRoleOwner => 'Creador';

  @override
  String get familyRoleMember => 'Miembro';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'Ajustes del muro';

  @override
  String familyStorageUsed(String used, String total) {
    return '$used de $total usados';
  }

  @override
  String get familyRename => 'Cambiar nombre';

  @override
  String get familyInviteTitle => 'Invitar';

  @override
  String get familyInviteBody =>
      'Envía un enlace a alguien de confianza. Cada enlace funciona una vez y caduca a los 7 días.';

  @override
  String get familyInviteAction => 'Crear enlace de invitación';

  @override
  String get familyCreatingInvite => 'Creando la invitación…';

  @override
  String get familyInviteReady => 'Enlace de invitación listo';

  @override
  String get familyInviteValidity =>
      'Funciona una vez y caduca como máximo a los 7 días.';

  @override
  String get familyInviteKeyWarning =>
      'El enlace lleva la clave del muro: quien lo abra puede unirse y leer el muro. Envíalo solo a la persona que invitas.';

  @override
  String get familyInviteShare => 'Compartir enlace';

  @override
  String get familyInviteCopy => 'Copiar enlace';

  @override
  String get familyInviteCopied => 'Enlace copiado.';

  @override
  String get familyInviteShareFailed =>
      'Compartir no está disponible. Copia el enlace.';

  @override
  String familyInviteSubject(String family) {
    return 'Únete a $family en LifeThreads';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'Únete a nuestro muro familiar «$family» en LifeThreads: $link';
  }

  @override
  String get familyMembersTitle => 'Miembros';

  @override
  String get familyMemberActions => 'Acciones del miembro';

  @override
  String get familyYou => 'Tú';

  @override
  String familyYouNamed(String name) {
    return '$name (tú)';
  }

  @override
  String get familyAMember => 'Un miembro';

  @override
  String get familyFormerMember => 'Antiguo miembro';

  @override
  String get familyBlocked => 'Bloqueado';

  @override
  String get familyBlock => 'Bloquear';

  @override
  String get familyUnblock => 'Desbloquear';

  @override
  String familyBlockAuthor(String name) {
    return 'Bloquear a $name';
  }

  @override
  String familyBlockQuestion(String name) {
    return '¿Bloquear a $name?';
  }

  @override
  String get familyBlockBody =>
      'Dejarás de ver sus recuerdos en todos los muros familiares. No se le avisa. Puedes desbloquear en la lista de miembros.';

  @override
  String get familyReport => 'Denunciar';

  @override
  String get familyRemoveMember => 'Quitar del muro';

  @override
  String familyRemoveQuestion(String name) {
    return '¿Quitar a $name?';
  }

  @override
  String get familyRemoveBody =>
      'Perderá el acceso a este muro. Invítale de nuevo para que vuelva.';

  @override
  String get familyRemoveDeleteContent =>
      'Eliminar también los recuerdos que añadió';

  @override
  String get familyDeleteTitle => 'Eliminar muro familiar';

  @override
  String get familyDeleteBody =>
      'Como creador no puedes salir del muro; puedes eliminarlo para todos.';

  @override
  String get familyDeleteAction => 'Eliminar muro';

  @override
  String familyDeleteQuestion(String family) {
    return '¿Eliminar $family?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'Todos los recuerdos y fotos de este muro se eliminan de nuestros servidores para todos los miembros. No se puede deshacer. Los recuerdos de Mi muro no se ven afectados.';

  @override
  String get familyDeleting => 'Eliminando…';

  @override
  String get familyLeaveTitle => 'Salir del muro familiar';

  @override
  String get familyLeaveBody =>
      'Dejarás de ver este muro. Puedes conservar o eliminar los recuerdos que añadiste.';

  @override
  String get familyLeaveAction => 'Salir';

  @override
  String familyLeaveQuestion(String family) {
    return '¿Salir de $family?';
  }

  @override
  String get familyLeaveConfirmBody =>
      'Para volver necesitas una nueva invitación.';

  @override
  String get familyLeaveDeleteMine =>
      'Eliminar también los recuerdos que añadí';

  @override
  String get familyLeaving => 'Saliendo…';

  @override
  String get familySignInTitle => 'Iniciar sesión';

  @override
  String get familySignInHeadline => 'Una cuenta para muros familiares';

  @override
  String get familySignInWhy =>
      'Un muro familiar es compartido, así que necesita una cuenta: los miembros ven quién añadió cada recuerdo y solo los miembros pueden abrir el muro.';

  @override
  String get familySignInMyWallStays =>
      'Mi muro no necesita cuenta. Sigue siendo privado en este dispositivo y nunca se sube.';

  @override
  String get familySignInEncrypted =>
      'Los recuerdos y fotos familiares tienen cifrado de extremo a extremo. GK Coding los guarda, pero no puede leerlos.';

  @override
  String get familySignInWhatWeGet =>
      'De Apple o Google solo usamos un ID de cuenta, no tus contactos ni tus fotos.';

  @override
  String get familySignInApple => 'Iniciar sesión con Apple';

  @override
  String get familySignInGoogle => 'Iniciar sesión con Google';

  @override
  String get familySignInFinePrint =>
      'Al iniciar sesión aceptas las Condiciones de uso y la Política de privacidad. Puedes eliminar tu cuenta en la app cuando quieras.';

  @override
  String get familyAccountTitle => 'Cuenta';

  @override
  String get familySignedOutTitle => 'Sesión no iniciada';

  @override
  String get familySignedOutBody =>
      'Inicia sesión para ver tus muros familiares. Mi muro funciona sin cuenta.';

  @override
  String get familySignedInTitle => 'Sesión iniciada';

  @override
  String get familySignedInBody =>
      'Tu cuenta solo se usa para los muros familiares.';

  @override
  String familyAccountId(String id) {
    return 'ID de cuenta: $id';
  }

  @override
  String get familySignOut => 'Cerrar sesión';

  @override
  String get familySignOutQuestion => '¿Cerrar sesión?';

  @override
  String get familySignOutBody =>
      'Los muros familiares y sus claves se quitan de este dispositivo hasta que vuelvas a iniciar sesión. No se elimina nada del servidor. Mi muro no se ve afectado.';

  @override
  String get familySigningOut => 'Cerrando sesión…';

  @override
  String get familyDeleteAccountTitle => 'Eliminar cuenta';

  @override
  String get familyDeleteAccountBody =>
      'Elimina tu cuenta y los datos de tus muros familiares de nuestros servidores. Mi muro se queda en este dispositivo.';

  @override
  String get familyDeleteAccount => 'Eliminar cuenta';

  @override
  String get familyDeleteAccountQuestion => '¿Eliminar tu cuenta?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Los $count muros familiares que creaste se eliminan para todos sus miembros, con todos sus recuerdos y fotos.',
      one:
          'El muro familiar que creaste se elimina para todos sus miembros, con todos sus recuerdos y fotos.',
      zero: 'No eres creador de ningún muro familiar.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'Los recuerdos y fotos que añadiste a muros de otras familias se eliminan, y sales de esos muros.';

  @override
  String get familyDeleteAccountKeys =>
      'Las claves de los muros familiares y las fotos guardadas se quitan de este dispositivo. No se puede deshacer.';

  @override
  String get familyDeleteAccountMyWall =>
      'Mi muro no se ve afectado: sus recuerdos se quedan en este dispositivo.';

  @override
  String get familyDeleteAccountSubscription =>
      'Esto no cancela una suscripción Premium; gestiónala en el App Store o en Google Play.';

  @override
  String get familyDeleteAccountUnderstood =>
      'Entiendo que esto elimina mi cuenta para siempre.';

  @override
  String get familyDeletingAccount => 'Eliminando tu cuenta…';

  @override
  String get familyAccountDeleted => 'Tu cuenta se ha eliminado.';

  @override
  String get familyTermsTitle => 'Normas del muro familiar';

  @override
  String get familyTermsHeadline => 'Antes de compartir';

  @override
  String get familyTermsIntro =>
      'Los muros familiares son para las personas que invitas. Para que sean seguros, todos aceptan estas normas:';

  @override
  String get familyTermsZeroTolerance =>
      'Tolerancia cero con el contenido inapropiado: nada de acoso, odio, contenido sexual, violencia, autolesiones, contenido ilegal ni información privada de otros sin su consentimiento.';

  @override
  String get familyTermsOwnContent =>
      'Comparte solo fotos e historias que tengas derecho a compartir.';

  @override
  String get familyTermsReport =>
      'Denuncia cualquier recuerdo o miembro desde el muro. GK Coding revisa las denuncias en 24 horas.';

  @override
  String get familyTermsBlock =>
      'Bloquea a un miembro para dejar de ver sus recuerdos.';

  @override
  String get familyTermsOwner =>
      'El creador de un muro puede quitar miembros y sus recuerdos.';

  @override
  String get familyTermsConsequences =>
      'El contenido que incumple estas normas se elimina, y las cuentas que lo publicaron pueden suspenderse o eliminarse.';

  @override
  String get familyTermsReadFull => 'Leer las condiciones completas';

  @override
  String get familyTermsAgree =>
      'Acepto las Condiciones de uso y estas normas.';

  @override
  String get familyTermsAccept => 'Aceptar y continuar';

  @override
  String familyTermsVersion(String version) {
    return 'Versión de las condiciones $version';
  }

  @override
  String get familyWallEmptyTitle => 'El muro te espera';

  @override
  String get familyWallEmptyBody =>
      'Añade el primer recuerdo. Todos en este muro lo verán.';

  @override
  String get familyWallGoneBody =>
      'Este muro familiar ya no está disponible para ti. Puede que se haya eliminado o que te hayan quitado.';

  @override
  String get familyAddMemory => 'Añadir recuerdo';

  @override
  String get familyRefresh => 'Actualizar';

  @override
  String get familySyncing => 'Sincronizando…';

  @override
  String get familyOffline => 'Sin conexión: se muestran recuerdos guardados';

  @override
  String get familySyncFailed => 'Error de sincronización';

  @override
  String get familyMemoryTitle => 'Recuerdo';

  @override
  String get familyMemoryGone => 'Este recuerdo ya no está en el muro.';

  @override
  String get familyMemoryActions => 'Acciones del recuerdo';

  @override
  String familyAddedBy(String name) {
    return 'Añadido por $name';
  }

  @override
  String get familyDeleteMemoryQuestion => '¿Eliminar este recuerdo?';

  @override
  String get familyDeleteMemoryBody =>
      'Se quita del muro para todos, con sus fotos.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'Como creador puedes quitar recuerdos de este muro. Este recuerdo de $name se quita para todos, con sus fotos.';
  }

  @override
  String get familyDeletingMemory => 'Eliminando el recuerdo…';

  @override
  String get familyNoPhotosYet => 'Aún no hay fotos';

  @override
  String get familyPostNote =>
      'Todos en este muro verán este recuerdo. Las fotos se reducen y se cifran en tu teléfono antes de subirse.';

  @override
  String get familyPost => 'Publicar';

  @override
  String get familyPostMemory => 'Publicar en el muro';

  @override
  String get familyUploading => 'Cifrando y subiendo…';

  @override
  String get familyMemorySaved => 'Guardado en el muro familiar.';

  @override
  String get familyConflictTitle => 'Cambiado por otra persona';

  @override
  String get familyConflictBody =>
      'Este recuerdo cambió en otro dispositivo mientras lo editabas. ¿Cargar la última versión y guardar tus cambios encima?';

  @override
  String get familyConflictRetry => 'Actualizar y guardar';

  @override
  String get familyQuotaTitle => 'El muro está lleno';

  @override
  String get familyReportMemoryTitle => 'Denunciar recuerdo';

  @override
  String get familyReportPhotoTitle => 'Denunciar foto';

  @override
  String get familyReportMemberTitle => 'Denunciar miembro';

  @override
  String get familyReportIntro =>
      'Cuéntanos qué pasa. Tu denuncia va a GK Coding, no a la persona denunciada.';

  @override
  String get familyReportSpam => 'Spam o estafa';

  @override
  String get familyReportHarassment => 'Acoso';

  @override
  String get familyReportHate => 'Discurso de odio';

  @override
  String get familyReportSexual => 'Contenido sexual o desnudos';

  @override
  String get familyReportViolence => 'Violencia o amenazas';

  @override
  String get familyReportSelfHarm => 'Autolesiones o suicidio';

  @override
  String get familyReportIllegal => 'Contenido ilegal';

  @override
  String get familyReportPrivacy =>
      'Información privada compartida sin permiso';

  @override
  String get familyReportOther => 'Otra cosa';

  @override
  String get familyReportDetailsLabel => 'Detalles (opcional)';

  @override
  String get familyReportDetailsHint => '¿Qué deberíamos saber?';

  @override
  String familyReportAlsoBlock(String name) {
    return 'Bloquear también a $name';
  }

  @override
  String get familyReportSend => 'Enviar denuncia';

  @override
  String get familyReportReviewNote =>
      'GK Coding revisa cada denuncia en 24 horas y elimina el contenido y los miembros que incumplen las normas.';

  @override
  String get familyReportSentTitle => 'Gracias';

  @override
  String get familyReportSentBody =>
      'Tu denuncia se ha enviado. GK Coding la revisa en 24 horas y actúa contra el contenido que incumple las normas.';

  @override
  String get familyErrorGeneric => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get familyErrorOffline =>
      'Parece que no tienes conexión. Compruébala e inténtalo de nuevo.';

  @override
  String get familyErrorSubscriptionRequired =>
      'Esto requiere una suscripción Premium activa del creador del muro.';

  @override
  String get familyErrorInviteExpired =>
      'Esta invitación ha caducado. Pide un enlace nuevo.';

  @override
  String get familyErrorInviteUsed =>
      'Esta invitación ya se usó. Cada enlace funciona una vez; pide uno nuevo.';

  @override
  String get familyErrorInviteInvalid =>
      'Este no es un enlace de invitación válido de LifeThreads.';

  @override
  String get familyErrorAlreadyMember =>
      'Ya eres miembro de este muro familiar.';

  @override
  String get familyErrorFamilyFull =>
      'Este muro familiar ha llegado a su límite de miembros.';

  @override
  String get familyErrorQuotaExceeded =>
      'Este muro familiar no tiene espacio. Elimina algunos recuerdos o fotos para liberar espacio.';

  @override
  String get familyErrorVersionConflict =>
      'Alguien cambió este recuerdo antes. Actualiza e inténtalo de nuevo.';

  @override
  String get familyErrorTermsRequired =>
      'Acepta primero las normas del muro familiar.';

  @override
  String get familyErrorSignedOut =>
      'Se cerró tu sesión. Vuelve a iniciar sesión.';

  @override
  String get familyErrorNotAllowed =>
      'No tienes permiso para hacer esto en este muro.';

  @override
  String get familyErrorNotFound => 'Muro familiar no encontrado';

  @override
  String get familyErrorOwnerCannotLeave =>
      'El creador no puede salir del muro, pero puede eliminarlo.';

  @override
  String get familyPaste => 'Pegar';

  @override
  String get familyErrorInviteRevoked =>
      'Esta invitación se retiró. Pide un enlace nuevo.';

  @override
  String get familyErrorKeyMissing =>
      'Este dispositivo no tiene la clave de este muro familiar (por ejemplo, tras reinstalar o en un teléfono nuevo). Pide a un miembro un nuevo enlace de invitación: al abrirlo recuperas el acceso.';

  @override
  String get familyErrorSignInUnavailable =>
      'Iniciar sesión no está disponible ahora en este dispositivo.';

  @override
  String get familyErrorNoPurchase =>
      'No se encontró ninguna compra de Premium en esta cuenta de App Store o Google Play. Consigue Premium primero e inténtalo de nuevo.';

  @override
  String get familyErrorVerificationUnavailable =>
      'No se pudo comprobar tu Premium ahora. Inténtalo más tarde.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'Esta compra de Premium ya está vinculada a otra cuenta de muro familiar. Inicia sesión con esa cuenta o escribe a info@gkcoding.dev.';

  @override
  String get familyErrorNameTooLong =>
      'Ese nombre es demasiado largo. Usa uno más corto.';

  @override
  String get familyErrorContentNotAllowed =>
      'Esto contiene palabras no permitidas en los muros familiares. Cambia el texto e inténtalo de nuevo.';

  @override
  String get familyErrorPhotoUnreadable =>
      'No se pudo leer una de las fotos. Quítala e inténtalo de nuevo.';

  @override
  String get familyErrorTooLarge =>
      'Es demasiado grande para subirlo. Prueba con menos fotos o más pequeñas.';

  @override
  String get familyReportEvidenceNote =>
      'Para revisarla, GK Coding recibe el título y la historia de este recuerdo con tu denuncia. Sus fotos nunca se envían.';

  @override
  String get moveLeft => 'Mover a la izquierda';

  @override
  String get moveUp => 'Mover arriba';

  @override
  String get moveDown => 'Mover abajo';

  @override
  String get moveRight => 'Mover a la derecha';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get removePerson => 'Quitar persona';

  @override
  String get draftKept =>
      'Guardado como borrador – estará aquí la próxima vez.';

  @override
  String get draftResumeTitle => '¿Seguir donde lo dejaste?';

  @override
  String draftResumeBody(String date) {
    return 'Empezaste un recuerdo el $date y aún no lo has guardado.';
  }

  @override
  String draftResumePhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos',
      one: '1 foto',
    );
    return '$_temp0';
  }

  @override
  String get draftContinue => 'Seguir borrador';

  @override
  String get draftStartNew => 'Empezar de nuevo';

  @override
  String get lookBackMenu => 'Repasar un mes';

  @override
  String lookBackTitle(String month) {
    return 'Tu $month';
  }

  @override
  String get lookBackWallCardTitle => 'Tu mes en recuerdos';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recuerdos',
      one: '1 recuerdo',
    );
    return '$month: $_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recuerdos',
      one: '1 recuerdo',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personas',
      one: '1 persona',
    );
    return '$_temp0';
  }

  @override
  String lookBackPlaces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lugares',
      one: '1 lugar',
    );
    return '$_temp0';
  }

  @override
  String get lookBackPeopleHeading => 'Quién estaba';

  @override
  String get lookBackPlacesHeading => 'Dónde estuviste';

  @override
  String lookBackEmpty(String month) {
    return 'Aún no hay nada guardado de $month.';
  }

  @override
  String get lookBackEmptyHint =>
      'Aquí aparecen los recuerdos con fecha de este mes.';

  @override
  String get lookBackPreviousMonth => 'Mes anterior';

  @override
  String get lookBackNextMonth => 'Mes siguiente';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recuerdos',
      one: '1 recuerdo',
    );
    return '$month: $_temp0 para repasar.';
  }

  @override
  String get lookBackNotificationPrivate => 'Tu mes en recuerdos está listo.';

  @override
  String get homeWidgetLocked => 'Abre LifeThreads para ver tus recuerdos.';

  @override
  String get homeWidgetSettingsTitle => 'Widget de inicio';

  @override
  String get homeWidgetSettingsSubtitle => 'Qué recuerdos muestra';

  @override
  String get homeWidgetPreviewTitle => 'Hoy en tu widget';

  @override
  String get homeWidgetSourceTitle => 'Qué recuerdos';

  @override
  String get homeWidgetAllWalls => 'Todos mis muros';

  @override
  String get homeWidgetOrderTitle => 'Primero se muestran';

  @override
  String get homeWidgetOnThisDayFirst => 'Primero, un día como hoy';

  @override
  String get homeWidgetOnThisDayFirstBody =>
      'Primero va un recuerdo de este día en un año anterior.';

  @override
  String get homeWidgetPhotosFirst => 'Primero, recuerdos con fotos';

  @override
  String get homeWidgetPhotosFirstBody =>
      'Los demás solo si ninguno tiene foto.';

  @override
  String get homeWidgetHowToTitle => 'Añádelo a tu pantalla de inicio';

  @override
  String get homeWidgetHowToIos =>
      'Mantén pulsado el icono de LifeThreads en la pantalla de inicio y elige un tamaño de widget. O mantén pulsado un espacio vacío, toca Editar › Añadir widget y elige LifeThreads.';

  @override
  String get homeWidgetHowToAndroid =>
      'Mantén pulsado un espacio vacío en la pantalla de inicio, toca Widgets y arrastra LifeThreads donde quieras.';

  @override
  String get homeWidgetPrivacyNote =>
      'Los recuerdos ocultos nunca aparecen en el widget. Con el bloqueo de la app activo, no muestra ningún recuerdo.';

  @override
  String get yearThreadAlmostThere => 'Ya casi';

  @override
  String get yearThreadMemoriesFrom => 'Recuerdos de';

  @override
  String yearThreadAddMemoryTo(String year) {
    return 'Añade un recuerdo a $year';
  }

  @override
  String get onboardingHangTitle => 'Cuelga tus recuerdos';

  @override
  String get onboardingHangText =>
      'Una foto, un lugar, las personas que estaban – tu muro crece con tu vida.';

  @override
  String get onboardingConnectTitle => 'Únelos con hilos';

  @override
  String get onboardingConnectText =>
      'Di por qué dos momentos van juntos. Los hilos muestran cómo encaja tu historia.';

  @override
  String get onboardingComeBackTitle => 'Los recuerdos vuelven a ti';

  @override
  String get onboardingComeBackText =>
      'Un día como hoy, tu mes en repaso, tu año como película – y un widget en tu pantalla de inicio.';

  @override
  String get onboardingPrivateText =>
      'Sin cuenta. Todo se queda en tu teléfono – con Face ID si quieres.';

  @override
  String get onboardingNameStaysHere =>
      'Solo para saludarte – se queda en este teléfono.';

  @override
  String get tutorialLookBackTitle => 'Busca y repasa';

  @override
  String get tutorialLookBackText =>
      'Busca por título, lugar, persona o año. Más › Repasar un mes muestra los recuerdos de un mes; Más › Hilo del año convierte un año en película.';

  @override
  String get tutorialStoryTitle => 'Crea una historia';

  @override
  String get tutorialStoryText =>
      'Más › Crear historia: elige recuerdos, una plantilla y música, y compártela como imagen o vídeo.';

  @override
  String get tutorialWallsTitle => 'Muros y recuerdos ocultos';

  @override
  String get tutorialWallsText =>
      'Más › Nuevo muro separa viajes o etapas (Premium). Mantén pulsada una tarjeta › Ocultar la quita de la vista; Ver › Recuerdos ocultos la muestra tras Face ID.';

  @override
  String get tutorialFamilyTitle => 'Comparte con tu familia';

  @override
  String get tutorialFamilyText =>
      'Más › Muros familiares: un muro para toda la familia, con cifrado de extremo a extremo. Invita a otros con un enlace.';

  @override
  String get tutorialWidgetTitle => 'Un recuerdo en tu pantalla de inicio';

  @override
  String get tutorialWidgetText =>
      'Añade el widget de LifeThreads: un recuerdo distinto cada día. Ajustes › Widget de inicio elige cuáles.';

  @override
  String photoNumber(int number) {
    return 'Foto $number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      'No se pudo guardar tu nombre en este muro. Puedes ponerlo en los ajustes del muro.';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Contiene $count recuerdos.',
      one: 'Contiene 1 recuerdo.',
    );
    return '$_temp0 Los recuerdos que ya están en tus muros se conservan y no se duplican.';
  }

  @override
  String get importAction => 'Importar';

  @override
  String get familyRemovingMember => 'Quitando y protegiendo el muro…';

  @override
  String get tourSkip => 'Saltar';

  @override
  String get tourNext => 'Siguiente';

  @override
  String get tourDone => 'Listo';

  @override
  String get tourTapIt => 'Tócalo';

  @override
  String get tourEnd => 'Terminar tour';

  @override
  String get tourShowMeHow => 'Enséñame cómo';

  @override
  String get tourShowMeHowSubtitle => 'Un tour corto con recuerdos de ejemplo';

  @override
  String get tourWelcomeTitle => 'Bienvenido a tu muro';

  @override
  String get tourWelcomeBody =>
      'Recorramos LifeThreads juntos con recuerdos y fotos de ejemplo. Sigue el anillo dorado. Al final decides si los conservas.';

  @override
  String get tourCardTitle => 'Cada tarjeta es un recuerdo';

  @override
  String get tourCardBody =>
      'Fotos, una historia, el lugar y cómo se sintió. Arrastra tarjetas para ordenarlas y pellizca para hacer zoom. Toca esta para abrirla.';

  @override
  String get tourConnectTitle => 'Conecta recuerdos';

  @override
  String get tourConnectBody =>
      'Los hilos unen momentos: un viaje con una persona, un lugar con un sentimiento. Toca Conectar.';

  @override
  String get tourConnectionsTitle => 'Elige lo que va junto';

  @override
  String get tourConnectionsBody =>
      'Elige otros recuerdos y escribe por qué van juntos. El hilo cuelga entonces entre las tarjetas de tu muro.';

  @override
  String get tourAddTitle => 'Guarda un momento nuevo';

  @override
  String get tourAddBody => 'Toca + para añadir algo a tu muro.';

  @override
  String get tourAddMemoryTitle => 'Un recuerdo';

  @override
  String get tourAddMemoryBody =>
      'Elige Recuerdo. También puedes fijar una nota o un clavo para agrupar tarjetas.';

  @override
  String get tourAddTextTitle => 'Bastan unas palabras';

  @override
  String get tourAddTextBody =>
      'Te hemos puesto una foto de ejemplo y un título. Normalmente eliges tus fotos o haces una. La fecha y el lugar salen de la foto.';

  @override
  String get tourSaveTitle => 'Cuélgalo en el muro';

  @override
  String get tourSaveBody =>
      'Toca Guardar ya. Sentimientos, personas e hilos pueden venir después.';

  @override
  String get tourCameraTitle => 'Foto rápida';

  @override
  String get tourCameraBody =>
      'La cámara guarda un momento al instante. Las palabras las añades después.';

  @override
  String get tourViewTitle => 'Distintas vistas';

  @override
  String get tourViewBody => 'Toca Ver.';

  @override
  String get tourViewModesTitle => 'Muro, cronología, mapa';

  @override
  String get tourViewModesBody =>
      'Mira tu vida como muro, cronología o en un mapa. Filtra por categoría aquí y muestra recuerdos ocultos (con Face ID).';

  @override
  String get tourViewDoneTitle => 'Volver al muro';

  @override
  String get tourViewDoneBody => 'Toca Listo.';

  @override
  String get tourSearchTitle => 'Encuentra cualquier recuerdo';

  @override
  String get tourSearchBody =>
      'Escribe aquí un nombre, lugar, persona o año. Los resultados aparecen mientras escribes.';

  @override
  String get tourMoreTitle => 'Todo lo demás';

  @override
  String get tourMoreBody =>
      'Historias, tu año, repasar, más muros y ajustes están en este menú. Tócalo.';

  @override
  String get tourStoryTitle => 'Crea una historia';

  @override
  String get tourStoryBody => 'Toca Crear historia.';

  @override
  String get tourYearTitle => 'Hilo del año';

  @override
  String get tourYearBody =>
      'Tu año como película corta con música: tus recuerdos en orden y luego los lugares, personas y sentimientos del año (Premium).';

  @override
  String get tourLookBackTitle => 'Repasar un mes';

  @override
  String get tourLookBackBody =>
      'Cada mes en recuerdos, con sus personas y lugares. Un día como hoy te recuerda años anteriores (Premium).';

  @override
  String get tourWallsTitle => 'Más muros';

  @override
  String get tourWallsBody =>
      'Un muro para cada hijo, viaje o proyecto (Premium). Toca el nombre de arriba para cambiar de muro.';

  @override
  String get tourFamilyTitle => 'Muros familiares';

  @override
  String get tourFamilyBody =>
      'Un muro compartido donde todos añaden sus momentos, con cifrado de extremo a extremo. Solo quien lo crea necesita Premium; la familia se une gratis.';

  @override
  String get tourSettingsTitle => 'Ajustes';

  @override
  String get tourSettingsBody =>
      'Haz copia de todo gratis, bloquea la app con Face ID, configura el widget y Un día como hoy, y elige tu idioma.';

  @override
  String get tourFinishTitle => '¡Eso es todo!';

  @override
  String get tourFinishBody => 'Ya sabes moverte. Ahora haz tuyo el muro.';

  @override
  String get tourDemoPhotoTitle => 'Un día en el lago';

  @override
  String get tourRemoveDemoTitle => '¿Empezar tu propio muro?';

  @override
  String get tourRemoveDemoBody =>
      'El tour usó recuerdos y fotos de ejemplo. ¿Quitarlos ahora y empezar con tus propias fotos?';

  @override
  String get tourRemoveDemoRemove => 'Quitar y empezar';

  @override
  String get tourRemoveDemoKeep => 'Conservarlos por ahora';

  @override
  String get tourRemovedToast =>
      'Recuerdos de ejemplo quitados. Tu muro está listo.';

  @override
  String get storyTemplatePolaroid => 'Polaroid';

  @override
  String get storyTemplateAlbum => 'Álbum';

  @override
  String get storyTemplateFilmstrip => 'Tira de película';

  @override
  String get storyTemplateTimeline => 'Viaje en el tiempo';

  @override
  String get storyTemplatePostcard => 'Postal';

  @override
  String get storyTemplateCinema => 'Cine';

  @override
  String get storyTemplateSingleHint =>
      'Cada recuerdo a pantalla completa, uno tras otro';

  @override
  String get storyTemplateThreadHint =>
      'Tarjetas en el muro, unidas por el hilo';

  @override
  String get storyTemplateCollageHint =>
      'Todas las fotos juntas en una cuadrícula';

  @override
  String get storyTemplateQuoteHint => 'Tus palabras se escriben solas';

  @override
  String get storyTemplatePolaroidHint =>
      'Fotos instantáneas caen en un montón';

  @override
  String get storyTemplateAlbumHint => 'Las páginas pasan, una foto por página';

  @override
  String get storyTemplateFilmstripHint => 'Una película pasa y hace zoom';

  @override
  String get storyTemplateTimelineHint =>
      'Los años avanzan hasta cada recuerdo';

  @override
  String get storyTemplatePostcardHint =>
      'Cada postal se gira y muestra su historia';

  @override
  String get storyTemplateCinemaHint => 'Rótulos, zoom lento y créditos';

  @override
  String get storyAnimationTitle => 'Animación';

  @override
  String get storyAnimationPageTitle => 'Elige una animación';

  @override
  String get storyAnimationExamples =>
      'Con fotos de ejemplo. Tu historia usa tus recuerdos.';

  @override
  String get storyMusicPageTitle => 'Música y duración';

  @override
  String get storyLengthTitle => 'Duración';

  @override
  String get storyLengthAuto => 'Auto';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds s';
  }

  @override
  String get storyMusicAll => 'Todas';

  @override
  String get storyMusicPlay => 'Reproducir';

  @override
  String get storyMusicPause => 'Pausa';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return 'Canción $song ▸ Vídeo $video';
  }

  @override
  String get storyMusicSyncHint =>
      'La línea blanca muestra qué segundo de la canción suena con el vídeo. Las marcas indican dónde empieza cada recuerdo.';

  @override
  String get storyMusicLengthHint =>
      'Auto se ajusta al número de recuerdos. Las películas más largas van más despacio.';

  @override
  String get tourBack => 'Atrás';

  @override
  String get tourStoryPickTitle => 'Elige recuerdos';

  @override
  String get tourStoryPickBody =>
      'Elegimos tres por ti. Puedes elegir hasta seis. Toca Continuar.';

  @override
  String get tourStoryAnimationTitle => 'Elige cómo se mueve';

  @override
  String get tourStoryAnimationBody =>
      'Animaciones de Polaroid a Cine. Toca Animación.';

  @override
  String get tourStoryStyleTitle => 'Prueba Polaroid';

  @override
  String get tourStoryStyleBody =>
      'Cada miniatura muestra una vista previa. Toca Polaroid.';

  @override
  String get tourStoryMusicTitle => 'Añade música';

  @override
  String get tourStoryMusicBody =>
      'Elige una canción y cuánto dura el vídeo. Toca Música.';

  @override
  String get tourStoryTrimTitle => 'Canción y vídeo sincronizados';

  @override
  String get tourStoryTrimBody =>
      'Arrastra el recuadro dorado para elegir la parte de la canción. La línea blanca avanza con el vídeo, así ves qué segundo suena en cada momento.';

  @override
  String get tourStoryMusicDoneTitle => 'Vuelve a tu historia';

  @override
  String get tourStoryMusicDoneBody => 'Toca Listo.';

  @override
  String get tourStoryShareTitle => 'Comparte o guarda';

  @override
  String get tourStoryShareBody =>
      'Lista para Instagram, WhatsApp y más. Guardar y compartir es parte de Premium.';

  @override
  String get tourMoreAgainTitle => 'Más en el menú';

  @override
  String get tourMoreAgainBody => 'Abre el menú otra vez. Tócalo.';

  @override
  String get scannerStep1 =>
      'En una tele, un ordenador o una tablet, abre el navegador.';

  @override
  String scannerStep2(Object url) {
    return 'Ve a $url. Allí aparece un código QR.';
  }

  @override
  String get scannerStep3 =>
      'Sujeta el teléfono para que el código quede dentro del marco dorado. Tu muro se mostrará allí un rato, solo para ver.';

  @override
  String get scannerShareLink => 'Enviar enlace';

  @override
  String get scannerCopyLink => 'Copiar enlace';

  @override
  String get scannerLinkCopied => 'Enlace copiado';

  @override
  String get storyTemplateScrapbook => 'Álbum de recortes';

  @override
  String get storyTemplateMosaic => 'Mosaico';

  @override
  String get storyTemplateContactSheet => 'Hoja de contactos';

  @override
  String get storyTemplateWallFlight => 'Vuelo por el muro';

  @override
  String get storyTemplateCarousel => 'Carrusel';

  @override
  String get storyTemplateJourney => 'Ruta';

  @override
  String get storyTemplateScrapbookHint =>
      'Cada foto pegada con cinta en una página';

  @override
  String get storyTemplateMosaicHint => 'Una foto grande y las demás alrededor';

  @override
  String get storyTemplateContactSheetHint =>
      'Cada recuerdo, un fotograma de película';

  @override
  String get storyTemplateWallFlightHint =>
      'Vuela por el hilo de tarjeta en tarjeta';

  @override
  String get storyTemplateCarouselHint =>
      'Las tarjetas giran, una al frente cada vez';

  @override
  String get storyTemplateJourneyHint =>
      'Una ruta por el mapa, con un pin en cada lugar';

  @override
  String get storyModePicture => 'Imagen';

  @override
  String get storyModeVideo => 'Vídeo';

  @override
  String get storyModePictureHint =>
      'Una imagen con todos tus recuerdos, para posts e historias.';

  @override
  String get storyModeVideoHint =>
      'Una película corta con movimiento y música.';

  @override
  String get storyLayoutTitle => 'Diseño';

  @override
  String get storyLayoutPageTitle => 'Elige un diseño';

  @override
  String get storyChoosePhoto => 'Elige la foto para la historia';

  @override
  String get wallTidyUp => 'Ordenar el muro';

  @override
  String get wallTidyUpBody =>
      '¿Colgar todas las tarjetas ordenadas en filas, del recuerdo más antiguo al más reciente? Las notas y los clavos se quedan donde están.';

  @override
  String get wallTidyUpAction => 'Ordenar';

  @override
  String get wallTidiedToast => 'Tu muro está ordenado.';

  @override
  String get storyFormatTitle => 'Formato';

  @override
  String get storyFormatStory => 'Historia 9:16';

  @override
  String get storyFormatPost => 'Publicación 4:5';

  @override
  String get storyFormatSquare => 'Cuadrado 1:1';
}
