import 'package:flutter_my_app/core/services/index.dart';
import 'package:flutter_my_app/data/models/message_model.dart';

class ChatRepository {
  final HiveService hiveService;

  ChatRepository({required this.hiveService});

  Future<List<MessageModel>> getMessagesFromLocal() async {
    return await hiveService.getMessages();
  }

  Future<void> saveMessagesToLocal(List<MessageModel> messages) async {
    await hiveService.saveMessages(messages);
  }
}
