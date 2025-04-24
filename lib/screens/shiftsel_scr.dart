import 'package:flutter/material.dart';
import '../widgets/shiftseelctor.dart';

class ShiftSelectionScreen extends StatelessWidget {
  const ShiftSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Izaberite smenu')),
      body: ShiftSelector(),
    );
  }
}
