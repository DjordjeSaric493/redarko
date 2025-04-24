import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShiftPicker extends StatefulWidget {
  final Function(DateTime, String) onShiftSelected;

  const ShiftPicker({super.key, required this.onShiftSelected});

  @override
  State<ShiftPicker> createState() => _ShiftPickerState();
}

class _ShiftPickerState extends State<ShiftPicker> {
  DateTime? selectedDate;
  String? selectedShift;

  final List<String> shiftOptions = [
    '08:00 - 12:00',
    '12:00 - 16:00',
    '16:00 - 20:00',
    '20:00 - 00:00',
    '00:00 - 04:00',
    '04:00 - 08:00',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(today.year + 1),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      _notifyIfComplete();
    }
  }

  void _onShiftChanged(String? shift) {
    setState(() {
      selectedShift = shift;
    });
    _notifyIfComplete();
  }

  void _notifyIfComplete() {
    if (selectedDate != null && selectedShift != null) {
      widget.onShiftSelected(selectedDate!, selectedShift!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        selectedDate != null
            ? DateFormat('EEEE, dd.MM.yyyy').format(selectedDate!)
            : 'Select date';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kalendar
        ListTile(
          title: Text(formattedDate),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => _selectDate(context),
        ),
        const SizedBox(height: 16),

        // Dropdown
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Select shift'),
          value: selectedShift,
          items:
              shiftOptions.map((String shift) {
                return DropdownMenuItem<String>(
                  value: shift,
                  child: Text(shift),
                );
              }).toList(),
          onChanged: _onShiftChanged,
        ),
      ],
    );
  }
}
