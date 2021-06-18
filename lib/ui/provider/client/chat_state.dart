import 'package:esma3ny/ui/pages/communications/chat.dart';
import 'package:flutter/material.dart';

class ChatState extends ChangeNotifier {
  List<MessageBubble> _messages = [];

  addMessage(String message, String type) {
    _messages.add(MessageBubble(message, type, type == 'me'));
    notifyListeners();
  }

  List<MessageBubble> get messages => _messages;
}
