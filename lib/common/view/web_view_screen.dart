import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  var controller = WebViewController();
  bool isLoading = true;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    controller.setNavigationDelegate(NavigationDelegate(
      onProgress: (progress) {
        // logger.d(progress);
        if (progress >= 100) {
          setState(() {
            isLoading = false;
          });
        }
      },
    ));
    controller.loadRequest(Uri.parse(widget.url));
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : WebViewWidget(
                controller: controller,
              ),
      ),
    );
  }
}
