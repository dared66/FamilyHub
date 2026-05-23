import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/calendar_service.dart';
import '../models/partials.dart';
import '../core/theme.dart';
import '../core/const.dart';

class AddEventSheet extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final List<TaskList> calendars;

  const AddEventSheet({
    super.key,
    required this.selectedDate,
    required this.calendars,
  });

  @override
  ConsumerState<AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends ConsumerState<AddEventSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _endTime = TimeOfDay.now();
  TaskList? _selectedCalendar;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _startDate = widget.selectedDate;
    _endDate = widget.selectedDate;
    if (widget.calendars.isNotEmpty) {
      _selectedCalendar = widget.calendars.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final combinedStart = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime.hour,
        _startTime.minute,
      );
      final combinedEnd = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime.hour,
        _endTime.minute,
      );

      final calendarId = _selectedCalendar?.id ?? '';
      await ref
          .read(calendarServiceProvider)
          .createEvent(
            title: _titleController.text.trim(),
            startTime: combinedStart,
            endTime: combinedEnd,
            description: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
            location:
                _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
            calendarId: calendarId,
          );

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to save event. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Widget _buildDatePicker(IconData icon, bool isStart) {
    return OutlinedButton.icon(
      onPressed: () => _pickDate(context, isStart),
      icon: Icon(icon, size: 20, color: primary),
      label: Text(
        isStart
            ? '${_startDate.year}-${_startDate.month.toString().padLeft(2, '0')}-${_startDate.day.toString().padLeft(2, '0')}'
            : '${_endDate.year}-${_endDate.month.toString().padLeft(2, '0')}-${_endDate.day.toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 16),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        side: const BorderSide(color: textSecondary),
      ),
    );
  }

  Widget _buildTimePicker(IconData icon, bool isStart) {
    return OutlinedButton.icon(
      onPressed: () => _pickTime(context, isStart),
      icon: Icon(icon, size: 20, color: primary),
      label: Text(
        isStart ? _startTime.format(context) : _endTime.format(context),
        style: const TextStyle(fontSize: 16),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        side: const BorderSide(color: textSecondary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Event',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(thickness: 1),
          const SizedBox(height: 16),

          // Scrollable form
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title field
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title *',
                        hintText: 'Enter event title',
                        prefixIcon: Icon(Icons.event_note),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Start date
                    _buildDatePicker(Icons.calendar_today, true),
                    const SizedBox(height: 16),

                    // Start time
                    _buildTimePicker(Icons.access_time, true),
                    const SizedBox(height: 16),

                    // End date
                    _buildDatePicker(Icons.calendar_today, false),
                    const SizedBox(height: 16),

                    // End time
                    _buildTimePicker(Icons.access_time, false),
                    const SizedBox(height: 16),

                    // Calendar dropdown
                    DropdownButtonFormField<TaskList>(
                      value: _selectedCalendar,
                      decoration: const InputDecoration(
                        labelText: 'Calendar',
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                      items: widget.calendars.map((calendar) {
                        return DropdownMenuItem(
                          value: calendar,
                          child: Text(calendar.title),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCalendar = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Select a calendar';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Location field
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        hintText: 'Add location (optional)',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notes field
                    TextFormField(
                      controller: _notesController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        hintText: 'Add notes or description...',
                        prefixIcon: Icon(Icons.note_alt),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveEvent,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(textPrimary),
                                  ),
                                )
                              : const Text('Save'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
