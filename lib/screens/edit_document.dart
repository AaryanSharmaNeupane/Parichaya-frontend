import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../providers/documents.dart';
import '../widgets/ui/custom_text_field.dart';

class EditDocument extends StatefulWidget {
  const EditDocument({Key? key}) : super(key: key);

  static const routeName = '/edit_document';

  @override
  _EditDocumentState createState() => _EditDocumentState();
}

class _EditDocumentState extends State<EditDocument> {
  final titleController = TextEditingController();
  var titleErrorMessage = '';
  final noteController = TextEditingController();
  var noteErrorMessage = '';

  Future<void> editDocument(context, documentid) async {
    if (titleController.text.isEmpty) {
      setState(() {
        titleErrorMessage = 'Title is required.';
      });
    }
    if (titleController.text.isNotEmpty && titleErrorMessage.isNotEmpty) {
      setState(() {
        titleErrorMessage = '';
      });
      return;
    }
    if (titleController.text.isNotEmpty) {
      await Provider.of<Documents>(context, listen: false).updateDocument(
          documentid, titleController.text, noteController.text);
      const snackBar = SnackBar(content: Text('Document Edited Successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      // Navigator.of(context).popUntil(ModalRoute.withName('/'));
      // Navigator.of(context)
      //     .pushNamed(DocumentDetails.routeName, arguments: documentid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final documentId = ModalRoute.of(context)?.settings.arguments as int;
    final document = Provider.of<Documents>(context, listen: false)
        .getDocumentById(documentId);
    titleController.text = document.title;
    noteController.text = document.note;

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
          'EDIT DOCUMENT',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    // side: BorderSide(color: Colors.red),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).canvasColor),
                foregroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                overlayColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor.withOpacity(0.1)),
              ),
              label: const Text('Done'),
              icon: const Icon(Icons.done),
              onPressed: () {
                editDocument(context, document.id);
              },
            ),
          )
        ],
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
                  ],
                ),
              ),
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
