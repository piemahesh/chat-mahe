import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_my_app/config/index.dart';
import 'package:flutter_my_app/core/constants/app_strings.dart';
import 'package:flutter_my_app/core/services/hive_service.dart';
import 'package:flutter_my_app/data/models/index.dart';
import 'package:flutter_my_app/data/repositories/chat_repository.dart';
import 'package:flutter_my_app/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_my_app/features/user/bloc/user_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();

  // Register Hive adapter
  Hive.registerAdapter(MessageModelAdapter());

  // Encryption key
  final passphrase = AppStrings.hiveEncryptionKey;
  final key = sha256.convert(utf8.encode(passphrase)).bytes;

  // Open Hive box
  await Hive.openBox<MessageModel>(
    'messagesBox',
    encryptionCipher: HiveAesCipher(key),
  );

  // Setup services
  final hiveService = HiveService();
  final chatRepository = ChatRepository(hiveService: hiveService);

  runApp(MyApp(hiveService: hiveService, chatRepository: chatRepository));
}

class MyApp extends StatelessWidget {
  final HiveService hiveService;
  final ChatRepository chatRepository;

  const MyApp({
    super.key,
    required this.hiveService,
    required this.chatRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (_) => UserBloc()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<ChatBloc>(
          create:
              (_) =>
                  ChatBloc(chatRepository: chatRepository)
                    ..add(LoadMessagesFromLocalEvent()),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
