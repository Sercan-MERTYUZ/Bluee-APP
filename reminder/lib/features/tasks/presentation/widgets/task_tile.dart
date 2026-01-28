import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../data/task_model.dart';
import '../../state/task_providers.dart';

class TaskTile extends ConsumerWidget {
  final Task task;

  const TaskTile({required this.task, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: task.isDone
              ? const Color(0xFF7C3AED).withValues(alpha: 0.2)
              : const Color(0xFF2D2D3A),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTaskDetailsBottomSheet(context, ref, task),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Checkbox(
                  value: task.isDone,
                  onChanged: (value) async {
                    await ref.read(tasksProvider.notifier).markDone(task, value ?? false);
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: task.isDone ? const Color(0xFF6B7280) : const Color(0xFFEDEDF3),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: task.isDone ? TextDecoration.lineThrough : null,
                          decorationColor: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: task.isDone
                                ? const Color(0xFF4B5563)
                                : const Color(0xFFA78BFA),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('MMM d, HH:mm').format(task.scheduledAt),
                            style: TextStyle(
                              color: task.isDone ? const Color(0xFF4B5563) : const Color(0xFF9CA3AF),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (!task.isDone)
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline, color: Color(0xFF7C3AED)),
                    onPressed: () async {
                      await ref.read(tasksProvider.notifier).markDone(task, true);
                    },
                    tooltip: 'done'.tr(),
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    padding: EdgeInsets.zero,
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'reschedule') {
                      _showRescheduleDialog(context, ref, task);
                    } else if (value == 'delete') {
                      _showDeleteDialog(context, ref, task);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'reschedule',
                      child: Row(
                        children: [
                          const Icon(Icons.schedule, size: 20, color: Color(0xFF7C3AED)),
                          const SizedBox(width: 12),
                          Text(
                            'reschedule'.tr(),
                            style: const TextStyle(color: Color(0xFFEDEDF3)),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 20, color: Color(0xFFEF4444)),
                          const SizedBox(width: 12),
                          Text(
                            'delete'.tr(),
                            style: const TextStyle(color: Color(0xFFEF4444)),
                          ),
                        ],
                      ),
                    ),
                  ],
                  color: const Color(0xFF1A1A25),
                  constraints: const BoxConstraints(minWidth: 200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTaskDetailsBottomSheet(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A25),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _TaskDetailsBottomSheet(task: task, ref: ref),
    );
  }

  void _showRescheduleDialog(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) {
    showDialog(
      context: context,
      builder: (context) => _RescheduleDialog(task: task, ref: ref),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_outline,
                color: const Color(0xFFEF4444).withValues(alpha: 0.8),
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'delete'.tr(),
                style: const TextStyle(
                  color: Color(0xFFEDEDF3),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'cancel'.tr(),
                        style: const TextStyle(color: Color(0xFF9CA3AF)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('delete'.tr()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm ?? false) {
      if (context.mounted) {
        await ref.read(tasksProvider.notifier).deleteTask(task);
      }
    }
  }
}

class _RescheduleDialog extends ConsumerStatefulWidget {
  final Task task;
  final WidgetRef ref;

  const _RescheduleDialog({required this.task, required this.ref});

  @override
  ConsumerState<_RescheduleDialog> createState() => _RescheduleDateTimeState();
}

class _RescheduleDateTimeState extends ConsumerState<_RescheduleDialog> {
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.task.scheduledAt;
  }

  Future<void> _saveReschedule() async {
    if (!mounted) return;

    final error = await ref
        .read(tasksProvider.notifier)
        .rescheduleTask(widget.task, selectedDateTime);

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.tr()),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.schedule,
              color: Color(0xFF7C3AED),
              size: 44,
            ),
            const SizedBox(height: 16),
            Text(
              'reschedule'.tr(),
              style: const TextStyle(
                color: Color(0xFFEDEDF3),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.task.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF7C3AED),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          DateFormat('EEEE, MMM d, yyyy').format(selectedDateTime),
                          style: const TextStyle(
                            color: Color(0xFFA78BFA),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF7C3AED),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          DateFormat('HH:mm').format(selectedDateTime),
                          style: const TextStyle(
                            color: Color(0xFFA78BFA),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickDateTime,
                icon: const Icon(Icons.edit, size: 20),
                label: const Text('Change Date & Time'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D2D3A),
                  foregroundColor: const Color(0xFF7C3AED),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'cancel'.tr(),
                      style: const TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveReschedule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                    ),
                    child: Text('save'.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskDetailsBottomSheet extends ConsumerWidget {
  final Task task;
  final WidgetRef ref;

  const _TaskDetailsBottomSheet({required this.task, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.3,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9CA3AF).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                task.title,
                style: const TextStyle(
                  color: Color(0xFFEDEDF3),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Status & Date Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                  border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          task.isDone ? Icons.check_circle : Icons.schedule,
                          color: task.isDone ? const Color(0xFF10B981) : const Color(0xFF7C3AED),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            task.isDone ? 'Completed' : 'Scheduled',
                            style: TextStyle(
                              color: task.isDone ? const Color(0xFF10B981) : const Color(0xFF7C3AED),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFFA78BFA),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            DateFormat('EEEE, MMMM d, yyyy • HH:mm').format(task.scheduledAt),
                            style: const TextStyle(
                              color: Color(0xFFA78BFA),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Note Section
              Text(
                'note_optional'.tr(),
                style: const TextStyle(
                  color: Color(0xFFEDEDF3),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0B10),
                  border: Border.all(color: const Color(0xFF2D2D3A)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: task.note != null && task.note!.isNotEmpty
                    ? Text(
                        task.note!,
                        style: const TextStyle(
                          color: Color(0xFFEDEDF3),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      )
                    : Text(
                        'No note added',
                        style: TextStyle(
                          color: const Color(0xFF9CA3AF).withValues(alpha: 0.6),
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Show reschedule dialog after closing bottom sheet
                        Future.delayed(const Duration(milliseconds: 300), () {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => _RescheduleDialog(task: task, ref: ref),
                            );
                          }
                        });
                      },
                      icon: const Icon(Icons.schedule, size: 18),
                      label: const Text('Reschedule'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D2D3A),
                        foregroundColor: const Color(0xFF7C3AED),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        if (!task.isDone) {
                          ref.read(tasksProvider.notifier).markDone(task, true);
                        }
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(task.isDone ? 'Completed' : 'Mark Done'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Show delete dialog after closing bottom sheet
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: const Color(0xFF1A1A25),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.delete_outline,
                                    color: const Color(0xFFEF4444).withValues(alpha: 0.8),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'delete'.tr(),
                                    style: const TextStyle(
                                      color: Color(0xFFEDEDF3),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    task.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFF9CA3AF),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text(
                                            'cancel'.tr(),
                                            style: const TextStyle(
                                              color: Color(0xFF9CA3AF),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            ref.read(tasksProvider.notifier).deleteTask(task);
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFEF4444),
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text('delete'.tr()),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    });
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: Text('delete'.tr()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444).withValues(alpha: 0.1),
                    foregroundColor: const Color(0xFFEF4444),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

