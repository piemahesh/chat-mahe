// lib/core/services/hive_service.dart
import 'package:flutter_my_app/data/models/index.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _messagesBox = 'messages';

  // // Initialize Hive (call this once in main before runApp)
  // Future<void> init() async {
  //   await Hive.initFlutter();
  //
  //   // Register adapter only once
  //   if (!Hive.isAdapterRegistered(0)) {
  //     Hive.registerAdapter(MessageModelAdapter());
  //   }
  // }
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MessageModelAdapter());
    }

    if (!Hive.isBoxOpen('messages')) {
      await Hive.openBox<MessageModel>('messages');
    }
  }

  // Open the box for messages
  Future<Box<MessageModel>> _openMessagesBox() async {
    return await Hive.openBox<MessageModel>(_messagesBox);
  }

  // Get all messages as a Map
  Future<Map<dynamic, MessageModel>> getAllMessages() async {
    final box = await _openMessagesBox();
    return box.toMap();
  }

  Future<List<MessageModel>> getMessages() async {
    final box = Hive.box<MessageModel>(_messagesBox);
    return box.values.toList();
  }

  // Save or update a single message by id
  Future<void> saveMessage(String id, MessageModel message) async {
    final box = await _openMessagesBox();
    await box.put(id, message);
  }

  // Save multiple messages (bulk)
  Future<void> saveMessages(List<MessageModel> messages) async {
    final box = await _openMessagesBox();
    final Map<String, MessageModel> messagesMap = {
      for (var msg in messages) msg.id: msg,
    };
    await box.putAll(messagesMap);
  }

  // Delete message by id (optional)
  Future<void> deleteMessage(String id) async {
    final box = await _openMessagesBox();
    await box.delete(id);
  }

  // Clear all messages (optional)
  Future<void> clearMessages() async {
    final box = await _openMessagesBox();
    await box.clear();
  }
}
