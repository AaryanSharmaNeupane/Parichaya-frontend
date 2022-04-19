class DocumentImage {
  int? id;
  String path;
  int documentId;

  DocumentImage({
    this.id,
    required this.path,
    required this.documentId,
  });

  factory DocumentImage.fromMap(Map<String, dynamic> map) => DocumentImage(
        id: map['id'],
        path: map['path'],
        documentId: map['documentId'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'path': path,
        'documentId': documentId,
      };

  @override
  String toString() {
    return 'DocumentImage(id: $id, path: $path, documentId: $documentId)';
  }
}
