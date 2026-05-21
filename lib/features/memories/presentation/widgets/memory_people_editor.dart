import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../data/memory_repository.dart';

class MemoryPeopleEditor extends StatelessWidget {
  const MemoryPeopleEditor({
    super.key,
    required this.people,
    required this.onChanged,
  });

  final List<MemoryPersonDraft> people;
  final ValueChanged<List<MemoryPersonDraft>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (people.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.wallDeep.withValues(alpha: 0.44),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.line),
            ),
            child: const Text(
              'Add people who belong to this moment. Contacts stay local.',
              style: TextStyle(color: AppColors.muted, height: 1.35),
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var index = 0; index < people.length; index++)
                _PersonChip(
                  person: people[index],
                  onEdit: () => _openPersonDialog(
                    context,
                    initial: people[index],
                    index: index,
                  ),
                  onRemove: () {
                    final updated = [...people]..removeAt(index);
                    onChanged(updated);
                  },
                ),
            ],
          ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => _openPersonDialog(context),
          icon: const Icon(Icons.person_add_alt_1_rounded),
          label: const Text('Add person'),
        ),
      ],
    );
  }

  Future<void> _openPersonDialog(
    BuildContext context, {
    MemoryPersonDraft? initial,
    int? index,
  }) async {
    final nameController = TextEditingController(text: initial?.name ?? '');
    final relationshipController = TextEditingController(
      text: initial?.relationship ?? '',
    );
    final phoneController = TextEditingController(text: initial?.phone ?? '');
    final emailController = TextEditingController(text: initial?.email ?? '');

    final result = await showDialog<MemoryPersonDraft>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(initial == null ? 'Add person' : 'Edit person'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: relationshipController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Relationship',
                    hintText: 'Friend, mother, partner...',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Phone (optional)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email (optional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = nameController.text.trim();
                final relationship = relationshipController.text.trim();
                if (name.isEmpty || relationship.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Name and relationship are required.'),
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop(
                  MemoryPersonDraft(
                    name: name,
                    relationship: relationship,
                    phone: _optional(phoneController.text),
                    email: _optional(emailController.text),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    relationshipController.dispose();
    phoneController.dispose();
    emailController.dispose();

    if (result == null) return;
    final updated = [...people];
    if (index == null) {
      updated.add(result);
    } else {
      updated[index] = result;
    }
    onChanged(updated);
  }

  String? _optional(String value) {
    final clean = value.trim();
    return clean.isEmpty ? null : clean;
  }
}

class _PersonChip extends StatelessWidget {
  const _PersonChip({
    required this.person,
    required this.onEdit,
    required this.onRemove,
  });

  final MemoryPersonDraft person;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.panelWarm.withValues(alpha: 0.88),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 9, 8, 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_rounded, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.name,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    person.relationship,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 6),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
