// lib/features/chat/bloc/chat_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_my_app/data/models/index.dart';

class ChatState extends Equatable {
  final List<MessageModel> messages;
  final bool isLoading;

  const ChatState({this.messages = const [], this.isLoading = false});

  ChatState copyWith({List<MessageModel>? messages, bool? isLoading}) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [messages, isLoading];
}
