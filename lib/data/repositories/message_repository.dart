import 'package:hive/hive.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../core/constants/app_strings.dart';
import '../models/message_model.dart';

class MessageRepository {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('messages');
  late Box<MessageModel> _messagesBox;

  MessageRepository() {
    _messagesBox = Hive.box<MessageModel>('messagesBox');
  }

  // Load all messages from Realtime DB on app start
  Future<void> loadInitialMessages() async {
    final snapshot = await _dbRef.get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> messagesMap = snapshot.value as Map;
      for (final entry in messagesMap.entries) {
        // final message = MessageModel.fromMap(
        //   Map<String, dynamic>.from(entry.value),
        // );
        // _messagesBox.put(message.id, message);
      }
    }
  }

  // Listen for updates (new or updated messages) by timestamp
  Stream<DatabaseEvent> listenForUpdates(int lastTimestamp) {
    // Query messages newer than lastTimestamp
    final query = _dbRef.orderByChild('timestamp').startAfter(lastTimestamp);
    return query.onChildAdded;
  }

  // Save/Update message in Hive
  Future<void> saveMessage(MessageModel message) async {
    await _messagesBox.put(message.id, message);
  }

  // Get all messages from Hive (local storage)
  List<MessageModel> getAllMessages() {
    return _messagesBox.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }
}
