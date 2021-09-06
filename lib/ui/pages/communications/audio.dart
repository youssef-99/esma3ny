import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:esma3ny/core/constants.dart';
import 'package:esma3ny/data/models/public/login_response.dart';
import 'package:esma3ny/data/models/public/room.dart';
import 'package:esma3ny/data/shared_prefrences/shared_prefrences.dart';
import 'package:esma3ny/repositories/public/public_repository.dart';
import 'package:esma3ny/ui/pages/communications/chat.dart';
import 'package:esma3ny/ui/pages/doctor/client_health_profile.dart';
import 'package:esma3ny/ui/pages/doctor/session_notes.dart';
import 'package:esma3ny/ui/pages/doctor/share_notes_page.dart';
import 'package:esma3ny/ui/provider/client/chat_state.dart';
import 'package:esma3ny/ui/provider/therapist/call_state.dart';
import 'package:esma3ny/ui/theme/colors.dart';
import 'package:esma3ny/ui/widgets/chached_image.dart';
import 'package:esma3ny/ui/widgets/utils/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:proximity_sensor/proximity_sensor.dart';

/// JoinChannelAudio Example
class JoinChannelAudio extends StatefulWidget {
  final Room room;
  final int clientId;
  final endTime;

  const JoinChannelAudio({
    Key key,
    @required this.room,
    @required this.endTime,
    this.clientId,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<JoinChannelAudio> {
  RtcEngine _engine;
  bool isJoined = false, openMicrophone = true, enableSpeakerphone = false;
  bool _enableInEarMonitoring = false;
  double _recordingVolume = 400,
      _playbackVolume = 400,
      _inEarMonitoringVolume = 400;

  final _users = <int>[];
  final _usersInfo = <int, Map<String, dynamic>>{};
  String state;
  LoginResponse _loginResponse;
  ChatState _chatState;
  bool isClient = true;
  PublicRepository _publicRepository = PublicRepository();
  Channel channel;
  bool _isNear = false;
  StreamSubscription<dynamic> _streamSubscription;

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        if (!enableSpeakerphone) {
          _isNear = (event > 0) ? true : false;
          if (_isNear) {
            SystemChrome.setEnabledSystemUIOverlays([]);
          } else {
            SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
          }
        }
      });
    });
  }

  @override
  void initState() {
    Provider.of<CallState>(context, listen: false)
        .createTimer(DateTime.parse(widget.endTime));
    super.initState();
    getInitData();
    initPusher();
    this._initEngine();
    this._joinChannel();
    listenSensor();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  getInitData() async {
    isClient = await SharedPrefrencesHelper.isLogged() == CLIENT;
    if (!isClient) {
      await Provider.of<CallState>(context, listen: false).getInitData(
          '${widget.room.id}-${widget.room.uuid}', widget.clientId);
    }
  }

  _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(APP_ID));
    this._addListeners();

    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  _addListeners() {
    _engine.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: (channel, uid, elapsed) {
      print('joinChannelSuccess ${channel} ${uid} ${elapsed}');
      setState(() {
        isJoined = true;
      });
    }, leaveChannel: (stats) async {
      print('leaveChannel ${stats.toJson()}');
      setState(() {
        _users.clear();
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        _users.remove(uid);
      });
    }, userJoined: (uid, elapsed) async {
      _usersInfo[uid] = {};
      _usersInfo[uid]['audio'] = false;
      dynamic data = await _publicRepository.getSessionPics(
          widget.room.id, widget.room.uuid, uid);
      setState(
        () {
          _users.add(uid);
          _usersInfo[uid]['name'] = data['name'];
          _usersInfo[uid]['profile_pic'] = data['image'];
        },
      );
    }, userMuteAudio: (uid, value) {
      setState(() {
        _usersInfo[uid]['audio'] = value;
      });
    }));
  }

  initPusher() async {
    _loginResponse = await SharedPrefrencesHelper.getLoginData();
    _chatState = Provider.of<ChatState>(context, listen: false);
    _chatState.isVideoCall = true;
    try {
      await Pusher.init(
        '42af18980641fe3a9f51',
        PusherOptions(cluster: 'eu'),
        enableLogging: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }
    await Pusher.connect(onConnectionStateChange: (x) {
      print(x.currentState);
    }, onError: (e) {
      print(e);
    });

    channel = await Pusher.subscribe(widget.room.uuid);

    _chatState.getMe(_loginResponse);

    await channel.bind('message', (event) {
      Map<String, dynamic> data = jsonDecode(event.data);
      _chatState.addMessage(
        data['message'],
        data['author']['name'],
      );
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

  _joinChannel() async {
    await Permission.microphone.request();

    await _engine
        .joinChannel(
            widget.room.token, widget.room.uuid, null, _loginResponse.uid)
        .catchError((onError) {
      print('error ${onError.toString()}');
    });
  }

  _switchMicrophone() {
    _engine.enableLocalAudio(!openMicrophone).then((value) {
      setState(() {
        openMicrophone = !openMicrophone;
      });
    }).catchError((err) {
      log('enableLocalAudio $err');
    });
  }

  _switchSpeakerphone() {
    _engine.setEnableSpeakerphone(!enableSpeakerphone).then((value) {
      setState(() {
        enableSpeakerphone = !enableSpeakerphone;
      });
    }).catchError((err) {
      log('setEnableSpeakerphone $err');
    });
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<Widget> list = [];

    _users.forEach(
      (uid) {
        list.add(
          Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                decoration: decoration(CustomColors.orange, 100),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedImage(
                      url: _usersInfo[uid]['profile_pic'].substring(5) ==
                              'https'
                          ? 'https://esma3ny.org/${_usersInfo[uid]['profile_pic']}'
                          : _usersInfo[uid]['profile_pic'],
                      raduis: 70,
                    ),
                    _usersInfo[uid]['audio'] ? Icon(Icons.mic_off) : SizedBox(),
                  ],
                ),
              ),
              Text(
                _usersInfo[uid]['name'],
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        );
      },
    );

    return list;
  }

  decoration(Color borderColor, double borderRaduis) => BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: 3,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(borderRaduis),
      );

  /// Video view wrapper
  Widget _videoView(view) {
    return view;
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: wrappedViews,
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _videoView(views[0]),
          ],
        );
      case 2:
        return Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _expandedVideoRow([views[1]]),
            _expandedVideoRow([views[0]]),
          ],
        ));
      case 3:
        return Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return _isNear
        ? Container()
        : Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
            floatingActionButton: Column(
              children: [
                Consumer<ChatState>(
                  builder: (context, state, child) => FloatingActionButton(
                    heroTag: 'chat',
                    mini: true,
                    onPressed: () {
                      state.resetMessagesNumber();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(widget.room, false,
                              widget.clientId, widget.endTime),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Icon(
                          Icons.chat_bubble,
                          color: Colors.blueAccent,
                        ),
                        state.numOfMessages == 0
                            ? SizedBox()
                            : CircleAvatar(
                                radius: 7,
                                backgroundColor: Colors.red,
                                child: Text(
                                  state.numOfMessages.toString(),
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ),
                      ],
                    ),
                    backgroundColor: Colors.white,
                    // child: ,
                  ),
                ),
                isClient
                    ? Consumer<CallState>(
                        builder: (context, state, child) =>
                            FloatingActionButton(
                          heroTag: 'allow_share',
                          mini: true,
                          backgroundColor: Colors.white,
                          onPressed: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: CheckboxListTile(
                                    value: state.authorizeNotesReferral,
                                    onChanged: (value) {
                                      state.authorizeReferral(value,
                                          '${widget.room.id}-${widget.room.uuid}');
                                      Navigator.pop(context);
                                    },
                                    title: Text('Authorize notes referral'),
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.notes,
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                    : SizedBox(),
                isClient
                    ? SizedBox()
                    : FloatingActionButton(
                        heroTag: 'notes',
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SessionNotes())),
                        child: Icon(
                          Icons.note_add,
                          color: Colors.blueAccent,
                        ),
                      ),
                isClient
                    ? SizedBox()
                    : FloatingActionButton(
                        heroTag: 'health_profile',
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClientHealthProfilePage(),
                          ),
                        ),
                        child: Icon(
                          Icons.health_and_safety,
                          color: Colors.blueAccent,
                        ),
                      ),
                isClient
                    ? SizedBox()
                    : FloatingActionButton(
                        heroTag: 'share_notes',
                        mini: true,
                        backgroundColor: Colors.white,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ShareNotesPage(
                              uid: '${widget.room.id}-${widget.room.uuid}',
                            ),
                          ),
                        ),
                        child: Icon(
                          Icons.person_add,
                          color: Colors.blueAccent,
                        ),
                      ),
              ],
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Timer(),
                  ),
                  Center(child: _viewRows()),
                  _toolbar(),
                ],
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

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: this._switchMicrophone,
            child: Icon(
              !openMicrophone ? Icons.mic_off : Icons.mic,
              color: !openMicrophone ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: !openMicrophone ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: this._switchSpeakerphone,
            child: Icon(
              enableSpeakerphone ? Icons.speaker : Icons.headset,
              color: enableSpeakerphone ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: enableSpeakerphone ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          isClient
              ? RawMaterialButton(
                  onPressed: () => _onCallEnd(context),
                  child: Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                )
              : ElevatedButton(
                  onPressed: () => _onCallEnd(context),
                  child: Text('End Session'),
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
        ],
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
