import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:parichaya_frontend/database/database_helper.dart';
import 'package:parichaya_frontend/models/db_models/document_image_model.dart';
import 'package:parichaya_frontend/models/document_model.dart';
import '../models/db_models/base_document_model.dart';

class Documents with ChangeNotifier {
  bool isSyncing = false;
  final List<Document> _items = [];

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Documents() {
    // DatabaseHelper _tempdataBaseHelper = DatabaseHelper();
    // _databaseHelper = _tempdataBaseHelper;
    syncToDB();
  }
  Documents.noSync() {
    // DatabaseHelper _tempdataBaseHelper = DatabaseHelper();
    // _databaseHelper = _tempdataBaseHelper;
    // syncToDB();
  }

  Future<void> syncToDB() async {
    isSyncing = true;
    final List<BaseDocument> baseDocuments =
        await _databaseHelper.getDocuments();

    final List<Document> documents = [];

    for (BaseDocument baseDocument in baseDocuments) {
      final images = await _databaseHelper.getDocumentImages(baseDocument.id!);
      final document =
          Document.fromMap({...baseDocument.toMap(), 'images': images});
      documents.add(document);
    }
    _items.clear();
    _items.addAll([...documents]);
    sortItemsInAlphabeticalOrder();
    isSyncing = false;
    notifyListeners();
  }

  void syncToDBBackend() async {
    final documents = await _databaseHelper.getDocumentsWithImages();
    _items.addAll([...documents]);
    sortItemsInAlphabeticalOrder();

    notifyListeners();
  }

  List<Document> get items {
    return [..._items];
  }

  void sortItemsInAlphabeticalOrder() {
    _items.sort((a, b) => a.title.compareTo(b.title));
  }

  int get count {
    return _items.length;
  }

  bool checkIfDocumentExists(int documentId) {
    return _items.any((document) => document.id == documentId);
  }

  Document getDocumentById(int documentId) {
    return _items.firstWhere((document) => document.id == documentId);
  }

  Future<Document> addDocument(
    String title,
    String note,
    List<String> imagePaths,
  ) async {
    final newBaseDocument = await _databaseHelper
        .insertDocument(BaseDocument(title: title, note: note));

    final newDocument =
        Document(id: newBaseDocument.id!, title: title, note: note, images: []);

    for (String imagePath in imagePaths) {
      final newDocumentImage = await _databaseHelper.insertDocumentImage(
        DocumentImage(
          path: imagePath,
          documentId: newBaseDocument.id!,
        ),
      );
      newDocument.images.add(newDocumentImage);
    }
    // option 1
    _items.add(newDocument);
    sortItemsInAlphabeticalOrder();

    notifyListeners();
    // option 2
    // syncToDB();

    return newDocument;
  }

  Future<int> updateDocument(
    int documentId,
    String? title,
    String? note,
  ) async {
    var existingDocument = getDocumentById(documentId);
    if (title != null) {
      existingDocument.title = title;
    }
    if (note != null) {
      existingDocument.note = note;
    }
    await _databaseHelper.updateDocument(
      documentId,
      existingDocument.toBaseDocument(),
    );
    notifyListeners();
    return documentId;
  }

  Future<DocumentImage> addDocumentImage(
    int documentId,
    String imagePath,
  ) async {
    final newDocumentImage = await _databaseHelper.insertDocumentImage(
        DocumentImage(path: imagePath, documentId: documentId));

    final existingDocument = getDocumentById(documentId);
    existingDocument.images.add(newDocumentImage);
    notifyListeners();
    return newDocumentImage;
  }

  void deleteDocumentImage(DocumentImage documentImage) {
    /// Deletes the image with id=imageId and returns documentId.
    log('deleting image');
    final existingDocument = getDocumentById(documentImage.documentId);
    existingDocument.images
        .removeWhere((image) => image.id == documentImage.id);
    _databaseHelper.deleteDocumentImageById(documentImage.id!);

    notifyListeners();
    // return documentImage.documentId;
  }

  void deleteDocument(
    int documentId,
  ) {
    _items.removeWhere((document) => document.id == documentId);
    _databaseHelper.deleteDocument(documentId);
    notifyListeners();
  }
}
