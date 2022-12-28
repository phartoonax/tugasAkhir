import 'package:flutter/material.dart';
import 'notes_detail.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NotesBrowser extends StatefulWidget {
  const NotesBrowser({super.key});

  @override
  State<NotesBrowser> createState() => NotesBrowserState();
}

class NotesBrowserState extends State<NotesBrowser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simulation browser"),
      ),
    );
  }
}
