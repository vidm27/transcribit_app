import 'dart:convert';

TranscriptionDb transcriptionDbFromJson(String str) =>
    TranscriptionDb.fromJson(json.decode(str));

String transcriptionDbToJson(TranscriptionDb data) =>
    json.encode(data.toJson());

class TranscriptionDb {
  String id;
  String? state;
  List<Segment> segments;
  String pathFile;
  String? title;
  String tokenUrl;
  DateTime uploaded;
  String? duration;
  String? language;
  double? languageProbability;
  String? topic;
  String? tag;

  TranscriptionDb({
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

  factory TranscriptionDb.fromJson(Map<String, dynamic> json) =>
      TranscriptionDb(
        id: json["id"],
        state: json["state"] ?? "",
        segments: List<Segment>.from(
            json["segments"].map((x) => Segment.fromJson(x))),
        pathFile: json["path_file"] ?? "",
        title: json["title"] ?? "",
        tokenUrl: json["token_url"],
        uploaded: DateTime.parse(json["uploaded"]),
        duration: json["duration"] ?? "",
        language: json["language"] ?? "",
        languageProbability: json["language_probability"] ?? 0.0,
        topic: json["topic"] ?? "",
        tag: json["tag"] ?? "",
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

class Segment {
  String id;
  double minutesStart;
  double minutesEnd;
  dynamic segmentEdit;
  String segmentOriginal;
  DateTime uploaded;
  DateTime edited;
  String transcription;

  Segment({
    required this.id,
    required this.minutesStart,
    required this.minutesEnd,
    required this.segmentEdit,
    required this.segmentOriginal,
    required this.uploaded,
    required this.edited,
    required this.transcription,
  });

  factory Segment.fromJson(Map<String, dynamic> json) => Segment(
        id: json["id"],
        minutesStart: json["minutes_start"]?.toDouble(),
        minutesEnd: json["minutes_end"]?.toDouble(),
        segmentEdit: json["segment_edit"],
        segmentOriginal: json["segment_original"],
        uploaded: DateTime.parse(json["uploaded"]),
        edited: DateTime.parse(json["edited"]),
        transcription: json["transcription"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "minutes_start": minutesStart,
        "minutes_end": minutesEnd,
        "segment_edit": segmentEdit,
        "segment_original": segmentOriginal,
        "uploaded": uploaded.toIso8601String(),
        "edited": edited.toIso8601String(),
        "transcription": transcription,
      };
}
