// lib/features/chat/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_my_app/data/models/index.dart';
import 'package:flutter_my_app/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_my_app/features/chat/bloc/chat_event.dart';
import 'package:flutter_my_app/features/chat/bloc/chat_state.dart';
import 'package:flutter_my_app/features/drawer/index.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Load messages from local storage when screen initializes
    context.read<ChatBloc>().add(LoadMessagesFromLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      drawer: AppDrawer(),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.messages.isEmpty) {
            return const Center(child: Text('No messages found.'));
          }

          return ListView.builder(
            reverse: true, // latest messages at bottom
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final MessageModel msg = state.messages[index];
              final bool isMe =
                  msg.senderId ==
                  'currentUserId'; // Replace with actual current user id logic

              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blueAccent : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    msg.content,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: _buildChatInput(),
    );
  }

  Widget _buildChatInput() {
    final TextEditingController _controller = TextEditingController();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) {
                  // Here you should trigger sending message event or call a method
                  // For now, just clear the input
                  _controller.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
