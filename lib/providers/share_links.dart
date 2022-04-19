import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:parichaya_frontend/models/document_model.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/db_models/base_share_link_model.dart';
import '../models/db_models/document_image_model.dart';
import '../models/share_link_model.dart';
import '../utils/server_url.dart';

const baseUrl = baseServerUrl;

class ShareLinks with ChangeNotifier {
  final List<ShareLink> _items = [];
  bool isSyncing = false;

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  ShareLinks() {
    // DatabaseHelper _tempdataBaseHelper = DatabaseHelper();
    // _databaseHelper = _tempdataBaseHelper;
    syncToDB();
  }
  ShareLinks.noSync() {
    // DatabaseHelper _tempdataBaseHelper = DatabaseHelper();
    // _databaseHelper = _tempdataBaseHelper;
  }

  Future<ShareLink?> createShareLinkFromBaseShareLink(
      BaseShareLink baseShareLink) async {
    final serverId = baseShareLink.serverId;
    final encryptionKey = baseShareLink.encryptionKey;
    final url = baseUrl + '$serverId/$encryptionKey';
    log('fetching sharelink detail from server...');
    final response = await http.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    // ? Recheck this logic
    if (response.statusCode == 404) {
      _databaseHelper.deleteShareLink(baseShareLink.id!);
      return null;
    }
    final responseData = json.decode(response.body);
    log(responseData.toString());
    final createdOn = responseData['created_on'];
    final expiryDate = responseData['expiry_date'];
    final documentMaps = responseData['documents'];
    final shareLink = ShareLink(
        id: baseShareLink.id!,
        serverId: baseShareLink.serverId,
        title: baseShareLink.title,
        encryptionKey: baseShareLink.encryptionKey,
        createdOn: DateTime.parse(createdOn),
        expiryDate: DateTime.parse(expiryDate),
        documents: []);
    for (Map documentMap in documentMaps) {
      final document = Document(
        id: documentMap['id'],
        title: documentMap['title'],
        note: '',
        images: [],
      );
      for (Map imageMap in documentMap['images']) {
        document.images.add(
          DocumentImage(
              path: baseUrl + 'image/${imageMap['id']}/$encryptionKey/',
              documentId: document.id),
        );
      }
      shareLink.documents.add(document);
    }
    return shareLink;
  }

  Future<void> syncToDB() async {
    isSyncing = true;
    final List<BaseShareLink> baseShareLinks =
        await _databaseHelper.getShareLinks();

    final List<ShareLink> shareLinks = [];

    for (BaseShareLink baseShareLink in baseShareLinks) {
      final serverId = baseShareLink.serverId;
      final encryptionKey = baseShareLink.encryptionKey;
      final url = baseUrl + '$serverId/$encryptionKey';
      log('fetching sharelink detail from server...');
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      // ? Recheck this logic
      if (response.statusCode == 404) {
        _databaseHelper.deleteShareLink(baseShareLink.id!);
        continue;
      }
      final responseData = json.decode(response.body);
      log(responseData.toString());
      final createdOn = responseData['created_on'];
      final expiryDate = responseData['expiry_date'];
      final documentMaps = responseData['documents'];
      final shareLink = ShareLink(
          id: baseShareLink.id!,
          serverId: baseShareLink.serverId,
          title: baseShareLink.title,
          encryptionKey: baseShareLink.encryptionKey,
          createdOn: DateTime.parse(createdOn),
          expiryDate: DateTime.parse(expiryDate),
          documents: []);
      for (Map documentMap in documentMaps) {
        final document = Document(
          id: documentMap['id'],
          title: documentMap['title'],
          note: '',
          images: [],
        );
        for (Map imageMap in documentMap['images']) {
          document.images.add(
            DocumentImage(
                path: baseUrl + 'image/${imageMap['id']}/$encryptionKey/',
                documentId: document.id),
          );
        }
        shareLink.documents.add(document);
      }

      shareLinks.add(shareLink);
    }
    _items.clear();
    _items.addAll([...shareLinks]);
    sortItemsByExpiry();
    isSyncing = false;
    notifyListeners();
  }

  List<ShareLink> get items {
    return [..._items];
  }

  void sortItemsByExpiry() {
    _items.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
  }

  int get count {
    return _items.length;
  }

  bool checkIfShareLinkExists(int shareLinkId) {
    return _items.any((shareLink) => shareLink.id == shareLinkId);
  }

  ShareLink getShareLinkById(int shareLinkId) {
    return _items.firstWhere((shareLink) => shareLink.id == shareLinkId);
  }

  Future<int?> addShareLink({
    required String title,
    required String expiryDate,
    required List<Document> documents,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'title': title,
            'expiry_date': expiryDate,
          },
        ),
      );
      final responseData = json.decode(response.body);

      final _serverId = responseData['id'];
      final _encryptionKey = responseData['encryption_key'];
      final _createdOn = responseData['created_on'];
      final _expiryDate = responseData['expiry_date'];

      for (Document document in documents) {
        final documentAddingUrl =
            baseUrl + '$_serverId/$_encryptionKey/add-document/';
        log('Sending Initial Request');
        final request =
            http.MultipartRequest('POST', Uri.parse(documentAddingUrl));

        request.fields['title'] = document.title;
        for (DocumentImage image in document.images) {
          log('add image ${image.path}');
          ImageProperties properties =
              await FlutterNativeImage.getImageProperties(image.path);
          File compressedImage = await FlutterNativeImage.compressImage(
            image.path,
            quality: 70,
            // targetWidth: 600,
            // targetHeight:
            //     (properties.height! * 600 / properties.width!).round()
          );
          request.files.add(await http.MultipartFile.fromPath(
              'images', compressedImage.path));
        }
        log('sending request!!!!');
        await request.send();
        log('Done');
      }

      final newBaseShareLink = await _databaseHelper.insertShareLink(
        BaseShareLink(
          serverId: _serverId,
          title: title,
          encryptionKey: _encryptionKey,
          createdOn: _createdOn,
          expiryDate: _expiryDate,
        ),
      );

      final newShareLink =
          await createShareLinkFromBaseShareLink(newBaseShareLink);
      if (newShareLink == null) {
      } else {
        _items.add(newShareLink);
        sortItemsByExpiry();
      }
      notifyListeners();
      // await syncToDB();

      return newBaseShareLink.id!;
    } catch (e) {
      return null;
    }
  }

  Future<int> updateShareLink(
    int shareLinkId,
    String? title,
  ) async {
    var existingShareLink = getShareLinkById(shareLinkId);
    if (title != null) {
      existingShareLink.title = title;
    }

    await _databaseHelper.updateShareLink(
      shareLinkId,
      existingShareLink.toBaseShareLink(),
    );
    notifyListeners();
    return shareLinkId;
  }

  Future<Document> addSharedDocument(
    int shareLinkId,
    Document document,
  ) async {
    final existingShareLink = getShareLinkById(shareLinkId);
    final url = baseUrl +
        '${existingShareLink.serverId}/${existingShareLink.encryptionKey}/add-document/';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'document': document}),
    );

    log(json.decode(response.body).toString());
    existingShareLink.documents.add(document);
    // ? Create new documnet object based on the response and add to existingSharedLink
    // existingShareLink.documents.add(document);
    notifyListeners();
    return document;
  }

  void deleteSharedDocument(int shareLinkId, int sharedDocumentId) {
    log('deleting shared document');
    final existingShareLink = getShareLinkById(shareLinkId);
    // ? Make http DELETE to delete document in share link with id
    existingShareLink.documents
        .removeWhere((document) => document.id == sharedDocumentId);

    notifyListeners();
    // return documentImage.documentId;
  }

  Future<void> deleteShareLink(int shareLinkId) async {
    final existingShareLink = getShareLinkById(shareLinkId);
    final url = baseUrl +
        '${existingShareLink.serverId}/${existingShareLink.encryptionKey}/';
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 204) {
      log('deleted share link $shareLinkId from server');
      _databaseHelper.deleteShareLink(shareLinkId);
      _items.removeWhere((shareLink) => shareLink.id == shareLinkId);
    }
    notifyListeners();
  }
}
