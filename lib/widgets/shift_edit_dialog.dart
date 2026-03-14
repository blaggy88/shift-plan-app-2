import 'package:flutter/material.dart';

class ShiftEditDialog extends StatefulWidget {
  final String initialShiftCode;
  final bool initialIsCustomTime;
  final String day;
  final String employeeName;
  final String weekType;
  
  const ShiftEditDialog({
    super.key,
    required this.initialShiftCode,
    required this.initialIsCustomTime,
    required this.day,
    required this.employeeName,
    required this.weekType,
  });

  @override
  State<ShiftEditDialog> createState() => _ShiftEditDialogState();
}

class _ShiftEditDialogState extends State<ShiftEditDialog> {
  late String _shiftCode;
  late bool _isCustomTime;
  final TextEditingController _customTimeController = TextEditingController();
  
  final List<Map<String, String>> _standardShifts = [
    {'code': 'F', 'label': 'Früh'},
    {'code': 'M', 'label': 'Mittel'},
    {'code': 'S', 'label': 'Spät'},
    {'code': 'E', 'label': 'Egal'},
    {'code': 'U', 'label': 'Urlaub'},
    {'code': 'X', 'label': 'Frei'},
    {'code': 'Schule', 'label': 'Schule'},
    {'code': 'Seminar', 'label': 'Seminar'},
    {'code': 'LR', 'label': 'LR'},
  ];

  @override
  void initState() {
    super.initState();
    _shiftCode = widget.initialShiftCode;
    _isCustomTime = widget.initialIsCustomTime;
    
    if (_isCustomTime) {
      _customTimeController.text = _shiftCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Schicht bearbeiten - ${widget.employeeName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.weekType} - ${widget.day}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Mode selector
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Standard-Kürzel'),
                    selected: !_isCustomTime,
                    onSelected: (selected) {
                      setState(() {
                        _isCustomTime = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Eigene Uhrzeit'),
                    selected: _isCustomTime,
                    onSelected: (selected) {
                      setState(() {
                        _isCustomTime = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (!_isCustomTime) ...[
              const Text(
                'Wähle ein Standard-Kürzel:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _standardShifts.map((shift) {
                  return ChoiceChip(
                    label: Text(shift['label']!),
                    selected: _shiftCode == shift['code'],
                    onSelected: (selected) {
                      setState(() {
                        _shiftCode = shift['code']!;
                      });
                    },
                  );
                }).toList(),
              ),
            ] else ...[
              const Text(
                'Gib eine benutzerdefinierte Uhrzeit ein (z.B. "6:00 - 15:00"):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _customTimeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'z.B. 6:00 - 15:00',
                ),
                onChanged: (value) {
                  _shiftCode = value;
                },
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Clear button
            if (_shiftCode.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _shiftCode = '';
                      _customTimeController.clear();
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Schicht löschen'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () {
            final result = {
              'shiftCode': _isCustomTime ? _customTimeController.text : _shiftCode,
              'isCustomTime': _isCustomTime,
            };
            Navigator.of(context).pop(result);
          },
          child: const Text('Speichern'),
        ),
      ],
    );
  }
}