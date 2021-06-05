import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:esma3ny/data/models/public/room.dart';
import 'package:esma3ny/ui/widgets/utils/settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CallPage extends StatefulWidget {
  final Room room;

  /// Creates a call page with given channel name.
  const CallPage({@required this.room});

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  String state;
  bool micMuted = false;
  bool videoMuted = false;
  RtcEngine _engine;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    _handleCameraAndMic();
    initialize();
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

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // ignore: deprecated_member_use
    await _engine.enableWebSdkInteroperability(true);

    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    configuration.frameRate = VideoFrameRate.Fps30;
    configuration.orientationMode = VideoOutputOrientationMode.Adaptative;
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(widget.room.token, widget.room.uuid, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.createWithConfig(RtcEngineConfig(APP_ID));
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
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
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
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
        String info;
        if (NetworkQuality.Bad == networkQuality && state != 'bad') {
          info = '$uid Network is Bad $state';
          _infoStrings.add(info);
          state = 'bad';
        } else if (NetworkQuality.Excellent == networkQuality &&
            state != 'excellent') {
          info = '$uid Network is excellent $state';
          _infoStrings.add(info);
          state = 'excellent';
        } else if (NetworkQuality.Poor == networkQuality && state != 'poor') {
          info = '$uid Network is poor $state';
          _infoStrings.add(info);
          state = 'poor';
        } else {
          info = '$uid unknown $state';
        }
      });
    }, connectionLost: () {
      _infoStrings.add('connection lost');
    }, videoStopped: () {
      _infoStrings.add('video stopped');
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];

    list.add(RtcLocalView.SurfaceView());

    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    // list.add(RtcLocalView.SurfaceView());

    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
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
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Stack(
          children: <Widget>[
            _expandedVideoRow([views[1]]),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 100, horizontal: 50),
                width: 150,
                height: 200,
                child: _expandedVideoRow([views[0]]),
              ),
            )
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
        ],
      ),
    );
  }

  //  RawMaterialButton(
  //           onPressed: _onSetBackgroundImage,
  //           child: Icon(
  //             Icons.image,
  //             color: Colors.blueAccent,
  //             size: 20.0,
  //           ),
  //           shape: CircleBorder(),
  //           elevation: 2.0,
  //           fillColor: Colors.white,
  //           padding: const EdgeInsets.all(12.0),
  //         ),

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
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

  void _onSetBackgroundImage() async {
    await _engine.setLiveTranscoding(
      LiveTranscoding(
        [TranscodingUser(_users[0], 0, 0)],
        backgroundImage: AgoraImage(
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.searchenginejournal.com%2Fgoogle-removes-some-filters-from-image-search-results%2F323241%2F&psig=AOvVaw2E-Q-3TYCXVP0fyeGkOLAl&ust=1614216332294000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCPjjlsquge8CFQAAAAAdAAAAABAD',
            0,
            0,
            100,
            100),
      ),
    );
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
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: _onSwitchCamera,
        child: Icon(
          Icons.camera_rear_rounded,
          color: Colors.blueAccent,
        ),
        backgroundColor: Colors.white,
        // child: ,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      //appBar: AppBar(),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            _viewRows(),
            // _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
