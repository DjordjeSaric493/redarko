import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redarko/widgets/shiftpick.dart';

class ShiftSelector extends StatefulWidget {
  const ShiftSelector({super.key});

  @override
  State<ShiftSelector> createState() => _ShiftSelectorState();
}

class _ShiftSelectorState extends State<ShiftSelector> {
  DateTime? selectedDate;
  String? selectedShift;

  void _handleShiftSelection(DateTime date, String shift) {
    setState(() {
      selectedDate = date;
      selectedShift = shift;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ShiftPicker(onShiftSelected: _handleShiftSelection),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed:
                (selectedDate != null && selectedShift != null)
                    ? () {
                      final formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(selectedDate!);

                      print('Date: $formattedDate');
                      print('Shift: $selectedShift');

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Shift saved!')),
                      );

                      // TODO: sačuvaj u bazu/provider
                    }
                    : null,
            child: const Text('Save shift'),
          ),
        ],
      ),
    );
  }
}
