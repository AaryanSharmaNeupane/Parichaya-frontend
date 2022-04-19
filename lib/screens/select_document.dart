import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/documents.dart';
import '../widgets/document_tile.dart';
import '../models/document_model.dart';
import '../widgets/ui/appbar_confirmation_button.dart';
import 'set_expiry.dart';

class SelectDocument extends StatefulWidget {
  const SelectDocument({Key? key}) : super(key: key);

  static const routeName = '/selected_document';

  @override
  State<SelectDocument> createState() => _SelectDocumentState();
}

class _SelectDocumentState extends State<SelectDocument> {
  // final documentList = DUMMY_DOCS;

  final searchController = TextEditingController();

  List<Document> filteredDocumentList = [];
  final List<Document> selectedDocumentList = [];
  List<Document> documentList = [];

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      documentList = Provider.of<Documents>(context, listen: false).items;
      filteredDocumentList =
          Provider.of<Documents>(context, listen: false).items;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateFilteredDcoumentList() {
    setState(() {
      filteredDocumentList = documentList
          .where((element) =>
              element.title.toLowerCase().contains(searchController.text))
          .toList();
    });
  }

  void toggleSelection(int id) {
    final existingIndex = selectedDocumentList.indexWhere((element) {
      return element.id == id;
    });
    if (existingIndex >= 0) {
      setState(() {
        selectedDocumentList.removeAt(existingIndex);
      });
    } else {
      setState(() {
        selectedDocumentList
            .add(documentList.firstWhere((doc) => doc.id == id));
      });
    }
  }

  bool isDocumentSelected(id) {
    return selectedDocumentList.any((element) {
      return element.id == id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColor),
        title: const Text('SELECT DOCUMENT'),
        actions: [
          DoneButton(
              text: 'Next',
              icon: const Icon(Icons.arrow_forward_rounded),
              onPressed: () {
                if (selectedDocumentList.isEmpty) {
                  final snackBar = SnackBar(
                      backgroundColor: Theme.of(context).errorColor,
                      content:
                          const Text('You must select atleast one document.'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  Navigator.of(context).pushNamed(SetExpiry.routeName,
                      arguments: selectedDocumentList);
                }
              })
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              Card(
                child: TextField(
                  controller: searchController,
                  onChanged: (_) {
                    _updateFilteredDcoumentList();
                  },
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.text = '';
                          _updateFilteredDcoumentList();
                        },
                      ),
                      hintText: 'Search your document',
                      border: InputBorder.none),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                          child: Text(
                            '${filteredDocumentList.length} DOCUMENT${filteredDocumentList.isNotEmpty ? 'S' : ''}',
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      ...filteredDocumentList.map(
                        (document) {
                          return DocumentTile(
                            title: document.title,
                            imagePath: document.images[0].path,
                            onTap: () {
                              toggleSelection(document.id);
                            },
                            action: Icon(isDocumentSelected(document.id)
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined),
                          );
                        },
                      ).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            maxChildSize: 0.1 + 0.1 * selectedDocumentList.length,
            minChildSize: 0.1,
            initialChildSize: 0.1,
            builder: (_, controller) {
              return Material(
                elevation: 10,
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: 20,
                              height: 2,
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            '${selectedDocumentList.isNotEmpty ? selectedDocumentList.length : 'No'} Document${selectedDocumentList.isNotEmpty ? 's' : ''} Selected',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        ...selectedDocumentList.map(
                          (document) {
                            return DocumentTile(
                              imagePath: document.images[0].path,
                              title: document.title,
                              onTap: () {
                                toggleSelection(document.id);
                              },
                              action: const Icon(Icons.cancel),
                            );
                          },
                        ).toList(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
