import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class UserProfile {
  List<String> kitchenGear;

  UserProfile({required this.kitchenGear});

  Map<String, dynamic> toJson() {
    return {
      'kitchenGear': kitchenGear,
    };
  }

  static UserProfile fromJson(Map<String, dynamic> json) {
    return UserProfile(
      kitchenGear: List<String>.from(json['kitchenGear'] ?? []),
    );
  }

  // Save to user.json
  Future<void> save() async {
    try {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/user.json');
  await file.writeAsString(jsonEncode(json));
  print('Saved user.json to ${file.path}');
    } catch (e) {
      print("Error saving user profile: $e");
    }
  }

  // Load from user.json
  static Future<UserProfile?> load() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/user.json');
      if (await file.exists()) {
        final data = await file.readAsString();
        return UserProfile.fromJson(jsonDecode(data));
      }
    } catch (e) {
      print("Error loading user profile: $e");
    }
    return null;
  }
}
