import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Pdf extends StatelessWidget {
  String url;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  Pdf(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SfPdfViewer.network(
      url,
      key: _pdfViewerKey,
    ));
  }
}
