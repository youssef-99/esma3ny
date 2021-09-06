import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pusher/pusher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class CallPage extends StatefulWidget {
  final Room room;
  final int clientId;
  final endTime;

  /// Creates a call page with given channel name.
  const CallPage({@required this.room, this.clientId, @required this.endTime});

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _usersInfo = <int, Map<String, dynamic>>{};
  final _infoStrings = <String>[];
  String state;
  bool micMuted = false;
  bool videoMuted = false;
  RtcEngine _engine;
  LoginResponse _loginResponse;
  Channel channel;
  ChatState _chatState;
  bool isClient = true;
  PublicRepository _publicRepository = PublicRepository();

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
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

  @override
  void initState() {
    Provider.of<CallState>(context, listen: false)
        .createTimer(DateTime.parse(widget.endTime));
    super.initState();
    getInitData();
    initPusher();
    // initialize agora sdk
    _handleCameraAndMic();
    initialize();
  }

  getInitData() async {
    isClient = await SharedPrefrencesHelper.isLogged() == CLIENT;
    if (!isClient) {
      await Provider.of<CallState>(context, listen: false).getInitData(
          '${widget.room.id}-${widget.room.uuid}', widget.clientId);
    }
  }

  Future<void> _handleCameraAndMic() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    try {
      await _initAgoraRtcEngine();
    } catch (e) {
      print(e);
    }
    _addAgoraEventHandlers();
    // ignore: deprecated_member_use
    await _engine.enableWebSdkInteroperability(true);

    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(width: 1920, height: 1080);
    configuration.frameRate = VideoFrameRate.Fps30;
    configuration.orientationMode = VideoOutputOrientationMode.Adaptative;
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(
        widget.room.token, widget.room.uuid, null, _loginResponse.uid);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(APP_ID));
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(
      RtcEngineEventHandler(error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      }, joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      }, leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      }, userJoined: (uid, elapsed) async {
        _usersInfo[uid] = {};
        _usersInfo[uid]['audio'] = false;
        _usersInfo[uid]['video'] = false;
        dynamic data = await _publicRepository.getSessionPics(
            widget.room.id, widget.room.uuid, uid);
        setState(() {
          _users.add(uid);
          _usersInfo[uid]['name'] = data['name'];
          _usersInfo[uid]['profile_pic'] = data['image'];
        });
      }, userOffline: (uid, elapsed) {
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _infoStrings.add(info);
        });
      }, rejoinChannelSuccess: (channelName, uid, elapsed) {
        setState(() {
          final info = 'user $uid $elapsed rejoin';
          _infoStrings.add(info);
        });
      }, connectionStateChanged: (connectionStateType, connectionStateReason) {
        setState(() {
          if (ConnectionStateType.Connecting == connectionStateType) {
            final info = 'conneting';
            _infoStrings.add(info);
          } else if (connectionStateReason ==
              ConnectionChangedReason.Interrupted) {}
          final info = 'interrupted';
          _infoStrings.add(info);
        });
      }, networkQuality: (uid, networkQuality, netWorkQuality) {
        setState(() {
          if (NetworkQuality.Bad == networkQuality && state != 'bad') {
            if (!_users.contains(uid))
              Fluttertoast.showToast(msg: 'Network is Bad $state');
            state = 'bad';
          }
        });
      }, connectionLost: () {
        _infoStrings.add('connection lost');
      }, videoStopped: () {
        _infoStrings.add('video stopped');
      }, userMuteVideo: (uid, value) {
        _usersInfo[uid]['video'] = value;
      }, userMuteAudio: (uid, value) {
        _usersInfo[uid]['audio'] = value;
      }),
    );
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<Widget> list = [];
    if (!videoMuted)
      list.add(
        Stack(
          alignment: Alignment.center,
          children: [
            RtcLocalView.SurfaceView(),
            micMuted ? Icon(Icons.mic_off) : SizedBox(),
          ],
        ),
      );
    else {
      list.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: decoration(CustomColors.orange, 100),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedImage(
                    url: _loginResponse.profileImage.small,
                    raduis: 70,
                  ),
                  micMuted ? Icon(Icons.mic_off) : SizedBox(),
                ],
              ),
            ),
            Text(
              _loginResponse.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      );
    }

    _users.forEach(
      (uid) {
        if (!_usersInfo[uid]['video'])
          list.add(
            Stack(
              alignment: Alignment.center,
              children: [
                RtcRemoteView.SurfaceView(uid: uid),
                _usersInfo[uid]['audio'] ? Icon(Icons.mic_off) : SizedBox(),
              ],
            ),
          );
        else
          list.add(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: decoration(CustomColors.orange, 100),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CachedImage(
                        url:
                            'https://esma3ny.org/${_usersInfo[uid]['profile_pic']}',
                        raduis: 70,
                      ),
                      _usersInfo[uid]['audio']
                          ? Icon(Icons.mic_off)
                          : SizedBox(),
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
    // list.add(RtcLocalView.SurfaceView());

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
    return Expanded(
      child: Container(child: view),
    );
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[
            _videoView(views[0]),
          ],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[1]]),
            _expandedVideoRow([views[0]]),
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onDisableVideo,
            child: Icon(
              videoMuted ? Icons.videocam_off : Icons.videocam,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              micMuted ? Icons.mic_off : Icons.mic,
              color: micMuted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: micMuted ? Colors.blueAccent : Colors.white,
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

  void _onToggleMute() {
    setState(() {
      micMuted = !micMuted;
    });
    _engine.muteLocalAudioStream(micMuted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onDisableVideo() {
    setState(() {
      videoMuted = !videoMuted;
    });
    _engine.muteLocalVideoStream(videoMuted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        children: [
          FloatingActionButton(
            heroTag: 'switch_cam',
            mini: true,
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.camera_rear_rounded,
              color: Colors.blueAccent,
            ),
            backgroundColor: Colors.white,
            // child: ,
          ),
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
                            widget.clientId, widget.endTime)));
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
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                ],
              ),
              backgroundColor: Colors.white,
              // child: ,
            ),
          ),
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
          isClient
              ? Consumer<CallState>(
                  builder: (context, state, child) => FloatingActionButton(
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
              : SizedBox()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      //appBar: AppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              // _panel(),
              _toolbar(),
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
