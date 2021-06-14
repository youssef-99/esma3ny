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

  Map<String, dynamic> toJson(String accountType) {
    return {
      'account_type': accountType,
      'video_dollar_fees_full': video.usd.full,
      'video_dollar_fees_half': video.usd.half,
      'video_egp_fees_full': video.egp.full,
      'video_egp_fees_half': video.egp.half,
      'audio_dollar_fees_full': audio.usd.full,
      'audio_dollar_fees_half': audio.usd.half,
      'audio_egp_fees_full': audio.egp.full,
      'audio_egp_fees_half': audio.egp.half,
      'chat_dollar_fees_full': chat.usd.full,
      'chat_dollar_fees_half': chat.usd.half,
      'chat_egp_fees_full': chat.egp.full,
      'chat_egp_fees_half': chat.egp.half,
    };
  }
}
