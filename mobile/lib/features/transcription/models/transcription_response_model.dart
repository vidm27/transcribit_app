// To parse this JSON data, do
//
//     final transcriptionResponse = transcriptionResponseFromJson(jsonString);

import 'dart:convert';

TranscriptionResponse transcriptionResponseFromJson(String str) =>
    TranscriptionResponse.fromJson(json.decode(str));

String transcriptionResponseToJson(TranscriptionResponse data) =>
    json.encode(data.toJson());

class TranscriptionResponse {
  int count;
  String? next;
  dynamic previous;
  List<Transcription> results;

  TranscriptionResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  factory TranscriptionResponse.fromJson(Map<String, dynamic> json) =>
      TranscriptionResponse(
        count: json["count"],
        next: json["next"] ?? "",
        previous: json["previous"],
        results: List<Transcription>.from(
            json["results"].map((x) => Transcription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Transcription {
  String id;
  dynamic state;
  List<dynamic> segments;
  String pathFile;
  dynamic title;
  String tokenUrl;
  DateTime uploaded;
  String? duration;
  String? language;
  double? languageProbability;
  String? topic;
  String? tag;

  Transcription({
    required this.id,
    required this.state,
    required this.segments,
    required this.pathFile,
    required this.title,
    required this.tokenUrl,
    required this.uploaded,
    required this.duration,
    required this.language,
    required this.languageProbability,
    required this.topic,
    required this.tag,
  });

  factory Transcription.fromJson(Map<String, dynamic> json) => Transcription(
        id: json["id"],
        state: json["state"],
        segments: List<dynamic>.from(json["segments"].map((x) => x)),
        pathFile: json["path_file"],
        title: json["title"],
        tokenUrl: json["token_url"],
        uploaded: DateTime.parse(json["uploaded"]),
        duration: json["duration"],
        language: json["language"],
        languageProbability: json["language_probability"]?.toDouble(),
        topic: json["topic"],
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "state": state,
        "segments": List<dynamic>.from(segments.map((x) => x)),
        "path_file": pathFile,
        "title": title,
        "token_url": tokenUrl,
        "uploaded": uploaded.toIso8601String(),
        "duration": duration,
        "language": language,
        "language_probability": languageProbability,
        "topic": topic,
        "tag": tag,
      };
}
