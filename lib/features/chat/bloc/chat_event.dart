// lib/features/chat/bloc/chat_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_my_app/data/models/index.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

// Load all messages from local storage (Hive)
class LoadMessagesFromLocal extends ChatEvent {}

// Update messages from remote source (e.g. Realtime DB)
class UpdateMessagesFromRemote extends ChatEvent {
  final List<MessageModel> newMessages;

  const UpdateMessagesFromRemote(this.newMessages);

  @override
  List<Object> get props => [newMessages];
}
