import 'package:hive/hive.dart';

part 'message_model.g.dart'; 

@HiveType(typeId: 1) 
class MessageModel {
  @HiveField(0) 
  final String message;

  @HiveField(1) 
  final String username;

  @HiveField(2) 
  final DateTime dateTime;

  MessageModel({
    required this.message,
    required this.username,
    required this.dateTime,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      username: json['username'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'username': username,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}
