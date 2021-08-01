import 'dart:convert';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:esma3ny/data/models/public/login_response.dart';
import 'package:esma3ny/data/models/public/room.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/ui/provider/client/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final Room room;
  ChatScreen(this.room);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _txtFocusNode = FocusNode();
  ScrollController _scrollController = ScrollController();
  Event lastEvent;
  String lastConnectionState;
  Channel channel;
  PublicRepository _publicRepository = PublicRepository();
  LoginResponse _loginResponse;

  // List<MessageBubble> messages = [];

  _onEmojiSelected(Emoji emoji) {
    _textEditingController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
  }

  _onBackspacePressed() {
    _textEditingController
      ..text = _textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
  }

  ChatState _chatState;
  initState() {
    initPusher();
    super.initState();
  }

  sendMessage() async {
    try {
      _chatState.addMessage(_textEditingController.text, 'me');

      _textEditingController.clear();
      await _publicRepository.sendChatMessage(
        widget.room.id,
        widget.room.uuid,
        _chatState.messages.last.messageText,
      );
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
  }

  initPusher() async {
    _loginResponse = await SharedPrefrencesHelper.getLoginData();
    try {
      await Pusher.init('42af18980641fe3a9f51', PusherOptions(cluster: 'eu'),
          enableLogging: true);
    } on PlatformException catch (e) {
      print(e);
    }
    await Pusher.connect(onConnectionStateChange: (x) {
      print(x.currentState);
    }, onError: (e) {
      print(e);
    });

    channel = await Pusher.subscribe(widget.room.uuid);

    await channel.bind('message', (event) {
      if (jsonDecode(event.data)['author']['name'] != _loginResponse.name) {
        _chatState.addMessage(jsonDecode(event.data)['message'],
            jsonDecode(event.data)['author']['name']);
      }
    });
  }

  bool showEmojiPicker = false;
  @override
  Widget build(BuildContext context) {
    _chatState = Provider.of<ChatState>(context);
    return WillPopScope(
      onWillPop: () async {
        if (showEmojiPicker) {
          setState(() {
            showEmojiPicker = !showEmojiPicker;
          });
          return showEmojiPicker;
        }
        Navigator.pop(context);
        return showEmojiPicker;
      },
      child: Scaffold(
        key: scaffoldState,
        appBar: AppBar(
          title: Text(
            'Chat',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 20,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: messagesList(),
              ),
              bottomTextfield(),
              Container(child: showEmojiPicker ? emojis() : Container())
            ],
          ),
        ),
      ),
    );
  }

  void showKeyboard() => _txtFocusNode.requestFocus();
  void hideKeyboard() => _txtFocusNode.unfocus();

  void hideEmoji() {
    setState(() {
      if (mounted) {
        showEmojiPicker = false;
      }
    });
  }

  void showEmojis() {
    setState(() {
      if (mounted) {
        showEmojiPicker = true;
      }
    });
  }

  Widget emojis() => Offstage(
        offstage: !showEmojiPicker,
        child: SizedBox(
          height: 250,
          child: EmojiPicker(
              onEmojiSelected: (Category category, Emoji emoji) {
                _onEmojiSelected(emoji);
              },
              onBackspacePressed: _onBackspacePressed,
              config: const Config(
                  columns: 7,
                  emojiSizeMax: 32.0,
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  initCategory: Category.RECENT,
                  bgColor: Color(0xFFF2F2F2),
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  progressIndicatorColor: Colors.blue,
                  backspaceColor: Colors.blue,
                  showRecentsTab: true,
                  recentsLimit: 28,
                  noRecentsText: 'No Recents',
                  noRecentsStyle:
                      TextStyle(fontSize: 20, color: Colors.black26),
                  categoryIcons: CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL)),
        ),
      );

  Widget messagesList() {
    return Consumer<ChatState>(
      builder: (context, state, child) => ListView(
        controller: _scrollController,
        reverse: true,
        children: List.from(state.messages.reversed),
      ),
    );
  }

  Widget bottomTextfield() => Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
          ),
        ),
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.emoji_emotions),
                onPressed: () {
                  if (showEmojiPicker) {
                    hideEmoji();
                    showKeyboard();
                  } else {
                    hideKeyboard();
                    showEmojis();
                  }
                }),
            Expanded(
              child: TextField(
                  focusNode: _txtFocusNode,
                  controller: _textEditingController,
                  onTap: () {
                    if (showEmojiPicker) {
                      hideEmoji();
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    hintText: 'Type your message here...',
                    border: InputBorder.none,
                  )),
            ),
            // IconButton(
            //     icon: Icon(Icons.attach_file),
            //     onPressed: () {
            //       scaffoldState.currentState
            //           .showBottomSheet((builder) => Material(
            //                 elevation: 50,
            //                 child: Container(
            //                   decoration: BoxDecoration(
            //                     border: Border.all(color: Colors.grey),
            //                     borderRadius: BorderRadius.circular(20),
            //                   ),
            //                   width: double.infinity,
            //                   height: 200,
            //                   child: GridView.count(
            //                     crossAxisCount: 3,
            //                     shrinkWrap: true,
            //                     physics: NeverScrollableScrollPhysics(),
            //                     padding: EdgeInsets.symmetric(
            //                         horizontal: 50, vertical: 10),
            //                     primary: false,
            //                     children: [
            //                       ButtonChat(() {}, Icons.photo),
            //                       ButtonChat(() {}, Icons.file_copy),
            //                       ButtonChat(() {}, Icons.camera_alt),
            //                       ButtonChat(() {}, Icons.contact_phone)
            //                     ],
            //                   ),
            //                 ),
            //               ));
            //     }),
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () async {
                  await sendMessage();
                  // _scrollController
                  //     .jumpTo(_scrollController.position.maxScrollExtent);
                })
          ],
        ),
      );
}

class MessageBubble extends StatelessWidget {
  MessageBubble(this.messageText, this.messageSender, this.isMe);
  final messageText;
  final messageSender;
  final isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(messageSender),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                messageText,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
