import 'package:flutter/material.dart';

import '../models/document_model.dart';

class SharedDocumentDetailsTiles extends StatefulWidget {
  final List<Document> documents;

  const SharedDocumentDetailsTiles({
    required this.documents,
    Key? key,
  }) : super(key: key);

  @override
  State<SharedDocumentDetailsTiles> createState() =>
      _SharedDocumentDetailsTilesState();
}

class _SharedDocumentDetailsTilesState
    extends State<SharedDocumentDetailsTiles> {
  // bool isItExpanded = false;
  List<int> expandedIndex = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ExpansionPanelList.radio(
            elevation: 0,
            animationDuration: const Duration(milliseconds: 500),
            // expandedHeaderPadding: const EdgeInsets.all(5),
            // expansionCallback: (panelIndex, isExpanded) {
            //   setState(() {
            //     if (isExpanded) {
            //       expandedIndex.add(panelIndex);
            //     } else {
            //       expandedIndex.remove(panelIndex);
            //     }
            //     // isItExpanded = !isExpanded;
            //   });
            // },
            children: widget.documents
                .map(
                  (document) => ExpansionPanelRadio(
                    canTapOnHeader: true,
                    value: document.id,
                    // isExpanded: isItExpanded,
                    backgroundColor:
                        Theme.of(context).disabledColor.withOpacity(0.1),
                    headerBuilder: (context, isExpanded) {
                      return Container(
                        // padding: EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                        child: Text(
                          document.title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                    body: Container(
                      margin: const EdgeInsets.all(10),
                      child: GridView.count(
                        padding: EdgeInsets.zero,
                        physics: const ScrollPhysics(),
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                        children: [
                          ...document.images.map((image) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                image.path,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Container(
                                    color: Colors.grey.withOpacity(0.1),
                                  );
                                },
                                height: 200,
                                width: 200,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ));
    // return Card(
    //   margin: const EdgeInsets.all(10),
    //   elevation: 0,
    //   color: Theme.of(context).disabledColor.withOpacity(0.1),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    //   child: Padding(
    //     padding: const EdgeInsets.all(10.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           title.toUpperCase(),
    //           style: const TextStyle(
    //             fontSize: 14,
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //         const Divider(
    //           height: 20,
    //         ),
    //         const SizedBox(
    //           height: 10,
    //         ),
    //         GridView.count(
    //           padding: EdgeInsets.zero,
    //           physics: const ScrollPhysics(),
    //           crossAxisCount: 3,
    //           shrinkWrap: true,
    //           crossAxisSpacing: 15,
    //           mainAxisSpacing: 15,
    //           children: [
    //             ...images.map((image) {
    //               return ClipRRect(
    //                 borderRadius: BorderRadius.circular(15),
    //                 child: Stack(
    //                   children: [
    //                     Positioned.fill(
    //                       child: Image.file(
    //                         File(image.path),
    //                         height: 200,
    //                         width: 200,
    //                         fit: BoxFit.cover,
    //                       ),
    //                     ),
    //                     Positioned.fill(
    //                       child: Material(
    //                         color: Colors.transparent,
    //                         child: InkWell(
    //                           highlightColor: Colors.orange.withOpacity(0.1),
    //                           splashColor: Colors.black12,
    //                           onTap: onTap,
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               );
    //             }).toList(),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
