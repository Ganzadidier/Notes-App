class NoteModel {
  final String id;
  final String text;

  NoteModel({
    required this.id,
    required this.text,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json, String id) {
    return NoteModel(
      id: id,
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}