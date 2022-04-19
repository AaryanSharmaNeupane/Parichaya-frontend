import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parichaya_frontend/screens/document_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
// import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter_document_scanner/flutter_document_scanner.dart';
import '../widgets/options_modal_buttom_sheet.dart';
import '../screens/document_details.dart';
import '../widgets/ui/custom_text_field.dart';
import '../providers/documents.dart';
import '../widgets/ui/appbar_confirmation_button.dart';

class AddDocuments extends StatefulWidget {
  const AddDocuments({Key? key}) : super(key: key);
  static const routeName = '/add_documents';

  @override
  State<AddDocuments> createState() => _AddDocumentsState();
}

class _AddDocumentsState extends State<AddDocuments> {
  // final List<Image> uploadedImages = [];
  final titleController = TextEditingController();
  var titleErrorMessage = '';
  final noteController = TextEditingController();
  var noteErrorMessage = '';
  final List<String> uploadedImagePaths = [];
  var imageErrorMessage = '';

  bool _showScannerOverlay = false;
  final _controller = DocumentScannerController();

  // openImageScanner(BuildContext context) async {
  //   var image = await DocumentScannerFlutter.launch(
  //     context,
  //     //source: ScannerFileSource.CAMERA,
  //   );
  //   if (image != null) {
  //     setState(() {
  //       uploadedImagePaths.add(image.path);
  //       Navigator.of(context).pop();
  //     });
  //   }
  // }

  void addDocument(context) async {
    titleErrorMessage = '';
    imageErrorMessage = '';
    setState(() {
      titleErrorMessage =
          titleController.text.isEmpty ? 'Title is required.' : '';
      imageErrorMessage = uploadedImagePaths.isEmpty
          ? 'You must upload atleast one image.'
          : '';
    });

    if (titleController.text.isNotEmpty && uploadedImagePaths.isNotEmpty) {
      final newDocument = await Provider.of<Documents>(context, listen: false)
          .addDocument(
              titleController.text, noteController.text, uploadedImagePaths);

      const snackBar = SnackBar(content: Text('Document Successfully Added'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).popAndPushNamed(DocumentDetails.routeName,
          arguments: newDocument.id);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        uploadedImagePaths.add(image.path);
        imageErrorMessage = '';
      });
    } on PlatformException catch (_) {
      return;
    }
  }

  void unPickImage(int index) {
    setState(() {
      uploadedImagePaths.removeAt(index);
    });
  }

  void showAddImageModalBottomSheet(BuildContext context) {
    showOptionsModalButtomSheet(
      context,
      children: [
        const Text('Select Actions'),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.document_scanner_rounded),
          title: const Text('Scan Document'),
          onTap: () async {
            File? scannedImage = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DocumentScannerScreen(),
              ),
            );
            if (scannedImage != null) {
              uploadedImagePaths.add(scannedImage.path);
            }
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.file_upload_rounded),
          title: const Text('Upload Image'),
          onTap: () {
            pickImage(ImageSource.gallery);
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt_rounded),
          title: const Text('Take a Photo'),
          onTap: () {
            pickImage(ImageSource.camera);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.clear),
        ),
        titleSpacing: 5,
        title: const Text(
          'ADD NEW DOCUMENT',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          DoneButton(
            text: 'Done',
            icon: const Icon(Icons.done),
            onPressed: () {
              addDocument(context);
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddImageModalBottomSheet(context);
        },
        child: const Icon(Icons.add_photo_alternate_rounded),
      ),
      body: LayoutBuilder(builder: (ctx, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'TITLE',
                      controller: titleController,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      errorMessage: titleErrorMessage,
                      onChanged: (value) {
                        if (titleErrorMessage.isNotEmpty && value.isNotEmpty) {
                          setState(() {
                            titleErrorMessage = '';
                          });
                        }
                      },
                    ),
                    CustomTextField(
                      label: 'NOTE',
                      controller: noteController,
                      maxLines: 3,
                      errorMessage: noteErrorMessage,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFieldLabel('IMAGES',
                        errorMessage: imageErrorMessage),
                  ],
                ),
              ),
              GridView.count(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 8.0,
                  children: [
                    ...List.generate(
                      uploadedImagePaths.length,
                      (index) {
                        return Center(
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    File(uploadedImagePaths[index]),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    unPickImage(index);
                                  },
                                  icon: const Icon(Icons.cancel),
                                  // size: 40,
                                  // color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          showAddImageModalBottomSheet(context);
                          // pickImage(ImageSource.gallery);
                        },
                        splashColor:
                            Theme.of(context).disabledColor.withOpacity(0.1),
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.05),
                            // border: Border.all(
                            // color: Colors.blueAccent,
                            // ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.add_circle,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ]),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      }),
    );
  }
}
