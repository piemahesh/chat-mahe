import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_my_app/core/services/index.dart';
import 'package:flutter_my_app/data/repositories/chat_repository.dart';
import 'package:flutter_my_app/features/auth/index.dart';
import 'package:flutter_my_app/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_my_app/features/chat/bloc/chat_event.dart';
import 'package:flutter_my_app/features/chat/index.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(path: '/', name: 'home', builder: (context, state) => ChatScreen()),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) {
        final hiveService = HiveService(); // Assuming it's already initialized
        final chatRepo = ChatRepository(hiveService: hiveService);
        return BlocProvider(
          create: (_) => ChatBloc(chatRepo)..add(LoadMessagesFromLocal()),
          child: const ChatScreen(),
        );
      },
    ),
  ],
);
