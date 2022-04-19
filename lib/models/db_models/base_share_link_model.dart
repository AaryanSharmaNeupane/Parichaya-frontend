class BaseShareLink {
  int? id;
  String serverId;
  String title;
  String encryptionKey;
  String createdOn;
  String expiryDate;

  BaseShareLink(
      {this.id,
      required this.serverId,
      required this.title,
      required this.encryptionKey,
      required this.createdOn,
      required this.expiryDate,
      required});

  factory BaseShareLink.fromMap(Map<String, dynamic> map) => BaseShareLink(
        id: map['id'],
        serverId: map['serverId'],
        title: map['title'],
        encryptionKey: map['encryptionKey'],
        createdOn: map['createdOn'],
        expiryDate: map['expiryDate'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'serverId': serverId,
        'title': title,
        'encryptionKey': encryptionKey,
        'createdOn': createdOn,
        'expiryDate': expiryDate,
      };

  @override
  String toString() {
    return 'BaseShareLink(id: $id, serverId: $serverId, title: $title, encryptionKey: $encryptionKey, createdOn: $createdOn ,expiryDate: $expiryDate)';
  }
}
