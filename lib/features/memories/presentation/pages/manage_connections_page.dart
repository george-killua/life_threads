import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/memory_repository.dart';
import '../../domain/memory_connection.dart';
import '../../domain/memory_event.dart';

class ManageConnectionsPage extends ConsumerWidget {
  const ManageConnectionsPage({super.key, required this.memoryId});

  final String memoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoryState = ref.watch(memoryRepositoryProvider);
    final repository = ref.read(memoryRepositoryProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Thread Reasons')),
      body: memoryState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (state) {
          final memory = state.findEvent(memoryId);
          if (memory == null) {
            return const Center(child: Text('Memory not found'));
          }

          final candidates = state.events
              .where((event) => event.id != memoryId)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _Header(memory: memory),
              const SizedBox(height: 22),
              if (candidates.isEmpty)
                const Text(
                  'Create more memories before linking.',
                  style: TextStyle(color: AppColors.muted),
                )
              else
                ...candidates.map((event) {
                  final connection = state.connectionBetween(
                    memoryId,
                    event.id,
                  );
                  return _ConnectionReasonCard(
                    event: event,
                    connection: connection,
                    onToggle: (value) async {
                      if (!value) {
                        await repository.setMemoryConnection(
                          memoryId: memoryId,
                          otherMemoryId: event.id,
                          isConnected: false,
                        );
                        return;
                      }

                      final reason = await _askConnectionReason(
                        context,
                        connectedTitle: event.title,
                        initialReason: connection?.label,
                      );
                      if (!context.mounted || reason == null) return;

                      await repository.setMemoryConnection(
                        memoryId: memoryId,
                        otherMemoryId: event.id,
                        isConnected: true,
                        label: reason,
                      );
                    },
                    onEditReason: connection == null
                        ? null
                        : () async {
                            final reason = await _askConnectionReason(
                              context,
                              connectedTitle: event.title,
                              initialReason: connection.label,
                            );
                            if (!context.mounted || reason == null) return;
                            await repository.updateConnectionLabel(
                              connection.id,
                              reason,
                            );
                          },
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.memory});

  final MemoryEvent memory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.panelWarm.withValues(alpha: 0.92),
            AppColors.panel.withValues(alpha: 0.84),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            memory.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.7,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Connect memories with a reason. The rope should explain why two moments belong together.',
            style: TextStyle(color: AppColors.muted, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ConnectionReasonCard extends StatelessWidget {
  const _ConnectionReasonCard({
    required this.event,
    required this.connection,
    required this.onToggle,
    required this.onEditReason,
  });

  final MemoryEvent event;
  final MemoryConnection? connection;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onEditReason;

  @override
  Widget build(BuildContext context) {
    final isConnected = connection != null;
    final reason = connection?.label.trim();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isConnected
              ? AppColors.gold.withValues(alpha: 0.28)
              : AppColors.line,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: event.coverColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.category.label} • ${event.locationLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isConnected,
                activeThumbColor: AppColors.gold,
                onChanged: onToggle,
              ),
            ],
          ),
          if (isConnected) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppColors.wallInk.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cable_rounded, color: AppColors.amber),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      reason?.isNotEmpty == true ? reason! : 'connected memory',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: onEditReason,
                    child: const Text('Edit'),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Future<String?> _askConnectionReason(
  BuildContext context, {
  required String connectedTitle,
  String? initialReason,
}) async {
  return showDialog<String>(
    context: context,
    builder: (_) => _ConnectionReasonDialog(
      connectedTitle: connectedTitle,
      initialReason: initialReason ?? '',
    ),
  );
}

class _ConnectionReasonDialog extends StatefulWidget {
  const _ConnectionReasonDialog({
    required this.connectedTitle,
    required this.initialReason,
  });

  final String connectedTitle;
  final String initialReason;

  @override
  State<_ConnectionReasonDialog> createState() =>
      _ConnectionReasonDialogState();
}

class _ConnectionReasonDialogState extends State<_ConnectionReasonDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialReason);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Why are they connected?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.connectedTitle,
            style: const TextStyle(
              color: AppColors.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            autofocus: true,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Example: same trip, same person, before / after...',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Save Reason'),
        ),
      ],
    );
  }
}
