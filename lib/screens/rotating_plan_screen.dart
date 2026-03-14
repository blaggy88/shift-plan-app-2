import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shift_plan_app/models/employee.dart';
import 'package:shift_plan_app/utils/storage_service.dart';
import 'package:shift_plan_app/widgets/employee_management.dart';
import 'package:shift_plan_app/widgets/shift_edit_dialog.dart';

class RotatingPlanScreen extends StatefulWidget {
  const RotatingPlanScreen({super.key});

  @override
  State<RotatingPlanScreen> createState() => _RotatingPlanScreenState();
}

class _RotatingPlanScreenState extends State<RotatingPlanScreen> {
  final StorageService _storage = StorageService();
  String _selectedWeek = 'A';
  
  final List<String> _weekTypes = ['A', 'B', 'C', 'D'];
  final List<String> _weekdays = [
    'Montag',
    'Dienstag',
    'Mittwoch',
    'Donnerstag',
    'Freitag',
    'Samstag',
  ];
  
  final Map<String, String> _weekdayKeys = {
    'Montag': 'monday',
    'Dienstag': 'tuesday',
    'Mittwoch': 'wednesday',
    'Donnerstag': 'thursday',
    'Freitag': 'friday',
    'Samstag': 'saturday',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Week selector
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _weekTypes.map((week) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text('Woche $week'),
                  selected: _selectedWeek == week,
                  onSelected: (selected) {
                    setState(() {
                      _selectedWeek = week;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        
        // Employee management
        EmployeeManagement(
          onEmployeeAdded: () => setState(() {}),
          onEmployeeDeleted: () => setState(() {}),
        ),
        
        const SizedBox(height: 8),
        
        // Table header
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade100,
          ),
          child: Row(
            children: [
              // Employee name column header
              Container(
                width: 120,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey.shade300)),
                ),
                child: const Text(
                  'Mitarbeiter',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              
              // Weekday headers
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _weekdays.map((day) {
                      return Container(
                        width: 100,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: Colors.grey.shade300)),
                        ),
                        child: Text(
                          day,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Table content
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: Hive.box<Employee>('employees').listenable(),
            builder: (context, Box<Employee> box, _) {
              final employees = box.values.toList();
              
              return ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return _buildEmployeeRow(employee);
                },
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildEmployeeRow(Employee employee) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          // Employee name cell
          Container(
            width: 120,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Text(employee.name),
          ),
          
          // Shift cells
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _weekdays.map((day) {
                  final dayKey = _weekdayKeys[day]!;
                  final shift = _storage.getShift(
                    employeeId: employee.key.toString(),
                    weekType: _selectedWeek,
                    day: dayKey,
                  );
                  
                  return GestureDetector(
                    onTap: () => _editShift(employee, day, dayKey),
                    child: Container(
                      width: 100,
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.grey.shade300)),
                        color: shift != null ? _getShiftColor(shift.shiftCode) : Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          shift?.displayText ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: shift != null ? _getTextColor(shift.shiftCode) : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _editShift(Employee employee, String day, String dayKey) async {
    final shift = _storage.getShift(
      employeeId: employee.key.toString(),
      weekType: _selectedWeek,
      day: dayKey,
    );
    
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ShiftEditDialog(
        initialShiftCode: shift?.shiftCode ?? '',
        initialIsCustomTime: shift?.isCustomTime ?? false,
        day: day,
        employeeName: employee.name,
        weekType: 'Woche $_selectedWeek',
      ),
    );
    
    if (result != null) {
      await _storage.saveShift(
        employeeId: employee.key.toString(),
        weekType: _selectedWeek,
        day: dayKey,
        shiftCode: result['shiftCode'],
        isCustomTime: result['isCustomTime'],
      );
      setState(() {});
    }
  }
  
  Color _getShiftColor(String shiftCode) {
    final colors = {
      'F': Colors.blue.shade100,
      'M': Colors.green.shade100,
      'S': Colors.orange.shade100,
      'U': Colors.red.shade100,
      'X': Colors.grey.shade200,
      'Schule': Colors.purple.shade100,
      'Seminar': Colors.teal.shade100,
      'LR': Colors.yellow.shade100,
      'E': Colors.cyan.shade100,
    };
    
    return colors[shiftCode] ?? Colors.white;
  }
  
  Color _getTextColor(String shiftCode) {
    final darkColors = ['U', 'X'];
    return darkColors.contains(shiftCode) ? Colors.black : Colors.black87;
  }
}