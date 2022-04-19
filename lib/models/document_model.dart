import 'package:parichaya_frontend/models/db_models/base_document_model.dart';

import 'db_models/document_image_model.dart';

class Document {
  int id;
  String title;
  String note;
  final List<DocumentImage> images;

  Document({
    required this.id,
    required this.title,
    required this.note,
    required this.images,
  });

  factory Document.fromMap(Map<String, dynamic> map) => Document(
        id: map['id'],
        title: map['title'],
        note: map['note'],
        images: map['images'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'note': note,
        'images': images,
      };

  BaseDocument toBaseDocument() =>
      BaseDocument(id: id, title: title, note: note);

  @override
  String toString() {
    return 'Document(id: $id, title: $title, note: $note, images: ${images.length} images)';
  }
}
