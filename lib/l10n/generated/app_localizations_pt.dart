// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'LifeThreads';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

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
      'Escolha o idioma do app. Sistema segue o idioma do seu celular, se o LifeThreads tiver suporte a ele.';

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
    return 'Idioma alterado para $language.';
  }

  @override
  String get privacyTitle => 'Privacidade';

  @override
  String get privacyBody =>
      'O LifeThreads funciona localmente: sem conta e sem perfil público. Suas memórias ficam neste aparelho, a menos que você exporte um backup, compartilhe uma cápsula criptografada ou mostre seu mural em outra tela.';

  @override
  String get viewPrivacyPolicy => 'Ver política de privacidade';

  @override
  String get termsTitle => 'Termos de uso';

  @override
  String get viewTerms => 'Ver termos';

  @override
  String get betaFeedbackTitle => 'Feedback do beta';

  @override
  String get betaFeedbackBody =>
      'Envie feedback do beta com diagnósticos seguros. Os registros incluem só eventos do app e tipos de falha, nunca textos das memórias, caminhos de fotos, backups ou localizações exatas.';

  @override
  String get closedBetaBadge => 'Beta fechado';

  @override
  String get sendFeedback => 'Enviar feedback';

  @override
  String get backupArchiveBody =>
      'Salve tudo – memórias, fotos, notas, fios e layout – em um só arquivo. Guarde no seu computador ou na sua própria nuvem, e adicione uma senha para criptografar.';

  @override
  String get backupArchiveTitle => 'Backup';

  @override
  String get premiumBadge => 'Premium';

  @override
  String get unlockBadge => 'Desbloquear';

  @override
  String get exportArchive => 'Exportar arquivo';

  @override
  String get importArchive => 'Importar arquivo';

  @override
  String get importCapsule => 'Importar cápsula';

  @override
  String get moveDevices => 'Trocar de aparelho';

  @override
  String get themeTitle => 'Tema';

  @override
  String get themeBody =>
      'Escolha o clima do seu mural privado. A versão grátis inclui Sala aconchegante. O Premium libera todos os climas.';

  @override
  String get oneFreeBadge => '1 grátis';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumActiveBody => 'A assinatura Premium está ativa.';

  @override
  String get premiumLockedBody =>
      'Anual ou mensal: memórias ilimitadas, vários murais, stories, temas e layouts.';

  @override
  String get activeBadge => 'Ativo';

  @override
  String get openPremium => 'Abrir Premium';

  @override
  String get appVersionTitle => 'Versão do app';

  @override
  String get clearAllDataTitle => 'Apagar todos os dados';

  @override
  String get clearAllDataBody =>
      'Exclui deste aparelho todas as memórias, conexões, notas, pregos e fotos copiadas.';

  @override
  String get clearData => 'Apagar dados';

  @override
  String exportFailed(Object error) {
    return 'Falha ao exportar: $error';
  }

  @override
  String importRejected(Object message) {
    return 'Importação recusada: $message';
  }

  @override
  String importFailed(Object error) {
    return 'Falha ao importar: $error';
  }

  @override
  String deleteFailed(Object message) {
    return 'Falha ao excluir: $message';
  }

  @override
  String capsuleRejected(Object message) {
    return 'Cápsula recusada: $message';
  }

  @override
  String capsuleImportFailed(Object error) {
    return 'Falha ao importar a cápsula: $error';
  }

  @override
  String get clearAllDataQuestion => 'Apagar todos os dados?';

  @override
  String get clearAllDataQuestionBody =>
      'Isso remove para sempre todos os dados locais do LifeThreads neste aparelho. Exporte um backup antes se quiser guardá-los.';

  @override
  String get clearAll => 'Apagar tudo';

  @override
  String get allLocalDataCleared => 'Todos os dados locais foram apagados.';

  @override
  String get feedbackGeneral => 'Feedback geral';

  @override
  String get feedbackBug => 'Bug';

  @override
  String get feedbackCrash => 'Travamento';

  @override
  String get feedbackDesign => 'Problema de design';

  @override
  String get feedbackMissingFeature => 'Recurso que falta';

  @override
  String get feedbackPerformance => 'Desempenho';

  @override
  String get betaFeedbackIntro =>
      'Conte o que aconteceu ou o que pareceu estranho. Diagnósticos seguros serão anexados, sem conteúdo privado das memórias.';

  @override
  String get feedbackType => 'Tipo';

  @override
  String get feedbackLabel => 'Feedback';

  @override
  String get feedbackHint =>
      'Exemplo: toquei em Adicionar > Foto rápida e a tela travou.';

  @override
  String get betaFeedbackNotIncluded =>
      'Não incluído: títulos de memórias, histórias, notas, caminhos de fotos, caminhos de backups, localizações exatas.';

  @override
  String get feedbackEmpty => 'Escreva primeiro uma mensagem curta.';

  @override
  String get feedbackCopied =>
      'Nenhum app de e-mail abriu. Feedback copiado para a área de transferência para info@gkcoding.dev.';

  @override
  String themeSelected(Object theme) {
    return '$theme selecionado.';
  }

  @override
  String get onboardingHeadline => 'Monte seu mural vivo.';

  @override
  String get onboardingBody =>
      'Uma sala privada de memórias onde fotos, lugares, pessoas e pequenas notas se ligam por fios de emoção.';

  @override
  String get onboardingPrivacy =>
      'Suas memórias são privadas por padrão: sem conta e sem perfil público. Compartilhamento criptografado na nuvem e backup só acontecem quando você escolhe.';

  @override
  String get onboardingPrivacyShort =>
      'Sem conta e sem perfil público. Suas memórias ficam neste aparelho, a menos que você escolha outra coisa.';

  @override
  String get onboardingNext => 'Próximo';

  @override
  String get onboardingNameTitle => 'Como podemos te chamar?';

  @override
  String get onboardingNameHint => 'Seu nome';

  @override
  String onboardingNiceToMeetYou(String name) {
    return 'Prazer, $name.';
  }

  @override
  String get onboardingGetStartedTitle => 'Escolha como começar';

  @override
  String get onboardingGetStartedBody =>
      'Veja um mural de exemplo ou comece com um vazio e pendure suas próprias memórias.';

  @override
  String get settingsNameTitle => 'Seu nome';

  @override
  String get settingsNameBody => 'Aparece como saudação no seu mural.';

  @override
  String get settingsNameHint => 'Seu nome';

  @override
  String get settingsNameSaved => 'Nome atualizado.';

  @override
  String get storyPrivacyTitle => 'Suas memórias ficam privadas';

  @override
  String get storyConnectTitle => 'Conecte momentos';

  @override
  String get storyConnectText =>
      'Ligue memórias, notas e lugares para que cada capítulo tenha contexto.';

  @override
  String get storyWallTitle => 'Monte seu mural vivo';

  @override
  String get storyWallText =>
      'Comece com uma foto e deixe o mural crescer até parecer vivo.';

  @override
  String get previewDemoWall => 'Ver mural de exemplo';

  @override
  String get startFresh => 'Começar do zero';

  @override
  String get optionalDemoPreview => 'Prévia opcional';

  @override
  String get quickTutorial => 'Tutorial rápido';

  @override
  String get tutorialIntro =>
      'Primeiro o básico – salvar, conectar, organizar – depois tudo o que seu mural sabe fazer.';

  @override
  String get gotIt => 'Entendi';

  @override
  String get howItWorks => 'Como funciona';

  @override
  String get tutorialAddTitle => 'Adicione uma memória';

  @override
  String get tutorialAddText =>
      'Toque em +, escolha Memória ou Foto rápida e salve o título, a data, as pessoas e a foto. Se você sair antes de salvar, ela fica como rascunho.';

  @override
  String get tutorialConnectTitle => 'Conecte memórias';

  @override
  String get tutorialConnectText =>
      'Abra um card, toque no ícone de conectar, escolha memórias relacionadas e adicione um motivo curto.';

  @override
  String get tutorialArrangeTitle => 'Organize o mural';

  @override
  String get tutorialArrangeText =>
      'Arraste cards, notas e pregos para o lugar. Ver › Organizar ordena por data, categoria ou lugar – vale ao tocar em OK.';

  @override
  String get tutorialShowBoardTitle => 'Mostre o mural';

  @override
  String get tutorialShowBoardText =>
      'Abra lifethreads.gkcoding.dev/display em outra tela, escolha Mais › Mostrar mural e escaneie o código para mostrar um mural temporário, só para ver.';

  @override
  String get tutorialBackupTitle => 'Privacidade e backup';

  @override
  String get tutorialBackupText =>
      'Ajustes › Privacidade › Bloqueio do app abre o LifeThreads com Face ID. Antes de trocar de celular, exporte um backup em Ajustes › Backup e dados.';

  @override
  String get scanDisplayQr => 'Escanear QR da tela';

  @override
  String get scannerHintTitle => 'Onde está o QR code?';

  @override
  String get addMemoryBeforeDisplay =>
      'Adicione uma memória antes de mostrar um mural.';

  @override
  String get notLifeThreadsDisplayQr =>
      'Este não é um QR de tela do LifeThreads.';

  @override
  String get displayWallQuestion => 'Mostrar este mural?';

  @override
  String displayWallBody(int memoryCount) {
    return 'O LifeThreads vai enviar uma cópia temporária, só para leitura, com $memoryCount memórias para a sessão do navegador que você escaneou. Ela abre em lifethreads.gkcoding.dev/display e expira sozinha.';
  }

  @override
  String get displayAction => 'Mostrar';

  @override
  String get soon => 'em breve';

  @override
  String wallDisplayLive(int memoryCount, Object expires) {
    return 'O mural está sendo exibido com $memoryCount memórias até $expires.';
  }

  @override
  String get preparingWallDisplay => 'Preparando a exibição do mural...';

  @override
  String get open => 'Abrir';

  @override
  String get edit => 'Editar';

  @override
  String get save => 'Salvar';

  @override
  String get done => 'OK';

  @override
  String get back => 'Voltar';

  @override
  String get continueAction => 'Continuar';

  @override
  String get close => 'Fechar';

  @override
  String get add => 'Adicionar';

  @override
  String get saveReason => 'Salvar motivo';

  @override
  String get chooseBackup => 'Escolher backup';

  @override
  String get chooseArchive => 'Escolher arquivo';

  @override
  String get chooseCapsule => 'Escolher cápsula';

  @override
  String get exportAction => 'Exportar';

  @override
  String get addToWall => 'Adicionar ao mural';

  @override
  String get cinemaSkip => 'Pular';

  @override
  String get cinemaNotNow => 'Agora não';

  @override
  String get cinemaSharedChapter => 'Um capítulo compartilhado';

  @override
  String get cinemaConnectedThread => 'Fio conectado';

  @override
  String get cinemaInviteTitle => 'Adicionar esta memória ao seu mural?';

  @override
  String get useSelected => 'Usar seleção';

  @override
  String photoGridItem(String date) {
    return 'Foto de $date';
  }

  @override
  String get noPhotosFound => 'Nenhuma foto encontrada.';

  @override
  String get manage => 'Gerenciar';

  @override
  String get manageAccess => 'Gerenciar acesso';

  @override
  String get saveNow => 'Salvar agora';

  @override
  String get hangOnWall => 'Pendurar no mural';

  @override
  String get placeHere => 'Colocar aqui';

  @override
  String get openSettings => 'Abrir Ajustes';

  @override
  String get viewPremium => 'Ver Premium';

  @override
  String get memoryNotFound => 'Memória não encontrada';

  @override
  String get memoryTypeMoment => 'Momento';

  @override
  String get memoryTypeTrip => 'Viagem';

  @override
  String get memoryTypePerson => 'Pessoa';

  @override
  String get memoryTypePlace => 'Lugar';

  @override
  String get memoryTypeNote => 'Nota';

  @override
  String get memoryTypeMomentDescription => 'Uma pequena cena que vale guardar';

  @override
  String get memoryTypeTripDescription => 'Uma viagem ou um passeio';

  @override
  String get memoryTypePersonDescription => 'Alguém importante';

  @override
  String get memoryTypePlaceDescription => 'Um lugar com significado';

  @override
  String get memoryTypeNoteDescription =>
      'Um pensamento, uma citação ou um lembrete';

  @override
  String get categoryPersonal => 'Pessoal';

  @override
  String get categoryFamily => 'Família';

  @override
  String get categoryTravel => 'Viagens';

  @override
  String get feelingWarm => 'Carinhoso';

  @override
  String get feelingNostalgic => 'Nostálgico';

  @override
  String get feelingProud => 'Orgulhoso';

  @override
  String get feelingCalm => 'Tranquilo';

  @override
  String get feelingImportant => 'Importante';

  @override
  String get feelingWarmDescription => 'Suave, próximo, cheio de amor.';

  @override
  String get feelingNostalgicDescription => 'Uma memória que te leva de volta.';

  @override
  String get feelingProudDescription => 'Um momento que provou alguma coisa.';

  @override
  String get feelingCalmDescription => 'Quieto, seguro, em paz.';

  @override
  String get feelingImportantDescription => 'Uma memória que mudou a história.';

  @override
  String get addPeopleHint =>
      'Adicione as pessoas deste momento. Os contatos ficam no aparelho.';

  @override
  String get addPerson => 'Adicionar pessoa';

  @override
  String get editPerson => 'Editar pessoa';

  @override
  String get chooseFromContacts => 'Escolher dos contatos';

  @override
  String get personNameLabel => 'Nome';

  @override
  String get personNameHint => 'Digite para buscar pessoas salvas';

  @override
  String get relationshipLabel => 'Relação';

  @override
  String get relationshipHint => 'Amiga, mãe, parceiro...';

  @override
  String get phoneOptionalLabel => 'Telefone (opcional)';

  @override
  String get emailOptionalLabel => 'E-mail (opcional)';

  @override
  String get nameRelationshipRequired => 'Nome e relação são obrigatórios.';

  @override
  String get contactAccessDenied => 'O acesso aos contatos não foi permitido.';

  @override
  String get couldNotOpenContacts => 'Não foi possível abrir os contatos.';

  @override
  String get chooseContact => 'Escolher contato';

  @override
  String get searchContacts => 'Buscar contatos';

  @override
  String get noContactsFound => 'Nenhum contato encontrado.';

  @override
  String get unnamedContact => 'Contato sem nome';

  @override
  String get contactRelationship => 'Contato';

  @override
  String get couldNotLoadContacts => 'Não foi possível carregar os contatos.';

  @override
  String get saveMomentTitle => 'Salve um momento';

  @override
  String get todayEyebrow => 'Hoje';

  @override
  String get addMemoryStepTitle => 'O que aconteceu que você não quer perder?';

  @override
  String get addMemoryStepSubtitle =>
      'Escreva uma linha, adicione uma foto se tiver e salve. Os detalhes podem esperar.';

  @override
  String get momentLabel => 'Momento';

  @override
  String get momentHint =>
      'Jantar com a Lara, primeiro lançamento, caminhada tranquila...';

  @override
  String get storyWorthLabel => 'Por que vale a pena guardar?';

  @override
  String get storyWorthHint => 'Algumas palavras bastam.';

  @override
  String get feelingEyebrow => 'Sentimento';

  @override
  String get feelingStepTitle => 'Como isso deve parecer quando voltar?';

  @override
  String get feelingStepSubtitle =>
      'Assim fica mais fácil redescobrir a memória depois.';

  @override
  String get contextEyebrow => 'Contexto';

  @override
  String get whenWasItTitle => 'Quando foi?';

  @override
  String get photoGpsStepSubtitle =>
      'O mapa usa o GPS salvo nas fotos escolhidas. Se uma foto não tiver GPS, nenhum lugar é mostrado.';

  @override
  String get peopleThreadsEyebrow => 'Pessoas e fios';

  @override
  String get peopleThreadsTitle => 'Com quem ou com o quê isso se conecta?';

  @override
  String get peopleThreadsSubtitle =>
      'Detalhes opcionais transformam momentos soltos em um fio da vida.';

  @override
  String get connectExistingMemoryLabel => 'Conectar a uma memória existente';

  @override
  String get noConnectionYet => 'Ainda sem conexão';

  @override
  String get connectionReasonLabel => 'Por que estão conectadas?';

  @override
  String get connectionReasonHint =>
      'Exemplo: mesma viagem, mesma pessoa, antes / depois...';

  @override
  String get writeMomentOrPhotoFirst =>
      'Escreva um momento ou adicione uma foto primeiro.';

  @override
  String get todaysMoment => 'O momento de hoje';

  @override
  String get savedFromTodaysPrompt => 'Salvo a partir da pergunta de hoje.';

  @override
  String get saveItBeforeItFades => 'Salve antes que se apague';

  @override
  String get chooseDate => 'Escolher data';

  @override
  String get dateLabel => 'Data';

  @override
  String get untitledMemory => 'Memória sem título';

  @override
  String get organize => 'Organizar';

  @override
  String get memoryShape => 'Forma da memória';

  @override
  String get wallCategory => 'Categoria do mural';

  @override
  String get privatePhotos => 'Fotos privadas';

  @override
  String get pick => 'Escolher';

  @override
  String get addMore => 'Adicionar mais';

  @override
  String get takePhoto => 'Tirar foto';

  @override
  String get takePhotosNow => 'Tirar fotos agora';

  @override
  String get takePhotosFabTooltip => 'Tirar fotos para uma nova memória';

  @override
  String get takeAnotherPhoto => 'Tirar outra foto';

  @override
  String get continueWithPhotos => 'Continuar com estas fotos';

  @override
  String get addPhotosToMemory => 'Adicionar à memória';

  @override
  String get takeAnotherOrContinueBody =>
      'Continue fotografando para esta memória ou siga em frente e adicione a história.';

  @override
  String photosCapturedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos tiradas',
      one: '1 foto tirada',
    );
    return '$_temp0';
  }

  @override
  String get photoStorageHint =>
      'O LifeThreads copia as fotos escolhidas para o armazenamento privado do app e mantém data e local quando disponíveis.';

  @override
  String get limitedPhotoAccessActive =>
      'O acesso limitado às fotos está ativo. Você pode liberar mais fotos.';

  @override
  String get selectPhotos => 'Selecionar fotos';

  @override
  String get photoAccessOff => 'O acesso às fotos está desligado';

  @override
  String get photoAccessOffBody =>
      'Ative o acesso às fotos para escolher memórias. Suas fotos ficam neste aparelho.';

  @override
  String get freeMemoryLimitReached => 'Limite grátis atingido';

  @override
  String get freeMemoryLimitBody =>
      'Murais grátis incluem 30 memórias. Faça upgrade para continuar montando seu mural vivo.';

  @override
  String get photoAccessNeeded => 'Primeiro é preciso acesso às fotos.';

  @override
  String get quickPhotoMemory => 'Foto rápida';

  @override
  String get quickPhotoDescription =>
      'Uma foto que vale guardar. Adicione a história quando quiser.';

  @override
  String get hangQuickPhoto => 'Pendurar foto rápida';

  @override
  String photoGpsDetected(Object latitude, Object longitude) {
    return 'GPS da foto detectado: $latitude, $longitude';
  }

  @override
  String get photoGpsMissing =>
      'Nenhum GPS na foto. Esta memória não vai aparecer no mapa.';

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
    return '$count/$total datas';
  }

  @override
  String metadataLocations(int count, int total) {
    return '$count/$total locais';
  }

  @override
  String metadataSizes(int count, int total) {
    return '$count/$total tamanhos';
  }

  @override
  String newSelected(int count) {
    return '$count novas selecionadas';
  }

  @override
  String selectedCount(int count) {
    return '$count selecionadas';
  }

  @override
  String get editMemoryTitle => 'Editar memória';

  @override
  String get storyPanel => 'História';

  @override
  String get memoryTitleLabel => 'Título da memória';

  @override
  String get addTitleValidation => 'Adicione um título';

  @override
  String get storyDescriptionLabel => 'História / descrição';

  @override
  String get addStoryValidation => 'Adicione uma história curta';

  @override
  String get shapeFeelingTitle => 'Forma e sentimento';

  @override
  String get memoryTypeLabel => 'Tipo de memória';

  @override
  String get feelingLabel => 'Sentimento';

  @override
  String get categoryLabel => 'Categoria';

  @override
  String get timePhotoGpsTitle => 'Data e GPS da foto';

  @override
  String get memoryDateLabel => 'Data da memória';

  @override
  String get peopleTitle => 'Pessoas';

  @override
  String get galleryTitle => 'Galeria';

  @override
  String get addPhotos => 'Adicionar fotos';

  @override
  String get saveMemory => 'Salvar memória';

  @override
  String get memorySaveFailed =>
      'Não foi possível salvar esta memória. Tente de novo.';

  @override
  String get passwordOnlySpaces => 'A senha não pode ter só espaços.';

  @override
  String get somethingWentWrong => 'Algo deu errado. Tente de novo.';

  @override
  String get mapUnavailable => 'O mapa não está disponível agora.';

  @override
  String get coverPhoto => 'Foto de capa';

  @override
  String get galleryPhoto => 'Foto da galeria';

  @override
  String get setAsCover => 'Definir como capa';

  @override
  String get replacePhoto => 'Trocar foto';

  @override
  String get removePhoto => 'Remover foto';

  @override
  String get choosePhoto => 'Escolher foto';

  @override
  String get threadReasonsTitle => 'Motivos dos fios';

  @override
  String get createMoreMemoriesBeforeLinking =>
      'Crie mais memórias antes de conectá-las.';

  @override
  String get connectionHeaderBody =>
      'Conecte memórias com um motivo. A corda deve explicar por que dois momentos andam juntos.';

  @override
  String get connectedMemory => 'memória conectada';

  @override
  String get whyConnectedTitle => 'Por que estão conectadas?';

  @override
  String get exportPremiumArchiveTitle => 'Exportar backup';

  @override
  String get importArchiveTitle => 'Importar arquivo';

  @override
  String get archiveExportBody =>
      'Adicione uma senha para criptografar o arquivo. Deixe em branco para um zip local comum.';

  @override
  String get archiveImportBody =>
      'Se este arquivo estiver criptografado, digite a senha. Deixe em branco para backups antigos ou sem proteção.';

  @override
  String get archivePasswordOptional => 'Senha do arquivo (opcional)';

  @override
  String get archivePasswordLabel => 'Senha do arquivo';

  @override
  String get archivePasswordWarning =>
      'Guarde a senha em um lugar seguro. Ela não pode ser recuperada se você perder.';

  @override
  String get sendArchiveTitle => 'Enviar arquivo do LifeThreads';

  @override
  String get sendArchiveSubject => 'Arquivo de memórias do LifeThreads';

  @override
  String get sendEncryptedArchiveText =>
      'Arquivo criptografado do LifeThreads. Use a senha que você escolheu para importá-lo em outro aparelho.';

  @override
  String get sendArchiveText =>
      'Arquivo do LifeThreads. Importe no LifeThreads para abrir seu mural de memórias em outro aparelho.';

  @override
  String get archiveReadyToSend =>
      'Backup pronto. Guarde em um lugar seguro, fora deste celular.';

  @override
  String get archiveNotSaved =>
      'Backup não salvo. Exporte de novo quando quiser.';

  @override
  String get archiveSharingUnavailable =>
      'Compartilhar não está disponível neste aparelho.';

  @override
  String archiveShareFailed(Object error) {
    return 'Arquivo salvo, mas não foi possível compartilhar: $error';
  }

  @override
  String get archiveImportedTitle => 'Arquivo importado';

  @override
  String get memoriesLabel => 'Memórias';

  @override
  String get photosLabel => 'Fotos';

  @override
  String get wallNotesNailsLabel => 'Notas / pregos';

  @override
  String get connectionsLabel => 'Conexões';

  @override
  String get archiveImportSummary =>
      'Seu mural atual foi mantido. As memórias importadas foram adicionadas com segurança.';

  @override
  String get shareEncryptedCapsuleTitle => 'Compartilhar cápsula criptografada';

  @override
  String get openSharedCapsuleTitle => 'Abrir cápsula compartilhada';

  @override
  String get exportMemoryCapsuleTitle => 'Exportar cápsula de memória';

  @override
  String get importCapsuleDialogTitle => 'Importar cápsula';

  @override
  String get secureSharePasswordBody =>
      'Crie uma senha antes de enviar esta cápsula. Mande a senha separadamente para quem vai recebê-la.';

  @override
  String get sharedCapsulePasswordBody =>
      'Digite a senha que você recebeu para esta memória compartilhada.';

  @override
  String get capsuleExportBody =>
      'Adicione uma senha se esta memória precisar de proteção antes do envio. Deixe em branco para uma cápsula comum.';

  @override
  String get capsuleImportBody =>
      'Se esta cápsula tiver senha, digite-a. Se não, deixe em branco.';

  @override
  String get capsulePasswordLabel => 'Senha da cápsula';

  @override
  String get sharedCapsulePasswordLabel => 'Senha da cápsula compartilhada';

  @override
  String get capsulePasswordOptional => 'Senha da cápsula (opcional)';

  @override
  String get capsulePasswordWarning =>
      'O LifeThreads não consegue recuperar esta senha depois.';

  @override
  String get passwordRequiredCloudSharing =>
      'É preciso uma senha para compartilhar pela nuvem.';

  @override
  String get createSecureShare => 'Criar link seguro';

  @override
  String get previewMemory => 'Prévia da memória';

  @override
  String get sendCapsuleTitle => 'Compartilhar memória do LifeThreads';

  @override
  String get sendCapsuleSubject => 'Cápsula de memória do LifeThreads';

  @override
  String get sendEncryptedCapsuleText =>
      'Oi, compartilhei com você uma memória protegida do LifeThreads. Use a senha que te mandei para importar.';

  @override
  String get sendCapsuleText =>
      'Oi, compartilhei com você uma memória do LifeThreads. Importe a cápsula no LifeThreads para adicioná-la ao seu mural.';

  @override
  String get capsuleReadyToSend => 'Cápsula pronta para enviar.';

  @override
  String get capsuleSavedLater =>
      'Cápsula salva. Você pode compartilhar depois.';

  @override
  String get capsuleSharingUnavailable =>
      'Cápsula salva, mas compartilhar não está disponível.';

  @override
  String capsuleShareFailed(Object error) {
    return 'Cápsula salva, mas não foi possível compartilhar: $error';
  }

  @override
  String get importThisMemory => 'Importar esta memória?';

  @override
  String get noStoryTextIncluded => 'Sem texto da história.';

  @override
  String get placeLabel => 'Lugar';

  @override
  String get notesLabel => 'Notas';

  @override
  String get capsulePasswordProtected =>
      'Esta cápsula era protegida por senha.';

  @override
  String get openingSharedMemory => 'Abrindo memória compartilhada...';

  @override
  String get lifeThreadsMemoryTitle => 'Memória do LifeThreads';

  @override
  String shareMemoryText(Object url) {
    return 'Oi, compartilhei uma memória com você no LifeThreads.\n\n$url';
  }

  @override
  String get shareLinkReady => 'Link pronto.';

  @override
  String get shareLinkCreated => 'Link criado.';

  @override
  String get shareLinkUnavailable =>
      'Link criado, mas compartilhar não está disponível.';

  @override
  String shareLinkExpiresDelete(Object label) {
    return '$label O link expira sozinho. Você pode excluí-lo agora.';
  }

  @override
  String cloudShareFailed(Object message) {
    return 'Falha ao compartilhar na nuvem: $message';
  }

  @override
  String get sharedMemoryLinkDeleted => 'Link da memória excluído.';

  @override
  String get creatingSecureMemoryLink => 'Criando link seguro...';

  @override
  String get shareMemoryCapsule => 'Compartilhar cápsula';

  @override
  String get editStory => 'Editar história';

  @override
  String get metaType => 'Tipo';

  @override
  String get metaFeeling => 'Sentimento';

  @override
  String get metaCategory => 'Categoria';

  @override
  String get metaDate => 'Data';

  @override
  String get storyEyebrow => 'História';

  @override
  String get whyMemoryMatters => 'Por que esta memória importa';

  @override
  String get galleryEyebrow => 'Galeria';

  @override
  String editSectionTooltip(String section) {
    return 'Editar $section';
  }

  @override
  String get openInMaps => 'Abrir no Mapas';

  @override
  String get memoryChangesSaved => 'Alterações salvas.';

  @override
  String get memoryDeletedToast => 'Memória excluída.';

  @override
  String get noteDeletedToast => 'Nota excluída.';

  @override
  String get nailDeletedToast => 'Prego removido.';

  @override
  String get undo => 'Desfazer';

  @override
  String photoPlaceDetected(String place) {
    return 'Lugar da foto: $place';
  }

  @override
  String get settingsGroupYou => 'Você';

  @override
  String get settingsGroupReminders => 'Lembretes';

  @override
  String get settingsGroupMore => 'Mais';

  @override
  String get backupDataTitle => 'Backup e dados';

  @override
  String get backupDataSubtitle => 'Fazer backup, restaurar, trocar de celular';

  @override
  String get aboutHelpTitle => 'Sobre e ajuda';

  @override
  String get aboutHelpSubtitle => 'Feedback, privacidade, música, versão';

  @override
  String get discardChangesTitle => 'Descartar alterações?';

  @override
  String get discardChangesBody => 'O que você mudou aqui será perdido.';

  @override
  String get discardChanges => 'Descartar';

  @override
  String get keepEditing => 'Continuar editando';

  @override
  String get settingsGroupPrivacy => 'Privacidade';

  @override
  String get appLockTitle => 'Bloqueio do app';

  @override
  String get appLockSubtitle => 'Face ID ou código para abrir o LifeThreads';

  @override
  String get appLockReason => 'Desbloqueie suas memórias';

  @override
  String get appLockLockedTitle => 'O LifeThreads está bloqueado';

  @override
  String get appLockUnlock => 'Desbloquear';

  @override
  String get appLockUnavailable =>
      'Configure primeiro o Face ID ou um código neste celular.';

  @override
  String onThisDayNotificationPrivate(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Uma memória de $years anos atrás está te esperando.',
      one: 'Uma memória de 1 ano atrás está te esperando.',
    );
    return '$_temp0';
  }

  @override
  String get searchTitle => 'Buscar';

  @override
  String get searchHint => 'Título, lugar, pessoa ou ano';

  @override
  String get searchClear => 'Limpar busca';

  @override
  String get searchNoResults => 'Nenhuma memória encontrada.';

  @override
  String searchResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memórias',
      one: '1 memória',
    );
    return '$_temp0';
  }

  @override
  String get searchTooltip => 'Buscar memórias';

  @override
  String get premiumFeatureWalls => 'Mais murais';

  @override
  String get newWall => 'Novo mural';

  @override
  String get wallNameLabel => 'Nome do mural';

  @override
  String get newWallHint => 'ex.: Viagens 2025';

  @override
  String get createWall => 'Criar';

  @override
  String get renameWall => 'Renomear';

  @override
  String get deleteWall => 'Excluir mural';

  @override
  String deleteWallQuestion(String name) {
    return 'Excluir “$name”?';
  }

  @override
  String get deleteWallBody =>
      'As memórias dele vão para Meu mural; nada se perde.';

  @override
  String get personalWallSubtitle => 'Seu mural, neste aparelho';

  @override
  String get wallOptions => 'Opções do mural';

  @override
  String get moveToWall => 'Mover para mural…';

  @override
  String movedToWall(String name) {
    return 'Movida para $name.';
  }

  @override
  String get hideMemory => 'Ocultar';

  @override
  String get unhideMemory => 'Mostrar de novo';

  @override
  String get memoryHiddenToast => 'Oculta. Encontre em Ver › Memórias ocultas.';

  @override
  String get showHiddenMemories => 'Memórias ocultas';

  @override
  String get showHiddenReason => 'Mostrar memórias ocultas';

  @override
  String get yearThreadFirstTitle => 'Seu primeiro Fio do Ano';

  @override
  String yearThreadProgress(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de 3 memórias',
      one: '1 de 3 memórias',
    );
    return '$_temp0';
  }

  @override
  String get yearThreadStoryInstead => 'Ou crie um story agora';

  @override
  String get moveMemoriesHere => 'Mover memórias para cá';

  @override
  String get moveMemoriesTitle => 'Escolha as memórias para mover para cá';

  @override
  String moveSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mover $count memórias',
      one: 'Mover 1 memória',
    );
    return '$_temp0';
  }

  @override
  String get showAllMemories => 'Mostrar tudo';

  @override
  String get addAMemory => 'Adicionar uma memória';

  @override
  String get mapAddPhotoMemory => 'Adicione uma foto com o lugar';

  @override
  String get searchSuggestions => 'Tente uma das suas';

  @override
  String thisWeekYearsAgo(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Nesta semana, $years anos atrás',
      one: 'Nesta semana, 1 ano atrás',
    );
    return '$_temp0';
  }

  @override
  String get peopleHint => 'Quem estava lá?';

  @override
  String get premiumPlanYearly => 'Anual';

  @override
  String get premiumPlanMonthly => 'Mensal';

  @override
  String premiumYearlyWithPrice(String price) {
    return 'Premium • $price/ano';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Economize $percent%';
  }

  @override
  String purchasesHandledYearly(String store) {
    return 'O pagamento é cobrado na sua conta $store. A assinatura é renovada automaticamente todo ano, a menos que você cancele pelo menos 24 horas antes do fim do período atual. Gerencie ou cancele nos ajustes da sua conta $store.';
  }

  @override
  String savedPhotosTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotos salvas',
      one: '1 foto salva',
    );
    return '$_temp0';
  }

  @override
  String get peopleEyebrow => 'Pessoas';

  @override
  String get partOfMemory => 'Parte desta memória';

  @override
  String get notesEyebrow => 'Notas';

  @override
  String get attachedThoughts => 'Pensamentos anexados';

  @override
  String get stickyNote => 'Post-it';

  @override
  String get placeEyebrow => 'Lugar';

  @override
  String get threadsEyebrow => 'Fios';

  @override
  String get connectedMemories => 'Memórias conectadas';

  @override
  String get noConnectedMemoriesYet =>
      'Ainda não há memórias conectadas. Conecte este capítulo a outro momento para começar um fio da vida visível.';

  @override
  String get backToWall => 'Voltar ao mural';

  @override
  String get addTextToWall => 'Adicionar texto ao mural';

  @override
  String get addTextAction => 'Adicionar texto';

  @override
  String get textNoteHint => 'Escreva uma pequena memória, citação ou nota...';

  @override
  String get placeTextNote => 'Colocar nota';

  @override
  String get placeRopeAnchor => 'Colocar âncora';

  @override
  String get nailSubtitle =>
      'Um prego pode ligar cordas manualmente entre memórias.';

  @override
  String get clearDemoWallQuestion => 'Apagar mural de exemplo?';

  @override
  String get clearDemoWallBody =>
      'Isso remove as memórias de exemplo para você começar com um mural privado vazio.';

  @override
  String get importBackupQuestion => 'Importar backup?';

  @override
  String get importBackupBody =>
      'Isso restaura memórias de um arquivo do LifeThreads e mantém seu mural atual.';

  @override
  String get deleteMemoryQuestion => 'Excluir memória?';

  @override
  String get deleteMemoryBody =>
      'Isso remove a memória e todas as ligações dela no mural.';

  @override
  String get editText => 'Editar texto';

  @override
  String get editTextTitle => 'Editar texto';

  @override
  String get connectRope => 'Conectar corda';

  @override
  String get connectRopeSubtitle => 'Prenda este prego a memórias.';

  @override
  String get deleteNail => 'Excluir prego';

  @override
  String get connectNailTitle => 'Conectar prego a memórias';

  @override
  String get connectNailSubtitle =>
      'As memórias escolhidas ficarão penduradas nesta âncora.';

  @override
  String get timelineTitle => 'Linha do tempo';

  @override
  String get timelineSubtitle => 'Suas memórias em ordem cronológica.';

  @override
  String get noMemoriesFilter => 'Nenhuma memória neste filtro';

  @override
  String get noMemoriesFilterBody =>
      'Troque o filtro ou adicione uma memória para montar a linha do tempo.';

  @override
  String get memoryMapTitle => 'Mapa de memórias';

  @override
  String get memoryMapSubtitle => 'Suas memórias agrupadas por lugar.';

  @override
  String get noMappedMemories => 'Ainda não há memórias no mapa';

  @override
  String get displayWallTooltip => 'Mostrar mural';

  @override
  String get tutorialTooltip => 'Tutorial';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get freeformLayout => 'Livre';

  @override
  String get categoryLayout => 'Categoria';

  @override
  String get locationLayout => 'Lugar';

  @override
  String get saveToday => 'Salvar hoje';

  @override
  String get rememberThis => 'Guardar isto';

  @override
  String get whatHappenedToday => 'O que aconteceu hoje?';

  @override
  String get tapToOpenDrag => 'Toque para abrir • arraste para mover';

  @override
  String get demoWallPreview =>
      'Mural de exemplo. Apague quando quiser começar do zero.';

  @override
  String get clearDemo => 'Apagar exemplo';

  @override
  String get chooseQuickPhoto => 'Escolher foto rápida';

  @override
  String get wallView => 'Mural';

  @override
  String get timelineView => 'Linha do tempo';

  @override
  String get mapView => 'Mapa';

  @override
  String get wallFilterAll => 'Tudo';

  @override
  String get wallViewButton => 'Ver';

  @override
  String get wallShowAs => 'Mostrar como';

  @override
  String get wallArrange => 'Organizar';

  @override
  String get wallShowOnly => 'Mostrar';

  @override
  String get layoutByDate => 'Por data';

  @override
  String get moreActionsTooltip => 'Mais';

  @override
  String get addToWallTitle => 'Adicionar ao seu mural';

  @override
  String get expandableMemory => 'Memória';

  @override
  String get expandableMemorySubtitle => 'História guiada completa';

  @override
  String get expandableQuickPhoto => 'Foto rápida';

  @override
  String get expandableQuickPhotoSubtitle => 'Escolha a foto e pendure';

  @override
  String get expandableTextNote => 'Nota de texto';

  @override
  String get expandableTextNoteSubtitle => 'Um pensamento no mural';

  @override
  String get expandableNail => 'Prego / âncora';

  @override
  String get expandableNailSubtitle => 'Ponto manual para cordas';

  @override
  String get startWithOneThing => 'Comece com uma coisa de hoje';

  @override
  String get emptyWallBody =>
      'Salve um momento antes que se apague. Uma frase ou uma foto basta.';

  @override
  String get usePhoto => 'Usar uma foto';

  @override
  String get editMemoryTooltip => 'Editar memória';

  @override
  String get connectMemoryTooltip => 'Conectar memória';

  @override
  String get archiveTransferTitle => 'Abrir em outro aparelho';

  @override
  String get archiveTransferHeroTitle =>
      'Leve suas memórias entre aparelhos com segurança.';

  @override
  String get archiveTransferHeroBody =>
      'Um backup é um zip com suas memórias, fotos, notas, fios, posições no mural e metadados, com senha se você quiser. Não guardamos cópia: você decide para onde ele vai.';

  @override
  String get archiveTransferStep1Title => 'Exporte um arquivo';

  @override
  String get archiveTransferStep1Body =>
      'Abra Ajustes, escolha Exportar arquivo e adicione uma senha se quiser proteção.';

  @override
  String get archiveTransferStep2Title => 'Mova o zip';

  @override
  String get archiveTransferStep2Body =>
      'Transfira por AirDrop, USB, sua própria nuvem ou e-mail.';

  @override
  String get archiveTransferStep3Title => 'Importe com segurança';

  @override
  String get archiveTransferStep3Body =>
      'Instale o LifeThreads no outro aparelho, escolha Importar arquivo, digite a senha se precisar e restaure sem apagar dados existentes.';

  @override
  String get premiumPageTitle => 'LifeThreads Premium';

  @override
  String get developmentUnlockEnabled =>
      'Desbloqueio Premium de desenvolvimento ativado.';

  @override
  String get lifetimeActive => 'Assinatura ativa';

  @override
  String get oneTimeLifetimeUnlock => 'Anual ou mensal';

  @override
  String get premiumHeroActiveTitle => 'Seu mural de memórias é ilimitado.';

  @override
  String get premiumHeroLockedTitle => 'Transforme suas memórias em stories.';

  @override
  String get premiumHeroActiveBody =>
      'Sua assinatura Premium está ativa. Stories com música, Fio do Ano, murais de família e memórias ilimitadas são seus.';

  @override
  String premiumHeroLockedBody(int limit) {
    return 'A versão grátis inclui $limit memórias e backups completos. O Premium adiciona stories e filmes com música, Fio do Ano, murais de família e memórias ilimitadas.';
  }

  @override
  String get premiumMemories => 'Memórias Premium';

  @override
  String get freeMemories => 'Memórias grátis';

  @override
  String get unlimited => 'ilimitadas';

  @override
  String get benefitUnlimitedTitle => 'Memórias ilimitadas';

  @override
  String get benefitUnlimitedBody =>
      'Sem o limite de 30 memórias. Continue montando o mural enquanto a vida cresce.';

  @override
  String get benefitThemesTitle => 'Temas Premium';

  @override
  String get benefitThemesBody =>
      'Libere climas mais ricos, temas sazonais limitados e Auto pela hora do dia.';

  @override
  String get benefitLayoutsTitle => 'Layouts avançados';

  @override
  String get benefitLayoutsBody =>
      'Mais formas de organizar fios, linhas do tempo, âncoras e grupos de memórias.';

  @override
  String get lifetimeUnlock => 'Assinatura Premium';

  @override
  String get premiumActiveOnDevice => 'O Premium está ativo neste aparelho.';

  @override
  String onePurchaseBody(String store) {
    return 'Assine por ano ou por mês para ter stories com música, Fio do Ano, murais de família e memórias ilimitadas. Cancele quando quiser nos ajustes da $store.';
  }

  @override
  String get premiumActiveButton => 'Premium ativo';

  @override
  String get processing => 'Processando...';

  @override
  String get unlockPremium => 'Assinar o Premium';

  @override
  String get restorePurchase => 'Restaurar assinatura';

  @override
  String get enableDebugMockUnlock => 'Ativar desbloqueio de teste';

  @override
  String purchasesHandledByGooglePlay(String store) {
    return 'O pagamento é cobrado na sua conta $store. A assinatura é renovada automaticamente todo mês, a menos que você cancele pelo menos 24 horas antes do fim do período atual. Gerencie ou cancele nos ajustes da sua conta $store.';
  }

  @override
  String get premiumMessageBillingUpdateFailed =>
      'A atualização da loja falhou. Tente de novo.';

  @override
  String get premiumMessageStoreUnavailable =>
      'Compras não estão disponíveis neste aparelho.';

  @override
  String get premiumMessageProductUnavailable =>
      'O Premium ainda não está disponível na loja. Tente mais tarde.';

  @override
  String get premiumMessageLoadFailed =>
      'Não foi possível carregar o Premium da loja. Tente de novo.';

  @override
  String get premiumMessageOpeningCheckout => 'Abrindo o pagamento…';

  @override
  String get premiumMessageCheckoutFailed =>
      'Não foi possível abrir o pagamento. Tente de novo.';

  @override
  String get premiumMessageChecking => 'Verificando sua assinatura…';

  @override
  String get premiumMessageRestoreFailed =>
      'Falha ao restaurar. Tente de novo.';

  @override
  String get premiumMessageNoSubscriptionFound =>
      'Nenhuma assinatura Premium ativa encontrada.';

  @override
  String get premiumMessagePending =>
      'Sua compra está pendente. O Premium é liberado assim que for aprovada.';

  @override
  String get premiumMessagePurchaseFailed =>
      'A compra não foi concluída. Tente de novo.';

  @override
  String get premiumMessageCanceled => 'Compra cancelada.';

  @override
  String get premiumMessageRestored => 'Sua assinatura Premium foi restaurada.';

  @override
  String get premiumMessageActive => 'Sua assinatura Premium está ativa.';

  @override
  String lifetimeUnlockWithPrice(Object price) {
    return 'Premium • $price/mês';
  }

  @override
  String get loadingPlayStoreProduct => 'Carregando a assinatura…';

  @override
  String get playStoreUnavailable => 'A loja não está disponível agora';

  @override
  String get productNotConfigured => 'O Premium não está disponível agora';

  @override
  String get purchasePending => 'Compra pendente';

  @override
  String get purchased => 'Comprado';

  @override
  String get restored => 'Restaurado';

  @override
  String get premiumTryAgain => 'Tentar de novo';

  @override
  String get purchaseFailed => 'Falha na compra';

  @override
  String get preparingCheckout => 'Preparando o pagamento...';

  @override
  String get premiumLocalFirstTitle => 'Premium também é local';

  @override
  String get premiumLocalFirstBody =>
      'Suas memórias ficam no seu aparelho, e os backups são grátis para todos.';

  @override
  String get noMappedMemoriesBody =>
      'Adicione fotos com dados de GPS para ver memórias aqui.';

  @override
  String get peopleLabel => 'Pessoas';

  @override
  String get connect => 'Conectar';

  @override
  String get themeWarmMemoryRoom => 'Sala aconchegante';

  @override
  String get themeWarmMemoryRoomDescription =>
      'Calor escuro e suave, luz dourada e a profundidade de uma sala privada.';

  @override
  String get themeMidnightArchive => 'Arquivo da meia-noite';

  @override
  String get themeMidnightArchiveDescription =>
      'Sala de arquivo azul profundo com a calma de um museu.';

  @override
  String get themeSoftPaperWall => 'Papel suave';

  @override
  String get themeSoftPaperWallDescription =>
      'Papel creme, sombras de tinta e a calma de um scrapbook.';

  @override
  String get themeTravelCorkboard => 'Cortiça de viagem';

  @override
  String get themeTravelCorkboardDescription =>
      'O aconchego da cortiça com toques de mapa para viagens e lugares.';

  @override
  String get themeAutoTitle => 'Auto pela hora do dia';

  @override
  String get themeAutoDescription =>
      'Papel suave de dia, Sala aconchegante no fim da tarde, Arquivo da meia-noite à noite.';

  @override
  String get themeAutoSelected => 'Seu mural agora segue a hora do dia.';

  @override
  String get themeSeasonalTitle => 'Sazonais';

  @override
  String get themeSeasonalBody =>
      'Temas Premium limitados, cada um disponível só na sua estação.';

  @override
  String themeSeasonalUntil(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Até $dateString';
  }

  @override
  String get themeUseButton => 'Usar este tema';

  @override
  String get themeInUse => 'Em uso';

  @override
  String get themeUnlockButton => 'Liberar com Premium';

  @override
  String get themeAutumnHarvest => 'Colheita de outono';

  @override
  String get themeAutumnHarvestDescription =>
      'Luz âmbar, cards de papel kraft e o brilho das folhas caindo.';

  @override
  String get themeWinterLights => 'Luzes de inverno';

  @override
  String get themeWinterLightsDescription =>
      'Cards congelados e luzinhas quentes numa noite azul e fria.';

  @override
  String get themeSpringBlossom => 'Flores da primavera';

  @override
  String get themeSpringBlossomDescription =>
      'Cards de flores claras com um brilho rosa suave.';

  @override
  String get themeSummerEvening => 'Fim de tarde de verão';

  @override
  String get themeSummerEveningDescription =>
      'Cores de pôr do sol e cards de foto instantânea.';

  @override
  String get themeYearRoundTitle => 'Sempre disponíveis';

  @override
  String get themeComingTitle => 'Em breve';

  @override
  String get themeComingBody =>
      'Veja as próximas estações. Cada tema abre no primeiro dia da sua estação.';

  @override
  String themeAvailableFrom(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'A partir de $dateString';
  }

  @override
  String themeBrowse(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ver todos os temas, $count desta estação',
      one: 'Ver todos os temas, 1 desta estação',
      zero: 'Ver todos os temas',
    );
    return '$_temp0';
  }

  @override
  String get themeSeaside => 'Beira-mar';

  @override
  String get themeSeasideDescription =>
      'Água turquesa, papel cor de areia e luz quente de verão.';

  @override
  String get themeSnowyCabin => 'Cabana na neve';

  @override
  String get themeSnowyCabinDescription =>
      'Madeira junto à lareira, cards congelados e neve suave lá fora.';

  @override
  String get themeSpringMeadow => 'Campo na primavera';

  @override
  String get themeSpringMeadowDescription =>
      'Grama verdinha, cards claros e sol amarelo.';

  @override
  String get themeMistyForest => 'Floresta na névoa';

  @override
  String get themeMistyForestDescription =>
      'Pinheiros quietos, névoa da manhã e folhas douradas.';

  @override
  String get demoFirstDanceTitle => 'Nossa primeira dança';

  @override
  String get demoFirstDanceStory =>
      'A banda tocou a nossa música e o celeiro inteiro ficou em silêncio. Pisei no seu pé duas vezes, você riu o tempo todo, e por três minutos não existia mais ninguém.';

  @override
  String get demoFirstDancePlace => 'Salzburgo';

  @override
  String get demoNewbornTitle => 'Bem-vinda em casa, Lina';

  @override
  String get demoNewbornStory =>
      'A mãozinha inteira dela cabia em volta de um dedo. A primeira manhã tranquila em casa.';

  @override
  String get demoNewbornPlace => 'Viena';

  @override
  String get demoBeachSunsetTitle => 'Verão na praia';

  @override
  String get demoBeachSunsetStory =>
      'Descalços até o sol se pôr, Lina dormindo nos seus ombros na volta.';

  @override
  String get demoBeachSunsetPlace => 'Split, Croácia';

  @override
  String get demoGrandmaKitchenTitle => 'A cozinha da vovó';

  @override
  String get demoGrandmaKitchenStory =>
      'O bolo de damasco dela, finalmente anotado – e farinha por todo lado.';

  @override
  String get demoGrandmaKitchenPlace => 'Graz';

  @override
  String get demoGraduationTitle => 'Dia da formatura';

  @override
  String get demoGraduationStory =>
      'O papai chorou antes mesmo de os capelos caírem.';

  @override
  String get demoGraduationPlace => 'Innsbruck';

  @override
  String get demoFirstHomeTitle => 'As chaves da nossa primeira casa';

  @override
  String get demoFirstHomeStory =>
      'Ainda sem móveis, só caixas, pizza no chão e muitos planos.';

  @override
  String get demoFirstHomePlace => 'Linz';

  @override
  String get demoAlpineSummitTitle => 'Acima das nuvens';

  @override
  String get demoAlpineSummitStory =>
      'Em pé às 4 da manhã para isso. Valeu cada passo.';

  @override
  String get demoAlpineSummitPlace => 'Grossglockner';

  @override
  String get demoFirstBikeTitle => 'Primeira volta, sem as mãos';

  @override
  String get demoFirstBikeStory =>
      'Três pedaladas, uma balançada, e ele foi – todo orgulhoso.';

  @override
  String get demoFirstBikePlace => 'Prater, Viena';

  @override
  String get demoGardenDinnerTitle => 'Os 80 anos do vovô';

  @override
  String get demoGardenDinnerStory =>
      'Quatro gerações numa mesa comprida, e ele ainda contava as melhores histórias.';

  @override
  String get demoGardenDinnerPlace => 'Wachau';

  @override
  String get demoThreadFirstDanceToFirstHome => 'Nossa história';

  @override
  String get demoThreadFirstHomeToNewborn => 'Depois veio a Lina';

  @override
  String get demoThreadNewbornToBeachSunset => 'O primeiro verão dela';

  @override
  String get demoThreadGrandmaKitchenToGardenDinner => 'Família';

  @override
  String get demoThreadGraduationToFirstHome => 'Novo capítulo';

  @override
  String get demoThreadAlpineSummitToFirstBike => 'Pequenas aventuras';

  @override
  String get demoThreadFirstBikeToGardenDinner => 'O vovô assistia';

  @override
  String get demoRelationGrandpa => 'Vovô';

  @override
  String get demoRelationGrandma => 'Vovó';

  @override
  String get demoRelationDaughter => 'Filha';

  @override
  String get demoRelationWife => 'Esposa';

  @override
  String get demoRelationBestMan => 'Padrinho';

  @override
  String get demoRelationMother => 'Mãe';

  @override
  String savedToPath(Object label, Object path) {
    return '$label Salvo em $path';
  }

  @override
  String backupReminder(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memórias ainda não estão em um backup.',
      one: '1 memória ainda não está em um backup.',
    );
    return '$_temp0';
  }

  @override
  String get later => 'Depois';

  @override
  String get backUp => 'Fazer backup';

  @override
  String get onThisDayTitle => 'Neste dia';

  @override
  String onThisDayYearsAgoToday(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Há $years anos, neste dia',
      one: 'Há 1 ano, neste dia',
    );
    return '$_temp0';
  }

  @override
  String onThisDayHeader(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'há $years anos',
      one: 'há 1 ano',
    );
    return 'Neste dia · $_temp0';
  }

  @override
  String get onThisDaySettingsBody =>
      'Nos dias em que uma memória de um ano anterior volta, o LifeThreads envia um lembrete discreto.';

  @override
  String get onThisDayReminderSwitch => 'Lembrete diário';

  @override
  String onThisDayReminderAt(String time) {
    return 'Às $time';
  }

  @override
  String get onThisDayNotificationsDenied =>
      'As notificações do LifeThreads estão desligadas. Permita nos ajustes do celular.';

  @override
  String onThisDayNotificationBody(int years, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'Há $years anos, neste dia: $title',
      one: 'Há 1 ano, neste dia: $title',
    );
    return '$_temp0';
  }

  @override
  String onThisDayNotificationBodyMany(int count, String title) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memórias',
      one: '1 memória',
    );
    return '$title e mais $_temp0 deste dia';
  }

  @override
  String get onThisDayChannelDescription =>
      'Uma memória deste dia em um ano anterior.';

  @override
  String get benefitOnThisDayBody =>
      'Um lembrete quando uma memória de um ano anterior volta, aberta como um capítulo próprio.';

  @override
  String get premiumFeatureStoryImage => 'Imagens de story';

  @override
  String get premiumFeatureStoryVideo => 'Vídeos de story';

  @override
  String get premiumFeatureThreadOfTheYear => 'Fio do Ano';

  @override
  String get premiumFeatureFamilyWall => 'Mural da família';

  @override
  String premiumFeatureNotice(String feature) {
    return '$feature faz parte do Premium.';
  }

  @override
  String get yearThreadTitle => 'Fio do Ano';

  @override
  String yearThreadMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memórias',
      one: '1 memória',
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
      other: '$count pessoas',
      one: '1 pessoa',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count meses',
      one: '1 mês',
    );
    return '$_temp0';
  }

  @override
  String yearThreadMostFelt(String feeling) {
    return 'O que mais sentiu: $feeling';
  }

  @override
  String get yearThreadClosingLine => 'Um ano, costurado.';

  @override
  String get yearThreadMyYear => 'Meu ano';

  @override
  String get yearThreadWallCardTitle => 'Seu ano em memórias';

  @override
  String yearThreadWallCardBody(String year) {
    return 'Transforme $year em um filme curto.';
  }

  @override
  String get yearThreadDismiss => 'Agora não';

  @override
  String get yearThreadSettingsBody =>
      'Transforme qualquer ano com pelo menos 3 memórias em um filme curto, em ordem e ligado pelo fio.';

  @override
  String get yearThreadOpen => 'Criar o filme';

  @override
  String get yearThreadNoYears =>
      'O Fio do Ano precisa de um ano com pelo menos 3 memórias. Continue salvando momentos e volte depois.';

  @override
  String get yearThreadYear => 'Ano';

  @override
  String get yearThreadLength => 'Duração';

  @override
  String yearThreadLengthFull(int seconds) {
    return 'Filme · $seconds s';
  }

  @override
  String get yearThreadLengthStory => 'Story · 20 s';

  @override
  String get yearThreadMusic => 'Música';

  @override
  String get yearThreadNoMusic => 'Sem música';

  @override
  String get yearThreadInFilm => 'No filme';

  @override
  String yearThreadInFilmCount(int count, int max) {
    return '$count de $max';
  }

  @override
  String get yearThreadAddMemory => 'Adicionar uma memória';

  @override
  String get yearThreadSwap => 'Trocar';

  @override
  String get yearThreadRemove => 'Remover';

  @override
  String get yearThreadUseSuggestions => 'Usar sugestões';

  @override
  String yearThreadPickTitle(String year) {
    return 'Escolha uma memória de $year';
  }

  @override
  String get yearThreadNoOthers =>
      'Todas as memórias deste ano já estão no filme.';

  @override
  String yearThreadNeedMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memórias',
      one: '1 memória',
    );
    return 'Escolha pelo menos $_temp0.';
  }

  @override
  String get yearThreadPreview => 'Prévia';

  @override
  String get yearThreadExportVideo => 'Exportar vídeo';

  @override
  String get yearThreadExportImage => 'Exportar imagem';

  @override
  String get yearThreadShare => 'Compartilhar';

  @override
  String get yearThreadSave => 'Salvar no Fotos';

  @override
  String get yearThreadMakingFilm => 'Criando seu filme…';

  @override
  String get yearThreadMakingImage => 'Criando sua imagem…';

  @override
  String get yearThreadFilmReady => 'Seu filme está pronto';

  @override
  String get yearThreadImageReady => 'Sua imagem está pronta';

  @override
  String get yearThreadSaved => 'Salvo nas suas fotos.';

  @override
  String get yearThreadExportFailed => 'Não funcionou. Tente de novo.';

  @override
  String get yearThreadPlay => 'Reproduzir';

  @override
  String get yearThreadPause => 'Pausar';

  @override
  String get createStory => 'Criar story';

  @override
  String get storyPickTitle => 'Escolha memórias';

  @override
  String storyPickBody(int max) {
    return 'Escolha até $max memórias para um story.';
  }

  @override
  String storyPickCount(int count, int max) {
    return '$count de $max escolhidas';
  }

  @override
  String storyPickLimit(int max) {
    return 'Um story tem até $max memórias.';
  }

  @override
  String get storyPickContinue => 'Continuar';

  @override
  String get storyNoMemories =>
      'Salve uma memória primeiro e depois transforme em story.';

  @override
  String get storyEditorTitle => 'Seu story';

  @override
  String get storyChangeMemories => 'Trocar memórias';

  @override
  String get storyTemplateSingle => 'Uma memória';

  @override
  String get storyTemplateThread => 'Mural com fio';

  @override
  String get storyTemplateCollage => 'Colagem';

  @override
  String get storyTemplateQuote => 'Palavras';

  @override
  String get storySwipeHint => 'Deslize para ver outro visual';

  @override
  String get storyCaptionLabel => 'Legenda';

  @override
  String get storyCaptionHint => 'Uma linha da sua história';

  @override
  String get storyVideoSwitch => 'Vídeo';

  @override
  String get storyVideoBody =>
      'Um filme curto para Stories e Reels, com movimento e música.';

  @override
  String get storyMusicTitle => 'Música';

  @override
  String get storyMusicNone => 'Sem música';

  @override
  String get storyMusicNoneHint =>
      'Você também pode adicionar música no Instagram ao postar.';

  @override
  String get storyMoodWarm => 'Carinhosa';

  @override
  String get storyMoodJoyful => 'Alegre';

  @override
  String get storyMoodCalm => 'Tranquila';

  @override
  String get storyMoodNostalgic => 'Nostálgica';

  @override
  String get storyMoodEpic => 'Épica';

  @override
  String get storyMoodEmotional => 'Emocionante';

  @override
  String get storyMusicTrimHint =>
      'Arraste a caixa dourada para escolher o trecho da música';

  @override
  String get storySearchHint => 'Busque memórias, lugares, anos';

  @override
  String storySearchEmpty(String query) {
    return 'Nenhuma memória encontrada para “$query”.';
  }

  @override
  String get storyMemoriesInStory => 'No seu story';

  @override
  String get storyMemoriesReorderHint => 'Segure e arraste para mudar a ordem';

  @override
  String get storyAddMemory => 'Adicionar';

  @override
  String get storyAddMemoryTitle => 'Adicionar uma memória';

  @override
  String storyRemoveMemory(String title) {
    return 'Remover $title do story';
  }

  @override
  String get storyAllMemoriesAdded => 'Todas as memórias já estão neste story.';

  @override
  String get storyShare => 'Compartilhar';

  @override
  String get storySaveToPhotos => 'Salvar no Fotos';

  @override
  String get storySaved => 'Salvo nas suas fotos.';

  @override
  String get storySaveDenied =>
      'O LifeThreads não tem permissão para adicionar às suas fotos. Permita nos ajustes do celular.';

  @override
  String storyExportFailed(String error) {
    return 'Não foi possível criar o story: $error';
  }

  @override
  String get storyRenderingTitle => 'Criando seu filme';

  @override
  String get storyRenderingBody =>
      'Mantenha o LifeThreads aberto, leva alguns segundos.';

  @override
  String storyRenderingPercent(int percent) {
    return '$percent %';
  }

  @override
  String get storyPreviewFree =>
      'A prévia é grátis. Compartilhar e salvar stories faz parte do Premium.';

  @override
  String get benefitStoriesTitle => 'Criar story';

  @override
  String get benefitStoriesBody =>
      'Transforme memórias em imagens de story e filmes curtos com música para Instagram, WhatsApp e mais.';

  @override
  String get musicCreditsTitle => 'Créditos musicais';

  @override
  String get musicCreditsBody =>
      'Músicas incluídas para os vídeos de story, com suas licenças.';

  @override
  String musicCreditLine(String title, String artist, String license) {
    return '$title · $artist · $license';
  }

  @override
  String get benefitYearThreadBody =>
      'Seu ano em um filme curto: os momentos que importaram, em ordem, com música.';

  @override
  String get benefitFamilyTitle => 'Murais de família';

  @override
  String get benefitFamilyBody =>
      'Um mural compartilhado para sua família, com criptografia de ponta a ponta. Cada um adiciona seus momentos.';

  @override
  String get myWall => 'Meu mural';

  @override
  String get myWallSubtitle => 'Privado, neste aparelho';

  @override
  String get switchWall => 'Trocar de mural';

  @override
  String get familyWallsTitle => 'Murais de família';

  @override
  String get familyWallsSettingsBody =>
      'Compartilhe um mural com a família ou os amigos: todos adicionam memórias, com criptografia de ponta a ponta. Meu mural continua privado neste aparelho.';

  @override
  String get familyWallsOpen => 'Abrir murais de família';

  @override
  String get familyWallsManage => 'Gerenciar murais de família';

  @override
  String get familyWallsHeadline => 'Um mural, a família toda';

  @override
  String get familyWallsIntro =>
      'Um mural de família é compartilhado com as pessoas que você convida. Memórias e fotos são criptografadas no seu celular antes do envio; só os membros podem abri-las. Meu mural não é compartilhado e fica neste aparelho.';

  @override
  String get familyUnavailableTitle => 'Ainda não disponível';

  @override
  String get familyUnavailable =>
      'Murais de família ainda não estão disponíveis nesta versão do LifeThreads.';

  @override
  String get familySignInNeededTitle => 'Entre para usar murais de família';

  @override
  String get familySignInNeededBody =>
      'Um mural compartilhado precisa de uma conta para a família saber quem adicionou o quê. Meu mural funciona sem conta.';

  @override
  String get familySignIn => 'Entrar';

  @override
  String get familyLoadFailed => 'Não foi possível carregar';

  @override
  String get familyRetry => 'Tentar de novo';

  @override
  String get familyNoWallsYet =>
      'Ainda não há murais de família. Crie um ou entre com um link de convite.';

  @override
  String get familyStartTitle => 'Criar ou entrar';

  @override
  String get familyStartBody =>
      'Criar um mural de família exige Premium. Entrar é grátis: o Premium de quem cria cobre a família.';

  @override
  String get familyCreateAction => 'Criar mural de família';

  @override
  String get familyCreateTitle => 'Novo mural de família';

  @override
  String get familyNameLabel => 'Nome do mural';

  @override
  String get familyNameHint => 'ex.: Família Silva';

  @override
  String get familyMyNameLabel => 'Seu nome neste mural';

  @override
  String get familyMyNameHelper =>
      'Os membros veem nas suas memórias. É criptografado como tudo no mural.';

  @override
  String get familyMyNameSaved => 'Nome salvo.';

  @override
  String get familySetMyName => 'Meu nome';

  @override
  String get familyCheckingSubscription => 'Verificando seu Premium…';

  @override
  String get familyCreating => 'Criando o mural…';

  @override
  String get familyJoinWithLink => 'Entrar com link';

  @override
  String get familyInviteLinkLabel => 'Link de convite';

  @override
  String get familyJoinTitle => 'Entrar neste mural de família?';

  @override
  String get familyJoinBody =>
      'Os membros vão ver seu nome e as memórias que você adicionar, e você vai ver as deles. Você pode sair quando quiser.';

  @override
  String get familyJoinAction => 'Entrar';

  @override
  String get familyJoining => 'Entrando…';

  @override
  String familyJoined(String family) {
    return 'Você entrou em $family.';
  }

  @override
  String get familyRoleOwner => 'Dono';

  @override
  String get familyRoleMember => 'Membro';

  @override
  String familyMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membros',
      one: '1 membro',
    );
    return '$_temp0';
  }

  @override
  String get familySettingsTitle => 'Ajustes do mural';

  @override
  String familyStorageUsed(String used, String total) {
    return '$used de $total usados';
  }

  @override
  String get familyRename => 'Renomear';

  @override
  String get familyInviteTitle => 'Convidar';

  @override
  String get familyInviteBody =>
      'Envie um link para alguém de confiança. Cada link funciona uma vez e expira em 7 dias.';

  @override
  String get familyInviteAction => 'Criar link de convite';

  @override
  String get familyCreatingInvite => 'Criando o convite…';

  @override
  String get familyInviteReady => 'Link de convite pronto';

  @override
  String get familyInviteValidity =>
      'Funciona uma vez e expira em no máximo 7 dias.';

  @override
  String get familyInviteKeyWarning =>
      'O link leva a chave do mural: quem abrir pode entrar e ler o mural. Envie só para a pessoa que você convida.';

  @override
  String get familyInviteShare => 'Compartilhar link';

  @override
  String get familyInviteCopy => 'Copiar link';

  @override
  String get familyInviteCopied => 'Link copiado.';

  @override
  String get familyInviteShareFailed =>
      'Compartilhar não está disponível. Copie o link.';

  @override
  String familyInviteSubject(String family) {
    return 'Entre em $family no LifeThreads';
  }

  @override
  String familyInviteText(String family, String link) {
    return 'Entre no nosso mural de família “$family” no LifeThreads: $link';
  }

  @override
  String get familyMembersTitle => 'Membros';

  @override
  String get familyMemberActions => 'Ações do membro';

  @override
  String get familyYou => 'Você';

  @override
  String familyYouNamed(String name) {
    return '$name (você)';
  }

  @override
  String get familyAMember => 'Um membro';

  @override
  String get familyFormerMember => 'Ex-membro';

  @override
  String get familyBlocked => 'Bloqueado';

  @override
  String get familyBlock => 'Bloquear';

  @override
  String get familyUnblock => 'Desbloquear';

  @override
  String familyBlockAuthor(String name) {
    return 'Bloquear $name';
  }

  @override
  String familyBlockQuestion(String name) {
    return 'Bloquear $name?';
  }

  @override
  String get familyBlockBody =>
      'Você não vai mais ver as memórias dessa pessoa em nenhum mural de família. Ela não é avisada. Você pode desbloquear na lista de membros.';

  @override
  String get familyReport => 'Denunciar';

  @override
  String get familyRemoveMember => 'Remover do mural';

  @override
  String familyRemoveQuestion(String name) {
    return 'Remover $name?';
  }

  @override
  String get familyRemoveBody =>
      'Essa pessoa perde o acesso a este mural. Convide de novo para ela voltar.';

  @override
  String get familyRemoveDeleteContent =>
      'Excluir também as memórias que ela adicionou';

  @override
  String get familyDeleteTitle => 'Excluir mural de família';

  @override
  String get familyDeleteBody =>
      'Como dono, você não pode sair do mural; pode excluí-lo para todos.';

  @override
  String get familyDeleteAction => 'Excluir mural';

  @override
  String familyDeleteQuestion(String family) {
    return 'Excluir $family?';
  }

  @override
  String get familyDeleteConfirmBody =>
      'Todas as memórias e fotos deste mural são excluídas dos nossos servidores para todos os membros. Não dá para desfazer. As memórias do Meu mural não são afetadas.';

  @override
  String get familyDeleting => 'Excluindo…';

  @override
  String get familyLeaveTitle => 'Sair do mural de família';

  @override
  String get familyLeaveBody =>
      'Você deixa de ver este mural. Pode manter ou excluir as memórias que adicionou.';

  @override
  String get familyLeaveAction => 'Sair';

  @override
  String familyLeaveQuestion(String family) {
    return 'Sair de $family?';
  }

  @override
  String get familyLeaveConfirmBody =>
      'Para voltar, você vai precisar de um novo convite.';

  @override
  String get familyLeaveDeleteMine =>
      'Excluir também as memórias que adicionei';

  @override
  String get familyLeaving => 'Saindo…';

  @override
  String get familySignInTitle => 'Entrar';

  @override
  String get familySignInHeadline => 'Uma conta para murais de família';

  @override
  String get familySignInWhy =>
      'Um mural de família é compartilhado, então precisa de uma conta: os membros veem quem adicionou cada memória, e só os membros podem abrir o mural.';

  @override
  String get familySignInMyWallStays =>
      'Meu mural não precisa de conta. Ele continua privado neste aparelho e nunca é enviado.';

  @override
  String get familySignInEncrypted =>
      'Memórias e fotos da família têm criptografia de ponta a ponta. A GK Coding armazena, mas não consegue ler.';

  @override
  String get familySignInWhatWeGet =>
      'Da Apple ou do Google usamos só um ID de conta, não seus contatos nem suas fotos.';

  @override
  String get familySignInApple => 'Entrar com a Apple';

  @override
  String get familySignInGoogle => 'Entrar com o Google';

  @override
  String get familySignInFinePrint =>
      'Ao entrar, você aceita os Termos de uso e a Política de privacidade. Você pode excluir sua conta no app a qualquer momento.';

  @override
  String get familyAccountTitle => 'Conta';

  @override
  String get familySignedOutTitle => 'Você não entrou';

  @override
  String get familySignedOutBody =>
      'Entre para ver seus murais de família. Meu mural funciona sem conta.';

  @override
  String get familySignedInTitle => 'Conectado';

  @override
  String get familySignedInBody =>
      'Sua conta é usada só para murais de família.';

  @override
  String familyAccountId(String id) {
    return 'ID da conta: $id';
  }

  @override
  String get familySignOut => 'Sair da conta';

  @override
  String get familySignOutQuestion => 'Sair da conta?';

  @override
  String get familySignOutBody =>
      'Os murais de família e suas chaves são removidos deste aparelho até você entrar de novo. Nada é excluído no servidor. Meu mural não é afetado.';

  @override
  String get familySigningOut => 'Saindo da conta…';

  @override
  String get familyDeleteAccountTitle => 'Excluir conta';

  @override
  String get familyDeleteAccountBody =>
      'Exclui sua conta e os dados dos seus murais de família dos nossos servidores. Meu mural fica neste aparelho.';

  @override
  String get familyDeleteAccount => 'Excluir conta';

  @override
  String get familyDeleteAccountQuestion => 'Excluir sua conta?';

  @override
  String familyDeleteAccountOwned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Os $count murais de família que você criou são excluídos para todos os membros, com todas as memórias e fotos.',
      one:
          'O mural de família que você criou é excluído para todos os membros, com todas as memórias e fotos.',
      zero: 'Você não é dono de nenhum mural de família.',
    );
    return '$_temp0';
  }

  @override
  String get familyDeleteAccountPosts =>
      'As memórias e fotos que você adicionou aos murais de outras famílias são excluídas, e você sai desses murais.';

  @override
  String get familyDeleteAccountKeys =>
      'As chaves dos murais de família e as fotos em cache são removidas deste aparelho. Não dá para desfazer.';

  @override
  String get familyDeleteAccountMyWall =>
      'Meu mural não é afetado: as memórias dele ficam neste aparelho.';

  @override
  String get familyDeleteAccountSubscription =>
      'Isso não cancela uma assinatura Premium; gerencie na App Store ou no Google Play.';

  @override
  String get familyDeleteAccountUnderstood =>
      'Entendo que isso exclui minha conta para sempre.';

  @override
  String get familyDeletingAccount => 'Excluindo sua conta…';

  @override
  String get familyAccountDeleted => 'Sua conta foi excluída.';

  @override
  String get familyTermsTitle => 'Regras do mural de família';

  @override
  String get familyTermsHeadline => 'Antes de compartilhar';

  @override
  String get familyTermsIntro =>
      'Murais de família são para as pessoas que você convida. Para mantê-los seguros, todos aceitam estas regras:';

  @override
  String get familyTermsZeroTolerance =>
      'Tolerância zero com conteúdo ofensivo: nada de assédio, ódio, conteúdo sexual, violência, automutilação, conteúdo ilegal ou informações privadas de outras pessoas sem consentimento.';

  @override
  String get familyTermsOwnContent =>
      'Compartilhe só fotos e histórias que você tem direito de compartilhar.';

  @override
  String get familyTermsReport =>
      'Denuncie qualquer memória ou membro pelo mural. A GK Coding analisa as denúncias em até 24 horas.';

  @override
  String get familyTermsBlock =>
      'Bloqueie um membro para não ver mais as memórias dele.';

  @override
  String get familyTermsOwner =>
      'O dono de um mural pode remover membros e as memórias deles.';

  @override
  String get familyTermsConsequences =>
      'Conteúdo que viola estas regras é removido, e as contas que o publicaram podem ser suspensas ou excluídas.';

  @override
  String get familyTermsReadFull => 'Ler os termos completos';

  @override
  String get familyTermsAgree => 'Aceito os Termos de uso e estas regras.';

  @override
  String get familyTermsAccept => 'Aceitar e continuar';

  @override
  String familyTermsVersion(String version) {
    return 'Versão dos termos $version';
  }

  @override
  String get familyWallEmptyTitle => 'O mural está esperando';

  @override
  String get familyWallEmptyBody =>
      'Adicione a primeira memória. Todos neste mural vão ver.';

  @override
  String get familyWallGoneBody =>
      'Este mural de família não está mais disponível para você. Ele pode ter sido excluído, ou você foi removido.';

  @override
  String get familyAddMemory => 'Adicionar memória';

  @override
  String get familyRefresh => 'Atualizar';

  @override
  String get familySyncing => 'Sincronizando…';

  @override
  String get familyOffline => 'Offline: mostrando memórias salvas';

  @override
  String get familySyncFailed => 'Falha na sincronização';

  @override
  String get familyMemoryTitle => 'Memória';

  @override
  String get familyMemoryGone => 'Esta memória não está mais no mural.';

  @override
  String get familyMemoryActions => 'Ações da memória';

  @override
  String familyAddedBy(String name) {
    return 'Adicionada por $name';
  }

  @override
  String get familyDeleteMemoryQuestion => 'Excluir esta memória?';

  @override
  String get familyDeleteMemoryBody =>
      'Ela é removida do mural para todos, com as fotos.';

  @override
  String familyDeleteMemoryAsOwnerBody(String name) {
    return 'Como dono, você pode remover memórias deste mural. Esta memória de $name é removida para todos, com as fotos.';
  }

  @override
  String get familyDeletingMemory => 'Excluindo a memória…';

  @override
  String get familyNoPhotosYet => 'Ainda sem fotos';

  @override
  String get familyPostNote =>
      'Todos neste mural vão ver esta memória. As fotos são reduzidas e criptografadas no seu celular antes do envio.';

  @override
  String get familyPost => 'Publicar';

  @override
  String get familyPostMemory => 'Publicar no mural';

  @override
  String get familyUploading => 'Criptografando e enviando…';

  @override
  String get familyMemorySaved => 'Salvo no mural de família.';

  @override
  String get familyConflictTitle => 'Alterada por outra pessoa';

  @override
  String get familyConflictBody =>
      'Esta memória mudou em outro aparelho enquanto você editava. Carregar a versão mais recente e salvar suas alterações por cima?';

  @override
  String get familyConflictRetry => 'Atualizar e salvar';

  @override
  String get familyQuotaTitle => 'O mural está cheio';

  @override
  String get familyReportMemoryTitle => 'Denunciar memória';

  @override
  String get familyReportPhotoTitle => 'Denunciar foto';

  @override
  String get familyReportMemberTitle => 'Denunciar membro';

  @override
  String get familyReportIntro =>
      'Conte o que está errado. Sua denúncia vai para a GK Coding, não para a pessoa denunciada.';

  @override
  String get familyReportSpam => 'Spam ou golpe';

  @override
  String get familyReportHarassment => 'Assédio ou bullying';

  @override
  String get familyReportHate => 'Discurso de ódio';

  @override
  String get familyReportSexual => 'Conteúdo sexual ou nudez';

  @override
  String get familyReportViolence => 'Violência ou ameaças';

  @override
  String get familyReportSelfHarm => 'Automutilação ou suicídio';

  @override
  String get familyReportIllegal => 'Conteúdo ilegal';

  @override
  String get familyReportPrivacy =>
      'Informações privadas compartilhadas sem consentimento';

  @override
  String get familyReportOther => 'Outra coisa';

  @override
  String get familyReportDetailsLabel => 'Detalhes (opcional)';

  @override
  String get familyReportDetailsHint => 'O que devemos saber?';

  @override
  String familyReportAlsoBlock(String name) {
    return 'Bloquear também $name';
  }

  @override
  String get familyReportSend => 'Enviar denúncia';

  @override
  String get familyReportReviewNote =>
      'A GK Coding analisa cada denúncia em até 24 horas e remove conteúdos e membros que violam as regras.';

  @override
  String get familyReportSentTitle => 'Obrigado';

  @override
  String get familyReportSentBody =>
      'Sua denúncia foi enviada. A GK Coding analisa em até 24 horas e age contra conteúdos que violam as regras.';

  @override
  String get familyErrorGeneric => 'Algo deu errado. Tente de novo.';

  @override
  String get familyErrorOffline =>
      'Parece que você está offline. Verifique a conexão e tente de novo.';

  @override
  String get familyErrorSubscriptionRequired =>
      'Isso exige uma assinatura Premium ativa do dono do mural.';

  @override
  String get familyErrorInviteExpired =>
      'Este convite expirou. Peça um novo link.';

  @override
  String get familyErrorInviteUsed =>
      'Este convite já foi usado. Cada link funciona uma vez; peça um novo.';

  @override
  String get familyErrorInviteInvalid =>
      'Este não é um link de convite válido do LifeThreads.';

  @override
  String get familyErrorAlreadyMember =>
      'Você já é membro deste mural de família.';

  @override
  String get familyErrorFamilyFull =>
      'Este mural de família chegou ao limite de membros.';

  @override
  String get familyErrorQuotaExceeded =>
      'Este mural de família está sem espaço. Exclua algumas memórias ou fotos para liberar espaço.';

  @override
  String get familyErrorVersionConflict =>
      'Alguém mudou esta memória antes. Atualize e tente de novo.';

  @override
  String get familyErrorTermsRequired =>
      'Aceite primeiro as regras do mural de família.';

  @override
  String get familyErrorSignedOut => 'Você saiu da conta. Entre de novo.';

  @override
  String get familyErrorNotAllowed =>
      'Você não tem permissão para fazer isso neste mural.';

  @override
  String get familyErrorNotFound => 'Mural de família não encontrado';

  @override
  String get familyErrorOwnerCannotLeave =>
      'O dono não pode sair do mural, mas pode excluí-lo.';

  @override
  String get familyPaste => 'Colar';

  @override
  String get familyErrorInviteRevoked =>
      'Este convite foi retirado. Peça um novo link.';

  @override
  String get familyErrorKeyMissing =>
      'Este aparelho não tem a chave deste mural de família (por exemplo, depois de reinstalar ou em um celular novo). Peça a um membro um novo link de convite: abri-lo restaura o acesso.';

  @override
  String get familyErrorSignInUnavailable =>
      'Entrar não está disponível neste aparelho agora.';

  @override
  String get familyErrorNoPurchase =>
      'Nenhuma compra do Premium foi encontrada para esta conta da App Store ou do Google Play. Assine o Premium primeiro e tente de novo.';

  @override
  String get familyErrorVerificationUnavailable =>
      'Não foi possível verificar seu Premium agora. Tente mais tarde.';

  @override
  String get familyErrorPurchaseLinkedElsewhere =>
      'Esta compra do Premium já está vinculada a outra conta de mural de família. Entre com essa conta ou fale com info@gkcoding.dev.';

  @override
  String get familyErrorNameTooLong =>
      'Esse nome é longo demais. Use um mais curto.';

  @override
  String get familyErrorContentNotAllowed =>
      'Isso tem palavras que não são permitidas nos murais de família. Mude o texto e tente de novo.';

  @override
  String get familyErrorPhotoUnreadable =>
      'Não foi possível ler uma das fotos. Remova-a e tente de novo.';

  @override
  String get familyErrorTooLarge =>
      'É grande demais para enviar. Tente menos fotos ou fotos menores.';

  @override
  String get familyReportEvidenceNote =>
      'Para analisar, a GK Coding recebe o título e a história desta memória junto com a denúncia. As fotos nunca são enviadas.';

  @override
  String get moveLeft => 'Mover para a esquerda';

  @override
  String get moveUp => 'Mover para cima';

  @override
  String get moveDown => 'Mover para baixo';

  @override
  String get moveRight => 'Mover para a direita';

  @override
  String get showPassword => 'Mostrar senha';

  @override
  String get hidePassword => 'Ocultar senha';

  @override
  String get removePerson => 'Remover pessoa';

  @override
  String get draftKept =>
      'Guardado como rascunho – vai estar aqui da próxima vez.';

  @override
  String get draftResumeTitle => 'Continuar de onde parou?';

  @override
  String draftResumeBody(String date) {
    return 'Você começou uma memória em $date e ainda não salvou.';
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
  String get draftContinue => 'Continuar rascunho';

  @override
  String get draftStartNew => 'Começar nova';

  @override
  String get lookBackMenu => 'Relembrar um mês';

  @override
  String lookBackTitle(String month) {
    return 'Seu $month';
  }

  @override
  String get lookBackWallCardTitle => 'Seu mês em memórias';

  @override
  String lookBackWallCardBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memórias',
      one: '1 memória',
    );
    return '$month: $_temp0';
  }

  @override
  String lookBackMemories(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memórias',
      one: '1 memória',
    );
    return '$_temp0';
  }

  @override
  String lookBackPeople(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pessoas',
      one: '1 pessoa',
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
  String get lookBackPeopleHeading => 'Quem estava lá';

  @override
  String get lookBackPlacesHeading => 'Onde você esteve';

  @override
  String lookBackEmpty(String month) {
    return 'Nada salvo de $month ainda.';
  }

  @override
  String get lookBackEmptyHint => 'Memórias com data deste mês aparecem aqui.';

  @override
  String get lookBackPreviousMonth => 'Mês anterior';

  @override
  String get lookBackNextMonth => 'Próximo mês';

  @override
  String lookBackNotificationBody(String month, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count memórias',
      one: '1 memória',
    );
    return '$month: $_temp0 para relembrar.';
  }

  @override
  String get lookBackNotificationPrivate => 'Seu mês em memórias está pronto.';

  @override
  String get homeWidgetLocked => 'Abra o LifeThreads para ver suas memórias.';

  @override
  String get homeWidgetSettingsTitle => 'Widget da tela de início';

  @override
  String get homeWidgetSettingsSubtitle => 'Quais memórias ele mostra';

  @override
  String get homeWidgetPreviewTitle => 'Hoje no seu widget';

  @override
  String get homeWidgetSourceTitle => 'Quais memórias';

  @override
  String get homeWidgetAllWalls => 'Todos os meus murais';

  @override
  String get homeWidgetOrderTitle => 'Aparecem primeiro';

  @override
  String get homeWidgetOnThisDayFirst => 'Neste dia primeiro';

  @override
  String get homeWidgetOnThisDayFirstBody =>
      'Uma memória deste dia em um ano anterior vem primeiro.';

  @override
  String get homeWidgetPhotosFirst => 'Memórias com fotos primeiro';

  @override
  String get homeWidgetPhotosFirstBody =>
      'As outras só quando nenhuma tem foto.';

  @override
  String get homeWidgetHowToTitle => 'Adicione à tela de início';

  @override
  String get homeWidgetHowToIos =>
      'Mantenha pressionado o ícone do LifeThreads na tela de início e escolha um tamanho de widget. Ou mantenha pressionado um espaço vazio, toque em Editar › Adicionar Widget e escolha LifeThreads.';

  @override
  String get homeWidgetHowToAndroid =>
      'Mantenha pressionado um espaço vazio na tela de início, toque em Widgets e arraste o LifeThreads para onde quiser.';

  @override
  String get homeWidgetPrivacyNote =>
      'Memórias ocultas nunca aparecem no widget. Com o bloqueio do app ligado, ele não mostra nenhuma memória.';

  @override
  String get yearThreadAlmostThere => 'Quase lá';

  @override
  String get yearThreadMemoriesFrom => 'Memórias de';

  @override
  String yearThreadAddMemoryTo(String year) {
    return 'Adicione uma memória a $year';
  }

  @override
  String get onboardingHangTitle => 'Pendure suas memórias';

  @override
  String get onboardingHangText =>
      'Uma foto, um lugar, as pessoas que estavam lá – seu mural cresce com a sua vida.';

  @override
  String get onboardingConnectTitle => 'Ligue tudo com fios';

  @override
  String get onboardingConnectText =>
      'Diga por que dois momentos andam juntos. Os fios mostram como sua história se encaixa.';

  @override
  String get onboardingComeBackTitle => 'As memórias voltam para você';

  @override
  String get onboardingComeBackText =>
      'Neste dia, seu mês relembrado, seu ano como filme – e um widget na tela de início.';

  @override
  String get onboardingPrivateText =>
      'Sem conta. Tudo fica no seu celular – com Face ID, se quiser.';

  @override
  String get onboardingNameStaysHere =>
      'Só para te cumprimentar – fica neste celular.';

  @override
  String get tutorialLookBackTitle => 'Busque e relembre';

  @override
  String get tutorialLookBackText =>
      'Busque por título, lugar, pessoa ou ano. Mais › Relembrar um mês mostra as memórias de um mês; Mais › Fio do Ano transforma um ano em filme.';

  @override
  String get tutorialStoryTitle => 'Crie um story';

  @override
  String get tutorialStoryText =>
      'Mais › Criar story: escolha memórias, um modelo e música, depois compartilhe como imagem ou vídeo.';

  @override
  String get tutorialWallsTitle => 'Murais e memórias ocultas';

  @override
  String get tutorialWallsText =>
      'Mais › Novo mural separa viagens ou fases (Premium). Segure um card › Ocultar tira ele de vista; Ver › Memórias ocultas mostra depois do Face ID.';

  @override
  String get tutorialFamilyTitle => 'Compartilhe com a família';

  @override
  String get tutorialFamilyText =>
      'Mais › Murais de família: um mural para a família toda, com criptografia de ponta a ponta. Convide outros com um link.';

  @override
  String get tutorialWidgetTitle => 'Uma memória na tela de início';

  @override
  String get tutorialWidgetText =>
      'Adicione o widget do LifeThreads: uma memória diferente todo dia. Ajustes › Widget da tela de início escolhe quais.';

  @override
  String photoNumber(int number) {
    return 'Foto $number';
  }

  @override
  String get familyDisplayNameNotSaved =>
      'Não foi possível salvar seu nome neste mural. Você pode definir nos ajustes do mural.';

  @override
  String importBackupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ele tem $count memórias.',
      one: 'Ele tem 1 memória.',
    );
    return '$_temp0 Memórias que já estão nos seus murais são mantidas e não são duplicadas.';
  }

  @override
  String get importAction => 'Importar';

  @override
  String get familyRemovingMember => 'Removendo e protegendo o mural…';

  @override
  String get tourSkip => 'Pular';

  @override
  String get tourNext => 'Próximo';

  @override
  String get tourDone => 'OK';

  @override
  String get tourTapIt => 'Toque aqui';

  @override
  String get tourEnd => 'Encerrar tour';

  @override
  String get tourShowMeHow => 'Me mostre como';

  @override
  String get tourShowMeHowSubtitle => 'Um tour rápido com memórias de exemplo';

  @override
  String get tourWelcomeTitle => 'Boas-vindas ao seu mural';

  @override
  String get tourWelcomeBody =>
      'Vamos conhecer o LifeThreads juntos com memórias e fotos de exemplo. Siga o anel dourado. No fim, você decide se fica com elas.';

  @override
  String get tourCardTitle => 'Cada card é uma memória';

  @override
  String get tourCardBody =>
      'Fotos, uma história, o lugar e como foi. Arraste os cards para organizar, faça pinça para dar zoom. Toque neste para abrir.';

  @override
  String get tourConnectTitle => 'Conecte memórias';

  @override
  String get tourConnectBody =>
      'Os fios unem momentos: uma viagem a uma pessoa, um lugar a um sentimento. Toque em Conectar.';

  @override
  String get tourConnectionsTitle => 'Escolha o que combina';

  @override
  String get tourConnectionsBody =>
      'Escolha outras memórias e escreva por que elas andam juntas. O fio então fica pendurado entre os cards no seu mural.';

  @override
  String get tourAddTitle => 'Salve um novo momento';

  @override
  String get tourAddBody => 'Toque em + para adicionar algo ao seu mural.';

  @override
  String get tourAddMemoryTitle => 'Uma memória';

  @override
  String get tourAddMemoryBody =>
      'Escolha Memória. Você também pode prender uma nota ou um prego para agrupar cards.';

  @override
  String get tourAddTextTitle => 'Algumas palavras bastam';

  @override
  String get tourAddTextBody =>
      'Colocamos uma foto de exemplo e um título para você. Normalmente você escolhe suas fotos ou tira uma. A data e o lugar vêm da foto.';

  @override
  String get tourSaveTitle => 'Pendure no mural';

  @override
  String get tourSaveBody =>
      'Toque em Salvar agora. Sentimentos, pessoas e fios podem vir depois.';

  @override
  String get tourCameraTitle => 'Foto rápida';

  @override
  String get tourCameraBody =>
      'A câmera salva um momento na hora. As palavras você adiciona depois.';

  @override
  String get tourViewTitle => 'Visualizações diferentes';

  @override
  String get tourViewBody => 'Toque em Ver.';

  @override
  String get tourViewModesTitle => 'Mural, linha do tempo, mapa';

  @override
  String get tourViewModesBody =>
      'Veja sua vida como mural, linha do tempo ou num mapa. Filtre por categoria aqui e mostre memórias ocultas (com Face ID).';

  @override
  String get tourViewDoneTitle => 'De volta ao mural';

  @override
  String get tourViewDoneBody => 'Toque em OK.';

  @override
  String get tourSearchTitle => 'Encontre qualquer memória';

  @override
  String get tourSearchBody =>
      'Digite aqui um nome, lugar, pessoa ou ano. Os resultados aparecem enquanto você digita.';

  @override
  String get tourMoreTitle => 'Todo o resto';

  @override
  String get tourMoreBody =>
      'Stories, seu ano, relembrar, mais murais e ajustes estão neste menu. Toque nele.';

  @override
  String get tourStoryTitle => 'Crie um story';

  @override
  String get tourStoryBody => 'Toque em Criar story.';

  @override
  String get tourYearTitle => 'Fio do Ano';

  @override
  String get tourYearBody =>
      'Seu ano em um filme curto com música: suas memórias em ordem, depois os lugares, pessoas e sentimentos do ano (Premium).';

  @override
  String get tourLookBackTitle => 'Relembrar um mês';

  @override
  String get tourLookBackBody =>
      'Cada mês em memórias, com as pessoas e os lugares dele. Neste dia lembra você de anos anteriores (Premium).';

  @override
  String get tourWallsTitle => 'Mais murais';

  @override
  String get tourWallsBody =>
      'Um mural para cada filho, viagem ou projeto (Premium). Toque no nome lá em cima para trocar de mural.';

  @override
  String get tourFamilyTitle => 'Murais de família';

  @override
  String get tourFamilyBody =>
      'Um mural compartilhado onde todos adicionam seus momentos, com criptografia de ponta a ponta. Só quem cria precisa do Premium; a família entra grátis.';

  @override
  String get tourSettingsTitle => 'Ajustes';

  @override
  String get tourSettingsBody =>
      'Faça backup de tudo de graça, bloqueie o app com Face ID, configure o widget e o Neste dia, e escolha seu idioma.';

  @override
  String get tourFinishTitle => 'Pronto!';

  @override
  String get tourFinishBody =>
      'Agora você já sabe usar. Deixe o mural com a sua cara.';

  @override
  String get tourDemoPhotoTitle => 'Um dia no lago';

  @override
  String get tourRemoveDemoTitle => 'Começar seu próprio mural?';

  @override
  String get tourRemoveDemoBody =>
      'O tour usou memórias e fotos de exemplo. Remover agora e começar com suas próprias fotos?';

  @override
  String get tourRemoveDemoRemove => 'Remover e começar';

  @override
  String get tourRemoveDemoKeep => 'Manter por enquanto';

  @override
  String get tourRemovedToast =>
      'Memórias de exemplo removidas. Seu mural está pronto.';

  @override
  String get storyTemplatePolaroid => 'Polaroid';

  @override
  String get storyTemplateAlbum => 'Álbum';

  @override
  String get storyTemplateFilmstrip => 'Filme fotográfico';

  @override
  String get storyTemplateTimeline => 'Viagem no tempo';

  @override
  String get storyTemplatePostcard => 'Cartão-postal';

  @override
  String get storyTemplateCinema => 'Cinema';

  @override
  String get storyTemplateSingleHint =>
      'Cada memória em tela cheia, uma após a outra';

  @override
  String get storyTemplateThreadHint => 'Cards no mural, ligados pelo fio';

  @override
  String get storyTemplateCollageHint => 'Todas as fotos juntas em uma grade';

  @override
  String get storyTemplateQuoteHint => 'Suas palavras se escrevem sozinhas';

  @override
  String get storyTemplatePolaroidHint => 'Fotos instantâneas caem numa pilha';

  @override
  String get storyTemplateAlbumHint => 'As páginas viram, uma foto por página';

  @override
  String get storyTemplateFilmstripHint => 'Um filme passa e dá zoom';

  @override
  String get storyTemplateTimelineHint => 'Os anos avançam até cada memória';

  @override
  String get storyTemplatePostcardHint =>
      'Cada cartão vira e mostra sua história';

  @override
  String get storyTemplateCinemaHint => 'Letreiros, zoom lento e créditos';

  @override
  String get storyAnimationTitle => 'Animação';

  @override
  String get storyAnimationPageTitle => 'Escolha uma animação';

  @override
  String get storyAnimationExamples =>
      'Com fotos de exemplo. Seu story usa suas memórias.';

  @override
  String get storyMusicPageTitle => 'Música e duração';

  @override
  String get storyLengthTitle => 'Duração';

  @override
  String get storyLengthAuto => 'Auto';

  @override
  String storyLengthSeconds(Object seconds) {
    return '$seconds s';
  }

  @override
  String get storyMusicAll => 'Todas';

  @override
  String get storyMusicPlay => 'Reproduzir';

  @override
  String get storyMusicPause => 'Pausar';

  @override
  String storyMusicPlayhead(Object song, Object video) {
    return 'Música $song ▸ Vídeo $video';
  }

  @override
  String get storyMusicSyncHint =>
      'A linha branca mostra qual segundo da música toca com o vídeo. As marcas mostram onde cada memória começa.';

  @override
  String get storyMusicLengthHint =>
      'Auto se ajusta ao número de memórias. Filmes mais longos andam mais devagar.';

  @override
  String get tourBack => 'Voltar';

  @override
  String get tourStoryPickTitle => 'Escolha memórias';

  @override
  String get tourStoryPickBody =>
      'Escolhemos três para você. Você pode escolher até seis. Toque em Continuar.';

  @override
  String get tourStoryAnimationTitle => 'Escolha o movimento';

  @override
  String get tourStoryAnimationBody =>
      'Animações de Polaroid a Cinema. Toque em Animação.';

  @override
  String get tourStoryStyleTitle => 'Experimente Polaroid';

  @override
  String get tourStoryStyleBody =>
      'Cada quadro toca uma prévia. Toque em Polaroid.';

  @override
  String get tourStoryMusicTitle => 'Adicione música';

  @override
  String get tourStoryMusicBody =>
      'Escolha uma música e quanto tempo o vídeo dura. Toque em Música.';

  @override
  String get tourStoryTrimTitle => 'Música e vídeo sincronizados';

  @override
  String get tourStoryTrimBody =>
      'Arraste a caixa dourada para escolher o trecho da música. A linha branca anda com o vídeo, então você vê qual segundo toca em cada momento.';

  @override
  String get tourStoryMusicDoneTitle => 'Volte ao seu story';

  @override
  String get tourStoryMusicDoneBody => 'Toque em OK.';

  @override
  String get tourStoryShareTitle => 'Compartilhe ou salve';

  @override
  String get tourStoryShareBody =>
      'Pronto para Instagram, WhatsApp e mais. Salvar e compartilhar fazem parte do Premium.';

  @override
  String get tourMoreAgainTitle => 'Mais no menu';

  @override
  String get tourMoreAgainBody => 'Abra o menu mais uma vez. Toque nele.';

  @override
  String get scannerStep1 => 'Numa TV, computador ou tablet, abra o navegador.';

  @override
  String scannerStep2(Object url) {
    return 'Acesse $url. Um QR code vai aparecer lá.';
  }

  @override
  String get scannerStep3 =>
      'Segure este celular para o código ficar dentro da moldura dourada. Seu mural aparece lá por um tempo, só para ver.';

  @override
  String get scannerShareLink => 'Enviar link';

  @override
  String get scannerCopyLink => 'Copiar link';

  @override
  String get scannerLinkCopied => 'Link copiado';

  @override
  String get storyTemplateScrapbook => 'Scrapbook';

  @override
  String get storyTemplateMosaic => 'Mosaico';

  @override
  String get storyTemplateContactSheet => 'Folha de contato';

  @override
  String get storyTemplateWallFlight => 'Voo pelo mural';

  @override
  String get storyTemplateCarousel => 'Carrossel';

  @override
  String get storyTemplateJourney => 'Roteiro';

  @override
  String get storyTemplateScrapbookHint =>
      'Cada foto colada com fita numa página';

  @override
  String get storyTemplateMosaicHint => 'Uma foto grande, as outras em volta';

  @override
  String get storyTemplateContactSheetHint =>
      'Cada memória, um quadro do filme';

  @override
  String get storyTemplateWallFlightHint => 'Voa pelo fio de card em card';

  @override
  String get storyTemplateCarouselHint =>
      'Os cards giram, um de cada vez na frente';

  @override
  String get storyTemplateJourneyHint =>
      'Uma rota pelo mapa, um alfinete em cada lugar';

  @override
  String get storyModePicture => 'Imagem';

  @override
  String get storyModeVideo => 'Vídeo';

  @override
  String get storyModePictureHint =>
      'Uma imagem com todas as suas memórias, para posts e stories.';

  @override
  String get storyModeVideoHint => 'Um filme curto com movimento e música.';

  @override
  String get storyLayoutTitle => 'Layout';

  @override
  String get storyLayoutPageTitle => 'Escolha um layout';

  @override
  String get storyChoosePhoto => 'Escolha a foto para o story';

  @override
  String get wallTidyUp => 'Organizar o mural';

  @override
  String get wallTidyUpBody =>
      'Pendurar todos os cartões em fileiras, da memória mais antiga à mais recente? Notas e pregos ficam onde estão.';

  @override
  String get wallTidyUpAction => 'Organizar';

  @override
  String get wallTidiedToast => 'Seu mural está organizado.';

  @override
  String get storyFormatTitle => 'Formato';

  @override
  String get storyFormatStory => 'Story 9:16';

  @override
  String get storyFormatPost => 'Post 4:5';

  @override
  String get storyFormatSquare => 'Quadrado 1:1';
}
