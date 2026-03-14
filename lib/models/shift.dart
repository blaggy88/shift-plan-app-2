import 'package:hive/hive.dart';

part 'shift.g.dart';

@HiveType(typeId: 1)
class Shift extends HiveObject {
  @HiveField(0)
  String employeeId;
  
  @HiveField(1)
  String weekType; // 'A', 'B', 'C', 'D' or 'standard'
  
  @HiveField(2)
  String day; // 'monday', 'tuesday', etc. or 'saturday_A', etc.
  
  @HiveField(3)
  String shiftCode; // 'F', 'M', 'S', 'E', 'U', 'X', 'Schule', 'Seminar', 'LR' or custom time
  
  @HiveField(4)
  bool isCustomTime;
  
  Shift({
    required this.employeeId,
    required this.weekType,
    required this.day,
    required this.shiftCode,
    this.isCustomTime = false,
  });
  
  String get displayText {
    if (isCustomTime) {
      return shiftCode;
    }
    
    final codes = {
      'F': 'Früh',
      'M': 'Mittel',
      'S': 'Spät',
      'E': 'Egal',
      'U': 'Urlaub',
      'X': 'Frei',
      'Schule': 'Schule',
      'Seminar': 'Seminar',
      'LR': 'LR',
    };
    
    return codes[shiftCode] ?? shiftCode;
  }
}