import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_my_app/data/models/index.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final DatabaseReference _realtimeDb = FirebaseDatabase.instance.ref();

  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  DatabaseReference get realtimeDb => _realtimeDb;

  // Firestore collection
  CollectionReference getCollection(String collectionPath) {
    return _firestore.collection(collectionPath);
  }

  // Upload file to Firebase Storage
  Future<String> uploadFile({
    required String path,
    required List<int> fileBytes,
    required String contentType,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putData(
      Uint8List.fromList(fileBytes),
      SettableMetadata(contentType: contentType),
    );
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // --- New: Fetch all messages from Realtime DB
  Future<List<MessageModel>> fetchMessages() async {
    final messagesRef = _realtimeDb.child('messages');
    final snapshot = await messagesRef.orderByChild('timestamp').get();

    if (snapshot.exists) {
      final Map<dynamic, dynamic> messagesMap =
          snapshot.value as Map<dynamic, dynamic>;
      return messagesMap.entries.map((entry) {
        final messageData = Map<String, dynamic>.from(entry.value);
        return MessageModel.fromJson(messageData);
      }).toList();
    }
    return [];
  }

  // --- New: Fetch messages after a certain timestamp (for syncing)
  Future<List<MessageModel>> fetchMessagesAfter(int lastTimestamp) async {
    final messagesRef = _realtimeDb.child('messages');
    final snapshot =
        await messagesRef
            .orderByChild('timestamp')
            .startAfter(lastTimestamp)
            .get();

    if (snapshot.exists) {
      final Map<dynamic, dynamic> messagesMap =
          snapshot.value as Map<dynamic, dynamic>;
      return messagesMap.entries.map((entry) {
        final messageData = Map<String, dynamic>.from(entry.value);
        return MessageModel.fromJson(messageData);
      }).toList();
    }
    return [];
  }
}
