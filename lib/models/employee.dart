import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  String name;
  
  @HiveField(1)
  DateTime createdAt;
  
  Employee({
    required this.name,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
  
  @override
  String toString() => name;
}