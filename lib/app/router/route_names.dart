class RouteNames {
  const RouteNames._();

  static const home = '/';
  static const wall = '/wall';
  static const settings = '/settings';
  static const themes = '/settings/themes';
  static const backupData = '/settings/backup';
  static const aboutHelp = '/settings/about';
  static const upgrade = '/upgrade';
  static const search = '/search';
  static const archiveTransfer = '/archive/transfer';
  static const addMemory = '/memories/new';
  static const memoryDetail = '/memories/:id';
  static const editMemory = '/memories/:id/edit';
  static const manageConnections = '/memories/:id/connections';
  static const capsuleCinema = '/capsule/cinema';
  static const yearThread = '/year-thread';
  static const createStory = '/stories/new';
  static const familyWalls = '/family';
  static const familyAccount = '/family/account';
  static const familyWall = '/family/wall/:familyId';
  static const familySettings = '/family/wall/:familyId/settings';
  static const familyAddMemory = '/family/wall/:familyId/memories/new';
  static const familyMemoryDetail = '/family/wall/:familyId/memories/:memoryId';
  static const familyEditMemory =
      '/family/wall/:familyId/memories/:memoryId/edit';

  static String yearThreadFor(int year) => '$yearThread?year=$year';

  static String familyWallFor(String familyId) =>
      '/family/wall/${Uri.encodeComponent(familyId)}';
  static String familySettingsFor(String familyId) =>
      '${familyWallFor(familyId)}/settings';
  static String familyAddMemoryFor(String familyId) =>
      '${familyWallFor(familyId)}/memories/new';
  static String familyMemoryFor(String familyId, String memoryId) =>
      '${familyWallFor(familyId)}/memories/${Uri.encodeComponent(memoryId)}';
  static String familyEditMemoryFor(String familyId, String memoryId) =>
      '${familyMemoryFor(familyId, memoryId)}/edit';
}
