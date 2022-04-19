import 'package:parichaya_frontend/models/db_models/base_share_link_model.dart';
import 'document_model.dart';

class ShareLink {
  final int id;
  final String serverId;
  String title;
  final String encryptionKey;
  final DateTime createdOn;
  final DateTime expiryDate;
  List<Document> documents;

  ShareLink({
    required this.id,
    required this.serverId,
    required this.title,
    required this.encryptionKey,
    required this.createdOn,
    required this.expiryDate,
    required this.documents,
  });

  factory ShareLink.fromMap(Map<String, dynamic> map) => ShareLink(
        id: map['id'],
        serverId: map['serverId'],
        title: map['title'],
        encryptionKey: map['encryptionKey'],
        createdOn: map['createdOn'],
        expiryDate: map['expiryDate'],
        documents: map['documents'],
      );

  // factory ShareLink.fromBaseShareLink(
  //         {required int id,
  //         required BaseShareLink baseShareLink,
  //         List<Document> documents = const []}) =>
  //     ShareLink(
  //       id: id,
  //       serverId: baseShareLink.serverId,
  //       title: baseShareLink.title,
  //       encryptionKey: baseShareLink.encryptionKey,
  //       // createdOn: DateTime.parse(baseShareLink.createdOn),
  //       // expiryDate: DateTime.parse(baseShareLink.expiryDate),
  //       documents: documents,
  //     );

  Map<String, dynamic> toMap() => {
        'id': id,
        'serverId': serverId,
        'title': title,
        'encryptionKey': encryptionKey,
        'createdOn': createdOn,
        'expiryDate': expiryDate,
        'documents': documents
      };

  BaseShareLink toBaseShareLink() => BaseShareLink(
        id: id,
        serverId: serverId,
        title: title,
        encryptionKey: encryptionKey,
        createdOn: createdOn.toString(),
        expiryDate: expiryDate.toString(),
      );

  @override
  String toString() {
    return 'BaseShareLink(id: $id, serverId: $serverId, title: $title, encryptionkey: $encryptionKey, createdOn: $createdOn, expiryDate: $expiryDate, documents:${documents.length}documents)';
  }
}
