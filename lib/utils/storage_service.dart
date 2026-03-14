import 'package:hive_flutter/hive_flutter.dart';
import 'package:shift_plan_app/models/employee.dart';
import 'package:shift_plan_app/models/shift.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();
  
  Box<Employee> get employeesBox => Hive.box<Employee>('employees');
  Box<Shift> get shiftsBox => Hive.box<Shift>('shifts');
  
  // Employee operations
  Future<void> addEmployee(String name) async {
    await employeesBox.add(Employee(name: name));
  }
  
  Future<void> deleteEmployee(String employeeId) async {
    // Delete employee
    await employeesBox.delete(employeeId);
    
    // Delete all shifts for this employee
    final shiftsToDelete = shiftsBox.values
        .where((shift) => shift.employeeId == employeeId)
        .toList();
    
    for (final shift in shiftsToDelete) {
      await shift.delete();
    }
  }
  
  List<Employee> getEmployees() {
    return employeesBox.values.toList();
  }
  
  // Shift operations
  Future<void> saveShift({
    required String employeeId,
    required String weekType,
    required String day,
    required String shiftCode,
    bool isCustomTime = false,
  }) async {
    // Check if shift already exists
    final existingShift = shiftsBox.values.firstWhere(
      (shift) =>
          shift.employeeId == employeeId &&
          shift.weekType == weekType &&
          shift.day == day,
      orElse: () => Shift(
        employeeId: '',
        weekType: '',
        day: '',
        shiftCode: '',
      ),
    );
    
    if (existingShift.employeeId.isNotEmpty) {
      // Update existing shift
      existingShift.shiftCode = shiftCode;
      existingShift.isCustomTime = isCustomTime;
      await existingShift.save();
    } else {
      // Create new shift
      await shiftsBox.add(Shift(
        employeeId: employeeId,
        weekType: weekType,
        day: day,
        shiftCode: shiftCode,
        isCustomTime: isCustomTime,
      ));
    }
  }
  
  Future<void> deleteShift({
    required String employeeId,
    required String weekType,
    required String day,
  }) async {
    final shift = shiftsBox.values.firstWhere(
      (shift) =>
          shift.employeeId == employeeId &&
          shift.weekType == weekType &&
          shift.day == day,
      orElse: () => Shift(
        employeeId: '',
        weekType: '',
        day: '',
        shiftCode: '',
      ),
    );
    
    if (shift.employeeId.isNotEmpty) {
      await shift.delete();
    }
  }
  
  Shift? getShift({
    required String employeeId,
    required String weekType,
    required String day,
  }) {
    try {
      return shiftsBox.values.firstWhere(
        (shift) =>
            shift.employeeId == employeeId &&
            shift.weekType == weekType &&
            shift.day == day,
      );
    } catch (e) {
      return null;
    }
  }
  
  // Get all shifts for an employee in a specific week
  List<Shift> getEmployeeShifts(String employeeId, String weekType) {
    return shiftsBox.values
        .where((shift) =>
            shift.employeeId == employeeId && shift.weekType == weekType)
        .toList();
  }
}