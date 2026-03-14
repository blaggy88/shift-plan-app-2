import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shift_plan_app/models/employee.dart';
import 'package:shift_plan_app/utils/storage_service.dart';

class EmployeeManagement extends StatefulWidget {
  final VoidCallback onEmployeeAdded;
  final VoidCallback onEmployeeDeleted;
  
  const EmployeeManagement({
    super.key,
    required this.onEmployeeAdded,
    required this.onEmployeeDeleted,
  });

  @override
  State<EmployeeManagement> createState() => _EmployeeManagementState();
}

class _EmployeeManagementState extends State<EmployeeManagement> {
  final StorageService _storage = StorageService();
  final TextEditingController _nameController = TextEditingController();
  
  Future<void> _addEmployee() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    
    await _storage.addEmployee(name);
    _nameController.clear();
    widget.onEmployeeAdded();
    
    // Hide keyboard
    FocusScope.of(context).unfocus();
  }
  
  Future<void> _deleteEmployee(String employeeId, String employeeName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mitarbeiter löschen'),
        content: Text('Möchtest du den Mitarbeiter "$employeeName" wirklich löschen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      await _storage.deleteEmployee(employeeId);
      widget.onEmployeeDeleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add employee section
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Mitarbeiter Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onSubmitted: (_) => _addEmployee(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _addEmployee,
                icon: const Icon(Icons.person_add),
                label: const Text('Hinzufügen'),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Employee list
          ValueListenableBuilder(
            valueListenable: Hive.box<Employee>('employees').listenable(),
            builder: (context, Box<Employee> box, _) {
              final employees = box.values.toList();
              
              if (employees.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Keine Mitarbeiter vorhanden. Füge einen neuen Mitarbeiter hinzu.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mitarbeiterliste:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: employees.map((employee) {
                      return Chip(
                        label: Text(employee.name),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _deleteEmployee(
                          employee.key.toString(),
                          employee.name,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}