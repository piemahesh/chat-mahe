import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseFirestore get firestore => _firestore;

  FirebaseStorage get storage => _storage;

  // Example: Get a collection reference by name
  CollectionReference getCollection(String collectionPath) {
    return _firestore.collection(collectionPath);
  }

  // Example: Upload file to Storage
  Future<String> uploadFile({
    required String path,
    required List<int> fileBytes,
    required String contentType,
  }) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putData(
      Uint8List.fromList(fileBytes), // convert List<int> to Uint8List here
      SettableMetadata(contentType: contentType),
    );
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
}
