import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/document_model.dart';
import '../providers/documents.dart';
import '../widgets/document_tile.dart';

import 'document_details.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({Key? key}) : super(key: key);

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  late List<Document> documentList;
  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      documentList = Provider.of<Documents>(context).items;
    }
  }

  @override
  Widget build(BuildContext context) {
    // documentList.clear();
    // documentList.addAll(Provider.of<Documents>(context).items);

    return RefreshIndicator(
      // triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await Provider.of<Documents>(context, listen: false).syncToDB();
        setState(() {
          documentList = Provider.of<Documents>(context, listen: false).items;
        });
      },
      child: Provider.of<Documents>(context).isSyncing
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85 -
                    // appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                        child: Text(
                          '${documentList.length} DOCUMENTS',
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    ...documentList.map(
                      (document) {
                        return DocumentTile(
                          title: document.title,
                          imagePath: document.images[0].path,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                DocumentDetails.routeName,
                                arguments: document.id);
                          },
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            ),
    );
  }
}
