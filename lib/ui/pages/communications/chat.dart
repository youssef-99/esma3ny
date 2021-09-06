import 'dart:convert';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/models/public/login_response.dart';
import 'package:esma3ny/data/models/public/room.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/ui/pages/doctor/client_health_profile.dart';
import 'package:esma3ny/ui/pages/doctor/session_notes.dart';
import 'package:esma3ny/ui/pages/doctor/share_notes_page.dart';
import 'package:esma3ny/ui/provider/client/chat_state.dart';
import 'package:esma3ny/ui/provider/public/image_picker_state.dart';
import 'package:esma3ny/ui/provider/therapist/call_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatScreen extends StatefulWidget {
  final Room room;
  final isChatSession;
  final clientId;
  final endTime;
  ChatScreen(this.room, this.isChatSession, this.clientId, this.endTime);
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
  bool isClient = true;
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
    Provider.of<CallState>(context, listen: false)
        .createTimer(DateTime.parse(widget.endTime));
    _chatState = Provider.of(context, listen: false);
    if (widget.isChatSession) initPusher();
    super.initState();
    getInitData();
  }

  sendMessage(String type) async {
    try {
      await _publicRepository.sendChatMessage(
        widget.room.id,
        widget.room.uuid,
        _textEditingController.text,
      );
      _textEditingController.clear();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(), backgroundColor: Colors.red);
    }
  }

  getInitData() async {
    isClient = await SharedPrefrencesHelper.isLogged() == CLIENT;
    if (!isClient) {
      await Provider.of<CallState>(context, listen: false).getInitData(
          '${widget.room.id}-${widget.room.uuid}', widget.clientId);
    }
  }

  initPusher() async {
    _loginResponse = await SharedPrefrencesHelper.getLoginData();
    Provider.of<ChatState>(context, listen: false).getMe(_loginResponse);
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
      Map<String, dynamic> data = jsonDecode(event.data);
      _chatState.addMessage(data['message'], data['author']['name']);
    });

    await channel.bind('end-session', (event) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Session Ended Successfully',
        backgroundColor: Colors.green,
      );
      Provider.of<CallState>(context, listen: false).reloadSessionsList();
    });
  }

  bool showEmojiPicker = false;
  @override
  Widget build(BuildContext context) {
    _chatState = Provider.of<ChatState>(context);
    return WillPopScope(
      onWillPop: () async {
        _chatState.resetMessagesNumber();
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
        endDrawer: Drawer(
          child: Scaffold(
            appBar: AppBar(backgroundColor: CustomColors.orange),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  isClient
                      ? SizedBox()
                      : ListTile(
                          leading: Text(
                            'Health Profile',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClientHealthProfilePage(),
                            ),
                          ),
                        ),
                  isClient
                      ? SizedBox()
                      : ListTile(
                          leading: Text(
                            'Referr Client Notes',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShareNotesPage(
                                uid: '${widget.room.id}-${widget.room.uuid}',
                              ),
                            ),
                          ),
                        ),
                  isClient
                      ? SizedBox()
                      : ListTile(
                          leading: Text(
                            'Session Notes',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SessionNotes())),
                        ),
                  isClient
                      ? SizedBox()
                      : ListTile(
                          leading: Text(
                            'Share Session',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () {},
                        ),
                  isClient
                      ? Consumer<CallState>(
                          builder: (context, state, child) => CheckboxListTile(
                            value: state.authorizeNotesReferral,
                            onChanged: (value) {
                              state.authorizeReferral(value,
                                  '${widget.room.id}-${widget.room.uuid}');
                            },
                            title: Text('Authorize notes referral'),
                          ),
                        )
                      : SizedBox(),
                  Spacer(),
                  isClient
                      ? SizedBox()
                      : ElevatedButton(
                          onPressed: () => _onCallEnd(context),
                          child: Text('End session'))
                ],
              ),
            ),
          ),
        ),
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
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: messagesList(),
                  ),
                  bottomTextfield(),
                  Container(child: showEmojiPicker ? emojis() : Container())
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Timer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    if (!isClient) {
      Provider.of<CallState>(context, listen: false).endSession();
      Fluttertoast.showToast(
        msg: 'Session Ended Successfully',
        backgroundColor: Colors.green,
      );
    }
    Navigator.pop(context);
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
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  hintText: 'Type your message here...',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: () async {
                  await Provider.of<ImagePickerState>(context, listen: false)
                      .pick(widget.room.id, widget.room.uuid);
                }),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                await sendMessage('text');
                // _scrollController
                //     .jumpTo(_scrollController.position.maxScrollExtent);
              },
            )
          ],
        ),
      );
}

class MessageBubble extends StatelessWidget {
  MessageBubble(this.message, this.messageSender, this.isMe);
  final message;
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
              child: getMessage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMessage() {
    if (message['type'] == 'text') {
      return Text(
        message['content'],
        style: TextStyle(
          fontSize: 15.0,
          color: isMe ? Colors.white : Colors.black54,
        ),
      );
    } else if (message['type'] == 'image') {
      return ClipRRect(
        child:
            Image.network('https://esma3ny.org/storage/${message['content']}'),
      );
    }
    return TextButton(
      onPressed: () async => await canLaunch(
              'https://esma3ny.org/storage/${message['content']}')
          ? await launch('https://esma3ny.org/storage/${message['content']}')
          : throw 'Could not launch ${message['content']}',
      child: Text(
        message['content'],
      ),
    );
  }
}

class Timer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      height: 30,
      color: Colors.white,
      child: CountdownTimer(
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        controller:
            Provider.of<CallState>(context, listen: false).timerController,
      ),
    );
  }
}
