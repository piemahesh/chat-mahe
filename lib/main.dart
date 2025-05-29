import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_my_app/config/index.dart';
import 'package:flutter_my_app/data/models/index.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'core/constants/app_strings.dart'; // your constants

void main() async {
  debugPrint("hello world");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize Hive
  await Hive.initFlutter();

  // Generate a 256-bit encryption key from a secure passphrase
  final passphrase =
      AppStrings
          .hiveEncryptionKey; // Store this securely (e.g. from secure storage)
  final key = sha256.convert(utf8.encode(passphrase)).bytes;

  // Open an encrypted box for storing messages locally
  // await Hive.openBox('messagesBox', encryptionCipher: HiveAesCipher(key));
  // Register adapter if you have a Hive TypeAdapter (optional here)
  Hive.registerAdapter(MessageModelAdapter());

  // Open encrypted box for messages
  await Hive.openBox<MessageModel>(
    'messagesBox',
    encryptionCipher: HiveAesCipher(key),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // <-- Use GoRouter instance here
      debugShowCheckedModeBanner: false,
    );
  }
}
