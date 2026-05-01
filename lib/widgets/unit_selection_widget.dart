import 'package:bimmer_wheels/statics/app_settings.dart';
import 'package:flutter/material.dart';

class UnitSelectionWidget extends StatefulWidget {
  final String selectedUnit;
  final Function(String) onUnitChanged;
  
  const UnitSelectionWidget({super.key, required this.selectedUnit, required this.onUnitChanged});

  @override
  State<UnitSelectionWidget> createState() => _UnitSelectionWidgetState();
}

class _UnitSelectionWidgetState extends State<UnitSelectionWidget> {
  final List<String> unitOptions = ['metric', 'imperial'];
  late String currentSelectedUnit;

  @override
  void initState() {
    super.initState();
    currentSelectedUnit = widget.selectedUnit;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Units', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        DropdownButton<String>(
          value: currentSelectedUnit,
          items: unitOptions.map((unit) {
            return DropdownMenuItem<String>(
              value: unit,
              child: Text(unit[0].toUpperCase() + unit.substring(1)), // Capitalize first letter
            );
          }).toList(),
          onChanged: (value) async {
            if (value != null) {
              setState(() {
                currentSelectedUnit = value;
              });
              await AppSettings.setUnit(value);
              widget.onUnitChanged(value);
            }
          },
        ),
      ],
    );
  }
}