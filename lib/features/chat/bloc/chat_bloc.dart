import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_my_app/data/repositories/chat_repository.dart';
import '../../../data/models/message_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(const ChatState()) {
    on<LoadMessagesFromLocal>(_onLoadMessagesFromLocal);
    on<UpdateMessagesFromRemote>(_onUpdateMessagesFromRemote);
  }

  Future<void> _onLoadMessagesFromLocal(
    LoadMessagesFromLocal event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final messages = await chatRepository.getMessagesFromLocal();
    emit(state.copyWith(messages: messages, isLoading: false));
  }

  Future<void> _onUpdateMessagesFromRemote(
    UpdateMessagesFromRemote event,
    Emitter<ChatState> emit,
  ) async {
    await chatRepository.saveMessagesToLocal(event.newMessages);
    final messages = await chatRepository.getMessagesFromLocal();
    emit(state.copyWith(messages: messages));
  }
}
