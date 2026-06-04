import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../data/memory_repository.dart';

class MemoryPeopleEditor extends StatelessWidget {
  const MemoryPeopleEditor({
    super.key,
    required this.people,
    required this.onChanged,
    this.suggestedPeople = const [],
  });

  final List<MemoryPersonDraft> people;
  final ValueChanged<List<MemoryPersonDraft>> onChanged;
  final List<MemoryPersonDraft> suggestedPeople;
  static const _iosContactPicker = MethodChannel(
    'dev.gkcoding.lifethreads/contact_picker',
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
            child: Text(
              l10n.addPeopleHint,
              style: const TextStyle(color: AppColors.muted, height: 1.35),
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
          label: Text(l10n.addPerson),
        ),
      ],
    );
  }

  Future<void> _openPersonDialog(
    BuildContext context, {
    MemoryPersonDraft? initial,
    int? index,
  }) async {
    final l10n = context.l10n;
    final nameController = TextEditingController(text: initial?.name ?? '');
    final nameFocusNode = FocusNode();
    final relationshipController = TextEditingController(
      text: initial?.relationship ?? '',
    );
    final phoneController = TextEditingController(text: initial?.phone ?? '');
    final emailController = TextEditingController(text: initial?.email ?? '');
    var isPickingContact = false;

    void applyPerson(MemoryPersonDraft person) {
      nameController.text = person.name;
      relationshipController.text = person.relationship;
      phoneController.text = person.phone ?? '';
      emailController.text = person.email ?? '';
    }

    final result = await showDialog<MemoryPersonDraft>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(initial == null ? l10n.addPerson : l10n.editPerson),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isPickingContact
                            ? null
                            : () async {
                                setDialogState(() => isPickingContact = true);
                                final person = await _pickDeviceContact(
                                  context,
                                  fallbackRelationship:
                                      relationshipController.text,
                                );
                                if (context.mounted && person != null) {
                                  applyPerson(person);
                                }
                                if (context.mounted) {
                                  setDialogState(
                                    () => isPickingContact = false,
                                  );
                                }
                              },
                        icon: isPickingContact
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.contacts_rounded),
                        label: Text(l10n.chooseFromContacts),
                      ),
                    ),
                    const SizedBox(height: 12),
                    RawAutocomplete<MemoryPersonDraft>(
                      textEditingController: nameController,
                      focusNode: nameFocusNode,
                      displayStringForOption: (person) => person.name,
                      optionsBuilder: (textEditingValue) {
                        return _matchingPeople(textEditingValue.text);
                      },
                      onSelected: applyPerson,
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                            return TextField(
                              controller: controller,
                              focusNode: focusNode,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: l10n.personNameLabel,
                                hintText: l10n.personNameHint,
                              ),
                            );
                          },
                      optionsViewBuilder: (context, onSelected, options) {
                        return _PersonSuggestions(
                          options: options.toList(),
                          onSelected: onSelected,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: relationshipController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.relationshipLabel,
                        hintText: l10n.relationshipHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.phoneOptionalLabel,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: l10n.emailOptionalLabel,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final relationship = relationshipController.text.trim();
                    if (name.isEmpty || relationship.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.nameRelationshipRequired)),
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
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );

    nameFocusNode.dispose();
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

  Iterable<MemoryPersonDraft> _matchingPeople(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return const [];

    return _uniquePeople([...suggestedPeople, ...people])
        .where((person) {
          return [person.name, person.relationship, person.phone, person.email]
              .whereType<String>()
              .any((value) => value.toLowerCase().contains(cleanQuery));
        })
        .take(6);
  }

  List<MemoryPersonDraft> _uniquePeople(List<MemoryPersonDraft> people) {
    final seen = <String>{};
    final unique = <MemoryPersonDraft>[];
    for (final person in people) {
      final key = [
        person.name.trim().toLowerCase(),
        person.relationship.trim().toLowerCase(),
        person.phone?.trim().toLowerCase() ?? '',
        person.email?.trim().toLowerCase() ?? '',
      ].join('|');
      if (seen.add(key)) unique.add(person);
    }
    return unique;
  }

  Future<MemoryPersonDraft?> _pickDeviceContact(
    BuildContext context, {
    required String fallbackRelationship,
  }) async {
    final l10n = context.l10n;
    final relationship =
        _optional(fallbackRelationship) ?? l10n.contactRelationship;
    try {
      FocusManager.instance.primaryFocus?.unfocus();
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return _pickIosContact(relationship);
      }

      final permission = await FlutterContacts.permissions.request(
        PermissionType.read,
      );
      if (!_hasContactAccess(permission)) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.contactAccessDenied)));
        }
        return null;
      }

      FocusManager.instance.primaryFocus?.unfocus();
      if (!context.mounted) return null;

      return showModalBottomSheet<MemoryPersonDraft>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => _ContactPickerSheet(
          fallbackRelationship: relationship,
          personFromContact: _personFromContact,
        ),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.couldNotOpenContacts)));
      }
      return null;
    }
  }

  Future<MemoryPersonDraft?> _pickIosContact(String relationship) async {
    final result = await _iosContactPicker.invokeMethod<Map<dynamic, dynamic>>(
      'pickContact',
    );
    if (result == null) return null;

    final name = (result['name'] as String?)?.trim();
    if (name == null || name.isEmpty) return null;

    return MemoryPersonDraft(
      name: name,
      relationship: relationship,
      phone: _optional((result['phone'] as String?) ?? ''),
      email: _optional((result['email'] as String?) ?? ''),
    );
  }

  bool _hasContactAccess(PermissionStatus status) {
    return status == PermissionStatus.granted ||
        status == PermissionStatus.limited;
  }

  String? _firstPhone(Contact contact) {
    if (contact.phones.isEmpty) return null;
    return _optional(
      contact.phones.first.normalizedNumber ?? contact.phones.first.number,
    );
  }

  String? _firstEmail(Contact contact) {
    if (contact.emails.isEmpty) return null;
    return _optional(contact.emails.first.address);
  }

  String? _optional(String value) {
    final clean = value.trim();
    return clean.isEmpty ? null : clean;
  }

  MemoryPersonDraft? _personFromContact(
    Contact contact,
    String fallbackRelationship,
  ) {
    final name = contact.displayName?.trim();
    if (name == null || name.isEmpty) return null;

    return MemoryPersonDraft(
      name: name,
      relationship: fallbackRelationship,
      phone: _firstPhone(contact),
      email: _firstEmail(contact),
    );
  }
}

class _ContactPickerSheet extends StatefulWidget {
  const _ContactPickerSheet({
    required this.fallbackRelationship,
    required this.personFromContact,
  });

  final String fallbackRelationship;
  final MemoryPersonDraft? Function(Contact contact, String relationship)
  personFromContact;

  @override
  State<_ContactPickerSheet> createState() => _ContactPickerSheetState();
}

class _ContactPickerSheetState extends State<_ContactPickerSheet> {
  final _searchController = TextEditingController();
  final List<Contact> _contacts = [];
  Timer? _searchDebounce;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 4, 20, 20 + bottomInset),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.chooseContact,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _searchController,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded),
                  labelText: l10n.searchContacts,
                ),
                onChanged: _queueSearch,
              ),
              const SizedBox(height: 14),
              Expanded(child: _buildContactList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final error = _error;
    if (error != null) {
      return Center(
        child: Text(error, style: const TextStyle(color: AppColors.muted)),
      );
    }

    if (_contacts.isEmpty) {
      return Center(
        child: Text(
          context.l10n.noContactsFound,
          style: const TextStyle(color: AppColors.muted),
        ),
      );
    }

    return ListView.separated(
      itemCount: _contacts.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: AppColors.gold.withValues(alpha: 0.18),
            foregroundColor: AppColors.gold,
            child: const Icon(Icons.person_rounded),
          ),
          title: Text(
            contact.displayName ?? context.l10n.unnamedContact,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          subtitle: Text(_contactDetails(contact)),
          onTap: () {
            final person = widget.personFromContact(
              contact,
              widget.fallbackRelationship,
            );
            if (person != null) Navigator.of(context).pop(person);
          },
        );
      },
    );
  }

  void _queueSearch(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 260),
      () => _loadContacts(query),
    );
  }

  Future<void> _loadContacts([String query = '']) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cleanQuery = query.trim();
      final contacts = await FlutterContacts.getAll(
        properties: {
          ContactProperty.name,
          ContactProperty.phone,
          ContactProperty.email,
        },
        filter: cleanQuery.isEmpty ? null : ContactFilter.name(cleanQuery),
        limit: cleanQuery.isEmpty ? 80 : 40,
      );

      if (!mounted) return;
      setState(() {
        _contacts
          ..clear()
          ..addAll(contacts.where(_hasUsableName));
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = context.l10n.couldNotLoadContacts;
        _isLoading = false;
      });
    }
  }

  bool _hasUsableName(Contact contact) {
    final name = contact.displayName?.trim();
    return name != null && name.isNotEmpty;
  }

  String _contactDetails(Contact contact) {
    final details = [
      if (contact.phones.isNotEmpty)
        contact.phones.first.normalizedNumber ?? contact.phones.first.number,
      if (contact.emails.isNotEmpty) contact.emails.first.address,
    ].where((value) => value.trim().isNotEmpty);
    return details.isEmpty
        ? context.l10n.contactRelationship
        : details.join(' • ');
  }
}

class _PersonSuggestions extends StatelessWidget {
  const _PersonSuggestions({required this.options, required this.onSelected});

  final List<MemoryPersonDraft> options;
  final ValueChanged<MemoryPersonDraft> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: AppColors.panelWarm,
        elevation: 10,
        borderRadius: BorderRadius.circular(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 260, maxWidth: 360),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 6),
            shrinkWrap: true,
            itemCount: options.length,
            separatorBuilder: (_, _) =>
                const Divider(height: 1, color: AppColors.line),
            itemBuilder: (context, index) {
              final person = options[index];
              return ListTile(
                dense: true,
                leading: const Icon(
                  Icons.person_rounded,
                  color: AppColors.gold,
                ),
                title: Text(
                  person.name,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(_personDetails(person)),
                onTap: () => onSelected(person),
              );
            },
          ),
        ),
      ),
    );
  }

  String _personDetails(MemoryPersonDraft person) {
    return [
      person.relationship,
      person.phone,
      person.email,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' • ');
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
