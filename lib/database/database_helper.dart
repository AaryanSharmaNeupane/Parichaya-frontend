import 'dart:developer';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/db_models/base_document_model.dart';
import '../models/db_models/base_share_link_model.dart';
import '../models/db_models/document_image_model.dart';
import '../models/document_model.dart';

class DatabaseHelper {
  static const _databaseName = 'parichaya_DB.db';
  static const _databaseVersion = 1;

  static const documentTable = 'document_table';
  static const imageTable = 'image_table';
  static const shareLinkTable = 'share_link_table';

  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseHelper;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: _databaseVersion,
      // onOpen: _onOpen,
    );
  }

  // Future<void> _onOpen(Database db) async {
  //   await db.execute('PRAGMA foreign_keys=on;');
  // }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $documentTable(id INTEGER PRIMARY KEY, title TEXT, note TEXT)',
    );
    await db.execute(
      'CREATE TABLE $imageTable(id INTEGER PRIMARY KEY, path TEXT,documentId INTEGER, FOREIGN KEY (documentId) REFERENCES document(id) ON DELETE CASCADE)',
    );
    await db.execute(
      'CREATE TABLE $shareLinkTable(id INTEGER PRIMARY KEY, serverId TEXT,title TEXT, encryptionKey TEXT, createdOn TEXT, expiryDate TEXT)',
    );
  }

  Future<BaseDocument> insertDocument(BaseDocument document) async {
    log('Inserting document in DB');
    final db = await _databaseHelper.database;
    final newDocumentId = await db.insert(
      documentTable,
      document.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    document.id = newDocumentId;
    log('Inserted document ($newDocumentId) in DB ');
    return document;
  }

  Future<DocumentImage> insertDocumentImage(DocumentImage documentImage) async {
    log('Inserting image of documentID(${documentImage.documentId}) in DB');
    final db = await _databaseHelper.database;

    final Directory baseDir = await getApplicationDocumentsDirectory();
    final path = baseDir.path;
    // final fileName = basenameWithoutExtension(documentImage.path);
    final fileExtension = extension(documentImage.path);
    const uuid = Uuid();
    final newPath = '$path/${uuid.v4()}$fileExtension';
    File(documentImage.path).copy(newPath);

    documentImage.path = newPath;

    final newDocumentImageId = await db.insert(
      imageTable,
      documentImage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    documentImage.id = newDocumentImageId;
    log('Inserted image in DB ');

    return documentImage;
  }

  Future<BaseShareLink> insertShareLink(BaseShareLink shareLink) async {
    log('Inserting Share link in DB');
    final db = await _databaseHelper.database;
    final newShareLinkId = await db.insert(
      shareLinkTable,
      shareLink.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    shareLink.id = newShareLinkId;
    log('Inserted share link ($newShareLinkId) in DB ');
    return shareLink;
  }

  Future<List<BaseDocument>> getDocuments() async {
    log('Getting documents from DB');
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> documentMaps =
        await db.query(documentTable);
    log(documentMaps.toString());

    return List.generate(documentMaps.length,
        (index) => BaseDocument.fromMap(documentMaps[index]));
  }

  Future<BaseDocument> getDocumentById(int documentId) async {
    log('Getting document by Id in DB');
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> documentMaps = await db.query(
      documentTable,
      where: 'id = ?',
      whereArgs: [documentId],
      limit: 1,
    );
    log(documentMaps.toString());
    return BaseDocument.fromMap(documentMaps.first);
  }

  Future<List<DocumentImage>> getDocumentImages(int documentId) async {
    log('Getting document image of documentID($documentId)from DB');
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> documentImageMaps = await db.query(
      imageTable,
      where: 'documentId = ?',
      whereArgs: [documentId],
    );
    log(documentImageMaps.toString());
    return List.generate(documentImageMaps.length,
        (index) => DocumentImage.fromMap(documentImageMaps[index]));
  }

  Future<DocumentImage> getDocumentImageById(int id) async {
    log('Getting document image by Id from DB');
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> documentImageMaps = await db.query(
      imageTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    log(documentImageMaps.toString());
    return DocumentImage.fromMap(documentImageMaps.first);
  }

  Future<List<BaseShareLink>> getShareLinks() async {
    log('Getting share links from DB');
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> shareLinkMaps =
        await db.query(shareLinkTable);
    log(shareLinkMaps.toString());

    return List.generate(shareLinkMaps.length,
        (index) => BaseShareLink.fromMap(shareLinkMaps[index]));
  }

  Future<BaseShareLink> getShareLinkById(int shareLinkId) async {
    log('Getting share link by Id in DB');
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> shareLinkMaps = await db.query(
      shareLinkTable,
      where: 'id = ?',
      whereArgs: [shareLinkId],
      limit: 1,
    );
    log(shareLinkMaps.first.toString());
    return BaseShareLink.fromMap(shareLinkMaps.first);
  }

  Future<BaseShareLink> getShareLinkByServerId(int shareLinkServerId) async {
    log('Getting share link by serverId in DB');
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> shareLinkMaps = await db.query(
      shareLinkTable,
      where: 'serverId = ?',
      whereArgs: [shareLinkServerId],
      limit: 1,
    );
    log(shareLinkMaps.first.toString());
    return BaseShareLink.fromMap(shareLinkMaps.first);
  }

  Future<BaseDocument> updateDocument(
      int documentId, BaseDocument document) async {
    log('Updating document with documentID($documentId)in DB');
    final db = await _databaseHelper.database;

    await db.update(
      documentTable,
      document.toMap(),
      where: 'id = ?',
      whereArgs: [documentId],
    );
    log('Updated document');
    return document;
  }

  Future<BaseShareLink> updateShareLink(
      int shareLinkId, BaseShareLink shareLink) async {
    log('Updating shareLink with shareLinkID($shareLinkId)in DB');
    final db = await _databaseHelper.database;

    await db.update(
      shareLinkTable,
      shareLink.toMap(),
      where: 'id = ?',
      whereArgs: [shareLinkId],
    );
    log('Updated shareLink');
    return shareLink;
  }

  Future<int> deleteDocument(int documentId) async {
    log('Deleting document with documentId($documentId)in DB');

    final db = await _databaseHelper.database;

    await deleteDocumentImages(documentId);

    final deletedDocumentId = await db.delete(
      documentTable,
      where: 'id = ?',
      whereArgs: [documentId],
    );
    log('Document deleted');
    return deletedDocumentId;
  }

  Future<void> deleteDocumentImages(int documentId) async {
    log('Deleting document images with documentId($documentId) in DB');

    final db = await _databaseHelper.database;

    final documentImages = await getDocumentImages(documentId);
    Batch batch = db.batch();
    for (final documentImage in documentImages) {
      File(documentImage.path).delete();
      batch.delete(
        imageTable,
        where: 'id = ?',
        whereArgs: [documentImage.id],
      );
    }
    batch.commit();
    log('Document Images deleted');
  }

  Future<int> deleteDocumentImageById(int imageId) async {
    log('Deleting document image with imageId($imageId) in DB');

    final db = await _databaseHelper.database;

    final documentImage = await getDocumentImageById(imageId);
    File(documentImage.path).delete();

    final deletedDocumentImageId = await db.delete(
      imageTable,
      where: 'id = ?',
      whereArgs: [imageId],
    );
    log('Document Image deleted');
    return deletedDocumentImageId;
  }

  Future<int> deleteShareLink(int shareLinkId) async {
    log('Deleting sharelink with shareLinkId($shareLinkId)in DB');

    final db = await _databaseHelper.database;

    final deletedShareLinkId = await db.delete(
      shareLinkTable,
      where: 'id = ?',
      whereArgs: [shareLinkId],
    );
    log('Share Link deleted');
    return deletedShareLinkId;
  }

  // Future<int> xinsertDocumentWithImage(Document document) async {
  //   final db = await _databaseHelper.database;
  //   final newDocumentDBModel =
  //       Document(title: document.title, note: document.note);

  //   final newDocumentId = await db.insert(
  //     documentTable,
  //     newDocumentDBModel.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   Batch batch = db.batch();
  //   for (DocumentImage documentImage in document.images) {
  //     var newImageDBModel = DocumentImage(
  //       path: documentImage.path,
  //       documentId: newDocumentId,
  //     );
  //     newImageDBModel.documentId = newDocumentId;
  //     batch.insert(imageTable, newImageDBModel.toMap());
  //   }
  //   batch.commit(noResult: true);

  //   return newDocumentId;
  // }

  Future<List<Document>> getDocumentsWithImages() async {
    final db = await _databaseHelper.database;

    final List<Map<String, dynamic>> documentMaps =
        await db.query(documentTable);

    final List<Document> documents = [];

    for (Map<String, dynamic> documentMap in documentMaps) {
      final images = await getDocumentImages(documentMap['id']);
      final document = Document.fromMap({...documentMap, 'images': images});
      documents.add(document);
    }
    return documents;
  }

  Future<Document> getDocumentWithImagesById(int documentId) async {
    // final db = await _databaseHelper.database;
    final baseDocument = await getDocumentById(documentId);

    final images = getDocumentImages(documentId);
    final document =
        Document.fromMap({...baseDocument.toMap(), 'images': images});
    return document;
  }

  Future<int> xinsertDocument(
    BaseDocument document,
  ) async {
    final db = await _databaseHelper.database;

    final newDocumentId = await db.insert(
      documentTable,
      document.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return newDocumentId;
  }
}
