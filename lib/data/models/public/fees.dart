import 'package:flutter/material.dart';

class FeesAmount {
  final full;
  final half;

  FeesAmount({@required this.full, @required this.half});

  factory FeesAmount.fromJson(Map<String, dynamic> json) {
    return FeesAmount(full: json['full'], half: json['half']);
  }

  Map<String, dynamic> toJson() {
    return {
      'half': half,
      'full': full,
    };
  }
}

class FeesUnit {
  final FeesAmount usd;
  final FeesAmount egp;

  FeesUnit({@required this.usd, @required this.egp});

  factory FeesUnit.fromJson(Map<String, dynamic> json) {
    return FeesUnit(
      usd: FeesAmount.fromJson(json['usd']),
      egp: FeesAmount.fromJson(json['egp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usd': usd.toJson(),
      'full': egp.toJson(),
    };
  }
}

class Fees {
  final FeesUnit video;
  final FeesUnit audio;
  final FeesUnit chat;

  Fees({
    @required this.video,
    @required this.audio,
    @required this.chat,
  });

  factory Fees.fromJson(Map<String, dynamic> json) {
    return Fees(
      video: FeesUnit.fromJson(json['video']),
      audio: FeesUnit.fromJson(json['audio']),
      chat: FeesUnit.fromJson(json['chat']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video': video.toJson(),
      'audio': audio.toJson(),
      'chat': chat.toJson(),
    };
  }
}
