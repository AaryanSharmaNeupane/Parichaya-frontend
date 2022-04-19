import 'package:flutter/material.dart';
import 'dart:async';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:parichaya_frontend/widgets/full_screen_gallery.dart';
import 'package:parichaya_frontend/widgets/options_modal_buttom_sheet.dart';
import 'package:provider/provider.dart';

import '../models/db_models/document_image_model.dart';
import '../models/document_model.dart';
import '../providers/documents.dart';
import '../widgets/delete_confirmation_buttom_sheet.dart';

class DocumentDetailFullScreenGallery extends StatefulWidget {
  const DocumentDetailFullScreenGallery({Key? key}) : super(key: key);

  static const routeName = '/document_detail_fullscreen_gallery';
  @override
  State<DocumentDetailFullScreenGallery> createState() =>
      _DocumentDetailFullScreenGalleryState();
}

class _DocumentDetailFullScreenGalleryState
    extends State<DocumentDetailFullScreenGallery> {
  bool isInitialized = false;
  int currentImageIndex = 0;

  Future<void> deleteDocumentImage(
    BuildContext context,
    Document document,
  ) async {
    final isConfirmed = await showDeleteConfirmationButtomSheet(context,
        message: 'Deleting the image cannot be undone.');

    if (isConfirmed) {
      final imageToBeDeleted = document.images[currentImageIndex];
      if (document.images.length > 1) {
        setState(() {
          if (currentImageIndex == 0) {
            currentImageIndex = currentImageIndex + 1;
          } else {
            currentImageIndex = currentImageIndex - 1;
          }
        });
        Provider.of<Documents>(context, listen: false)
            .deleteDocumentImage(imageToBeDeleted);

        const snackBar = SnackBar(
          content: Text('Image Deleted Successfully'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content:
                const Text('You must have atleast one image in the document.'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final documentImage =
        ModalRoute.of(context)?.settings.arguments as DocumentImage;
    final document = Provider.of<Documents>(context)
        .getDocumentById(documentImage.documentId);
    if (!isInitialized) {
      currentImageIndex = document.images.indexOf(documentImage);
      isInitialized = true;
    }

    return GestureDetector(
      onTap: () {
        showOptionsModalButtomSheet(context, children: [
          const Text('Select Actions'),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.delete,
              color: Theme.of(context).disabledColor,
            ),
            title: const Text('Delete Image'),
            onTap: () async {
              Navigator.of(context).pop();
              await deleteDocumentImage(context, document);
              // Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.download,
              color: Theme.of(context).disabledColor,
            ),
            title: const Text('Save to Gallery'),
            onTap: () async {
              await ImageGallerySaver.saveFile(documentImage.path);
              const snackBar = SnackBar(
                content: Text('Image saved to gallery.'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop();
            },
          ),
        ]);
      },
      child: FullScreenGallery(
        imagePaths: List.generate(
            document.images.length, (index) => document.images[index].path),
        initialIndex: currentImageIndex,
        appBarActions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.more_vert),
          ),
        ],
        onPageChange: (index) {
          setState(() {
            currentImageIndex = index;
          });
        },
      ),
    );
  }
}
