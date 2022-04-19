import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class DocumentScannerScreen extends StatelessWidget {
  const DocumentScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = DocumentScannerController();

    return Scaffold(
      body: DocumentScanner(
        controller: _controller,
        generalStyles: const GeneralStyles(
          hideDefaultDialogs: true,
          baseColor: Colors.white,
        ),
        cropPhotoDocumentStyle: CropPhotoDocumentStyle(
          top: MediaQuery.of(context).padding.top,
        ),
        onSave: (Uint8List imageBytes) async {
          final dir = await getTemporaryDirectory();
          await dir.create(recursive: true);
          const uuid = Uuid();
          final tempFile = File(path.join(dir.path, '${uuid.v4()}.jpg'));
          await tempFile.writeAsBytes(imageBytes);

          // final fileExtension = path.extension(tempFile.path);
          // final path = baseDir.path;
          // final newPath = '$path/${uuid.v4()}$fileExtension';

          // uploadedImagePaths.add(tempFile.path);
          Navigator.of(context).pop(tempFile);
          // ? Bytes of the document/image already processed
        },
      ),
    );
  }
}
