import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'notes_detail.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttericon/octicons_icons.dart';

class NotesBrowser extends StatefulWidget {
  const NotesBrowser({super.key, required this.devRec, required this.isnew, required this.isnewabsen, required this.datenote, required this.leaderstatus});
  final Map devRec;
  final bool isnew;
    final bool isnewabsen;
  final String datenote;
  final bool leaderstatus;
  @override
  State<NotesBrowser> createState() => NotesBrowserState();
}

var loadingPercentage = 0;
WebViewController _controller = WebViewController();

class NotesBrowserState extends State<NotesBrowser> {
  @override
  void initState() {
    super.initState();
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.devRec['renungan']));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.devRec['judul_renungan']),
        automaticallyImplyLeading: widget.isnew,
        backgroundColor: Color.fromARGB(255, 227, 234, 243),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () async {
              if (await _controller.canGoBack()) {
                await _controller.goBack();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history item')),
                );
                return;
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () async {
              if (await _controller.canGoForward()) {
                await _controller.goForward();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history item')),
                );
                return;
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.replay),
            onPressed: () {
              _controller.reload();
            },
          ),
          IconButton(// ke notes_detail
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotesDetail(
                                devrecommend: widget.devRec,
                                isnew: widget.isnew,
                                isnewabsen: widget.isnewabsen,
                                datenote: widget.datenote,
                                leaderstatus: widget.leaderstatus,
                              )),
                    );
                  });
              },
              icon: Icon(Icons.arrow_forward),
              color: Theme.of(context).colorScheme.onSurface)
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
