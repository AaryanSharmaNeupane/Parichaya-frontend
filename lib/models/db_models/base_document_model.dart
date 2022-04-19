class BaseDocument {
  int? id;
  String title;
  String note;

  BaseDocument({
    this.id,
    required this.title,
    required this.note,
  });

  factory BaseDocument.fromMap(Map<String, dynamic> map) => BaseDocument(
        id: map['id'],
        title: map['title'],
        note: map['note'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'note': note,
      };

  @override
  String toString() {
    return 'Document(id: $id, title: $title, note: $note)';
  }
}
