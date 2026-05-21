import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/app_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../features/backup/domain/backup_models.dart';
import '../../../../features/backup/presentation/widgets/archive_feedback.dart';
import '../../../../features/capsule/data/memory_capsule_service.dart';
import '../../../../features/capsule/data/memory_capsule_share_download_service.dart';
import '../../../../features/capsule/domain/memory_capsule_models.dart';
import '../../../../features/capsule/presentation/widgets/memory_capsule_dialogs.dart';
import '../../../../features/memories/data/memory_repository.dart';

class MemoryCapsuleDeepLinkListener extends ConsumerStatefulWidget {
  const MemoryCapsuleDeepLinkListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MemoryCapsuleDeepLinkListener> createState() =>
      _MemoryCapsuleDeepLinkListenerState();
}

class _MemoryCapsuleDeepLinkListenerState
    extends ConsumerState<MemoryCapsuleDeepLinkListener> {
  StreamSubscription<Uri>? _subscription;
  final _handledLinks = <String>{};
  var _isImporting = false;

  BuildContext get _uiContext =>
      AppRouter.rootNavigatorKey.currentContext ?? context;

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _startListening() async {
    try {
      final appLinks = AppLinks();
      _subscription = appLinks.uriLinkStream.listen(
        _handleLink,
        onError: (_) => _showMessage('Could not read the shared memory link.'),
      );
      final initial = await appLinks.getInitialLink();
      if (initial != null) _handleLink(initial);
    } catch (_) {
      // Deep-link plugins are unavailable in widget tests and some desktop runs.
    }
  }

  void _handleLink(Uri uri) {
    final downloadService = ref.read(memoryCapsuleShareDownloadServiceProvider);
    if (!downloadService.isShareLink(uri)) return;

    final key = uri.toString();
    if (_isImporting || !_handledLinks.add(key)) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _importSharedCapsule(uri);
    });
  }

  Future<void> _importSharedCapsule(Uri uri) async {
    _isImporting = true;
    var progressVisible = false;
    MemoryCapsuleImportDraft? draft;

    try {
      _showProgress();
      progressVisible = true;
      final bytes = await ref
          .read(memoryCapsuleShareDownloadServiceProvider)
          .downloadCapsule(uri);

      if (mounted && progressVisible) {
        Navigator.of(_uiContext, rootNavigator: true).pop();
        progressVisible = false;
      }
      if (!mounted) return;

      final password = await showMemoryCapsulePasswordDialog(
        _uiContext,
        purpose: MemoryCapsulePasswordPurpose.import,
        requirePassword: true,
      );
      if (!mounted || password == null) return;

      draft = await ref
          .read(memoryCapsuleServiceProvider)
          .prepareImportFromBytes(bytes, password: password);
      if (!mounted) return;

      final confirmed = await showMemoryCapsuleImportPreview(_uiContext, draft);
      if (!mounted) return;
      if (!confirmed) {
        await ref.read(memoryCapsuleServiceProvider).discardImport(draft);
        draft = null;
        return;
      }

      final result = await ref
          .read(memoryRepositoryProvider.notifier)
          .importBackup(draft.backup);
      draft = null;
      if (!mounted) return;
      await showArchiveImportSummary(_uiContext, result);
    } on MemoryCapsuleShareDownloadException catch (error) {
      _closeProgressIfNeeded(progressVisible);
      progressVisible = false;
      _showMessage(error.message);
    } on BackupValidationException catch (error) {
      _closeProgressIfNeeded(progressVisible);
      progressVisible = false;
      if (draft != null) {
        await ref.read(memoryCapsuleServiceProvider).discardImport(draft);
      }
      _showMessage('Capsule rejected: ${error.message}');
    } catch (error) {
      _closeProgressIfNeeded(progressVisible);
      progressVisible = false;
      if (draft != null) {
        await ref.read(memoryCapsuleServiceProvider).discardImport(draft);
      }
      _showMessage('Shared memory import failed: $error');
    } finally {
      _closeProgressIfNeeded(progressVisible);
      _isImporting = false;
    }
  }

  void _showProgress() {
    showDialog<void>(
      context: _uiContext,
      barrierDismissible: false,
      builder: (context) => const _SharedMemoryProgressDialog(),
    );
  }

  void _closeProgressIfNeeded(bool visible) {
    if (mounted && visible) {
      Navigator.of(_uiContext, rootNavigator: true).pop();
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.maybeOf(_uiContext)?.showSnackBar(
      SnackBar(duration: const Duration(seconds: 7), content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _SharedMemoryProgressDialog extends StatelessWidget {
  const _SharedMemoryProgressDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              'Opening shared memory...',
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
