import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parichaya_frontend/screens/document_scanner.dart';
import '../screens/document_detail_full_screen_gallery.dart';
import '../widgets/options_modal_buttom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/documents.dart';
import '../screens/page_not_found.dart';
import '../utils/string.dart';
import './edit_document.dart';
import '../widgets/delete_confirmation_buttom_sheet.dart';

// import 'package:document_scanner_flutter/configs/configs.dart';
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

enum selectionValue {
  edit,
  delete,
}

class DocumentDetails extends StatefulWidget {
  const DocumentDetails({Key? key}) : super(key: key);

  static const routeName = '/document_details';

  @override
  State<DocumentDetails> createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  Future<void> pickImage(
      BuildContext context, ImageSource source, int documentId) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      Provider.of<Documents>(context, listen: false)
          .addDocumentImage(documentId, image.path);
      const snackBar = SnackBar(content: Text('Image Successfully Added'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PlatformException catch (_) {
      return;
    }
  }

  void showMoreOptions(
    BuildContext context,
    int documentId,
  ) {
    showOptionsModalButtomSheet(
      context,
      children: [
        const Text('Select Actions'),
        const Divider(),
        ListTile(
          leading: Icon(Icons.edit, color: Theme.of(context).disabledColor),
          title: const Text('Edit Document'),
          onTap: () {
            Navigator.of(context)
                .popAndPushNamed(EditDocument.routeName, arguments: documentId);
            // Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: Icon(Icons.delete, color: Theme.of(context).disabledColor),
          title: const Text('Delete Document'),
          onTap: () async {
            Navigator.of(context).pop();
            final isConfirmed = await showDeleteConfirmationButtomSheet(context,
                message:
                    "Deleting the document will delete all the images in it and cannot be undone.");
            if (isConfirmed) {
              Navigator.of(context).pop();
              Provider.of<Documents>(context, listen: false)
                  .deleteDocument(documentId);
              const snackBar =
                  SnackBar(content: Text('Document Deleted Successfully'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeDocumentId = ModalRoute.of(context)?.settings.arguments as int;

    final documentsProvider = Provider.of<Documents>(context);
    if (!documentsProvider.checkIfDocumentExists(routeDocumentId)) {
      return const PageNotFound();
    }

    final document = documentsProvider.getDocumentById(routeDocumentId);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor),
        title: Text(
          generateLimitedLengthText(document.title.toUpperCase(), 25),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showMoreOptions(
                  context,
                  document.id,
                );
              },
              icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 10,
                ),
                if (document.note.isNotEmpty)
                  Text(
                    document.note,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (document.note.isNotEmpty)
                  const SizedBox(
                    height: 20,
                  ),
                const Divider(
                  // height: 30,
                  color: Colors.grey,
                ),

                Text(
                  '${document.images.length} Images Attached',
                  style: Theme.of(context).textTheme.bodySmall,
                ),

                const SizedBox(
                  height: 20,
                ),
                GridView.count(
                  padding: EdgeInsets.zero,
                  physics: const ScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    ...document.images.map((image) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            Positioned.fill(
                              child: Image.file(
                                File(image.path),
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  highlightColor:
                                      Colors.orange.withOpacity(0.1),
                                  splashColor: Colors.black12,
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        DocumentDetailFullScreenGallery
                                            .routeName,
                                        arguments: image);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
                // for (var image in document.images)
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_photo_alternate_rounded),
        tooltip: 'Add Image',
        elevation: 2,
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Wrap(
                    children: [
                      const Text('Select Actions'),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.document_scanner_rounded),
                        title: const Text('Scan Document'),
                        onTap: () async {
                          File? scannedImage = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DocumentScannerScreen(),
                            ),
                          );
                          if (scannedImage != null) {
                            // uploadedImagePaths.add(scannedImage.path);
                            Provider.of<Documents>(context, listen: false)
                                .addDocumentImage(
                                    document.id, scannedImage.path);
                            const snackBar = SnackBar(
                                content: Text('Image Successfully Added'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.file_upload_rounded),
                        title: const Text('Upload Image'),
                        onTap: () async {
                          await pickImage(
                              context, ImageSource.gallery, document.id);
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera_alt_rounded),
                        title: const Text('Take a Photo'),
                        onTap: () async {
                          Navigator.of(context).pop();

                          await pickImage(
                              context, ImageSource.camera, document.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
