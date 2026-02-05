import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:reminder/features/notes/data/note_model.dart';
import 'package:uuid/uuid.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late Box<Note> _notesBox;
  String _personFilter = '';
  DateTimeRange? _dateFilter;

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _personController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _notesBox = Hive.box<Note>('notes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notes'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          if (_personFilter.isNotEmpty || _dateFilter != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _personFilter = '';
                  _dateFilter = null;
                });
              },
            ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _notesBox.listenable(),
        builder: (context, Box<Note> box, _) {
          var notes = box.values.toList();

          // Apply filters
          if (_personFilter.isNotEmpty) {
            notes = notes
                .where((note) => note.person
                    .toLowerCase()
                    .contains(_personFilter.toLowerCase()))
                .toList();
          }

          if (_dateFilter != null) {
            notes = notes.where((note) {
              final noteDate = DateTime(
                note.createdAt.year,
                note.createdAt.month,
                note.createdAt.day,
              );
              final start = _dateFilter!.start;
              final end = _dateFilter!.end;
              final startDate = DateTime(start.year, start.month, start.day);
              final endDate = DateTime(end.year, end.month, end.day);
              
              return noteDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
                     noteDate.isBefore(endDate.add(const Duration(days: 1)));
            }).toList();
          }

          // Sort by date descending
          notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 64, color: Colors.grey[700]),
                  const SizedBox(height: 16),
                  Text(
                    'no_notes'.tr(),
                    style: TextStyle(color: Colors.grey[500], fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                color: const Color(0xFF1A1A25),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF2D2D3A), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C3AED).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              note.person,
                              style: const TextStyle(
                                color: Color(0xFFA78BFA),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy').format(note.createdAt),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        note.content,
                        style: const TextStyle(
                          color: Color(0xFFEDEDF3),
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete,
                              color: Color(0xFFEF4444), size: 20),
                          onPressed: () => note.delete(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddNoteDialog() {
    _contentController.clear();
    _personController.clear();
    _selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1A1A25),
            title: Text('add_note'.tr()),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _contentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'note_content'.tr(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _personController,
                    decoration: InputDecoration(
                      hintText: 'person_topic'.tr(),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate!,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF2D2D3A)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Color(0xFF9CA3AF)),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('dd MMM yyyy').format(_selectedDate!),
                            style: const TextStyle(color: Color(0xFFEDEDF3)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('cancel'.tr()),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_contentController.text.isNotEmpty &&
                      _personController.text.isNotEmpty) {
                    final note = Note(
                      id: const Uuid().v4(),
                      content: _contentController.text,
                      person: _personController.text,
                      createdAt: _selectedDate!,
                    );
                    _notesBox.add(note);
                    Navigator.pop(context);
                  }
                },
                child: Text('save'.tr()),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    // Get unique person names from all notes
    final allPersons = _notesBox.values.map((n) => n.person).toSet().toList();
    allPersons.sort();

    showDialog(
      context: context,
      builder: (context) {
        String? tempPerson = _personFilter.isEmpty ? null : _personFilter;
        DateTimeRange? tempDate = _dateFilter;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A25),
              title: Text('filter_notes'.tr()),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (allPersons.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'no_persons_yet'.tr(),
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      )
                    else ...[
                      Text(
                        'select_person'.tr(),
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: SingleChildScrollView(
                          child: Column(
                            children: allPersons.map((person) {
                              final isSelected = tempPerson == person;
                              return CheckboxListTile(
                                value: isSelected,
                                onChanged: (val) {
                                  setDialogState(() {
                                    if (val == true) {
                                      tempPerson = person;
                                    } else {
                                      tempPerson = null;
                                    }
                                  });
                                },
                                title: Text(
                                  person,
                                  style: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFFA78BFA)
                                        : const Color(0xFFEDEDF3),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                activeColor: const Color(0xFF7C3AED),
                                checkColor: Colors.white,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          initialDateRange: tempDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Color(0xFF7C3AED),
                                  onPrimary: Colors.white,
                                  surface: Color(0xFF1A1A25),
                                  onSurface: Color(0xFFEDEDF3),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setDialogState(() {
                            tempDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF2D2D3A)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.date_range,
                                color: Color(0xFF9CA3AF)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tempDate != null
                                    ? '${DateFormat('dd MMM').format(tempDate!.start)} - ${DateFormat('dd MMM yyyy').format(tempDate!.end)}'
                                    : 'filter_by_date_range'.tr(),
                                style: TextStyle(
                                  color: tempDate != null
                                      ? const Color(0xFFEDEDF3)
                                      : const Color(0xFF9CA3AF),
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (tempDate != null)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  setDialogState(() {
                                    tempDate = null;
                                  });
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('cancel'.tr()),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _personFilter = tempPerson ?? '';
                      _dateFilter = tempDate;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('apply'.tr()),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
