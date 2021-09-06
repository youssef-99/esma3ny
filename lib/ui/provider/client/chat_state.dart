import 'package:esma3ny/data/models/public/login_response.dart';
import 'package:esma3ny/ui/pages/communications/chat.dart';
import 'package:flutter/material.dart';

class ChatState extends ChangeNotifier {
  List<MessageBubble> _messages = [];
  LoginResponse _loginResponse;
  bool isVideoCall = false;
  int numOfMessages = 0;

  getMe(LoginResponse loginResponse) {
    _loginResponse = loginResponse;
  }

  addMessage(Map<String, dynamic> message, String type) {
    _messages.add(MessageBubble(message, type, type == _loginResponse.name));
    numOfMessages++;
    notifyListeners();
  }

  resetMessagesNumber() {
    numOfMessages = 0;
    notifyListeners();
  }

  List<MessageBubble> get messages => _messages;
}
